import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:tourneez/data/backup.dart';
import 'package:tourneez/data/database.dart';
import 'package:tourneez/data/logo_storage.dart';
import 'package:tourneez/domain/match_odds.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/domain/schedule_format.dart';
import 'package:tourneez/domain/series_score.dart';
import 'package:tourneez/domain/team_templates.dart';
import 'package:tourneez/domain/venue_maps.dart';
import 'package:tourneez/formats/bracket_utils.dart';
import 'package:tourneez/formats/format_registry.dart';

class TourneezRepository {
  TourneezRepository(this._db);

  final AppDatabase _db;
  final _random = Random();

  // --- Teams ---

  Stream<List<Team>> watchTeams() {
    return (_db.select(_db.teamsTable)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch()
        .map((rows) => rows.map(teamFromRow).toList());
  }

  Future<List<Team>> getTeams() async {
    final rows = await (_db.select(
      _db.teamsTable,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
    return rows.map(teamFromRow).toList();
  }

  Future<Team?> getTeam(int id) async {
    final row = await (_db.select(
      _db.teamsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : teamFromRow(row);
  }

  Future<int> createTeam({
    required String name,
    String? sourceLogoPath,
    int? colorArgb,
    int? powerRating,
    int? homeVenueId,
  }) async {
    String? logoPath;
    if (sourceLogoPath != null) {
      logoPath = await _persistLogo(sourceLogoPath);
    }
    final safeName = _clampText(name, max: 80);
    if (safeName.isEmpty) {
      throw ArgumentError('Team name cannot be empty.');
    }
    String? homeLocation;
    int? resolvedVenueId;
    if (homeVenueId != null) {
      final loc = await _locationTextForVenue(homeVenueId);
      if (loc != null) {
        resolvedVenueId = homeVenueId;
        homeLocation = loc;
      }
    }
    return _db
        .into(_db.teamsTable)
        .insert(
          TeamsTableCompanion.insert(
            name: safeName,
            logoPath: Value(logoPath),
            colorArgb: Value(colorArgb ?? pickPresetTeamColor(_random)),
            powerRating: Value((powerRating ?? 50).clamp(1, 100)),
            homeLocation: Value(homeLocation),
            homeVenueId: Value(resolvedVenueId),
          ),
        );
  }

  /// Instant team with a preset name, color, and randomized power.
  /// Adds a random bundled template team (logo, color, and power included).
  Future<Team> quickCreateTeam() async {
    final existing = await getTeams();
    final names = existing.map((t) => t.name.toLowerCase()).toSet();

    final unused = teamTemplates
        .where((t) => !names.contains(t.name.toLowerCase()))
        .toList();
    final pool = unused.isNotEmpty ? unused : teamTemplates;
    final template = pool[_random.nextInt(pool.length)];
    return createDuplicateTeamFromTemplate(template);
  }

  /// Create or refresh a team from a bundled logo template.
  Future<Team> createTeamFromTemplate(
    TeamTemplate template, {
    bool refreshExisting = true,
  }) async {
    final existing = await getTeams();
    final match = existing.firstWhereOrNull((t) => t.name == template.name);
    final logoPath = await persistLogoAsset(template.assetPath);

    if (match != null) {
      if (refreshExisting) {
        await (_db.update(
          _db.teamsTable,
        )..where((t) => t.id.equals(match.id))).write(
          TeamsTableCompanion(
            logoPath: Value(logoPath),
            colorArgb: Value(template.colorArgb),
            powerRating: Value(template.powerRating.clamp(1, 100)),
          ),
        );
        return (await getTeam(match.id))!;
      }
      return match;
    }

    final id = await _db
        .into(_db.teamsTable)
        .insert(
          TeamsTableCompanion.insert(
            name: template.name,
            logoPath: Value(logoPath),
            colorArgb: Value(template.colorArgb),
            powerRating: Value(template.powerRating.clamp(1, 100)),
          ),
        );
    final team = await getTeam(id);
    return team!;
  }

  /// Always inserts a new template team, adding " 2", " 3", etc. as needed.
  Future<Team> createDuplicateTeamFromTemplate(TeamTemplate template) async {
    final existing = await getTeams();
    final names = existing.map((t) => t.name.toLowerCase()).toSet();
    var name = template.name;
    var suffix = 2;
    while (names.contains(name.toLowerCase())) {
      name = '${template.name} $suffix';
      suffix++;
    }

    final logoPath = await persistLogoAsset(template.assetPath);
    final id = await _db
        .into(_db.teamsTable)
        .insert(
          TeamsTableCompanion.insert(
            name: name,
            logoPath: Value(logoPath),
            colorArgb: Value(template.colorArgb),
            powerRating: Value(template.powerRating.clamp(1, 100)),
          ),
        );
    return (await getTeam(id))!;
  }

  /// Add every template that is not already in the library.
  Future<int> ensureTemplateTeams() async {
    var added = 0;
    final existing = await getTeams();
    final names = existing.map((t) => t.name).toSet();
    for (final t in teamTemplates) {
      if (names.contains(t.name)) continue;
      await createTeamFromTemplate(t);
      names.add(t.name);
      added++;
    }
    return added;
  }

  /// Quietly re-copy bundled template logos into matching library teams, and
  /// shrink any oversized stored logos (large inline PNGs make lists lag).
  Future<void> syncTemplateLogos() async {
    final existing = await getTeams();
    final updated = <int>{};

    for (final template in teamTemplates) {
      final logoPath = await persistLogoAsset(template.assetPath);
      for (final team in existing) {
        if (!_matchesTemplateName(team.name, template.name)) continue;
        await (_db.update(
          _db.teamsTable,
        )..where((t) => t.id.equals(team.id))).write(
          TeamsTableCompanion(logoPath: Value(logoPath)),
        );
        updated.add(team.id);
      }
    }

    for (final team in existing) {
      if (updated.contains(team.id)) continue;
      final smaller = await shrinkLogoDataUrl(team.logoPath);
      if (smaller == null) continue;
      await (_db.update(
        _db.teamsTable,
      )..where((t) => t.id.equals(team.id))).write(
        TeamsTableCompanion(logoPath: Value(smaller)),
      );
    }
  }

  /// Wipes every table so the app looks freshly installed.
  Future<void> resetApp() async {
    await _db.transaction(() async {
      await _db.delete(_db.matchesTable).go();
      await _db.delete(_db.tournamentTeamsTable).go();
      await _db.delete(_db.tournamentsTable).go();
      await _db.delete(_db.divisionTeamsTable).go();
      await _db.delete(_db.divisionsTable).go();
      await _db.delete(_db.leaguesTable).go();
      await _db.delete(_db.teamListMembersTable).go();
      await _db.delete(_db.teamListsTable).go();
      await _db.delete(_db.teamsTable).go();
      await _db.delete(_db.venuesTable).go();
    });
    clearLogoCache();
  }

  /// Exports all local data as a versioned Tourneez JSON backup.
  Future<String> exportBackupJson({Map<String, dynamic>? preferences}) async {
    await _db.purgeOrphanRows();

    final teams = await _db.select(_db.teamsTable).get();
    final teamLists = await _db.select(_db.teamListsTable).get();
    final teamListMembers = await _db.select(_db.teamListMembersTable).get();
    final leagues = await _db.select(_db.leaguesTable).get();
    final divisions = await _db.select(_db.divisionsTable).get();
    final divisionTeams = await _db.select(_db.divisionTeamsTable).get();
    final tournaments = await _db.select(_db.tournamentsTable).get();
    final tournamentTeams = await _db.select(_db.tournamentTeamsTable).get();
    final matches = await _db.select(_db.matchesTable).get();
    final venues = await _db.select(_db.venuesTable).get();

    final envelope = buildBackupEnvelope(
      schemaVersion: tourneezSchemaVersion,
      preferences: preferences,
      tables: {
        'teams': [for (final r in teams) r.toJson()],
        'teamLists': [for (final r in teamLists) r.toJson()],
        'teamListMembers': [for (final r in teamListMembers) r.toJson()],
        'leagues': [for (final r in leagues) r.toJson()],
        'divisions': [for (final r in divisions) r.toJson()],
        'divisionTeams': [for (final r in divisionTeams) r.toJson()],
        'tournaments': [for (final r in tournaments) r.toJson()],
        'tournamentTeams': [for (final r in tournamentTeams) r.toJson()],
        'matches': [for (final r in matches) r.toJson()],
        'venues': [for (final r in venues) r.toJson()],
      },
    );
    return const JsonEncoder.withIndent('  ').convert(envelope);
  }

  /// Replaces all local data with a validated backup. Atomic.
  Future<void> restoreBackupJson(String raw) async {
    final backup = parseAndValidateBackup(raw);
    await _db.transaction(() async {
      await _db.delete(_db.matchesTable).go();
      await _db.delete(_db.tournamentTeamsTable).go();
      await _db.delete(_db.tournamentsTable).go();
      await _db.delete(_db.divisionTeamsTable).go();
      await _db.delete(_db.divisionsTable).go();
      await _db.delete(_db.leaguesTable).go();
      await _db.delete(_db.teamListMembersTable).go();
      await _db.delete(_db.teamListsTable).go();
      await _db.delete(_db.teamsTable).go();
      await _db.delete(_db.venuesTable).go();

      // Parents before child fields.
      final venues = backup.tables['venues'] ?? const <Map<String, dynamic>>[];
      final parents = [
        for (final row in venues)
          if (row['parentVenueId'] == null) row,
      ];
      final children = [
        for (final row in venues)
          if (row['parentVenueId'] != null) row,
      ];
      for (final row in parents) {
        await _db.into(_db.venuesTable).insert(VenuesTableData.fromJson(row));
      }
      for (final row in children) {
        await _db.into(_db.venuesTable).insert(VenuesTableData.fromJson(row));
      }

      for (final row in backup.tables['teams']!) {
        await _db.into(_db.teamsTable).insert(TeamsTableData.fromJson(row));
      }
      for (final row in backup.tables['teamLists']!) {
        await _db
            .into(_db.teamListsTable)
            .insert(TeamListsTableData.fromJson(row));
      }
      for (final row in backup.tables['teamListMembers']!) {
        await _db
            .into(_db.teamListMembersTable)
            .insert(TeamListMembersTableData.fromJson(row));
      }
      for (final row in backup.tables['leagues']!) {
        await _db.into(_db.leaguesTable).insert(LeaguesTableData.fromJson(row));
      }
      for (final row in backup.tables['divisions']!) {
        await _db
            .into(_db.divisionsTable)
            .insert(DivisionsTableData.fromJson(row));
      }
      for (final row in backup.tables['divisionTeams']!) {
        await _db
            .into(_db.divisionTeamsTable)
            .insert(DivisionTeamsTableData.fromJson(row));
      }
      for (final row in backup.tables['tournaments']!) {
        await _db
            .into(_db.tournamentsTable)
            .insert(TournamentsTableData.fromJson(row));
      }
      for (final row in backup.tables['tournamentTeams']!) {
        await _db
            .into(_db.tournamentTeamsTable)
            .insert(TournamentTeamsTableData.fromJson(row));
      }
      for (final row in backup.tables['matches']!) {
        await _db.into(_db.matchesTable).insert(MatchesTableData.fromJson(row));
      }
    });
    clearLogoCache();
  }

  static bool _matchesTemplateName(String teamName, String templateName) {
    if (teamName == templateName) return true;
    final prefix = '$templateName ';
    if (!teamName.startsWith(prefix)) return false;
    return int.tryParse(teamName.substring(prefix.length)) != null;
  }

  Future<void> updateTeam({
    required int id,
    required String name,
    String? sourceLogoPath,
    bool clearLogo = false,
    int? colorArgb,
    int? powerRating,
    int? homeVenueId,
    bool clearHomeVenue = false,
  }) async {
    String? logoPath;
    if (clearLogo) {
      logoPath = null;
    } else if (sourceLogoPath != null) {
      logoPath = await _persistLogo(sourceLogoPath);
    }

    final safeName = _clampText(name, max: 80);
    if (safeName.isEmpty) {
      throw ArgumentError('Team name cannot be empty.');
    }

    Value<int?> nextVenueId = const Value.absent();
    Value<String?> nextHomeLocation = const Value.absent();
    if (clearHomeVenue) {
      nextVenueId = const Value(null);
      nextHomeLocation = const Value(null);
    } else if (homeVenueId != null) {
      final loc = await _locationTextForVenue(homeVenueId);
      nextVenueId = Value(homeVenueId);
      nextHomeLocation = Value(loc);
    }

    await (_db.update(_db.teamsTable)..where((t) => t.id.equals(id))).write(
      TeamsTableCompanion(
        name: Value(safeName),
        logoPath: clearLogo
            ? const Value(null)
            : (logoPath != null ? Value(logoPath) : const Value.absent()),
        colorArgb: colorArgb != null ? Value(colorArgb) : const Value.absent(),
        powerRating: powerRating != null
            ? Value(powerRating.clamp(1, 100))
            : const Value.absent(),
        homeVenueId: nextVenueId,
        homeLocation: nextHomeLocation,
      ),
    );
  }

  Future<void> deleteTeam(int id) async {
    await (_db.delete(_db.teamsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> resetTeamStats(int id) async {
    await (_db.update(_db.teamsTable)..where((t) => t.id.equals(id))).write(
      const TeamsTableCompanion(
        titlesWon: Value(0),
        titlesJson: Value('[]'),
        promotionsWon: Value(0),
        relegations: Value(0),
        careerPlayed: Value(0),
        careerWon: Value(0),
        careerDrawn: Value(0),
        careerLost: Value(0),
        careerGoalsFor: Value(0),
        careerGoalsAgainst: Value(0),
      ),
    );
  }

  Future<String?> reorderTournamentSeeds({
    required int tournamentId,
    required List<int> orderedTeamIds,
  }) async {
    final tournament = await getTournament(tournamentId);
    if (tournament == null) return 'Tournament not found.';
    if (tournament.status == TournamentStatus.completed) {
      return 'Seeds cannot be changed after the tournament is completed.';
    }

    final matches = await getMatches(tournamentId);
    final gamesPlayed = matches.any((m) => m.status == MatchStatus.completed);
    if (gamesPlayed) {
      return 'Seeds can only be changed before any games have been played.';
    }

    final existing = await getTournamentTeams(tournamentId);
    if (existing.length != orderedTeamIds.length) {
      return 'Team list mismatch.';
    }
    final byTeamId = {for (final t in existing) t.teamId: t};
    for (var i = 0; i < orderedTeamIds.length; i++) {
      final row = byTeamId[orderedTeamIds[i]];
      if (row == null) return 'Unknown team in order.';
      await (_db.update(_db.tournamentTeamsTable)
            ..where((t) => t.id.equals(row.id)))
          .write(TournamentTeamsTableCompanion(seed: Value(i + 1)));
    }
    await (_db.update(_db.tournamentsTable)
          ..where((t) => t.id.equals(tournamentId)))
        .write(TournamentsTableCompanion(updatedAt: Value(DateTime.now())));

    // Active tournament with only unplayed fixtures: rebuild from new seeds.
    if (tournament.status == TournamentStatus.active) {
      await (_db.delete(
        _db.matchesTable,
      )..where((m) => m.tournamentId.equals(tournamentId))).go();

      final teams = await getTournamentTeams(tournamentId);
      if (tournament.format.usesGroups(tournament.config)) {
        final groups = tournament.format == TournamentFormat.groupsOnly
            ? groupsOnlyEngine.assignGroups(tournament.config, teams)
            : hybridEngine.assignGroups(tournament.config, teams);
        for (final entry in groups.entries) {
          await (_db.update(
            _db.tournamentTeamsTable,
          )..where((t) => t.id.equals(entry.key))).write(
            TournamentTeamsTableCompanion(groupLabel: Value(entry.value)),
          );
        }
      }

      final refreshed = await getTournamentTeams(tournamentId);
      final engine = engineFor(tournament.format);
      final drafts = engine.generateInitialMatches(tournament, refreshed);
      for (final d in drafts) {
        await _insertDraft(tournamentId, d);
      }
      await _propagateBracket(tournamentId);
    }
    return null;
  }

  /// Whether seeds can still be dragged (draft, or active with no scored games).
  Future<bool> canReorderSeeds(int tournamentId) async {
    final tournament = await getTournament(tournamentId);
    if (tournament == null || tournament.status == TournamentStatus.completed) {
      return false;
    }
    if (tournament.status == TournamentStatus.draft) return true;
    final matches = await getMatches(tournamentId);
    return !matches.any((m) => m.status == MatchStatus.completed);
  }

  Future<String> _persistLogo(String sourcePath) => persistLogoFile(sourcePath);

  // --- Tournaments ---

  /// Standalone tournaments (excludes division seasons inside multi-tier leagues).
  Stream<List<Tournament>> watchTournaments() {
    return (_db.select(_db.tournamentsTable)
          ..where((t) => t.leagueId.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.updatedAt),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch()
        .map((rows) => rows.map(tournamentFromRow).toList());
  }

  Future<Tournament?> getTournament(int id) async {
    final row = await (_db.select(
      _db.tournamentsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : tournamentFromRow(row);
  }

  Stream<Tournament?> watchTournament(int id) {
    return (_db.select(_db.tournamentsTable)..where((t) => t.id.equals(id)))
        .watch()
        .map((rows) => rows.isEmpty ? null : tournamentFromRow(rows.first));
  }

  Future<int> createTournament({
    required String name,
    required TournamentFormat format,
    required TournamentConfig config,
    required List<int> teamIds,
    TournamentStatus status = TournamentStatus.draft,
    int? leagueId,
    int? divisionId,
  }) async {
    return _db.transaction(() async {
      final id = await _db
          .into(_db.tournamentsTable)
          .insert(
            TournamentsTableCompanion.insert(
              name: name.trim(),
              format: format.name,
              status: status.name,
              configJson: jsonEncode(config.toJson()),
              leagueId: Value(leagueId),
              divisionId: Value(divisionId),
            ),
          );

      for (var i = 0; i < teamIds.length; i++) {
        await _db
            .into(_db.tournamentTeamsTable)
            .insert(
              TournamentTeamsTableCompanion.insert(
                tournamentId: id,
                teamId: teamIds[i],
                seed: Value(i + 1),
              ),
            );
      }
      return id;
    });
  }

  Future<String?> addTeamToTournament({
    required int tournamentId,
    required int teamId,
  }) async {
    final tournament = await getTournament(tournamentId);
    if (tournament == null) return 'Tournament not found.';
    if (tournament.status != TournamentStatus.draft) {
      return 'Teams can only be changed while the tournament is a draft.';
    }
    final existing = await getTournamentTeams(tournamentId);
    if (existing.any((t) => t.teamId == teamId)) {
      return 'Team is already enrolled.';
    }
    final seed = existing.length + 1;
    await _db
        .into(_db.tournamentTeamsTable)
        .insert(
          TournamentTeamsTableCompanion.insert(
            tournamentId: tournamentId,
            teamId: teamId,
            seed: Value(seed),
          ),
        );
    await (_db.update(_db.tournamentsTable)
          ..where((t) => t.id.equals(tournamentId)))
        .write(TournamentsTableCompanion(updatedAt: Value(DateTime.now())));
    return null;
  }

  Future<String?> removeTeamFromTournament({
    required int tournamentId,
    required int teamId,
  }) async {
    final tournament = await getTournament(tournamentId);
    if (tournament == null) return 'Tournament not found.';
    if (tournament.status != TournamentStatus.draft) {
      return 'Teams can only be changed while the tournament is a draft.';
    }
    await (_db.delete(_db.tournamentTeamsTable)..where(
          (t) => t.tournamentId.equals(tournamentId) & t.teamId.equals(teamId),
        ))
        .go();

    // Re-seed remaining teams
    final remaining = await getTournamentTeams(tournamentId);
    for (var i = 0; i < remaining.length; i++) {
      await (_db.update(_db.tournamentTeamsTable)
            ..where((t) => t.id.equals(remaining[i].id)))
          .write(TournamentTeamsTableCompanion(seed: Value(i + 1)));
    }
    await (_db.update(_db.tournamentsTable)
          ..where((t) => t.id.equals(tournamentId)))
        .write(TournamentsTableCompanion(updatedAt: Value(DateTime.now())));
    return null;
  }

  Future<void> deleteTournament(int id) async {
    // Explicit child deletes so orphans never accumulate if FKs are off.
    await _db.transaction(() async {
      await (_db.delete(_db.matchesTable)
            ..where((m) => m.tournamentId.equals(id)))
          .go();
      await (_db.delete(_db.tournamentTeamsTable)
            ..where((t) => t.tournamentId.equals(id)))
          .go();
      await (_db.delete(_db.tournamentsTable)..where((t) => t.id.equals(id)))
          .go();
      await (_db.update(_db.divisionsTable)
            ..where((d) => d.currentTournamentId.equals(id)))
          .write(
            const DivisionsTableCompanion(currentTournamentId: Value(null)),
          );
    });
  }

  Future<void> updateTournamentMeta({
    required int id,
    String? name,
    TournamentConfig? config,
  }) async {
    await (_db.update(
      _db.tournamentsTable,
    )..where((t) => t.id.equals(id))).write(
      TournamentsTableCompanion(
        name: name != null ? Value(name.trim()) : const Value.absent(),
        configJson: config != null
            ? Value(jsonEncode(config.toJson()))
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<TournamentTeam>> watchTournamentTeams(int tournamentId) {
    final query =
        _db.select(_db.tournamentTeamsTable).join([
            innerJoin(
              _db.teamsTable,
              _db.teamsTable.id.equalsExp(_db.tournamentTeamsTable.teamId),
            ),
          ])
          ..where(_db.tournamentTeamsTable.tournamentId.equals(tournamentId))
          ..orderBy([OrderingTerm.asc(_db.tournamentTeamsTable.seed)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final tt = row.readTable(_db.tournamentTeamsTable);
        final team = row.readTable(_db.teamsTable);
        return tournamentTeamFromRow(tt, team: teamFromRow(team));
      }).toList();
    });
  }

  Future<List<TournamentTeam>> getTournamentTeams(int tournamentId) async {
    final query =
        _db.select(_db.tournamentTeamsTable).join([
            innerJoin(
              _db.teamsTable,
              _db.teamsTable.id.equalsExp(_db.tournamentTeamsTable.teamId),
            ),
          ])
          ..where(_db.tournamentTeamsTable.tournamentId.equals(tournamentId))
          ..orderBy([OrderingTerm.asc(_db.tournamentTeamsTable.seed)]);

    final rows = await query.get();
    return rows.map((row) {
      final tt = row.readTable(_db.tournamentTeamsTable);
      final team = row.readTable(_db.teamsTable);
      return tournamentTeamFromRow(tt, team: teamFromRow(team));
    }).toList();
  }

  Stream<List<Match>> watchMatches(int tournamentId) {
    return (_db.select(_db.matchesTable)
          ..where((m) => m.tournamentId.equals(tournamentId))
          ..orderBy([
            (m) => OrderingTerm.asc(m.round),
            (m) => OrderingTerm.asc(m.bracketSlot),
            (m) => OrderingTerm.asc(m.id),
          ]))
        .watch()
        .map((rows) => rows.map(matchFromRow).toList());
  }

  Future<List<Match>> getMatches(int tournamentId) async {
    final rows =
        await (_db.select(_db.matchesTable)
              ..where((m) => m.tournamentId.equals(tournamentId))
              ..orderBy([
                (m) => OrderingTerm.asc(m.round),
                (m) => OrderingTerm.asc(m.bracketSlot),
                (m) => OrderingTerm.asc(m.id),
              ]))
            .get();
    return rows.map(matchFromRow).toList();
  }

  /// Start a draft tournament: generate matches and set status active.
  Future<String?> startTournament(int tournamentId) async {
    final tournament = await getTournament(tournamentId);
    if (tournament == null) return 'Tournament not found.';
    if (tournament.status != TournamentStatus.draft) {
      return 'Tournament already started.';
    }

    final teams = await getTournamentTeams(tournamentId);
    final engine = engineFor(tournament.format);
    final error = engine.validateTeams(tournament.config, teams);
    if (error != null) return error;

    await _db.transaction(() async {
      var workingTeams = teams;

      if (tournament.config.randomizeSeeds) {
        final shuffled = List<TournamentTeam>.from(workingTeams)
          ..shuffle(_random);
        for (var i = 0; i < shuffled.length; i++) {
          await (_db.update(_db.tournamentTeamsTable)
                ..where((t) => t.id.equals(shuffled[i].id)))
              .write(TournamentTeamsTableCompanion(seed: Value(i + 1)));
        }
        workingTeams = await getTournamentTeams(tournamentId);
      }

      if (tournament.format.usesGroups(tournament.config)) {
        final groups = tournament.format == TournamentFormat.groupsOnly
            ? groupsOnlyEngine.assignGroups(tournament.config, workingTeams)
            : hybridEngine.assignGroups(tournament.config, workingTeams);
        for (final entry in groups.entries) {
          await (_db.update(
            _db.tournamentTeamsTable,
          )..where((t) => t.id.equals(entry.key))).write(
            TournamentTeamsTableCompanion(groupLabel: Value(entry.value)),
          );
        }
      }

      final refreshedTeams = await getTournamentTeams(tournamentId);
      final drafts = engine.generateInitialMatches(tournament, refreshedTeams);

      for (final d in drafts) {
        await _insertDraft(tournamentId, d);
      }

      await (_db.update(
        _db.tournamentsTable,
      )..where((t) => t.id.equals(tournamentId))).write(
        TournamentsTableCompanion(
          status: Value(TournamentStatus.active.name),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });

    // Auto-advance byes in knockout
    await _propagateBracket(tournamentId);
    return null;
  }

  /// Clear every score for a tournament and rebuild opening fixtures.
  ///
  /// If the tournament was completed, reverses career stats / titles applied
  /// at completion and returns status to active.
  Future<String?> resetTournamentScores(int tournamentId) async {
    final tournament = await getTournament(tournamentId);
    if (tournament == null) return 'Tournament not found.';
    if (tournament.status == TournamentStatus.draft) {
      return 'This tournament has not started yet.';
    }

    final teams = await getTournamentTeams(tournamentId);
    final matches = await getMatches(tournamentId);
    final hasScores = matches.any(
      (m) =>
          m.status == MatchStatus.completed ||
          (m.status == MatchStatus.bye && m.homeScore != null),
    );
    if (!hasScores && tournament.status != TournamentStatus.completed) {
      return 'No scores to reset.';
    }

    if (tournament.status == TournamentStatus.completed) {
      await _reverseCompletionCareer(tournament, teams, matches);
    }

    await (_db.delete(
      _db.matchesTable,
    )..where((m) => m.tournamentId.equals(tournamentId))).go();

    final engine = engineFor(tournament.format);
    final refreshed = await getTournamentTeams(tournamentId);
    final drafts = engine.generateInitialMatches(tournament, refreshed);
    for (final d in drafts) {
      await _insertDraft(tournamentId, d);
    }

    await (_db.update(
      _db.tournamentsTable,
    )..where((t) => t.id.equals(tournamentId))).write(
      TournamentsTableCompanion(
        status: Value(TournamentStatus.active.name),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _propagateBracket(tournamentId);
    return null;
  }

  Future<void> _reverseCompletionCareer(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> matches,
  ) async {
    final engine = engineFor(tournament.format);
    final standings = engine.computeStandings(tournament, teams, matches);
    for (final row in standings) {
      final team = await getTeam(row.teamId);
      if (team == null) continue;
      await (_db.update(
        _db.teamsTable,
      )..where((t) => t.id.equals(row.teamId))).write(
        TeamsTableCompanion(
          careerPlayed: Value(
            (team.careerPlayed - row.played).clamp(0, 1 << 30),
          ),
          careerWon: Value((team.careerWon - row.won).clamp(0, 1 << 30)),
          careerDrawn: Value((team.careerDrawn - row.drawn).clamp(0, 1 << 30)),
          careerLost: Value((team.careerLost - row.lost).clamp(0, 1 << 30)),
          careerGoalsFor: Value(
            (team.careerGoalsFor - row.goalsFor).clamp(0, 1 << 30),
          ),
          careerGoalsAgainst: Value(
            (team.careerGoalsAgainst - row.goalsAgainst).clamp(0, 1 << 30),
          ),
        ),
      );
    }

    final championId = _championTeamId(tournament, teams, matches, standings);
    if (championId != null) {
      final champ = await getTeam(championId);
      if (champ != null && champ.titles.contains(tournament.name)) {
        final nextTitles = [
          for (final t in champ.titles)
            if (t != tournament.name) t,
        ];
        await (_db.update(
          _db.teamsTable,
        )..where((t) => t.id.equals(championId))).write(
          TeamsTableCompanion(
            titlesWon: Value(nextTitles.length),
            titlesJson: Value(jsonEncode(nextTitles)),
          ),
        );
      }
    }
  }

  /// Reset scores for every current-season division tournament in a league.
  Future<String?> resetLeagueSeasonScores(int leagueId) async {
    final league = await getLeague(leagueId);
    if (league == null) return 'League not found.';
    final divisions = await getDivisions(leagueId);
    final ids = <int>[
      for (final d in divisions)
        if (d.currentTournamentId != null) d.currentTournamentId!,
    ];
    if (ids.isEmpty) return 'No active season tournaments to reset.';

    String? lastErr;
    var anyOk = false;
    for (final id in ids) {
      final err = await resetTournamentScores(id);
      if (err == null) {
        anyOk = true;
      } else if (err != 'No scores to reset.') {
        lastErr = err;
      }
    }
    if (!anyOk) return lastErr ?? 'No scores to reset.';

    await (_db.update(
      _db.leaguesTable,
    )..where((t) => t.id.equals(leagueId))).write(
      LeaguesTableCompanion(
        status: Value(LeagueStatus.active.name),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return null;
  }

  /// Reset scores for every started tournament in the app.
  Future<String?> resetAllScores() async {
    final tournaments = await getTournaments();
    var resetCount = 0;
    for (final t in tournaments) {
      if (t.status == TournamentStatus.draft) continue;
      final err = await resetTournamentScores(t.id);
      if (err == null) resetCount++;
    }
    if (resetCount == 0) return 'No scores to reset.';
    return null;
  }

  Future<List<Tournament>> getTournaments() async {
    final rows = await (_db.select(
      _db.tournamentsTable,
    )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).get();
    return rows.map(tournamentFromRow).toList();
  }

  Future<void> _insertDraft(int tournamentId, DraftMatch d) async {
    String? seriesJson;
    if (d.status == MatchStatus.pending) {
      final tournament = await getTournament(tournamentId);
      if (tournament != null) {
        final len = tournament.config.seriesLengthForMatch(
          stage: d.stage,
          groupLabel: d.groupLabel,
          winnerAdvancesTo: d.winnerAdvancesTo,
        );
        if (len > 1) {
          seriesJson = SeriesScore.empty(len).encode();
        }
      }
    }
    await _db
        .into(_db.matchesTable)
        .insert(
          MatchesTableCompanion.insert(
            tournamentId: tournamentId,
            round: d.round,
            stage: d.stage.name,
            groupLabel: Value(d.groupLabel),
            bracketSlot: Value(d.bracketSlot),
            homeTeamId: Value(d.homeTeamId),
            awayTeamId: Value(d.awayTeamId),
            homeScore: Value(d.homeScore),
            awayScore: Value(d.awayScore),
            status: d.status.name,
            winnerAdvancesTo: Value(d.winnerAdvancesTo),
            loserAdvancesTo: Value(d.loserAdvancesTo),
            location: Value(d.location),
            venueId: Value(d.venueId),
            seriesJson: Value(seriesJson),
          ),
        );
  }

  /// Swap home/away and/or set venue / kickoff for a single match.
  Future<String?> updateMatchDetails({
    required int matchId,
    bool swapHomeAway = false,
    String? location,
    bool clearLocation = false,
    DateTime? scheduledAt,
    bool clearScheduledAt = false,
    int? durationMinutes,
    bool clearDurationMinutes = false,
    int? venueId,
    bool clearVenue = false,
  }) async {
    final row = await (_db.select(
      _db.matchesTable,
    )..where((m) => m.id.equals(matchId))).getSingleOrNull();
    if (row == null) return 'Match not found.';
    if (row.status == MatchStatus.bye.name) {
      return 'Cannot edit a bye.';
    }

    var homeId = row.homeTeamId;
    var awayId = row.awayTeamId;
    var homeScore = row.homeScore;
    var awayScore = row.awayScore;
    if (swapHomeAway) {
      final tmp = homeId;
      homeId = awayId;
      awayId = tmp;
      final tmpScore = homeScore;
      homeScore = awayScore;
      awayScore = tmpScore;
    }

    int? nextVenueId = row.venueId;
    if (clearVenue) {
      nextVenueId = null;
    } else if (venueId != null) {
      nextVenueId = venueId;
    }

    String? nextLocation = row.location;
    if (clearLocation) {
      nextLocation = null;
    } else if (location != null) {
      final trimmed = location.trim();
      nextLocation = trimmed.isEmpty ? null : trimmed;
    } else if (nextVenueId != null &&
        (clearVenue == false) &&
        (venueId != null || row.venueId != nextVenueId)) {
      nextLocation = await _locationTextForVenue(nextVenueId);
    } else if (swapHomeAway &&
        homeId != null &&
        nextVenueId == null &&
        !clearVenue &&
        venueId == null) {
      final homeTeam = await getTeam(homeId);
      final homeVen = homeTeam?.homeVenueId;
      if (homeVen != null) {
        nextVenueId = homeVen;
        nextLocation = await _locationTextForVenue(homeVen);
      } else {
        final homeLoc = homeTeam?.homeLocation?.trim();
        if (homeLoc != null && homeLoc.isNotEmpty) {
          nextLocation = homeLoc;
        }
      }
    }

    DateTime? nextScheduled = row.scheduledAt;
    if (clearScheduledAt) {
      nextScheduled = null;
    } else if (scheduledAt != null) {
      nextScheduled = scheduledAt;
    }

    int? nextDuration = row.durationMinutes;
    if (clearDurationMinutes) {
      nextDuration = null;
    } else if (durationMinutes != null) {
      nextDuration = durationMinutes.clamp(1, 24 * 60);
    }

    await (_db.update(
      _db.matchesTable,
    )..where((m) => m.id.equals(matchId))).write(
      MatchesTableCompanion(
        homeTeamId: Value(homeId),
        awayTeamId: Value(awayId),
        homeScore: Value(homeScore),
        awayScore: Value(awayScore),
        location: Value(nextLocation),
        scheduledAt: Value(nextScheduled),
        durationMinutes: Value(nextDuration),
        venueId: Value(nextVenueId),
      ),
    );
    return null;
  }

  Future<String?> _locationTextForVenue(int venueId) async {
    final venue = await getVenue(venueId);
    if (venue == null) return null;
    Venue? parent;
    if (venue.parentVenueId != null) {
      parent = await getVenue(venue.parentVenueId!);
    }
    return venueLocationText(venue, parent: parent);
  }

  /// Returns a short warning if [venueId] already has an overlapping kickoff.
  Future<String?> venueConflictWarning({
    required int venueId,
    required DateTime kickoff,
    int? durationMinutes,
    int? ignoreMatchId,
  }) async {
    final duration = durationMinutes ?? defaultMatchDurationMinutes;
    final end = kickoff.add(Duration(minutes: duration));
    final rows = await (_db.select(_db.matchesTable)
          ..where((m) => m.venueId.equals(venueId)))
        .get();
    for (final row in rows) {
      if (ignoreMatchId != null && row.id == ignoreMatchId) continue;
      final otherStart = row.scheduledAt;
      if (otherStart == null) continue;
      final otherDuration = row.durationMinutes ?? defaultMatchDurationMinutes;
      final otherEnd = otherStart.add(Duration(minutes: otherDuration));
      final overlaps =
          kickoff.isBefore(otherEnd) && end.isAfter(otherStart);
      if (overlaps) {
        return 'This venue may already be booked around '
            '${otherStart.hour.toString().padLeft(2, '0')}:'
            '${otherStart.minute.toString().padLeft(2, '0')}.';
      }
    }
    return null;
  }

  /// Assign kickoff times to every non-bye match in [round], spaced apart.
  /// When [useHomeTeamVenue] is true, sets each match's venue from the home
  /// team's home venue (teams without one are left unchanged).
  Future<String?> scheduleRoundKickoffs({
    required int tournamentId,
    required int round,
    required DateTime firstKickoff,
    int gapMinutes = 0,
    int? durationMinutes,
    bool useHomeTeamVenue = false,
  }) async {
    if (gapMinutes < 0) return 'Gap cannot be negative.';
    final duration = (durationMinutes ?? 90).clamp(1, 24 * 60);
    final rows =
        await (_db.select(_db.matchesTable)
              ..where(
                (m) =>
                    m.tournamentId.equals(tournamentId) &
                    m.round.equals(round),
              )
              ..orderBy([
                (m) => OrderingTerm.asc(m.bracketSlot),
                (m) => OrderingTerm.asc(m.id),
              ]))
            .get();
    final playable = rows
        .where((m) => m.status != MatchStatus.bye.name)
        .toList();
    if (playable.isEmpty) return 'No playable matches in that round.';

    final homeVenueByTeam = await _homeVenueMapForMatches(
      playable,
      useHomeTeamVenue: useHomeTeamVenue,
    );

    await _db.transaction(() async {
      await _writeRoundKickoffs(
        playable: playable,
        firstKickoff: firstKickoff,
        duration: duration,
        gapMinutes: gapMinutes,
        homeVenueByTeam: homeVenueByTeam,
        useHomeTeamVenue: useHomeTeamVenue,
      );
    });
    return null;
  }

  /// Schedules every existing round, placing each round's first kickoff on a
  /// new day spaced by [daysBetweenRounds] (1 = daily, 7 = weekly).
  Future<String?> scheduleAllRoundsKickoffs({
    required int tournamentId,
    required DateTime firstKickoff,
    int daysBetweenRounds = 7,
    int gapMinutes = 0,
    int? durationMinutes,
    bool useHomeTeamVenue = false,
  }) async {
    if (gapMinutes < 0) return 'Gap cannot be negative.';
    if (daysBetweenRounds < 1) return 'Days between rounds must be at least 1.';
    final duration = (durationMinutes ?? 90).clamp(1, 24 * 60);
    final rows =
        await (_db.select(_db.matchesTable)
              ..where((m) => m.tournamentId.equals(tournamentId))
              ..orderBy([
                (m) => OrderingTerm.asc(m.round),
                (m) => OrderingTerm.asc(m.bracketSlot),
                (m) => OrderingTerm.asc(m.id),
              ]))
            .get();
    final playable = rows
        .where((m) => m.status != MatchStatus.bye.name)
        .toList();
    if (playable.isEmpty) return 'No playable matches to schedule.';

    final rounds = playable.map((m) => m.round).toSet().toList()..sort();
    final homeVenueByTeam = await _homeVenueMapForMatches(
      playable,
      useHomeTeamVenue: useHomeTeamVenue,
    );

    await _db.transaction(() async {
      for (var i = 0; i < rounds.length; i++) {
        final round = rounds[i];
        final roundMatches =
            playable.where((m) => m.round == round).toList();
        final roundStart = firstKickoff.add(
          Duration(days: daysBetweenRounds * i),
        );
        await _writeRoundKickoffs(
          playable: roundMatches,
          firstKickoff: roundStart,
          duration: duration,
          gapMinutes: gapMinutes,
          homeVenueByTeam: homeVenueByTeam,
          useHomeTeamVenue: useHomeTeamVenue,
        );
      }
    });
    return null;
  }

  Future<Map<int, int>> _homeVenueMapForMatches(
    List<MatchesTableData> playable, {
    required bool useHomeTeamVenue,
  }) async {
    final homeVenueByTeam = <int, int>{};
    if (!useHomeTeamVenue) return homeVenueByTeam;
    final homeIds = {
      for (final m in playable)
        if (m.homeTeamId != null) m.homeTeamId!,
    };
    for (final teamId in homeIds) {
      final team = await getTeam(teamId);
      final venueId = team?.homeVenueId;
      if (venueId != null) homeVenueByTeam[teamId] = venueId;
    }
    return homeVenueByTeam;
  }

  Future<void> _writeRoundKickoffs({
    required List<MatchesTableData> playable,
    required DateTime firstKickoff,
    required int duration,
    required int gapMinutes,
    required Map<int, int> homeVenueByTeam,
    required bool useHomeTeamVenue,
  }) async {
    var kickoff = firstKickoff;
    for (final row in playable) {
      int? venueId;
      String? location;
      if (useHomeTeamVenue && row.homeTeamId != null) {
        venueId = homeVenueByTeam[row.homeTeamId!];
        if (venueId != null) {
          location = await _locationTextForVenue(venueId);
        }
      }
      await (_db.update(
        _db.matchesTable,
      )..where((m) => m.id.equals(row.id))).write(
        MatchesTableCompanion(
          scheduledAt: Value(kickoff),
          durationMinutes: Value(duration),
          venueId: venueId != null ? Value(venueId) : const Value.absent(),
          location: location != null ? Value(location) : const Value.absent(),
        ),
      );
      kickoff = kickoff.add(Duration(minutes: duration + gapMinutes));
    }
  }

  /// Clears kickoff (and optional duration) for every match in a round.
  Future<String?> clearRoundSchedule({
    required int tournamentId,
    required int round,
  }) async {
    await (_db.update(_db.matchesTable)..where(
          (m) => m.tournamentId.equals(tournamentId) & m.round.equals(round),
        ))
        .write(
          const MatchesTableCompanion(
            scheduledAt: Value(null),
            durationMinutes: Value(null),
          ),
        );
    return null;
  }

  Future<String?> recordScore({
    required int matchId,
    required int homeScore,
    required int awayScore,
  }) async {
    final row = await (_db.select(
      _db.matchesTable,
    )..where((m) => m.id.equals(matchId))).getSingleOrNull();
    if (row == null) return 'Match not found.';
    if (row.homeTeamId == null || row.awayTeamId == null) {
      return 'Match is not ready yet.';
    }
    if (homeScore < 0 || awayScore < 0) return 'Scores cannot be negative.';

    final tournament = await getTournament(row.tournamentId);
    if (tournament == null) return 'Tournament not found.';
    if (tournament.status != TournamentStatus.active &&
        tournament.status != TournamentStatus.completed) {
      return 'Tournament is not active.';
    }

    final stage = parseMatchStage(row.stage);
    var series = SeriesScore.tryParse(row.seriesJson);
    if (series == null) {
      final configuredLen = tournament.config.seriesLengthForMatch(
        stage: stage,
        groupLabel: row.groupLabel,
        winnerAdvancesTo: row.winnerAdvancesTo,
      );
      if (configuredLen > 1 && row.status == MatchStatus.pending.name) {
        series = SeriesScore.empty(configuredLen);
      }
    }

    final inSeries = series != null && series.length > 1 && !series.isDecided;
    if (inSeries) {
      return setSeriesLegs(
        matchId: matchId,
        legs: [...series.legs, (home: homeScore, away: awayScore)],
      );
    }

    final isBracket =
        stage == MatchStage.knockout ||
        stage == MatchStage.winners ||
        stage == MatchStage.losers ||
        stage == MatchStage.grandFinal;
    if (isBracket && homeScore == awayScore) {
      return 'Bracket matches cannot end in a draw.';
    }

    // Fall through to single-match write below via setSeriesLegs? No —
    // keep existing single-match path by calling internal helper.
    return _writeSingleMatchScore(
      row: row,
      tournament: tournament,
      homeScore: homeScore,
      awayScore: awayScore,
      isBracket: isBracket,
    );
  }

  /// Replace all legs of a multi-game series (edit any game, add/remove trailing).
  Future<String?> setSeriesLegs({
    required int matchId,
    required List<({int home, int away})> legs,
  }) async {
    final row = await (_db.select(
      _db.matchesTable,
    )..where((m) => m.id.equals(matchId))).getSingleOrNull();
    if (row == null) return 'Match not found.';
    if (row.homeTeamId == null || row.awayTeamId == null) {
      return 'Match is not ready yet.';
    }

    final tournament = await getTournament(row.tournamentId);
    if (tournament == null) return 'Tournament not found.';
    if (tournament.status != TournamentStatus.active &&
        tournament.status != TournamentStatus.completed) {
      return 'Tournament is not active.';
    }

    final stage = parseMatchStage(row.stage);
    final isBracket =
        stage == MatchStage.knockout ||
        stage == MatchStage.winners ||
        stage == MatchStage.losers ||
        stage == MatchStage.grandFinal;

    var series = SeriesScore.tryParse(row.seriesJson);
    if (series == null || series.length <= 1) {
      final configuredLen = tournament.config.seriesLengthForMatch(
        stage: stage,
        groupLabel: row.groupLabel,
        winnerAdvancesTo: row.winnerAdvancesTo,
      );
      if (configuredLen <= 1) {
        return 'This match is not a multi-game series.';
      }
      series = SeriesScore.empty(configuredLen);
    }

    if (legs.length > series.maxLegs) {
      return 'A ${series.length == 2 ? 'two-leg' : 'best-of-${series.length}'} '
          'series can have at most ${series.maxLegs} games.';
    }

    for (final leg in legs) {
      if (leg.home < 0 || leg.away < 0) {
        return 'Scores cannot be negative.';
      }
      if (isBracket && series.length != 2 && leg.home == leg.away) {
        return 'Best-of series games cannot end in a draw.';
      }
    }

    // Trim trailing games after the series is already decided.
    final trimmed = <({int home, int away})>[];
    for (final leg in legs) {
      final probe = SeriesScore(length: series.length, legs: [...trimmed, leg]);
      trimmed.add(leg);
      if (probe.isDecided) break;
    }

    final next = series.withLegs(trimmed);

    // No-op when nothing actually changed — do not wipe later bracket games.
    if (_sameLegs(series.legs, next.legs) &&
        (next.isDecided
            ? row.status == MatchStatus.completed.name
            : row.status == MatchStatus.pending.name)) {
      return null;
    }

    if (isBracket &&
        next.length == 2 &&
        next.isDecided &&
        next.aggregateHome == next.aggregateAway) {
      return 'Two-leg series cannot end level in a bracket.';
    }
    if (next.isDecided &&
        isBracket &&
        (next.seriesHomeScore ?? 0) == (next.seriesAwayScore ?? 0)) {
      return 'Series cannot end in a draw.';
    }

    final wasAlreadyPlayed =
        row.status == MatchStatus.completed.name ||
        row.status == MatchStatus.bye.name;
    final decided = next.isDecided;
    final prevWinnerId = _seriesWinnerTeamId(
      series,
      row.homeTeamId,
      row.awayTeamId,
    );
    final nextWinnerId = _seriesWinnerTeamId(
      next,
      row.homeTeamId,
      row.awayTeamId,
    );
    final outcomeChanged = prevWinnerId != nextWinnerId;
    final displayHome = next.legs.isEmpty ? null : (next.seriesHomeScore ?? 0);
    final displayAway = next.legs.isEmpty ? null : (next.seriesAwayScore ?? 0);

    await (_db.update(
      _db.matchesTable,
    )..where((m) => m.id.equals(matchId))).write(
      MatchesTableCompanion(
        homeScore: Value(displayHome),
        awayScore: Value(displayAway),
        seriesJson: Value(next.encode()),
        status: Value(
          decided ? MatchStatus.completed.name : MatchStatus.pending.name,
        ),
      ),
    );

    await (_db.update(
      _db.tournamentsTable,
    )..where((t) => t.id.equals(row.tournamentId))).write(
      TournamentsTableCompanion(
        status: tournament.status == TournamentStatus.completed
            ? Value(TournamentStatus.active.name)
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Only clear later games when who advances actually changes.
    if (outcomeChanged && tournament.format.hasBracketView) {
      await _resetDownstreamBracket(row.tournamentId, matchId);
    }

    if (decided || wasAlreadyPlayed || outcomeChanged) {
      await _propagateBracket(row.tournamentId);
      await _maybeGenerateNext(row.tournamentId);
      await _maybeCompleteTournament(row.tournamentId);
    }
    return null;
  }

  Future<String?> _writeSingleMatchScore({
    required MatchesTableData row,
    required Tournament tournament,
    required int homeScore,
    required int awayScore,
    required bool isBracket,
  }) async {
    final matchId = row.id;
    final wasAlreadyPlayed =
        row.status == MatchStatus.completed.name ||
        row.status == MatchStatus.bye.name;

    // No-op when scores are unchanged.
    if (wasAlreadyPlayed &&
        row.homeScore == homeScore &&
        row.awayScore == awayScore) {
      return null;
    }

    final prevWinnerId = _scoreWinnerTeamId(
      row.homeScore,
      row.awayScore,
      row.homeTeamId,
      row.awayTeamId,
    );
    final nextWinnerId = _scoreWinnerTeamId(
      homeScore,
      awayScore,
      row.homeTeamId,
      row.awayTeamId,
    );
    final outcomeChanged = prevWinnerId != nextWinnerId;

    await (_db.update(
      _db.matchesTable,
    )..where((m) => m.id.equals(matchId))).write(
      MatchesTableCompanion(
        homeScore: Value(homeScore),
        awayScore: Value(awayScore),
        status: Value(MatchStatus.completed.name),
      ),
    );

    await (_db.update(
      _db.tournamentsTable,
    )..where((t) => t.id.equals(row.tournamentId))).write(
      TournamentsTableCompanion(
        status: tournament.status == TournamentStatus.completed
            ? Value(TournamentStatus.active.name)
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );

    if (outcomeChanged && tournament.format.hasBracketView) {
      await _resetDownstreamBracket(row.tournamentId, matchId);
    }

    await _propagateBracket(row.tournamentId);
    await _maybeGenerateNext(row.tournamentId);
    await _maybeCompleteTournament(row.tournamentId);
    return null;
  }

  static bool _sameLegs(
    List<({int home, int away})> a,
    List<({int home, int away})> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].home != b[i].home || a[i].away != b[i].away) return false;
    }
    return true;
  }

  static int? _seriesWinnerTeamId(
    SeriesScore series,
    int? homeTeamId,
    int? awayTeamId,
  ) {
    if (!series.isDecided) return null;
    final home = series.seriesHomeScore ?? 0;
    final away = series.seriesAwayScore ?? 0;
    if (home > away) return homeTeamId;
    if (away > home) return awayTeamId;
    return null;
  }

  static int? _scoreWinnerTeamId(
    int? homeScore,
    int? awayScore,
    int? homeTeamId,
    int? awayTeamId,
  ) {
    if (homeScore == null || awayScore == null) return null;
    if (homeScore > awayScore) return homeTeamId;
    if (awayScore > homeScore) return awayTeamId;
    return null;
  }

  /// Clear later bracket matches that depended on [changedMatchId] so they can
  /// be re-filled after a score correction.
  Future<void> _resetDownstreamBracket(
    int tournamentId,
    int changedMatchId,
  ) async {
    final matches = await getMatches(tournamentId);
    final changed = matches.where((m) => m.id == changedMatchId).firstOrNull;
    if (changed?.bracketSlot == null) return;

    final toReset = <int>{};
    final queue = <int>[];
    if (changed!.winnerAdvancesTo != null) {
      queue.add(changed.winnerAdvancesTo!);
    }
    if (changed.loserAdvancesTo != null) {
      queue.add(changed.loserAdvancesTo!);
    }

    while (queue.isNotEmpty) {
      final slot = queue.removeAt(0);
      if (!toReset.add(slot)) continue;
      final m = matches.where((x) => x.bracketSlot == slot).firstOrNull;
      if (m == null) continue;
      if (m.winnerAdvancesTo != null) queue.add(m.winnerAdvancesTo!);
      if (m.loserAdvancesTo != null) queue.add(m.loserAdvancesTo!);
    }

    for (final slot in toReset) {
      final m = matches.where((x) => x.bracketSlot == slot).firstOrNull;
      if (m == null) continue;
      final hasFeeders = matches.any(
        (f) => f.winnerAdvancesTo == slot || f.loserAdvancesTo == slot,
      );
      if (!hasFeeders) continue;

      String? seriesJson;
      final existing = SeriesScore.tryParse(m.seriesJson);
      if (existing != null && existing.length > 1) {
        seriesJson = SeriesScore.empty(existing.length).encode();
      } else {
        final tournament = await getTournament(tournamentId);
        if (tournament != null) {
          final len = tournament.config.seriesLengthForMatch(
            stage: m.stage,
            groupLabel: m.groupLabel,
            winnerAdvancesTo: m.winnerAdvancesTo,
          );
          if (len > 1) {
            seriesJson = SeriesScore.empty(len).encode();
          }
        }
      }

      await (_db.update(
        _db.matchesTable,
      )..where((t) => t.id.equals(m.id))).write(
        MatchesTableCompanion(
          homeTeamId: const Value(null),
          awayTeamId: const Value(null),
          homeScore: const Value(null),
          awayScore: const Value(null),
          status: const Value('pending'),
          seriesJson: Value(seriesJson),
        ),
      );
    }
  }

  /// Simulate one ready match using team power ratings.
  Future<String?> randomizeMatchResult(int matchId) async {
    final row = await (_db.select(
      _db.matchesTable,
    )..where((m) => m.id.equals(matchId))).getSingleOrNull();
    if (row == null) return 'Match not found.';
    if (row.homeTeamId == null || row.awayTeamId == null) {
      return 'Match is not ready yet.';
    }

    final home = await getTeam(row.homeTeamId!);
    final away = await getTeam(row.awayTeamId!);
    final stage = parseMatchStage(row.stage);
    final isBracket =
        stage == MatchStage.knockout ||
        stage == MatchStage.winners ||
        stage == MatchStage.losers ||
        stage == MatchStage.grandFinal;

    var series = SeriesScore.tryParse(row.seriesJson);
    final needsSeriesLoop = series != null && series.length > 1 && !series.isDecided;

    if (needsSeriesLoop) {
      String? lastErr;
      for (var i = 0; i < 16; i++) {
        final fresh = await (_db.select(
          _db.matchesTable,
        )..where((m) => m.id.equals(matchId))).getSingleOrNull();
        if (fresh == null) return 'Match not found.';
        if (fresh.status == MatchStatus.completed.name) return null;
        final current = SeriesScore.tryParse(fresh.seriesJson);
        if (current != null && current.isDecided) return null;

        final bestOf = (current?.length ?? series.length) != 2;
        final score = sampleScore(
          homePower: home?.powerRating ?? 50,
          awayPower: away?.powerRating ?? 50,
          allowDraw: !isBracket || !bestOf,
          random: _random,
        );
        lastErr = await recordScore(
          matchId: matchId,
          homeScore: score.home,
          awayScore: score.away,
        );
        if (lastErr != null) return lastErr;
      }
      return lastErr;
    }

    final score = sampleScore(
      homePower: home?.powerRating ?? 50,
      awayPower: away?.powerRating ?? 50,
      allowDraw: !isBracket,
      random: _random,
    );
    return recordScore(
      matchId: matchId,
      homeScore: score.home,
      awayScore: score.away,
    );
  }

  /// Fill all ready pending matches using power-weighted odds.
  ///
  /// Batches each wave of ready matches (write scores, then one propagate /
  /// generate-next) so full-season simulate stays fast.
  Future<int> randomizePendingResults(int tournamentId) async {
    final tournament = await getTournament(tournamentId);
    if (tournament == null || tournament.status != TournamentStatus.active) {
      return 0;
    }

    final isBracketHeavy = tournament.format.hasBracketView;
    var filled = 0;

    for (var safety = 0; safety < 128; safety++) {
      final matches = await getMatches(tournamentId);
      final pending = matches
          .where(
            (m) =>
                m.status == MatchStatus.pending &&
                m.homeTeamId != null &&
                m.awayTeamId != null,
          )
          .toList();
      if (pending.isEmpty) break;

      // Series matches still need recordScore (multi-leg + propagate rules).
      final seriesPending = <Match>[];
      final simplePending = <Match>[];
      for (final m in pending) {
        final s = m.series;
        if (s != null && s.length > 1 && !s.isDecided) {
          seriesPending.add(m);
        } else {
          simplePending.add(m);
        }
      }

      var progressed = false;

      if (simplePending.isNotEmpty) {
        final teamCache = <int, Team?>{};
        Future<Team?> teamOf(int id) async {
          if (teamCache.containsKey(id)) return teamCache[id];
          final t = await getTeam(id);
          teamCache[id] = t;
          return t;
        }

        await _db.transaction(() async {
          for (final m in simplePending) {
            final home = await teamOf(m.homeTeamId!);
            final away = await teamOf(m.awayTeamId!);
            final score = sampleScore(
              homePower: home?.powerRating ?? 50,
              awayPower: away?.powerRating ?? 50,
              allowDraw: !m.isBracketMatch,
              random: _random,
            );
            await (_db.update(
              _db.matchesTable,
            )..where((t) => t.id.equals(m.id))).write(
              MatchesTableCompanion(
                homeScore: Value(score.home),
                awayScore: Value(score.away),
                status: Value(MatchStatus.completed.name),
              ),
            );
            filled++;
            progressed = true;
          }
        });

        if (isBracketHeavy) {
          await _propagateBracket(tournamentId);
        }
        await _maybeGenerateNext(tournamentId);
        await _maybeCompleteTournament(tournamentId);
      }

      for (final m in seriesPending) {
        final before = filled;
        // Finish the whole series in one go.
        final err = await randomizeMatchResult(m.id);
        if (err == null) {
          // Count legs approximated as 1 completion for progress.
          filled++;
          progressed = true;
        } else if (filled == before) {
          // ignore and continue other matches
        }
      }

      if (!progressed) break;

      final stillActive = await getTournament(tournamentId);
      if (stillActive?.status != TournamentStatus.active) break;
    }
    return filled;
  }

  Future<void> _propagateBracket(int tournamentId) async {
    final tournament = await getTournament(tournamentId);
    if (tournament == null || !tournament.format.hasBracketView) return;

    for (var i = 0; i < 16; i++) {
      final matches = await getMatches(tournamentId);
      final bracket = matches.where((m) => m.isBracketMatch).toList();
      if (bracket.isEmpty) return;

      // Repair: undo premature byes while feeders are still unfinished,
      // or byes that somehow have two teams assigned.
      var repaired = false;
      for (final m in bracket) {
        if (m.status != MatchStatus.bye || m.bracketSlot == null) continue;
        final bothTeams = m.homeTeamId != null && m.awayTeamId != null;
        if (bothTeams || _hasIncompleteFeeder(m, bracket)) {
          await (_db.update(
            _db.matchesTable,
          )..where((t) => t.id.equals(m.id))).write(
            MatchesTableCompanion(
              homeScore: const Value(null),
              awayScore: const Value(null),
              status: Value(MatchStatus.pending.name),
            ),
          );
          repaired = true;
        }
      }
      if (repaired) continue;

      final updates = advanceBracketParticipants(bracket);
      for (final m in updates) {
        // If both sides are now filled, ensure status isn't stuck on bye.
        final bothFilled = m.homeTeamId != null && m.awayTeamId != null;
        await (_db.update(
          _db.matchesTable,
        )..where((t) => t.id.equals(m.id))).write(
          MatchesTableCompanion(
            homeTeamId: Value(m.homeTeamId),
            awayTeamId: Value(m.awayTeamId),
            status: bothFilled && m.status == MatchStatus.bye
                ? Value(MatchStatus.pending.name)
                : const Value.absent(),
            homeScore: bothFilled && m.status == MatchStatus.bye
                ? const Value(null)
                : const Value.absent(),
            awayScore: bothFilled && m.status == MatchStatus.bye
                ? const Value(null)
                : const Value.absent(),
          ),
        );
      }

      // Auto-complete byes only when one side is filled AND no unfinished
      // feeder can still supply the missing opponent.
      final refreshed = await getMatches(tournamentId);
      final refreshedBracket = refreshed
          .where((m) => m.isBracketMatch)
          .toList();
      var byeMade = false;
      for (final m in refreshedBracket) {
        if (m.status != MatchStatus.pending) continue;
        if (_hasIncompleteFeeder(m, refreshedBracket)) continue;

        if (m.homeTeamId != null && m.awayTeamId == null) {
          await (_db.update(
            _db.matchesTable,
          )..where((t) => t.id.equals(m.id))).write(
            MatchesTableCompanion(
              status: Value(MatchStatus.bye.name),
              homeScore: const Value(1),
              awayScore: const Value(0),
            ),
          );
          byeMade = true;
        } else if (m.awayTeamId != null && m.homeTeamId == null) {
          await (_db.update(
            _db.matchesTable,
          )..where((t) => t.id.equals(m.id))).write(
            MatchesTableCompanion(
              homeTeamId: Value(m.awayTeamId),
              awayTeamId: const Value(null),
              status: Value(MatchStatus.bye.name),
              homeScore: const Value(1),
              awayScore: const Value(0),
            ),
          );
          byeMade = true;
        }
      }

      if (updates.isEmpty && !byeMade) break;
    }
  }

  bool _hasIncompleteFeeder(Match match, List<Match> all) {
    if (match.bracketSlot == null) return false;
    return all.any(
      (f) =>
          (f.winnerAdvancesTo == match.bracketSlot ||
              f.loserAdvancesTo == match.bracketSlot) &&
          !f.isCompleted,
    );
  }

  Future<void> _maybeGenerateNext(int tournamentId) async {
    final tournament = await getTournament(tournamentId);
    if (tournament == null) return;
    final teams = await getTournamentTeams(tournamentId);
    final matches = await getMatches(tournamentId);
    final engine = engineFor(tournament.format);
    final drafts = engine.generateNextRound(tournament, teams, matches);
    for (final d in drafts) {
      await _insertDraft(tournamentId, d);
    }
    if (drafts.isNotEmpty) {
      await _propagateBracket(tournamentId);
    }
  }

  Future<void> _maybeCompleteTournament(int tournamentId) async {
    final tournament = await getTournament(tournamentId);
    if (tournament == null || tournament.status != TournamentStatus.active) {
      return;
    }
    final teams = await getTournamentTeams(tournamentId);
    final matches = await getMatches(tournamentId);
    final engine = engineFor(tournament.format);
    if (!engine.isComplete(tournament, teams, matches)) return;

    await (_db.update(
      _db.tournamentsTable,
    )..where((t) => t.id.equals(tournamentId))).write(
      TournamentsTableCompanion(
        status: Value(TournamentStatus.completed.name),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Accumulate career match stats + title for the champion.
    final standings = engine.computeStandings(tournament, teams, matches);
    for (final row in standings) {
      final team = await getTeam(row.teamId);
      if (team == null) continue;
      await (_db.update(
        _db.teamsTable,
      )..where((t) => t.id.equals(row.teamId))).write(
        TeamsTableCompanion(
          careerPlayed: Value(team.careerPlayed + row.played),
          careerWon: Value(team.careerWon + row.won),
          careerDrawn: Value(team.careerDrawn + row.drawn),
          careerLost: Value(team.careerLost + row.lost),
          careerGoalsFor: Value(team.careerGoalsFor + row.goalsFor),
          careerGoalsAgainst: Value(team.careerGoalsAgainst + row.goalsAgainst),
        ),
      );
    }

    final championId = _championTeamId(tournament, teams, matches, standings);
    if (championId != null) {
      final champ = await getTeam(championId);
      if (champ != null) {
        final nextTitles = [...champ.titles, tournament.name];
        await (_db.update(
          _db.teamsTable,
        )..where((t) => t.id.equals(championId))).write(
          TeamsTableCompanion(
            titlesWon: Value(nextTitles.length),
            titlesJson: Value(jsonEncode(nextTitles)),
          ),
        );
      }
    }
  }

  int? _championTeamId(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> matches,
    List<StandingRow> standings,
  ) {
    if (tournament.format.hasBracketView) {
      final finals = matches.where((m) {
        if (!m.isCompleted || m.isBye) return false;
        if (m.stage == MatchStage.grandFinal) return true;
        if (m.stage == MatchStage.knockout &&
            m.winnerAdvancesTo == null &&
            m.groupLabel != '3rd Place') {
          return true;
        }
        if (m.stage == MatchStage.winners && m.winnerAdvancesTo == null) {
          // DE WB final feeds GF; prefer grandFinal when present.
          return !matches.any((x) => x.stage == MatchStage.grandFinal);
        }
        return false;
      }).toList();
      if (finals.isNotEmpty) return finals.last.winnerTeamId;
    }
    if (standings.isNotEmpty) return standings.first.teamId;
    return null;
  }

  // --- Team lists ---

  Stream<List<TeamList>> watchTeamLists() {
    return _db.select(_db.teamListsTable).watch().asyncMap((rows) async {
      final lists = <TeamList>[];
      for (final row in rows) {
        final members = await (_db.select(
          _db.teamListMembersTable,
        )..where((m) => m.listId.equals(row.id))).get();
        lists.add(
          teamListFromRow(row, teamIds: members.map((m) => m.teamId).toList()),
        );
      }
      lists.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
      return lists;
    });
  }

  Future<int> createTeamList({
    required String name,
    required List<int> teamIds,
  }) async {
    return _db.transaction(() async {
      final id = await _db
          .into(_db.teamListsTable)
          .insert(TeamListsTableCompanion.insert(name: name.trim()));
      for (final teamId in teamIds.toSet()) {
        await _db
            .into(_db.teamListMembersTable)
            .insert(
              TeamListMembersTableCompanion.insert(listId: id, teamId: teamId),
            );
      }
      return id;
    });
  }

  Future<void> updateTeamList({
    required int id,
    String? name,
    List<int>? teamIds,
  }) async {
    await _db.transaction(() async {
      if (name != null) {
        await (_db.update(_db.teamListsTable)..where((t) => t.id.equals(id)))
            .write(TeamListsTableCompanion(name: Value(name.trim())));
      }
      if (teamIds != null) {
        await (_db.delete(
          _db.teamListMembersTable,
        )..where((m) => m.listId.equals(id))).go();
        for (final teamId in teamIds.toSet()) {
          await _db
              .into(_db.teamListMembersTable)
              .insert(
                TeamListMembersTableCompanion.insert(
                  listId: id,
                  teamId: teamId,
                ),
              );
        }
      }
    });
  }

  Future<void> deleteTeamList(int id) async {
    await (_db.delete(_db.teamListsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<TeamList?> getTeamList(int id) async {
    final row = await (_db.select(
      _db.teamListsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final members = await (_db.select(
      _db.teamListMembersTable,
    )..where((m) => m.listId.equals(id))).get();
    return teamListFromRow(row, teamIds: members.map((m) => m.teamId).toList());
  }

  // --- Multi-division leagues ---

  Stream<List<League>> watchLeagues() {
    return (_db.select(_db.leaguesTable)..orderBy([
          (t) => OrderingTerm.desc(t.updatedAt),
          (t) => OrderingTerm.desc(t.createdAt),
        ]))
        .watch()
        .map((rows) => rows.map(leagueFromRow).toList());
  }

  Stream<League?> watchLeague(int id) {
    return (_db.select(_db.leaguesTable)..where((t) => t.id.equals(id)))
        .watch()
        .map((rows) => rows.isEmpty ? null : leagueFromRow(rows.first));
  }

  Future<League?> getLeague(int id) async {
    final row = await (_db.select(
      _db.leaguesTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : leagueFromRow(row);
  }

  Stream<List<Division>> watchDivisions(int leagueId) {
    return (_db.select(_db.divisionsTable)
          ..where((d) => d.leagueId.equals(leagueId))
          ..orderBy([(d) => OrderingTerm.asc(d.tierIndex)]))
        .watch()
        .map((rows) => rows.map(divisionFromRow).toList());
  }

  Future<List<Division>> getDivisions(int leagueId) async {
    final rows =
        await (_db.select(_db.divisionsTable)
              ..where((d) => d.leagueId.equals(leagueId))
              ..orderBy([(d) => OrderingTerm.asc(d.tierIndex)]))
            .get();
    return rows.map(divisionFromRow).toList();
  }

  Stream<List<DivisionTeam>> watchDivisionTeams(int divisionId) {
    final query = _db.select(_db.divisionTeamsTable).join([
      innerJoin(
        _db.teamsTable,
        _db.teamsTable.id.equalsExp(_db.divisionTeamsTable.teamId),
      ),
    ])..where(_db.divisionTeamsTable.divisionId.equals(divisionId));

    return query.watch().map((rows) {
      return rows.map((row) {
        final dt = row.readTable(_db.divisionTeamsTable);
        final team = row.readTable(_db.teamsTable);
        return DivisionTeam(
          id: dt.id,
          divisionId: dt.divisionId,
          teamId: dt.teamId,
          team: teamFromRow(team),
        );
      }).toList();
    });
  }

  Future<List<DivisionTeam>> getDivisionTeams(int divisionId) async {
    final query = _db.select(_db.divisionTeamsTable).join([
      innerJoin(
        _db.teamsTable,
        _db.teamsTable.id.equalsExp(_db.divisionTeamsTable.teamId),
      ),
    ])..where(_db.divisionTeamsTable.divisionId.equals(divisionId));
    final rows = await query.get();
    return rows.map((row) {
      final dt = row.readTable(_db.divisionTeamsTable);
      final team = row.readTable(_db.teamsTable);
      return DivisionTeam(
        id: dt.id,
        divisionId: dt.divisionId,
        teamId: dt.teamId,
        team: teamFromRow(team),
      );
    }).toList();
  }

  Future<int> createLeague({
    required String name,
    required List<String> divisionNames,
    required TournamentFormat format,
    required TournamentConfig config,
    int promoteCount = 2,
    int relegateCount = 2,
    bool promoRelegEnabled = true,
  }) async {
    if (divisionNames.isEmpty) {
      throw ArgumentError('Need at least 1 division.');
    }
    final allowPromo =
        promoRelegEnabled &&
        formatAllowsPromoReleg(format) &&
        divisionNames.length >= 2;
    return _db.transaction(() async {
      final id = await _db
          .into(_db.leaguesTable)
          .insert(
            LeaguesTableCompanion.insert(
              name: name.trim(),
              status: LeagueStatus.draft.name,
              format: Value(format.name),
              configJson: Value(jsonEncode(config.toJson())),
              promoteCount: Value(promoteCount),
              relegateCount: Value(relegateCount),
              promoRelegEnabled: Value(allowPromo),
              pointsForWin: Value(config.pointsForWin),
              pointsForDraw: Value(config.pointsForDraw),
              meetingsPerPair: Value(config.meetingsPerPair),
            ),
          );
      for (var i = 0; i < divisionNames.length; i++) {
        await _db
            .into(_db.divisionsTable)
            .insert(
              DivisionsTableCompanion.insert(
                leagueId: id,
                name: divisionNames[i].trim(),
                tierIndex: i,
              ),
            );
      }
      return id;
    });
  }

  Future<void> updateLeague({
    required int id,
    String? name,
    TournamentFormat? format,
    TournamentConfig? config,
    int? promoteCount,
    int? relegateCount,
    bool? promoRelegEnabled,
  }) async {
    await (_db.update(_db.leaguesTable)..where((t) => t.id.equals(id))).write(
      LeaguesTableCompanion(
        name: name != null ? Value(name.trim()) : const Value.absent(),
        format: format != null ? Value(format.name) : const Value.absent(),
        configJson: config != null
            ? Value(jsonEncode(config.toJson()))
            : const Value.absent(),
        promoteCount: promoteCount != null
            ? Value(promoteCount)
            : const Value.absent(),
        relegateCount: relegateCount != null
            ? Value(relegateCount)
            : const Value.absent(),
        promoRelegEnabled: promoRelegEnabled != null
            ? Value(promoRelegEnabled)
            : const Value.absent(),
        pointsForWin: config != null
            ? Value(config.pointsForWin)
            : const Value.absent(),
        pointsForDraw: config != null
            ? Value(config.pointsForDraw)
            : const Value.absent(),
        meetingsPerPair: config != null
            ? Value(config.meetingsPerPair)
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteLeague(int id) async {
    // Explicit cascade: linked tournaments + divisions + memberships.
    final linked = await (_db.select(_db.tournamentsTable)
          ..where((t) => t.leagueId.equals(id)))
        .get();
    for (final t in linked) {
      await deleteTournament(t.id);
    }
    final divisions = await getDivisions(id);
    await _db.transaction(() async {
      for (final d in divisions) {
        await (_db.delete(_db.divisionTeamsTable)
              ..where((x) => x.divisionId.equals(d.id)))
            .go();
        await (_db.delete(_db.divisionsTable)..where((x) => x.id.equals(d.id)))
            .go();
      }
      await (_db.delete(_db.leaguesTable)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<String?> setDivisionTeams({
    required int divisionId,
    required List<int> teamIds,
  }) async {
    final division = await (_db.select(
      _db.divisionsTable,
    )..where((d) => d.id.equals(divisionId))).getSingleOrNull();
    if (division == null) return 'Division not found.';
    final league = await getLeague(division.leagueId);
    if (league == null) return 'League not found.';
    if (league.status == LeagueStatus.active) {
      return 'Cannot change division rosters during an active season.';
    }

    final siblings = await getDivisions(division.leagueId);
    for (final sib in siblings) {
      if (sib.id == divisionId) continue;
      final occupied = await getDivisionTeams(sib.id);
      final conflict = occupied
          .where((t) => teamIds.contains(t.teamId))
          .toList();
      if (conflict.isNotEmpty) {
        final name = conflict.first.team?.name ?? 'A team';
        return '$name is already in ${sib.name}. Each team can only be in one division.';
      }
    }

    await _db.transaction(() async {
      await (_db.delete(
        _db.divisionTeamsTable,
      )..where((t) => t.divisionId.equals(divisionId))).go();
      for (final teamId in teamIds.toSet()) {
        await _db
            .into(_db.divisionTeamsTable)
            .insert(
              DivisionTeamsTableCompanion.insert(
                divisionId: divisionId,
                teamId: teamId,
              ),
            );
      }
    });
    return null;
  }

  /// Map of teamId → division name for all teams already placed in this league.
  Future<Map<int, String>> teamsInOtherDivisions({
    required int leagueId,
    required int excludeDivisionId,
  }) async {
    final result = <int, String>{};
    final divisions = await getDivisions(leagueId);
    for (final d in divisions) {
      if (d.id == excludeDivisionId) continue;
      final teams = await getDivisionTeams(d.id);
      for (final t in teams) {
        result[t.teamId] = d.name;
      }
    }
    return result;
  }

  Future<String?> addTeamToDivision({
    required int divisionId,
    required int teamId,
  }) async {
    final existing = await getDivisionTeams(divisionId);
    if (existing.any((t) => t.teamId == teamId)) {
      return 'Team already in this division.';
    }
    // Ensure not in another division of same league
    final division = await (_db.select(
      _db.divisionsTable,
    )..where((d) => d.id.equals(divisionId))).getSingleOrNull();
    if (division == null) return 'Division not found.';
    final siblings = await getDivisions(division.leagueId);
    for (final sib in siblings) {
      final teams = await getDivisionTeams(sib.id);
      if (teams.any((t) => t.teamId == teamId)) {
        return 'Team is already in ${sib.name}.';
      }
    }
    await _db
        .into(_db.divisionTeamsTable)
        .insert(
          DivisionTeamsTableCompanion.insert(
            divisionId: divisionId,
            teamId: teamId,
          ),
        );
    return null;
  }

  Future<void> removeTeamFromDivision({
    required int divisionId,
    required int teamId,
  }) async {
    await (_db.delete(_db.divisionTeamsTable)..where(
          (t) => t.divisionId.equals(divisionId) & t.teamId.equals(teamId),
        ))
        .go();
  }

  /// Create and start a season tournament for every division.
  Future<String?> startLeagueSeason(int leagueId) async {
    final league = await getLeague(leagueId);
    if (league == null) return 'League not found.';
    final divisions = await getDivisions(leagueId);
    if (divisions.isEmpty) return 'Add at least one division.';

    final format = league.format;
    final minTeams = format.minTeams;
    for (final d in divisions) {
      final teams = await getDivisionTeams(d.id);
      if (teams.length < minTeams) {
        return '${d.name} needs at least $minTeams teams for ${format.label}.';
      }
      if (d.currentTournamentId != null) {
        final t = await getTournament(d.currentTournamentId!);
        if (t != null && t.status != TournamentStatus.completed) {
          return 'Season already in progress for ${d.name}.';
        }
      }
    }

    final config = league.config;
    final createdIds = <int>[];
    for (final d in divisions) {
      final teams = await getDivisionTeams(d.id);
      final tournamentId = await createTournament(
        name: divisions.length == 1
            ? '${league.name} · S${league.seasonNumber}'
            : '${league.name} · ${d.name} · S${league.seasonNumber}',
        format: format,
        config: config,
        teamIds: teams.map((t) => t.teamId).toList(),
        leagueId: leagueId,
        divisionId: d.id,
      );
      await (_db.update(
        _db.divisionsTable,
      )..where((x) => x.id.equals(d.id))).write(
        DivisionsTableCompanion(currentTournamentId: Value(tournamentId)),
      );
      createdIds.add(tournamentId);
    }

    await (_db.update(
      _db.leaguesTable,
    )..where((t) => t.id.equals(leagueId))).write(
      LeaguesTableCompanion(
        status: Value(LeagueStatus.active.name),
        updatedAt: Value(DateTime.now()),
      ),
    );

    for (final id in createdIds) {
      final err = await startTournament(id);
      if (err != null) return err;
    }
    return null;
  }

  /// Completed past seasons for a league (archive).
  Stream<List<Tournament>> watchLeagueArchive(int leagueId) {
    return (_db.select(_db.tournamentsTable)
          ..where((t) => t.leagueId.equals(leagueId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch()
        .map(
          (rows) => rows
              .map(tournamentFromRow)
              .where((t) => t.status == TournamentStatus.completed)
              .toList(),
        );
  }

  Future<bool> leagueSeasonReadyForPromoReleg(int leagueId) async {
    final league = await getLeague(leagueId);
    if (league == null || !league.canUsePromoReleg) return false;
    final divisions = await getDivisions(leagueId);
    if (divisions.length < 2) return false;
    for (final d in divisions) {
      if (d.currentTournamentId == null) return false;
      final t = await getTournament(d.currentTournamentId!);
      if (t == null || t.status != TournamentStatus.completed) return false;
    }
    return true;
  }

  Future<List<PromoRelegMove>> previewPromoReleg(int leagueId) async {
    final league = await getLeague(leagueId);
    if (league == null || !league.canUsePromoReleg) return const [];
    final divisions = await getDivisions(leagueId);
    if (divisions.length < 2) return const [];
    final moves = <PromoRelegMove>[];

    for (var i = 0; i < divisions.length - 1; i++) {
      final upper = divisions[i];
      final lower = divisions[i + 1];
      if (upper.currentTournamentId == null ||
          lower.currentTournamentId == null) {
        continue;
      }

      final upperStandings = await _standingsForTournament(
        upper.currentTournamentId!,
      );
      final lowerStandings = await _standingsForTournament(
        lower.currentTournamentId!,
      );

      final relegated = upperStandings.reversed
          .take(league.relegateCount)
          .toList();
      final promoted = lowerStandings.take(league.promoteCount).toList();

      for (final row in relegated) {
        moves.add(
          PromoRelegMove(
            teamId: row.teamId,
            fromDivisionId: upper.id,
            toDivisionId: lower.id,
            promoted: false,
            teamName: row.displayName,
            fromDivisionName: upper.name,
            toDivisionName: lower.name,
          ),
        );
      }
      for (final row in promoted) {
        moves.add(
          PromoRelegMove(
            teamId: row.teamId,
            fromDivisionId: lower.id,
            toDivisionId: upper.id,
            promoted: true,
            teamName: row.displayName,
            fromDivisionName: lower.name,
            toDivisionName: upper.name,
          ),
        );
      }
    }
    return moves;
  }

  Future<List<StandingRow>> _standingsForTournament(int tournamentId) async {
    final tournament = await getTournament(tournamentId);
    if (tournament == null) return const [];
    final teams = await getTournamentTeams(tournamentId);
    final matches = await getMatches(tournamentId);
    return engineFor(
      tournament.format,
    ).computeStandings(tournament, teams, matches);
  }

  /// Apply promotion/relegation, clear season tournament links, bump season.
  Future<String?> applyPromoReleg(int leagueId) async {
    final league = await getLeague(leagueId);
    if (league == null) return 'League not found.';
    if (!league.canUsePromoReleg) {
      return 'Promotion/relegation is not enabled for this league.';
    }
    if (!await leagueSeasonReadyForPromoReleg(leagueId)) {
      return 'All division seasons must be completed first.';
    }

    final moves = await previewPromoReleg(leagueId);
    final divisions = await getDivisions(leagueId);

    await _db.transaction(() async {
      for (final move in moves) {
        await (_db.delete(_db.divisionTeamsTable)..where(
              (t) =>
                  t.divisionId.equals(move.fromDivisionId) &
                  t.teamId.equals(move.teamId),
            ))
            .go();
        final existing =
            await (_db.select(_db.divisionTeamsTable)..where(
                  (t) =>
                      t.divisionId.equals(move.toDivisionId) &
                      t.teamId.equals(move.teamId),
                ))
                .get();
        if (existing.isEmpty) {
          await _db
              .into(_db.divisionTeamsTable)
              .insert(
                DivisionTeamsTableCompanion.insert(
                  divisionId: move.toDivisionId,
                  teamId: move.teamId,
                ),
              );
        }
        final team = await getTeam(move.teamId);
        if (team != null) {
          await (_db.update(
            _db.teamsTable,
          )..where((t) => t.id.equals(move.teamId))).write(
            TeamsTableCompanion(
              promotionsWon: Value(
                move.promoted ? team.promotionsWon + 1 : team.promotionsWon,
              ),
              relegations: Value(
                move.promoted ? team.relegations : team.relegations + 1,
              ),
            ),
          );
        }
      }

      for (final d in divisions) {
        await (_db.update(
          _db.divisionsTable,
        )..where((x) => x.id.equals(d.id))).write(
          const DivisionsTableCompanion(currentTournamentId: Value(null)),
        );
      }

      await (_db.update(
        _db.leaguesTable,
      )..where((t) => t.id.equals(leagueId))).write(
        LeaguesTableCompanion(
          status: Value(LeagueStatus.draft.name),
          seasonNumber: Value(league.seasonNumber + 1),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
    return null;
  }

  /// Advance to the next season without moving teams (no promo/releg).
  ///
  /// Requires every division's current tournament to be completed or unset.
  Future<String?> advanceLeagueToNextSeason(int leagueId) async {
    final league = await getLeague(leagueId);
    if (league == null) return 'League not found.';

    final divisions = await getDivisions(leagueId);
    if (divisions.isEmpty) return 'Add at least one division.';

    for (final d in divisions) {
      final tid = d.currentTournamentId;
      if (tid == null) continue;
      final t = await getTournament(tid);
      if (t == null || t.status != TournamentStatus.completed) {
        return 'All division seasons must be completed first.';
      }
    }

    await _db.transaction(() async {
      for (final d in divisions) {
        await (_db.update(
          _db.divisionsTable,
        )..where((x) => x.id.equals(d.id))).write(
          const DivisionsTableCompanion(currentTournamentId: Value(null)),
        );
      }

      await (_db.update(
        _db.leaguesTable,
      )..where((t) => t.id.equals(leagueId))).write(
        LeaguesTableCompanion(
          status: Value(LeagueStatus.draft.name),
          seasonNumber: Value(league.seasonNumber + 1),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
    return null;
  }

  // --- Venues ---

  Stream<List<Venue>> watchVenues() {
    return (_db.select(_db.venuesTable)
          ..orderBy([
            (t) => OrderingTerm.asc(t.parentVenueId),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .watch()
        .map((rows) => rows.map(venueFromRow).toList());
  }

  Future<List<Venue>> getVenues() async {
    final rows = await (_db.select(_db.venuesTable)
          ..orderBy([
            (t) => OrderingTerm.asc(t.parentVenueId),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .get();
    return rows.map(venueFromRow).toList();
  }

  Future<Venue?> getVenue(int id) async {
    final row = await (_db.select(
      _db.venuesTable,
    )..where((v) => v.id.equals(id))).getSingleOrNull();
    return row == null ? null : venueFromRow(row);
  }

  Future<List<Venue>> getChildVenues(int parentId) async {
    final rows = await (_db.select(_db.venuesTable)
          ..where((v) => v.parentVenueId.equals(parentId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
    return rows.map(venueFromRow).toList();
  }

  Future<int> createVenue({
    required String name,
    String? address,
    String? mapUrl,
    String? notes,
    String? layoutImageSourcePath,
    int? parentVenueId,
  }) async {
    final safeName = _clampText(name, max: 120);
    if (safeName.isEmpty) {
      throw ArgumentError('Venue name cannot be empty.');
    }
    if (parentVenueId != null) {
      final parent = await getVenue(parentVenueId);
      if (parent == null) throw ArgumentError('Parent venue not found.');
      if (parent.parentVenueId != null) {
        throw ArgumentError('Fields can only be added under a top-level site.');
      }
    }
    String? layout;
    if (layoutImageSourcePath != null) {
      layout = await persistLayoutImageFile(layoutImageSourcePath);
    }
    return _db.into(_db.venuesTable).insert(
          VenuesTableCompanion.insert(
            name: safeName,
            address: Value(_clampOptionalText(address, max: 300)),
            mapUrl: Value(_clampOptionalText(mapUrl, max: 500)),
            notes: Value(_clampOptionalText(notes, max: 500)),
            layoutImagePath: Value(layout),
            parentVenueId: Value(parentVenueId),
          ),
        );
  }

  Future<void> updateVenue({
    required int id,
    required String name,
    String? address,
    bool clearAddress = false,
    String? mapUrl,
    bool clearMapUrl = false,
    String? notes,
    bool clearNotes = false,
    String? layoutImageSourcePath,
    bool clearLayoutImage = false,
  }) async {
    final safeName = _clampText(name, max: 120);
    if (safeName.isEmpty) {
      throw ArgumentError('Venue name cannot be empty.');
    }
    String? layout;
    var setLayout = false;
    if (clearLayoutImage) {
      layout = null;
      setLayout = true;
    } else if (layoutImageSourcePath != null) {
      layout = await persistLayoutImageFile(layoutImageSourcePath);
      setLayout = true;
    }

    await (_db.update(_db.venuesTable)..where((v) => v.id.equals(id))).write(
      VenuesTableCompanion(
        name: Value(safeName),
        address: clearAddress
            ? const Value(null)
            : (address != null
                ? Value(_clampOptionalText(address, max: 300))
                : const Value.absent()),
        mapUrl: clearMapUrl
            ? const Value(null)
            : (mapUrl != null
                ? Value(_clampOptionalText(mapUrl, max: 500))
                : const Value.absent()),
        notes: clearNotes
            ? const Value(null)
            : (notes != null
                ? Value(_clampOptionalText(notes, max: 500))
                : const Value.absent()),
        layoutImagePath: setLayout ? Value(layout) : const Value.absent(),
      ),
    );
  }

  Future<void> deleteVenue(int id) async {
    await _db.transaction(() async {
      final children = await getChildVenues(id);
      for (final child in children) {
        await (_db.update(_db.matchesTable)
              ..where((m) => m.venueId.equals(child.id)))
            .write(const MatchesTableCompanion(venueId: Value(null)));
        await (_db.update(_db.teamsTable)
              ..where((t) => t.homeVenueId.equals(child.id)))
            .write(
              const TeamsTableCompanion(
                homeVenueId: Value(null),
                homeLocation: Value(null),
              ),
            );
        await (_db.delete(_db.venuesTable)..where((v) => v.id.equals(child.id)))
            .go();
      }
      await (_db.update(_db.matchesTable)..where((m) => m.venueId.equals(id)))
          .write(const MatchesTableCompanion(venueId: Value(null)));
      await (_db.update(_db.teamsTable)..where((t) => t.homeVenueId.equals(id)))
          .write(
            const TeamsTableCompanion(
              homeVenueId: Value(null),
              homeLocation: Value(null),
            ),
          );
      await (_db.delete(_db.venuesTable)..where((v) => v.id.equals(id))).go();
    });
  }

  /// Venues referenced by matches in the given tournaments (for map overview).
  Future<List<Venue>> getVenuesUsedByTournaments(List<int> tournamentIds) async {
    if (tournamentIds.isEmpty) return const [];
    final matches = await (_db.select(_db.matchesTable)
          ..where((m) => m.tournamentId.isIn(tournamentIds)))
        .get();
    final ids = {
      for (final m in matches)
        if (m.venueId != null) m.venueId!,
    };
    if (ids.isEmpty) return const [];
    final rows = await (_db.select(_db.venuesTable)
          ..where((v) => v.id.isIn(ids.toList())))
        .get();
    return rows.map(venueFromRow).toList();
  }

  static String _clampText(String value, {required int max}) {
    final trimmed = value.trim();
    if (trimmed.length <= max) return trimmed;
    return trimmed.substring(0, max);
  }

  static String? _clampOptionalText(String? value, {int max = maxLocationChars}) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.length <= max) return trimmed;
    return trimmed.substring(0, max);
  }
}
