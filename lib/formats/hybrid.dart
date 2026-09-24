import 'package:collection/collection.dart';
import 'package:tourneez/domain/format_engine.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/formats/double_elim.dart';
import 'package:tourneez/formats/groups_only.dart';
import 'package:tourneez/formats/round_robin.dart';
import 'package:tourneez/formats/single_elim.dart';
import 'package:tourneez/formats/standings_utils.dart';
import 'package:tourneez/formats/swiss.dart';

/// Configurable league phase that feeds into a knockout bracket.
class HybridEngine implements FormatEngine {
  final _rr = RoundRobinEngine();
  final _swiss = SwissEngine();
  final _groups = GroupsOnlyEngine();
  final _se = SingleEliminationEngine();
  final _de = DoubleEliminationEngine();

  TournamentFormat _league(TournamentConfig c) =>
      c.leagueFormat.isLeagueFormat ? c.leagueFormat : TournamentFormat.groupsOnly;

  TournamentFormat _bracket(TournamentConfig c) =>
      c.bracketFormat.isBracketFormat
          ? c.bracketFormat
          : TournamentFormat.singleElimination;

  FormatEngine _leagueEngine(TournamentConfig c) => switch (_league(c)) {
        TournamentFormat.swiss => _swiss,
        TournamentFormat.roundRobin => _rr,
        _ => _groups,
      };

  FormatEngine _bracketEngine(TournamentConfig c) =>
      _bracket(c) == TournamentFormat.doubleElimination ? _de : _se;

  @override
  int minTeams(TournamentConfig config) {
    final leagueMin = _leagueEngine(config).minTeams(config);
    final bracketMin = _bracketEngine(config).minTeams(config);
    return [4, leagueMin, bracketMin].reduce((a, b) => a > b ? a : b);
  }

  @override
  String? validateTeams(TournamentConfig config, List<TournamentTeam> teams) {
    if (teams.length < minTeams(config)) {
      return 'Hybrid needs at least ${minTeams(config)} teams.';
    }
    final leagueErr = _leagueEngine(config).validateTeams(config, teams);
    if (leagueErr != null) return leagueErr;

    final league = _league(config);
    if (league == TournamentFormat.groupsOnly) {
      final groupSize = config.groupSize;
      final groups = teams.length ~/ groupSize;
      final qualifiers = groups * config.advancePerGroup;
      if (qualifiers < 2) {
        return 'Need at least 2 teams advancing to knockout.';
      }
      if (config.advancePerGroup > groupSize) {
        return 'Cannot advance more teams than group size.';
      }
      final bracketErr = _bracketEngine(config).validateTeams(
        config,
        List.generate(
          qualifiers,
          (i) => TournamentTeam(id: i, tournamentId: 0, teamId: i + 1),
        ),
      );
      if (bracketErr != null) return bracketErr;
    } else {
      final advance = config.advancePerGroup.clamp(2, teams.length);
      if (advance < 2) return 'Need at least 2 teams advancing to knockout.';
      if (advance > teams.length) {
        return 'Cannot advance more teams than are enrolled.';
      }
      final bracketErr = _bracketEngine(config).validateTeams(
        config,
        List.generate(
          advance,
          (i) => TournamentTeam(id: i, tournamentId: 0, teamId: i + 1),
        ),
      );
      if (bracketErr != null) return bracketErr;
    }
    return null;
  }

  Map<int, String> assignGroups(
    TournamentConfig config,
    List<TournamentTeam> teams,
  ) {
    if (_league(config) != TournamentFormat.groupsOnly) return {};
    return _groups.assignGroups(config, teams);
  }

  @override
  List<DraftMatch> generateInitialMatches(
    Tournament tournament,
    List<TournamentTeam> teams,
  ) {
    final league = _league(tournament.config);
    if (league == TournamentFormat.groupsOnly) {
      return _groups.generateInitialMatches(tournament, teams);
    }
    if (league == TournamentFormat.swiss) {
      return _swiss.generateInitialMatches(tournament, teams);
    }
    // Round robin league phase uses roundRobin stage.
    return _rr.generateInitialMatches(tournament, teams);
  }

