import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tourneez/data/database.dart';
import 'package:tourneez/data/repository.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/domain/schedule_format.dart';

void main() {
  test('scheduleRoundKickoffs spaces matches by duration + gap', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = TourneezRepository(db);

    final a = await repo.createTeam(name: 'A');
    final b = await repo.createTeam(name: 'B');
    final c = await repo.createTeam(name: 'C');
    final tid = await repo.createTournament(
      name: 'Cup',
      format: TournamentFormat.roundRobin,
      config: const TournamentConfig(meetingsPerPair: 1),
      teamIds: [a, b, c],
    );
    expect(await repo.startTournament(tid), isNull);

    final matches = await repo.getMatches(tid);
    final round = matches.first.round;
    final first = DateTime(2026, 9, 20, 9, 0);
    expect(
      await repo.scheduleRoundKickoffs(
        tournamentId: tid,
        round: round,
        firstKickoff: first,
        gapMinutes: 15,
        durationMinutes: 90,
      ),
      isNull,
    );

    final scheduled = (await repo.getMatches(tid))
        .where((m) => m.round == round && m.status != MatchStatus.bye)
        .toList()
      ..sort((x, y) => x.scheduledAt!.compareTo(y.scheduledAt!));
    expect(scheduled, isNotEmpty);
    expect(scheduled.first.scheduledAt, first);
    expect(scheduled.first.durationMinutes, 90);
    if (scheduled.length > 1) {
      expect(
        scheduled[1].scheduledAt,
        first.add(const Duration(minutes: 105)),
      );
    }
  });

  test('scheduleRoundKickoffs can assign home team venues', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = TourneezRepository(db);

    final venueId = await repo.createVenue(
      name: 'Home Ground',
      address: '1 Pitch Rd',
    );
    final a = await repo.createTeam(name: 'A', homeVenueId: venueId);
    final b = await repo.createTeam(name: 'B');
    final c = await repo.createTeam(name: 'C');
    final tid = await repo.createTournament(
      name: 'Cup',
      format: TournamentFormat.roundRobin,
      config: const TournamentConfig(meetingsPerPair: 1),
      teamIds: [a, b, c],
    );
    expect(await repo.startTournament(tid), isNull);

    final homeA = (await repo.getMatches(tid))
        .where((m) => m.homeTeamId == a && m.status != MatchStatus.bye)
        .toList();
    expect(homeA, isNotEmpty);
    // Draft generation should already stamp the home venue.
    expect(homeA.first.venueId, venueId);

    await repo.updateMatchDetails(
      matchId: homeA.first.id,
      clearVenue: true,
      clearLocation: true,
    );
    expect(
      await repo.scheduleRoundKickoffs(
        tournamentId: tid,
        round: homeA.first.round,
        firstKickoff: DateTime(2026, 9, 21, 10),
        useHomeTeamVenue: true,
      ),
      isNull,
    );

    final refreshed = (await repo.getMatches(tid))
        .firstWhere((m) => m.id == homeA.first.id);
    expect(refreshed.venueId, venueId);
    expect(refreshed.location, contains('Home Ground'));
  });

  test('buildTournamentIcs includes kickoff events', () {
    final created = DateTime(2026, 1, 1);
    final tournament = Tournament(
      id: 1,
      name: 'City Cup',
      format: TournamentFormat.roundRobin,
      status: TournamentStatus.active,
      config: const TournamentConfig(),
      createdAt: created,
    );
    final match = Match(
      id: 9,
      tournamentId: 1,
      round: 1,
      stage: MatchStage.group,
      homeTeamId: 1,
      awayTeamId: 2,
      status: MatchStatus.pending,
      scheduledAt: DateTime.utc(2026, 9, 20, 13, 0),
      durationMinutes: 90,
      location: 'Riverside Field',
    );
    Team team(int id, String name) => Team(
          id: id,
          name: name,
          colorArgb: 0xFF000000,
          powerRating: 50,
          titles: const [],
          promotionsWon: 0,
          relegations: 0,
          careerPlayed: 0,
          careerWon: 0,
          careerDrawn: 0,
          careerLost: 0,
          careerGoalsFor: 0,
          careerGoalsAgainst: 0,
          createdAt: created,
        );

    final ics = buildTournamentIcs(
      tournament: tournament,
      matches: [match],
      teamsById: {
        1: TournamentTeam(
          id: 1,
          tournamentId: 1,
          teamId: 1,
          team: team(1, 'Alpha'),
        ),
        2: TournamentTeam(
          id: 2,
          tournamentId: 1,
          teamId: 2,
          team: team(2, 'Beta'),
        ),
      },
    );

    expect(ics, contains('BEGIN:VCALENDAR'));
    expect(ics, contains('SUMMARY:Alpha vs Beta'));
    expect(ics, contains('LOCATION:Riverside Field'));
    expect(ics, contains('DTSTART:'));
    expect(ics, contains('END:VEVENT'));
  });
}
