import 'package:flutter_test/flutter_test.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/formats/double_elim.dart';
import 'package:tourneez/formats/groups_only.dart';
import 'package:tourneez/formats/hybrid.dart';
import 'package:tourneez/formats/round_robin.dart';
import 'package:tourneez/formats/single_elim.dart';
import 'package:tourneez/formats/swiss.dart';

Tournament _t({
  required TournamentFormat format,
  TournamentConfig config = const TournamentConfig(),
}) {
  return Tournament(
    id: 1,
    name: 'Test',
    format: format,
    status: TournamentStatus.active,
    config: config,
    createdAt: DateTime(2026),
  );
}

List<TournamentTeam> _teams(int n) {
  return List.generate(
    n,
    (i) => TournamentTeam(
      id: i + 1,
      tournamentId: 1,
      teamId: i + 1,
      seed: i + 1,
    ),
  );
}

void main() {
  group('categories', () {
    test('formats map to categories', () {
      expect(TournamentFormat.singleElimination.category,
          TournamentCategory.bracket);
      expect(TournamentFormat.roundRobin.category, TournamentCategory.league);
      expect(TournamentFormat.hybrid.category, TournamentCategory.hybrid);
      expect(TournamentFormat.singleElimination.showsStandings, isFalse);
      expect(TournamentFormat.roundRobin.showsStandings, isTrue);
    });
  });

  group('RoundRobinEngine', () {
    final engine = RoundRobinEngine();

    test('generates all-play-all once when meetingsPerPair is 1', () {
      final drafts = engine.generateInitialMatches(
        _t(
          format: TournamentFormat.roundRobin,
          config: const TournamentConfig(meetingsPerPair: 1),
        ),
        _teams(4),
      );
      expect(drafts.length, 6);
    });

    test('defaults to two meetings per pair', () {
      final drafts = engine.generateInitialMatches(
        _t(format: TournamentFormat.roundRobin),
        _teams(4),
      );
      expect(drafts.length, 12);
    });

    test('swaps home/away on second meeting', () {
      final drafts = engine.generateInitialMatches(
        _t(
          format: TournamentFormat.roundRobin,
          config: const TournamentConfig(meetingsPerPair: 2),
        ),
        _teams(3),
      );
      // 3 teams => 3 pairs × 2 = 6
      expect(drafts.length, 6);
      final firstLeg = drafts.where((d) => d.round <= 3).toList();
      final secondLeg = drafts.where((d) => d.round > 3).toList();
      expect(firstLeg.length, 3);
      expect(secondLeg.length, 3);
      final pair = (firstLeg.first.homeTeamId!, firstLeg.first.awayTeamId!);
      final rematch = secondLeg.firstWhere(
        (d) =>
            {d.homeTeamId, d.awayTeamId}.containsAll({pair.$1, pair.$2}),
      );
      expect(rematch.homeTeamId, pair.$2);
      expect(rematch.awayTeamId, pair.$1);
    });
  });

  group('SwissEngine', () {
    final engine = SwissEngine();

    test('first round pairs all teams', () {
      final drafts = engine.generateInitialMatches(
        _t(
          format: TournamentFormat.swiss,
          config: const TournamentConfig(swissRounds: 3),
        ),
        _teams(8),
      );
      expect(drafts.length, 4);
    });

    test('generates next round after completion', () {
      final tournament = _t(
        format: TournamentFormat.swiss,
        config: const TournamentConfig(swissRounds: 3),
      );
      final teams = _teams(4);
      final first = engine.generateInitialMatches(tournament, teams);
      final completed = [
        for (var i = 0; i < first.length; i++)
          Match(
            id: i + 1,
            tournamentId: 1,
            round: first[i].round,
            stage: MatchStage.swiss,
            homeTeamId: first[i].homeTeamId,
            awayTeamId: first[i].awayTeamId,
            homeScore: 1,
            awayScore: 0,
            status: MatchStatus.completed,
          ),
      ];
      final next = engine.generateNextRound(tournament, teams, completed);
      expect(next.length, 2);
      expect(next.first.round, 2);
    });
  });

  group('SingleEliminationEngine', () {
    final engine = SingleEliminationEngine();

    test('pads to power of two with byes', () {
      final drafts = engine.generateInitialMatches(
        _t(format: TournamentFormat.singleElimination),
        _teams(5),
      );
      expect(drafts.length, 7);
      expect(drafts.where((d) => d.status == MatchStatus.bye).length, 3);
    });

    test('includes 3rd place when configured', () {
      final drafts = engine.generateInitialMatches(
        _t(
          format: TournamentFormat.singleElimination,
          config: const TournamentConfig(includeThirdPlace: true),
        ),
        _teams(4),
      );
      expect(drafts.any((d) => d.groupLabel == '3rd Place'), isTrue);
      expect(drafts.where((d) => d.loserAdvancesTo != null).length, 2);
    });
  });

  group('DoubleEliminationEngine', () {
    test('builds winners, losers, and grand final', () {
      final drafts = DoubleEliminationEngine().generateInitialMatches(
        _t(format: TournamentFormat.doubleElimination),
        _teams(4),
      );
      expect(drafts.any((d) => d.stage == MatchStage.winners), isTrue);
      expect(drafts.any((d) => d.stage == MatchStage.losers), isTrue);
      expect(drafts.any((d) => d.stage == MatchStage.grandFinal), isTrue);
      expect(drafts.any((d) => d.loserAdvancesTo != null), isTrue);
    });

    test('8 teams: WB losers feed LB, GF exists, enough LB matches', () {
      final drafts = DoubleEliminationEngine().generateInitialMatches(
        _t(format: TournamentFormat.doubleElimination),
        _teams(8),
      );
      final wb = drafts.where((d) => d.stage == MatchStage.winners).toList();
      final lb = drafts.where((d) => d.stage == MatchStage.losers).toList();
      final gf = drafts.where((d) => d.stage == MatchStage.grandFinal).toList();

      expect(gf, isNotEmpty);
      expect(lb.length, greaterThanOrEqualTo(6));
      for (final m in wb) {
        expect(
          m.loserAdvancesTo,
          isNotNull,
          reason: 'WB slot ${m.bracketSlot} should send loser to LB',
        );
      }
    });
  });

  group('GroupsOnlyEngine', () {
    final engine = GroupsOnlyEngine();

    test('creates group matches without knockout', () {
      final tournament = _t(
        format: TournamentFormat.groupsOnly,
        config: const TournamentConfig(groupSize: 4, meetingsPerPair: 1),
      );
      final teams = _teams(8);
      final groups = engine.assignGroups(tournament.config, teams);
      final withGroups = teams
          .map(
            (t) => TournamentTeam(
              id: t.id,
              tournamentId: t.tournamentId,
              teamId: t.teamId,
              seed: t.seed,
              groupLabel: groups[t.id],
            ),
          )
          .toList();
      final drafts = engine.generateInitialMatches(tournament, withGroups);
      expect(drafts.every((d) => d.stage == MatchStage.group), isTrue);
      expect(drafts, isNotEmpty);
    });
  });

  group('HybridEngine', () {
    final engine = HybridEngine();

    test('rejects non-divisible team counts for groups league', () {
      final err = engine.validateTeams(
        const TournamentConfig(
          leagueFormat: TournamentFormat.groupsOnly,
          groupSize: 4,
        ),
        _teams(6),
      );
      expect(err, isNotNull);
    });

    test('creates group matches then knockout after groups finish', () {
      final tournament = _t(
        format: TournamentFormat.hybrid,
        config: const TournamentConfig(
          leagueFormat: TournamentFormat.groupsOnly,
          bracketFormat: TournamentFormat.singleElimination,
          groupSize: 4,
          advancePerGroup: 2,
          meetingsPerPair: 1,
        ),
      );
      final teams = _teams(8);
      final groups = engine.assignGroups(tournament.config, teams);
      final withGroups = teams
          .map(
            (t) => TournamentTeam(
              id: t.id,
              tournamentId: t.tournamentId,
              teamId: t.teamId,
              seed: t.seed,
              groupLabel: groups[t.id],
            ),
          )
          .toList();

      final groupDrafts =
          engine.generateInitialMatches(tournament, withGroups);
      expect(groupDrafts.every((d) => d.stage == MatchStage.group), isTrue);

      final completed = [
        for (var i = 0; i < groupDrafts.length; i++)
          Match(
            id: i + 1,
            tournamentId: 1,
            round: groupDrafts[i].round,
            stage: MatchStage.group,
            groupLabel: groupDrafts[i].groupLabel,
            homeTeamId: groupDrafts[i].homeTeamId,
            awayTeamId: groupDrafts[i].awayTeamId,
            homeScore: 1,
            awayScore: 0,
            status: MatchStatus.completed,
          ),
      ];
      final ko = engine.generateNextRound(tournament, withGroups, completed);
      expect(ko, isNotEmpty);
      expect(
        ko.every(
          (d) =>
              d.stage == MatchStage.knockout ||
              d.stage == MatchStage.winners ||
              d.stage == MatchStage.losers ||
              d.stage == MatchStage.grandFinal,
        ),
        isTrue,
      );
    });

    test('round robin league feeds top teams into bracket', () {
      final tournament = _t(
        format: TournamentFormat.hybrid,
        config: const TournamentConfig(
          leagueFormat: TournamentFormat.roundRobin,
          bracketFormat: TournamentFormat.singleElimination,
          meetingsPerPair: 1,
          advancePerGroup: 4,
        ),
      );
      final teams = _teams(6);
      final league = engine.generateInitialMatches(tournament, teams);
      expect(league.every((d) => d.stage == MatchStage.roundRobin), isTrue);

      final completed = [
        for (var i = 0; i < league.length; i++)
          Match(
            id: i + 1,
            tournamentId: 1,
            round: league[i].round,
            stage: MatchStage.roundRobin,
            homeTeamId: league[i].homeTeamId,
            awayTeamId: league[i].awayTeamId,
            homeScore: 2,
            awayScore: 1,
            status: MatchStatus.completed,
          ),
      ];
      final ko = engine.generateNextRound(tournament, teams, completed);
      expect(ko.length, greaterThanOrEqualTo(3)); // 4-team SE tree
    });
  });

  group('TournamentConfig', () {
    test('migrates doubleRoundRobin flag', () {
      final config = TournamentConfig.fromJson({
        'doubleRoundRobin': true,
        'swissRounds': 5,
      });
      expect(config.meetingsPerPair, 2);
      expect(config.swissRounds, 5);
    });

    test('seriesLengthForMatch distinguishes SE final, DE GF, and KO', () {
      const config = TournamentConfig(
        knockoutSeriesLength: 3,
        finalSeriesEnabled: true,
        finalSeriesLength: 5,
      );

      // SE final: knockout, no advance target.
      expect(
        config.seriesLengthForMatch(
          stage: MatchStage.knockout,
          winnerAdvancesTo: null,
        ),
        5,
      );
      // SE semi: knockout with advance.
      expect(
        config.seriesLengthForMatch(
          stage: MatchStage.knockout,
          winnerAdvancesTo: 10,
        ),
        3,
      );
      // DE grand final.
      expect(
        config.seriesLengthForMatch(stage: MatchStage.grandFinal),
        5,
      );
      // DE WB final advances to GF — uses knockout series, not final.
      expect(
        config.seriesLengthForMatch(
          stage: MatchStage.winners,
          winnerAdvancesTo: 99,
        ),
        3,
      );
      // 3rd place uses knockout series.
      expect(
        config.seriesLengthForMatch(
          stage: MatchStage.knockout,
          groupLabel: '3rd Place',
          winnerAdvancesTo: null,
        ),
        3,
      );

      const noFinalSeries = TournamentConfig(
        knockoutSeriesLength: 3,
        finalSeriesEnabled: false,
        finalSeriesLength: 7,
      );
      expect(
        noFinalSeries.seriesLengthForMatch(stage: MatchStage.grandFinal),
        1,
      );
      expect(
        config.seriesLengthForMatch(stage: MatchStage.roundRobin),
        1,
      );
      expect(
        config.seriesLengthForMatch(stage: MatchStage.group),
        1,
      );
    });
  });
}