  @override
  List<DraftMatch> generateNextRound(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> existingMatches,
  ) {
    final knockoutMatches =
        existingMatches.where((m) => m.isBracketMatch).toList();
    if (knockoutMatches.isNotEmpty) return const [];

    final league = _league(tournament.config);
    final leagueMatches = existingMatches
        .where((m) => !m.isBracketMatch)
        .toList();
    if (leagueMatches.isEmpty) return const [];

    // Swiss may still need more league rounds.
    if (league == TournamentFormat.swiss) {
      final more = _swiss.generateNextRound(tournament, teams, leagueMatches);
      if (more.isNotEmpty) return more;
      if (!_swiss.isComplete(tournament, teams, leagueMatches)) {
        return const [];
      }
    } else if (!leagueMatches.every((m) => m.isCompleted)) {
      return const [];
    }

    final seeded = _qualifiers(tournament, teams, leagueMatches);
    if (seeded.length < 2) return const [];

    final bracketTeams = seeded
        .mapIndexed(
          (i, id) => TournamentTeam(
            id: i,
            tournamentId: tournament.id,
            teamId: id,
            seed: i + 1,
          ),
        )
        .toList();

    // Bracket engines read includeThirdPlace from tournament.config.
    final koDrafts = _bracketEngine(tournament.config)
        .generateInitialMatches(tournament, bracketTeams);

    final leagueMaxRound = leagueMatches.map((m) => m.round).maxOrNull ?? 0;
    return koDrafts
        .map(
          (d) => DraftMatch(
            round: leagueMaxRound + d.round,
            stage: d.stage == MatchStage.roundRobin ||
                    d.stage == MatchStage.group ||
                    d.stage == MatchStage.swiss
                ? MatchStage.knockout
                : d.stage,
            groupLabel: d.groupLabel,
            bracketSlot: d.bracketSlot,
            homeTeamId: d.homeTeamId,
            awayTeamId: d.awayTeamId,
            status: d.status,
            winnerAdvancesTo: d.winnerAdvancesTo,
            loserAdvancesTo: d.loserAdvancesTo,
            homeScore: d.homeScore,
            awayScore: d.awayScore,
            location: d.location,
            venueId: d.venueId,
          ),
        )
        .toList();
  }

  List<int> _qualifiers(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> leagueMatches,
  ) {
    final league = _league(tournament.config);
    if (league == TournamentFormat.groupsOnly) {
      return _groupQualifiers(tournament, teams, leagueMatches);
    }
    final advance =
        tournament.config.advancePerGroup.clamp(2, teams.length);
    final standings = computeStandingsFromMatches(
      teamIds: teams.map((t) => t.teamId).toList(),
      matches: leagueMatches,
      config: tournament.config,
      teamsById: {for (final t in teams) t.teamId: t.team},
    );
    return standings.take(advance).map((s) => s.teamId).toList();
  }

  List<int> _groupQualifiers(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> groupMatches,
  ) {
    final advance = tournament.config.advancePerGroup;
    final groupSize = tournament.config.groupSize;
    final groupCount = teams.length ~/ groupSize;
    final labels =
        List.generate(groupCount, (i) => String.fromCharCode(65 + i));

    final byPlace = List.generate(advance, (_) => <int>[]);
    for (final label in labels) {
      final groupTeams =
          teams.where((t) => t.groupLabel == label).map((t) => t.teamId).toList();
      final ids = groupTeams.isNotEmpty
          ? groupTeams
          : groupMatches
              .where((m) => m.groupLabel == label)
              .expand((m) => [m.homeTeamId, m.awayTeamId])
              .whereType<int>()
              .toSet()
              .toList();

      final standings = computeStandingsFromMatches(
        teamIds: ids,
        matches: groupMatches,
        config: tournament.config,
        groupLabel: label,
      );
      for (var p = 0; p < advance && p < standings.length; p++) {
        byPlace[p].add(standings[p].teamId);
      }
    }

    final seeded = <int>[];
    for (var p = 0; p < byPlace.length; p++) {
      final place = List<int>.from(byPlace[p]);
      if (p == 1) {
        seeded.addAll(place.reversed);
      } else {
        seeded.addAll(place);
      }
    }
    return seeded;
  }

  @override
  List<StandingRow> computeStandings(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> matches, {
    String? groupLabel,
  }) {
    final league = _league(tournament.config);
    if (league == TournamentFormat.groupsOnly) {
      return _groups.computeStandings(
        tournament,
        teams,
        matches,
        groupLabel: groupLabel,
      );
    }
    final leagueMatches = matches.where((m) => !m.isBracketMatch).toList();
    return _leagueEngine(tournament.config).computeStandings(
      tournament,
      teams,
      leagueMatches.isEmpty ? matches : leagueMatches,
      groupLabel: groupLabel,
    );
  }

  @override
  bool isComplete(
    Tournament tournament,
    List<TournamentTeam> teams,
    List<Match> matches,
  ) {
    final knockout = matches.where((m) => m.isBracketMatch).toList();
    if (knockout.isEmpty) return false;
    return _bracketEngine(tournament.config)
        .isComplete(tournament, teams, knockout);
  }
}
