import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/domain/series_score.dart';

part 'database.g.dart';

/// Keep in sync with [AppDatabase.schemaVersion] and docs/SCHEMA_PLAN.md.
const tourneezSchemaVersion = 11;

class TeamsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get logoPath => text().nullable()();
  IntColumn get colorArgb =>
      integer().withDefault(const Constant(0xFF0B6E4F))();
  IntColumn get powerRating => integer().withDefault(const Constant(50))();
  /// Denormalized display label synced from [homeVenueId] when set.
  TextColumn get homeLocation => text().nullable()();
  /// Soft FK to [VenuesTable] — optional home ground / field.
  IntColumn get homeVenueId => integer().nullable()();
  IntColumn get titlesWon => integer().withDefault(const Constant(0))();
  /// JSON array of title names, e.g. `["Premier League S1","Cup Final"]`.
  TextColumn get titlesJson => text().withDefault(const Constant('[]'))();
  IntColumn get promotionsWon => integer().withDefault(const Constant(0))();
  IntColumn get relegations => integer().withDefault(const Constant(0))();
  IntColumn get careerPlayed => integer().withDefault(const Constant(0))();
  IntColumn get careerWon => integer().withDefault(const Constant(0))();
  IntColumn get careerDrawn => integer().withDefault(const Constant(0))();
  IntColumn get careerLost => integer().withDefault(const Constant(0))();
  IntColumn get careerGoalsFor => integer().withDefault(const Constant(0))();
  IntColumn get careerGoalsAgainst =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class TeamListsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class TeamListMembersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get listId =>
      integer().references(TeamListsTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get teamId =>
      integer().references(TeamsTable, #id, onDelete: KeyAction.cascade)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {listId, teamId},
      ];
}

class LeaguesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get status => text()(); // LeagueStatus.name
  TextColumn get format =>
      text().withDefault(const Constant('roundRobin'))();
  TextColumn get configJson => text().withDefault(const Constant('{}'))();
  IntColumn get promoteCount => integer().withDefault(const Constant(2))();
  IntColumn get relegateCount => integer().withDefault(const Constant(2))();
  BoolColumn get promoRelegEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get pointsForWin => integer().withDefault(const Constant(3))();
  IntColumn get pointsForDraw => integer().withDefault(const Constant(1))();
  IntColumn get meetingsPerPair => integer().withDefault(const Constant(2))();
  IntColumn get seasonNumber => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class DivisionsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get leagueId =>
      integer().references(LeaguesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get tierIndex => integer()();
  IntColumn get currentTournamentId => integer().nullable()();
}

class DivisionTeamsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get divisionId =>
      integer().references(DivisionsTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get teamId =>
      integer().references(TeamsTable, #id, onDelete: KeyAction.cascade)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {divisionId, teamId},
      ];
}

class TournamentsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get format => text()(); // TournamentFormat.name
  TextColumn get status => text()(); // TournamentStatus.name
  TextColumn get configJson => text()();
  IntColumn get leagueId => integer().nullable()();
  IntColumn get divisionId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class TournamentTeamsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tournamentId =>
      integer().references(TournamentsTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get teamId =>
      integer().references(TeamsTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get seed => integer().nullable()();
  TextColumn get groupLabel => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {tournamentId, teamId},
      ];
}

class MatchesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tournamentId =>
      integer().references(TournamentsTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get round => integer()();
  TextColumn get stage => text()();
  TextColumn get groupLabel => text().nullable()();
  IntColumn get bracketSlot => integer().nullable()();
  IntColumn get homeTeamId => integer().nullable()();
  IntColumn get awayTeamId => integer().nullable()();
  IntColumn get homeScore => integer().nullable()();
  IntColumn get awayScore => integer().nullable()();
  TextColumn get status => text()();
  IntColumn get winnerAdvancesTo => integer().nullable()();
  IntColumn get loserAdvancesTo => integer().nullable()();
  TextColumn get location => text().nullable()();
  /// Kickoff datetime (local wall clock stored as UTC millis via Drift).
  DateTimeColumn get scheduledAt => dateTime().nullable()();
  /// Planned match length; UI defaults to 90 when null.
  IntColumn get durationMinutes => integer().nullable()();
  /// Soft FK to [VenuesTable] — preferred over free-text [location].
  IntColumn get venueId => integer().nullable()();
  TextColumn get seriesJson => text().nullable()();
}

