import 'package:collection/collection.dart';
import 'package:tourneez/domain/format_engine.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/formats/bracket_utils.dart';
import 'package:tourneez/formats/standings_utils.dart';

/// Double elimination with winners bracket, losers bracket, and grand final.
///
/// Structure (power-of-two, with byes as needed):
/// - Winners bracket: standard single-elim tree
/// - Losers of WB round R feed into LB
/// - When LB has more survivors than WB drop-ins, LB plays down first
/// - LB champion meets the WB champion in the grand final
class DoubleEliminationEngine implements FormatEngine {
  @override
  int minTeams(TournamentConfig config) => 4;

  @override
  String? validateTeams(TournamentConfig config, List<TournamentTeam> teams) {
    if (teams.length < minTeams(config)) {
      return 'Double elimination needs at least ${minTeams(config)} teams.';
    }
    return null;
  }

  @override
  List<DraftMatch> generateInitialMatches(
    Tournament tournament,
    List<TournamentTeam> teams,
  ) {
    final sorted = List<TournamentTeam>.from(teams)
      ..sort((a, b) => (a.seed ?? a.teamId).compareTo(b.seed ?? b.teamId));
    return _build(sorted.map((t) => t.teamId).toList());
  }

  List<DraftMatch> _build(List<int> seeded) {
    final wb = buildSingleElimTree(
      seededTeamIds: seeded,
      stage: MatchStage.winners,
      groupLabel: 'Winners',
    );

    final wbFinal = wb.firstWhere((m) => m.winnerAdvancesTo == null);
    final wbRounds = wb.map((m) => m.round).max;
    var nextSlot = wb.map((m) => m.bracketSlot!).max + 1;

    final byRound = <int, List<DraftMatch>>{};
    for (final m in wb) {
      byRound.putIfAbsent(m.round, () => []).add(m);
    }
    for (final list in byRound.values) {
      list.sort((a, b) => a.bracketSlot!.compareTo(b.bracketSlot!));
    }

    final lb = <DraftMatch>[];
    final wbR1 = byRound[1] ?? [];
    final lbR1Slots = <int>[];
    var lbRound = 1;

    // LB round 1: pair WB R1 losers.
    for (var i = 0; i < wbR1.length; i += 2) {
      final slot = nextSlot++;
      lbR1Slots.add(slot);
      lb.add(
        DraftMatch(
          round: lbRound,
          stage: MatchStage.losers,
          groupLabel: 'Losers',
          bracketSlot: slot,
        ),
      );
      final a = wb.indexWhere((d) => d.bracketSlot == wbR1[i].bracketSlot);
      wb[a] = wb[a].copyWith(loserAdvancesTo: slot);
      if (i + 1 < wbR1.length) {
        final b = wb.indexWhere((d) => d.bracketSlot == wbR1[i + 1].bracketSlot);
        wb[b] = wb[b].copyWith(loserAdvancesTo: slot);
      }
    }

    var prevLbSlots = lbR1Slots;
    for (var wbRound = 2; wbRound <= wbRounds; wbRound++) {
      final wbMatches = byRound[wbRound] ?? [];
      final dropIns = wbMatches.length;

      // Play LB survivors down until they match WB drop-in count.
      while (prevLbSlots.length > dropIns && prevLbSlots.length >= 2) {
        lbRound++;
        final reduced = <int>[];
        for (var i = 0; i < prevLbSlots.length; i += 2) {
          if (i + 1 >= prevLbSlots.length) {
            // Odd survivor gets a bye slot into the next round.
            reduced.add(prevLbSlots[i]);
            continue;
          }
          final slot = nextSlot++;
          reduced.add(slot);
          lb.add(
            DraftMatch(
              round: lbRound,
              stage: MatchStage.losers,
              groupLabel: 'Losers',
              bracketSlot: slot,
            ),
          );
          for (final prev in [prevLbSlots[i], prevLbSlots[i + 1]]) {
            final idx = lb.indexWhere((d) => d.bracketSlot == prev);
            if (idx >= 0) {
              lb[idx] = lb[idx].copyWith(winnerAdvancesTo: slot);
            }
          }
        }
        prevLbSlots = reduced;
      }

      // Drop-in round: each WB loser faces one LB survivor.
      lbRound++;
      final thisLbSlots = <int>[];
      for (var i = 0; i < dropIns; i++) {
        final slot = nextSlot++;
        thisLbSlots.add(slot);
        lb.add(
          DraftMatch(
            round: lbRound,
            stage: MatchStage.losers,
            groupLabel: 'Losers',
            bracketSlot: slot,
          ),
        );

        final wbIdx =
            wb.indexWhere((d) => d.bracketSlot == wbMatches[i].bracketSlot);
        if (wbIdx >= 0) {
          wb[wbIdx] = wb[wbIdx].copyWith(loserAdvancesTo: slot);
        }

        if (i < prevLbSlots.length) {
          final lbIdx = lb.indexWhere((d) => d.bracketSlot == prevLbSlots[i]);
          if (lbIdx >= 0) {
            lb[lbIdx] = lb[lbIdx].copyWith(winnerAdvancesTo: slot);
          }
        }
      }
      prevLbSlots = thisLbSlots;
    }

    // Ensure a single LB champion.
    while (prevLbSlots.length > 1) {
      lbRound++;
      final reduced = <int>[];
      for (var i = 0; i < prevLbSlots.length; i += 2) {
        if (i + 1 >= prevLbSlots.length) {
          reduced.add(prevLbSlots[i]);
          continue;
        }
        final slot = nextSlot++;
        reduced.add(slot);
        lb.add(
          DraftMatch(
            round: lbRound,
            stage: MatchStage.losers,
            groupLabel: 'Losers',
            bracketSlot: slot,
          ),
        );
        for (final prev in [prevLbSlots[i], prevLbSlots[i + 1]]) {
          final idx = lb.indexWhere((d) => d.bracketSlot == prev);
          if (idx >= 0) {
            lb[idx] = lb[idx].copyWith(winnerAdvancesTo: slot);
          }
        }
      }
      prevLbSlots = reduced;
    }

    final gfSlot = nextSlot;
    final gf = DraftMatch(
      round: 1,
      stage: MatchStage.grandFinal,
      groupLabel: 'Grand Final',
      bracketSlot: gfSlot,
    );

    final wbFinalIdx =
        wb.indexWhere((d) => d.bracketSlot == wbFinal.bracketSlot);
    wb[wbFinalIdx] = wb[wbFinalIdx].copyWith(winnerAdvancesTo: gfSlot);

    if (prevLbSlots.isNotEmpty) {
      final lbChampIdx =
          lb.indexWhere((d) => d.bracketSlot == prevLbSlots.last);
      if (lbChampIdx >= 0) {
        lb[lbChampIdx] = lb[lbChampIdx].copyWith(winnerAdvancesTo: gfSlot);
      }
    }

    return [...wb, ...lb, gf];
  }

  @override
  List<DraftMatch> generateNextRound(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> existingMatches,
  ) =>
      const [];

  @override
  List<StandingRow> computeStandings(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> matches, {
    String? groupLabel,
  }) {
    return computeStandingsFromMatches(
      teamIds: teams.map((t) => t.teamId).toList(),
      matches: matches,
      config: tournament.config,
      teamsById: {for (final t in teams) t.teamId: t.team},
    );
  }

  @override
  bool isComplete(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> matches,
  ) {
    final gf = matches.where((m) => m.stage == MatchStage.grandFinal);
    return gf.isNotEmpty && gf.every((m) => m.isCompleted);
  }
}
