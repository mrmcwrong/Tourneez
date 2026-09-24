import 'package:tourneez/domain/models.dart';

abstract class FormatEngine {
  /// Minimum number of enrolled teams required to start.
  int minTeams(TournamentConfig config);

  /// Validate enrollment before generating matches. Returns error message or null.
  String? validateTeams(TournamentConfig config, List<TournamentTeam> teams);

  /// Generate all initial matches (and optionally later rounds as placeholders).
  List<DraftMatch> generateInitialMatches(
    Tournament tournament,
    List<TournamentTeam> teams,
  );

  /// After results are entered, generate any newly unlocked matches.
  /// Returns empty if nothing new to create.
  List<DraftMatch> generateNextRound(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> existingMatches,
  );

  List<StandingRow> computeStandings(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> matches, {
    String? groupLabel,
  });

  bool isComplete(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> matches,
  );
}