/// Sites and fields. Top-level rows are standalone venues or complexes;
/// children (`parentVenueId` set) are named fields at that complex.
class VenuesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get address => text().nullable()();
  TextColumn get mapUrl => text().nullable()();
  TextColumn get notes => text().nullable()();
  /// Optional PNG/JPEG site map (data URL) — useful for multi-field complexes.
  TextColumn get layoutImagePath => text().nullable()();
  IntColumn get parentVenueId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [
    TeamsTable,
    TeamListsTable,
    TeamListMembersTable,
    LeaguesTable,
    DivisionsTable,
    DivisionTeamsTable,
    TournamentsTable,
    TournamentTeamsTable,
    MatchesTable,
    VenuesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => tourneezSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(matchesTable, matchesTable.loserAdvancesTo);
          }
          if (from < 3) {
            await m.addColumn(teamsTable, teamsTable.colorArgb);
            await m.addColumn(teamsTable, teamsTable.powerRating);
          }
          if (from < 4) {
            await m.addColumn(teamsTable, teamsTable.homeLocation);
            await m.addColumn(matchesTable, matchesTable.location);
          }
          if (from < 5) {
            await m.createTable(teamListsTable);
            await m.createTable(teamListMembersTable);
            await m.createTable(leaguesTable);
            await m.createTable(divisionsTable);
            await m.createTable(divisionTeamsTable);
            await m.addColumn(tournamentsTable, tournamentsTable.leagueId);
            await m.addColumn(tournamentsTable, tournamentsTable.divisionId);
          }
          if (from < 6) {
            await m.addColumn(teamsTable, teamsTable.titlesWon);
            await m.addColumn(teamsTable, teamsTable.promotionsWon);
            await m.addColumn(teamsTable, teamsTable.relegations);
            await m.addColumn(teamsTable, teamsTable.careerPlayed);
            await m.addColumn(teamsTable, teamsTable.careerWon);
            await m.addColumn(teamsTable, teamsTable.careerDrawn);
            await m.addColumn(teamsTable, teamsTable.careerLost);
            await m.addColumn(teamsTable, teamsTable.careerGoalsFor);
            await m.addColumn(teamsTable, teamsTable.careerGoalsAgainst);
            await m.addColumn(leaguesTable, leaguesTable.format);
            await m.addColumn(leaguesTable, leaguesTable.configJson);
            await m.addColumn(leaguesTable, leaguesTable.promoRelegEnabled);
          }
          if (from < 7) {
            await m.addColumn(teamsTable, teamsTable.titlesJson);
            // Backfill placeholder title names from legacy count.
            final rows = await select(teamsTable).get();
            for (final row in rows) {
              if (row.titlesWon <= 0) continue;
              final titles = [
                for (var i = 1; i <= row.titlesWon; i++) 'Title $i',
              ];
              await (update(teamsTable)..where((t) => t.id.equals(row.id)))
                  .write(
                TeamsTableCompanion(titlesJson: Value(jsonEncode(titles))),
              );
            }
          }
          if (from < 8) {
            await m.addColumn(matchesTable, matchesTable.seriesJson);
          }
          if (from < 9) {
            await m.addColumn(matchesTable, matchesTable.scheduledAt);
            await m.addColumn(matchesTable, matchesTable.durationMinutes);
          }
          if (from < 10) {
            await m.createTable(venuesTable);
            await m.addColumn(matchesTable, matchesTable.venueId);
          }
          if (from < 11) {
            await m.addColumn(teamsTable, teamsTable.homeVenueId);
          }
        },
        beforeOpen: (details) async {
          // SQLite keeps FKs off unless enabled per connection.
          await customStatement('PRAGMA foreign_keys = ON');
          await purgeOrphanRows();
        },
      );

  /// Removes leftover child rows after deletes when FKs were not enforced.
  Future<void> purgeOrphanRows() async {
    await customStatement(
      'DELETE FROM matches_table WHERE tournament_id NOT IN '
      '(SELECT id FROM tournaments_table)',
    );
    await customStatement(
      'DELETE FROM tournament_teams_table WHERE tournament_id NOT IN '
      '(SELECT id FROM tournaments_table)',
    );
    await customStatement(
      'DELETE FROM tournament_teams_table WHERE team_id NOT IN '
      '(SELECT id FROM teams_table)',
    );
    await customStatement(
      'DELETE FROM divisions_table WHERE league_id NOT IN '
      '(SELECT id FROM leagues_table)',
    );
    await customStatement(
      'DELETE FROM division_teams_table WHERE division_id NOT IN '
      '(SELECT id FROM divisions_table)',
    );
    await customStatement(
      'DELETE FROM division_teams_table WHERE team_id NOT IN '
      '(SELECT id FROM teams_table)',
    );
    await customStatement(
      'DELETE FROM team_list_members_table WHERE list_id NOT IN '
      '(SELECT id FROM team_lists_table)',
    );
    await customStatement(
      'DELETE FROM team_list_members_table WHERE team_id NOT IN '
      '(SELECT id FROM teams_table)',
    );
    await customStatement(
      'UPDATE divisions_table SET current_tournament_id = NULL '
      'WHERE current_tournament_id IS NOT NULL '
      'AND current_tournament_id NOT IN (SELECT id FROM tournaments_table)',
    );
    await customStatement(
      'UPDATE tournaments_table SET league_id = NULL '
      'WHERE league_id IS NOT NULL '
      'AND league_id NOT IN (SELECT id FROM leagues_table)',
    );
    await customStatement(
      'UPDATE tournaments_table SET division_id = NULL '
      'WHERE division_id IS NOT NULL '
      'AND division_id NOT IN (SELECT id FROM divisions_table)',
    );
    await customStatement(
      'UPDATE matches_table SET venue_id = NULL '
      'WHERE venue_id IS NOT NULL '
      'AND venue_id NOT IN (SELECT id FROM venues_table)',
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'tourneez',
      native: DriftNativeOptions(
        databaseDirectory: getApplicationDocumentsDirectory,
        setup: (db) => db.execute('PRAGMA foreign_keys = ON'),
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}

// --- Mappers ---

TournamentFormat parseFormat(String value) => parseFormatName(value);

TournamentStatus parseStatus(String value) {
  for (final e in TournamentStatus.values) {
    if (e.name == value) return e;
  }
  throw FormatException('Unknown tournament status: $value');
}

MatchStatus parseMatchStatus(String value) {
  for (final e in MatchStatus.values) {
    if (e.name == value) return e;
  }
  throw FormatException('Unknown match status: $value');
}

MatchStage parseMatchStage(String value) {
  for (final e in MatchStage.values) {
    if (e.name == value) return e;
  }
  throw FormatException('Unknown match stage: $value');
}

LeagueStatus parseLeagueStatus(String value) {
  for (final e in LeagueStatus.values) {
    if (e.name == value) return e;
  }
  throw FormatException('Unknown league status: $value');
}

Tournament tournamentFromRow(TournamentsTableData row) {
  final map = jsonDecode(row.configJson) as Map<String, dynamic>;
  var config = TournamentConfig.fromJson(map);
  if (row.format == 'consolation') {
    config = config.copyWith(includeThirdPlace: true);
  }
  if (row.format == 'worldCup') {
    config = config.copyWith(
      leagueFormat: TournamentFormat.groupsOnly,
      bracketFormat: TournamentFormat.singleElimination,
    );
  }
  return Tournament(
    id: row.id,
    name: row.name,
    format: parseFormat(row.format),
    status: parseStatus(row.status),
    config: config,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    leagueId: row.leagueId,
    divisionId: row.divisionId,
  );
}

List<String> parseTitlesJson(String raw, {int legacyCount = 0}) {
  try {
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    }
  } catch (_) {}
  if (legacyCount > 0) {
    return [for (var i = 1; i <= legacyCount; i++) 'Title $i'];
  }
  return const [];
}

Team teamFromRow(TeamsTableData row) => Team(
      id: row.id,
      name: row.name,
      logoPath: row.logoPath,
      colorArgb: row.colorArgb,
      powerRating: row.powerRating,
      homeLocation: row.homeLocation,
      homeVenueId: row.homeVenueId,
      titles: parseTitlesJson(row.titlesJson, legacyCount: row.titlesWon),
      promotionsWon: row.promotionsWon,
      relegations: row.relegations,
      careerPlayed: row.careerPlayed,
      careerWon: row.careerWon,
      careerDrawn: row.careerDrawn,
      careerLost: row.careerLost,
      careerGoalsFor: row.careerGoalsFor,
      careerGoalsAgainst: row.careerGoalsAgainst,
      createdAt: row.createdAt,
    );

TeamList teamListFromRow(TeamListsTableData row, {List<int> teamIds = const []}) =>
    TeamList(
      id: row.id,
      name: row.name,
      createdAt: row.createdAt,
      teamIds: teamIds,
    );

League leagueFromRow(LeaguesTableData row) {
  Map<String, dynamic> map = {};
  try {
    final decoded = jsonDecode(row.configJson);
    if (decoded is Map<String, dynamic>) map = decoded;
  } catch (_) {}
  // Merge legacy flat columns into config if missing
  map.putIfAbsent('pointsForWin', () => row.pointsForWin);
  map.putIfAbsent('pointsForDraw', () => row.pointsForDraw);
  map.putIfAbsent('meetingsPerPair', () => row.meetingsPerPair);
  return League(
    id: row.id,
    name: row.name,
    status: parseLeagueStatus(row.status),
    format: parseFormat(row.format),
    config: TournamentConfig.fromJson(map),
    promoteCount: row.promoteCount,
    relegateCount: row.relegateCount,
    promoRelegEnabled: row.promoRelegEnabled,
    seasonNumber: row.seasonNumber,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

Division divisionFromRow(DivisionsTableData row) => Division(
      id: row.id,
      leagueId: row.leagueId,
      name: row.name,
      tierIndex: row.tierIndex,
      currentTournamentId: row.currentTournamentId,
    );

TournamentTeam tournamentTeamFromRow(
  TournamentTeamsTableData row, {
  Team? team,
}) =>
    TournamentTeam(
      id: row.id,
      tournamentId: row.tournamentId,
      teamId: row.teamId,
      seed: row.seed,
      groupLabel: row.groupLabel,
      team: team,
    );

Match matchFromRow(MatchesTableData row) {
  final series = SeriesScore.tryParse(row.seriesJson);
  return Match(
    id: row.id,
    tournamentId: row.tournamentId,
    round: row.round,
    stage: parseMatchStage(row.stage),
    groupLabel: row.groupLabel,
    bracketSlot: row.bracketSlot,
    homeTeamId: row.homeTeamId,
    awayTeamId: row.awayTeamId,
    homeScore: row.homeScore,
    awayScore: row.awayScore,
    status: parseMatchStatus(row.status),
    winnerAdvancesTo: row.winnerAdvancesTo,
    loserAdvancesTo: row.loserAdvancesTo,
    location: row.location,
    scheduledAt: row.scheduledAt,
    durationMinutes: row.durationMinutes,
    venueId: row.venueId,
    seriesJson: row.seriesJson,
    series: series,
  );
}

Venue venueFromRow(VenuesTableData row) => Venue(
      id: row.id,
      name: row.name,
      address: row.address,
      mapUrl: row.mapUrl,
      notes: row.notes,
      layoutImagePath: row.layoutImagePath,
      parentVenueId: row.parentVenueId,
      createdAt: row.createdAt,
    );
