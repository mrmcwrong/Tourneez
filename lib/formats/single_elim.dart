import 'package:tourneez/domain/format_engine.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/formats/bracket_utils.dart';
import 'package:tourneez/formats/standings_utils.dart';

class SingleEliminationEngine implements FormatEngine {
  @override
  int minTeams(TournamentConfig config) => 2;

  @override
  String? validateTeams(TournamentConfig config, List<TournamentTeam> teams) {
    if (teams.length < minTeams(config)) {
      return 'Single elimination needs at least ${minTeams(config)} teams.';
    }
    if (config.includeThirdPlace && teams.length < 4) {
      return '3rd-place match needs at least 4 teams.';
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
    return buildSingleElimTree(
      seededTeamIds: sorted.map((t) => t.teamId).toList(),
      stage: MatchStage.knockout,
      includeThirdPlace: tournament.config.includeThirdPlace,
    );
  }

  @override
  List<DraftMatch> generateNextRound(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> existingMatches,
  ) =>
      const [];

  List<Match> advanceWinners(List<Match> matches) =>
      advanceBracketParticipants(matches);

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
    if (matches.isEmpty) return false;
    final championship = matches.where(
      (m) => m.winnerAdvancesTo == null && m.groupLabel != '3rd Place',
    );
    final third = matches.where((m) => m.groupLabel == '3rd Place');
    return championship.isNotEmpty &&
        championship.every((m) => m.isCompleted) &&
        (third.isEmpty || third.every((m) => m.isCompleted));
  }
}
