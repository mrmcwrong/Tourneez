import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tourneez/data/database.dart';
import 'package:tourneez/data/repository.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/domain/venue_maps.dart';

void main() {
  late AppDatabase db;
  late TourneezRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = TourneezRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('create standalone venue and nested fields', () async {
    final complexId = await repo.createVenue(
      name: 'Riverside Complex',
      address: '100 River Rd',
    );
    final f1 = await repo.createVenue(
      name: 'Field 1',
      parentVenueId: complexId,
    );
    final f2 = await repo.createVenue(
      name: 'Field 2',
      parentVenueId: complexId,
      notes: 'Near parking',
    );

    final venues = await repo.getVenues();
    expect(venues, hasLength(3));

    final complex = await repo.getVenue(complexId);
    expect(complex?.isTopLevel, isTrue);
    expect(complex?.address, '100 River Rd');

    final children = await repo.getChildVenues(complexId);
    expect(children.map((c) => c.id).toSet(), {f1, f2});
    expect(children.every((c) => c.isField), isTrue);
  });

  test('assign venue syncs location text and detects conflicts', () async {
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

    final venueId = await repo.createVenue(
      name: 'Main Pitch',
      address: '9 Goal Ave',
    );
    final matches = await repo.getMatches(tid);
    expect(matches.length, greaterThanOrEqualTo(2));

    final kickoff = DateTime(2026, 9, 20, 10);
    final err1 = await repo.updateMatchDetails(
      matchId: matches[0].id,
      venueId: venueId,
      scheduledAt: kickoff,
      durationMinutes: 90,
    );
    expect(err1, isNull);

    final updated = (await repo.getMatches(tid))
        .firstWhere((m) => m.id == matches[0].id);
    expect(updated.venueId, venueId);
    expect(updated.location, contains('Main Pitch'));
    expect(updated.location, contains('9 Goal Ave'));

    final warning = await repo.venueConflictWarning(
      venueId: venueId,
      kickoff: kickoff.add(const Duration(minutes: 30)),
      durationMinutes: 90,
      ignoreMatchId: matches[1].id,
    );
    expect(warning, isNotNull);

    final used = await repo.getVenuesUsedByTournaments([tid]);
    expect(used.map((v) => v.id), [venueId]);
  });

  test('venueDisplayLabel and maps helpers', () {
    final parent = Venue(
      id: 1,
      name: 'Complex',
      address: '1 Park Lane',
      createdAt: DateTime(2026),
    );
    final field = Venue(
      id: 2,
      name: 'Field 1',
      parentVenueId: 1,
      createdAt: DateTime(2026),
    );

    expect(venueDisplayLabel(field, parent: parent), 'Field 1 · Complex');
    expect(venueEffectiveAddress(field, parent: parent), '1 Park Lane');
    expect(
      venueLocationText(field, parent: parent),
      'Field 1 · Complex (1 Park Lane)',
    );
    expect(venueMapsUri(field, parent: parent)?.host, 'www.google.com');
  });

  test('deleting complex clears match venueIds', () async {
    final a = await repo.createTeam(name: 'A');
    final b = await repo.createTeam(name: 'B');
    final c = await repo.createTeam(name: 'C');
    final tid = await repo.createTournament(
      name: 'Cup',
      format: TournamentFormat.roundRobin,
      config: const TournamentConfig(meetingsPerPair: 1),
      teamIds: [a, b, c],
    );
    await repo.startTournament(tid);

    final complexId = await repo.createVenue(name: 'Complex', address: 'X');
    final fieldId =
        await repo.createVenue(name: 'Field 1', parentVenueId: complexId);
    final match = (await repo.getMatches(tid)).first;
    await repo.updateMatchDetails(matchId: match.id, venueId: fieldId);

    await repo.deleteVenue(complexId);
    expect(await repo.getVenues(), isEmpty);
    final cleared = (await repo.getMatches(tid))
        .firstWhere((m) => m.id == match.id);
    expect(cleared.venueId, isNull);
  });
}
