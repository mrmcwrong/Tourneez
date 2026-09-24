import 'package:tourneez/domain/format_engine.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/formats/standings_utils.dart';

class RoundRobinEngine implements FormatEngine {
  @override
  int minTeams(TournamentConfig config) => 3;

  @override
  String? validateTeams(TournamentConfig config, List<TournamentTeam> teams) {
    if (teams.length < minTeams(config)) {
      return 'Round robin needs at least ${minTeams(config)} teams.';
    }
    if (config.meetingsPerPair < 1) {
      return 'Meetings per pair must be at least 1.';
    }
    return null;
  }

  @override
  List<DraftMatch> generateInitialMatches(
    Tournament tournament,
    List<TournamentTeam> teams,
  ) {
    final ids = teams.map((t) => t.teamId).toList();
    final homeLocations = {
      for (final t in teams)
        if (t.homeLocation != null && t.homeLocation!.trim().isNotEmpty)
          t.teamId: t.homeLocation!.trim(),
    };
    final homeVenueIds = {
      for (final t in teams)
        if (t.homeVenueId != null) t.teamId: t.homeVenueId!,
    };
    final baseRounds = circleMethodRounds(ids);
    final drafts = <DraftMatch>[];
    final meetings = tournament.config.meetingsPerPair.clamp(1, 6);

    for (var leg = 0; leg < meetings; leg++) {
      final swap = leg.isOdd;
      final roundOffset = leg * baseRounds.length;
      for (var r = 0; r < baseRounds.length; r++) {
        for (final (a, b) in baseRounds[r]) {
          final home = swap ? b : a;
          final away = swap ? a : b;
          drafts.add(
            DraftMatch(
              round: roundOffset + r + 1,
              stage: MatchStage.roundRobin,
              homeTeamId: home,
              awayTeamId: away,
              location: homeLocations[home],
              venueId: homeVenueIds[home],
            ),
          );
        }
      }
    }

    return drafts;
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
    if (matches.isEmpty) return false;
    return matches.every((m) => m.isCompleted);
  }
}
