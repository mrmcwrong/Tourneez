import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tourneez/data/backup.dart';
import 'package:tourneez/data/database.dart';
import 'package:tourneez/data/repository.dart';
import 'package:tourneez/domain/models.dart';

void main() {
  test('rejects non-Tourneez JSON', () {
    expect(
      () => parseAndValidateBackup('{"format":"other"}'),
      throwsA(isA<BackupException>()),
    );
  });

  test('rejects future schema versions', () {
    final envelope = buildBackupEnvelope(
      schemaVersion: tourneezSchemaVersion + 1,
      tables: {
        'teams': [],
        'teamLists': [],
        'teamListMembers': [],
        'leagues': [],
        'divisions': [],
        'divisionTeams': [],
        'tournaments': [],
        'tournamentTeams': [],
        'matches': [],
      },
    );
    expect(
      () => parseAndValidateBackup(jsonEncode(envelope)),
      throwsA(
        isA<BackupException>().having(
          (e) => e.message,
          'message',
          contains('newer Tourneez'),
        ),
      ),
    );
  });

  test('rejects broken foreign keys', () {
    final now = DateTime.now().millisecondsSinceEpoch;
    final envelope = buildBackupEnvelope(
      schemaVersion: tourneezSchemaVersion,
      tables: {
        'teams': [],
        'teamLists': [],
        'teamListMembers': [],
        'leagues': [],
        'divisions': [],
        'divisionTeams': [],
        'tournaments': [
          {
            'id': 1,
            'name': 'Cup',
            'format': 'roundRobin',
            'status': 'draft',
            'configJson': '{}',
            'leagueId': null,
            'divisionId': null,
            'createdAt': now,
            'updatedAt': null,
          },
        ],
        'tournamentTeams': [
          {
            'id': 1,
            'tournamentId': 1,
            'teamId': 99,
            'seed': 1,
            'groupLabel': null,
          },
        ],
        'matches': [],
      },
    );
    final validated = parseAndValidateBackup(jsonEncode(envelope));
    // Orphan tournament-team rows are pruned instead of rejecting the file.
    expect(validated.tables['tournamentTeams'], isEmpty);
    expect(validated.tables['tournaments'], hasLength(1));
  });

  test('prunes orphan divisions from dirty backups', () {
    final now = DateTime.now().millisecondsSinceEpoch;
    final envelope = buildBackupEnvelope(
      schemaVersion: tourneezSchemaVersion,
      tables: {
        'teams': [
          {
            'id': 1,
            'name': 'Only Team',
            'logoPath': null,
            'colorArgb': 0xFF0B6E4F,
            'powerRating': 50,
            'homeLocation': null,
            'titlesWon': 0,
            'titlesJson': '[]',
            'promotionsWon': 0,
            'relegations': 0,
            'careerPlayed': 0,
            'careerWon': 0,
            'careerDrawn': 0,
            'careerLost': 0,
            'careerGoalsFor': 0,
            'careerGoalsAgainst': 0,
            'createdAt': now,
          },
        ],
        'teamLists': [],
        'teamListMembers': [],
        'leagues': [
          {
            'id': 2,
            'name': 'Alive League',
            'status': 'draft',
            'format': 'roundRobin',
            'configJson': '{}',
            'promoteCount': 1,
            'relegateCount': 1,
            'promoRelegEnabled': true,
            'pointsForWin': 3,
            'pointsForDraw': 1,
            'meetingsPerPair': 1,
            'seasonNumber': 1,
            'createdAt': now,
            'updatedAt': null,
          },
        ],
        'divisions': [
          {
            'id': 1,
            'leagueId': 1,
            'name': 'Orphan Div',
            'tierIndex': 0,
            'currentTournamentId': null,
          },
          {
            'id': 3,
            'leagueId': 2,
            'name': 'Good Div',
            'tierIndex': 0,
            'currentTournamentId': null,
          },
        ],
        'divisionTeams': [
          {'id': 1, 'divisionId': 1, 'teamId': 1},
          {'id': 2, 'divisionId': 3, 'teamId': 1},
        ],
        'tournaments': [],
        'tournamentTeams': [],
        'matches': [],
      },
    );
    final validated = parseAndValidateBackup(jsonEncode(envelope));
    expect(validated.tables['divisions']!.map((d) => d['id']), [3]);
    expect(validated.tables['divisionTeams']!.map((d) => d['id']), [2]);
  });

  test('export/restore round-trip preserves teams and tournament', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = TourneezRepository(db);

    final a = await repo.createTeam(name: 'Alpha FC', powerRating: 61);
    final b = await repo.createTeam(name: 'Beta United', powerRating: 44);
    final c = await repo.createTeam(name: 'Gamma SC', powerRating: 50);
    final tid = await repo.createTournament(
      name: 'City Cup',
      format: TournamentFormat.roundRobin,
      config: const TournamentConfig(meetingsPerPair: 1),
      teamIds: [a, b, c],
    );
    final startErr = await repo.startTournament(tid);
    expect(startErr, isNull);

    final json = await repo.exportBackupJson(
      preferences: {'theme_mode': 'dark'},
    );
    final validated = parseAndValidateBackup(json);
    expect(validated.schemaVersion, tourneezSchemaVersion);
    expect(validated.tables['teams'], hasLength(3));
    expect(validated.tables['tournaments'], hasLength(1));
    expect(validated.tables['matches'], isNotEmpty);
    expect(validated.preferences['theme_mode'], 'dark');

    await repo.resetApp();
    expect(await repo.getTeams(), isEmpty);

    await repo.restoreBackupJson(json);
    final teams = await repo.getTeams();
    expect(teams.map((t) => t.name).toSet(), {
      'Alpha FC',
      'Beta United',
      'Gamma SC',
    });
    final tournament = await repo.getTournament(tid);
    expect(tournament?.name, 'City Cup');
    expect(tournament?.status, TournamentStatus.active);
    final matches = await repo.getMatches(tid);
    expect(matches, isNotEmpty);
  });

  test('deleteLeague removes archived season tournaments', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = TourneezRepository(db);

    final t1 = await repo.createTeam(name: 'North');
    final t2 = await repo.createTeam(name: 'South');
    final leagueId = await repo.createLeague(
      name: 'Metro League',
      format: TournamentFormat.roundRobin,
      config: const TournamentConfig(meetingsPerPair: 1),
      divisionNames: const ['Premier', 'First'],
      promoteCount: 1,
      relegateCount: 1,
    );
    final divisions = await repo.getDivisions(leagueId);
    await repo.setDivisionTeams(divisionId: divisions[0].id, teamIds: [t1]);
    await repo.setDivisionTeams(divisionId: divisions[1].id, teamIds: [t2]);

    // Create archived-style tournaments linked to the league.
    await repo.createTournament(
      name: 'Premier S1',
      format: TournamentFormat.roundRobin,
      config: const TournamentConfig(meetingsPerPair: 1),
      teamIds: [t1],
      leagueId: leagueId,
      divisionId: divisions[0].id,
    );
    await repo.createTournament(
      name: 'First S1',
      format: TournamentFormat.roundRobin,
      config: const TournamentConfig(meetingsPerPair: 1),
      teamIds: [t2],
      leagueId: leagueId,
      divisionId: divisions[1].id,
    );

    final before = await db.select(db.tournamentsTable).get();
    expect(before.where((t) => t.leagueId == leagueId), hasLength(2));

    await repo.deleteLeague(leagueId);
    final remaining = await db.select(db.tournamentsTable).get();
    expect(remaining.where((t) => t.leagueId == leagueId), isEmpty);
    expect(await repo.getLeague(leagueId), isNull);
  });
}
