import 'package:flutter_test/flutter_test.dart';
import 'package:tourneez/domain/models.dart';

void main() {
  test('formats expose sensible minimums', () {
    expect(TournamentFormat.hybrid.minTeams, greaterThanOrEqualTo(4));
    expect(TournamentFormat.roundRobin.minTeams, greaterThanOrEqualTo(3));
  });

  test('config round-trips meetings and hybrid phases', () {
    const config = TournamentConfig(
      pointsForLoss: 1,
      meetingsPerPair: 2,
      swissRounds: 5,
      leagueFormat: TournamentFormat.roundRobin,
      bracketFormat: TournamentFormat.doubleElimination,
      includeThirdPlace: true,
      tiebreakers: [
        Tiebreaker.points,
        Tiebreaker.wins,
        Tiebreaker.goalDifference,
      ],
    );
    final roundTripped = TournamentConfig.fromJson(config.toJson());
    expect(roundTripped.pointsForLoss, 1);
    expect(roundTripped.meetingsPerPair, 2);
    expect(roundTripped.swissRounds, 5);
    expect(roundTripped.leagueFormat, TournamentFormat.roundRobin);
    expect(roundTripped.bracketFormat, TournamentFormat.doubleElimination);
    expect(roundTripped.includeThirdPlace, isTrue);
    expect(roundTripped.tiebreakers, [
      Tiebreaker.points,
      Tiebreaker.wins,
      Tiebreaker.goalDifference,
    ]);
  });

  test('parseFormatName migrates legacy formats', () {
    expect(parseFormatName('consolation'), TournamentFormat.singleElimination);
    expect(parseFormatName('worldCup'), TournamentFormat.hybrid);
  });
}
