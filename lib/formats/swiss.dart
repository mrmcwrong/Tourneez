import 'package:collection/collection.dart';
import 'package:tourneez/domain/format_engine.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/formats/standings_utils.dart';

class SwissEngine implements FormatEngine {
  @override
  int minTeams(TournamentConfig config) => 4;

  @override
  String? validateTeams(TournamentConfig config, List<TournamentTeam> teams) {
    if (teams.length < minTeams(config)) {
      return 'Swiss needs at least ${minTeams(config)} teams.';
    }
    return null;
  }

  int _roundCount(Tournament tournament, int teamCount) {
    return tournament.config.swissRounds ?? defaultSwissRounds(teamCount);
  }

  @override
  List<DraftMatch> generateInitialMatches(
    Tournament tournament,
    List<TournamentTeam> teams,
  ) {
    final sorted = List<TournamentTeam>.from(teams)
      ..sort((a, b) => (a.seed ?? a.teamId).compareTo(b.seed ?? b.teamId));
    return _pairRound(1, sorted.map((t) => t.teamId).toList(), {});
  }

  @override
  List<DraftMatch> generateNextRound(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> existingMatches,
  ) {
    final totalRounds = _roundCount(tournament, teams.length);
    if (existingMatches.isEmpty) return const [];

    final maxRound =
        existingMatches.map((m) => m.round).maxOrNull ?? 0;
    if (maxRound >= totalRounds) return const [];

    final currentRoundMatches =
        existingMatches.where((m) => m.round == maxRound).toList();
    if (currentRoundMatches.isEmpty ||
        !currentRoundMatches.every((m) => m.isCompleted)) {
      return const [];
    }

    // Already generated next round?
    if (existingMatches.any((m) => m.round == maxRound + 1)) {
      return const [];
    }

    final standings = computeStandings(tournament, teams, existingMatches);
    final orderedIds = standings.map((s) => s.teamId).toList();

    final played = <(int, int)>{};
    for (final m in existingMatches) {
      if (m.homeTeamId != null && m.awayTeamId != null) {
        played.add(_pairKey(m.homeTeamId!, m.awayTeamId!));
      }
    }

    return _pairRound(maxRound + 1, orderedIds, played);
  }

  List<DraftMatch> _pairRound(
    int round,
    List<int> orderedByStanding,
    Set<(int, int)> alreadyPlayed,
  ) {
    final remaining = List<int>.from(orderedByStanding);
    final drafts = <DraftMatch>[];
    final unpaired = <int>[];

    while (remaining.isNotEmpty) {
      final a = remaining.removeAt(0);
      var paired = false;
      for (var i = 0; i < remaining.length; i++) {
        final b = remaining[i];
        if (!alreadyPlayed.contains(_pairKey(a, b))) {
          remaining.removeAt(i);
          drafts.add(
            DraftMatch(
              round: round,
              stage: MatchStage.swiss,
              homeTeamId: a,
              awayTeamId: b,
            ),
          );
          paired = true;
          break;
        }
      }
      if (!paired) {
        unpaired.add(a);
      }
    }

    // Bye for leftover (odd count or forced rematch avoidance failure)
    for (final id in unpaired) {
      drafts.add(
        DraftMatch(
          round: round,
          stage: MatchStage.swiss,
          homeTeamId: id,
          awayTeamId: null,
          status: MatchStatus.bye,
          homeScore: 1,
          awayScore: 0,
        ),
      );
    }

    // If two left unpaired who already played, force rematch
    // (handled by bye loop above for singles; if two remain from failed pairing,
    // re-pair them)
    // Rebuild if we somehow have 2+ unpaired without byes intent:
    if (unpaired.length >= 2) {
      drafts.removeWhere(
        (d) => d.status == MatchStatus.bye && unpaired.contains(d.homeTeamId),
      );
      for (var i = 0; i + 1 < unpaired.length; i += 2) {
        drafts.add(
          DraftMatch(
            round: round,
            stage: MatchStage.swiss,
            homeTeamId: unpaired[i],
            awayTeamId: unpaired[i + 1],
          ),
        );
      }
      if (unpaired.length.isOdd) {
        drafts.add(
          DraftMatch(
            round: round,
            stage: MatchStage.swiss,
            homeTeamId: unpaired.last,
            awayTeamId: null,
            status: MatchStatus.bye,
            homeScore: 1,
            awayScore: 0,
          ),
        );
      }
    }

    return drafts;
  }

  (int, int) _pairKey(int a, int b) => a < b ? (a, b) : (b, a);

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
    final totalRounds = _roundCount(tournament, teams.length);
    if (matches.isEmpty) return false;
    final maxRound = matches.map((m) => m.round).maxOrNull ?? 0;
    if (maxRound < totalRounds) return false;
    return matches.every((m) => m.isCompleted);
  }
}
