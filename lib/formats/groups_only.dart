import 'package:collection/collection.dart';
import 'package:tourneez/domain/format_engine.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/formats/standings_utils.dart';

/// Multiple round-robin groups with no knockout stage.
class GroupsOnlyEngine implements FormatEngine {
  @override
  int minTeams(TournamentConfig config) => 4;

  @override
  String? validateTeams(TournamentConfig config, List<TournamentTeam> teams) {
    if (teams.length < minTeams(config)) {
      return 'Group stage needs at least ${minTeams(config)} teams.';
    }
    final groupSize = config.groupSize;
    if (groupSize < 2) return 'Group size must be at least 2.';
    if (teams.length % groupSize != 0) {
      return 'Team count (${teams.length}) must be divisible by group size ($groupSize).';
    }
    return null;
  }

  List<String> _groupLabels(int count) =>
      List.generate(count, (i) => String.fromCharCode(65 + i));

  /// True snake seeding into groups.
  Map<int, String> assignGroups(
    TournamentConfig config,
    List<TournamentTeam> teams,
  ) {
    final groupSize = config.groupSize;
    final sorted = List<TournamentTeam>.from(teams)
      ..sort((a, b) => (a.seed ?? a.teamId).compareTo(b.seed ?? b.teamId));
    final groupCount = sorted.length ~/ groupSize;
    final labels = _groupLabels(groupCount);
    final groups = List.generate(groupCount, (_) => <TournamentTeam>[]);

    var goingDown = true;
    var g = 0;
    for (final team in sorted) {
      groups[g].add(team);
      if (goingDown) {
        if (g == groupCount - 1) {
          goingDown = false;
        } else {
          g++;
        }
      } else {
        if (g == 0) {
          goingDown = true;
        } else {
          g--;
        }
      }
    }

    final result = <int, String>{};
    for (var i = 0; i < groupCount; i++) {
      for (final t in groups[i]) {
        result[t.id] = labels[i];
      }
    }
    return result;
  }

  @override
  List<DraftMatch> generateInitialMatches(
    Tournament tournament,
    List<TournamentTeam> teams,
  ) {
    final groupSize = tournament.config.groupSize;
    final sorted = List<TournamentTeam>.from(teams)
      ..sort((a, b) => (a.seed ?? a.teamId).compareTo(b.seed ?? b.teamId));
    final groupCount = sorted.length ~/ groupSize;
    final labels = _groupLabels(groupCount);

    // Prefer stored group labels when present
    final byGroup = <String, List<int>>{};
    for (final t in teams) {
      if (t.groupLabel != null) {
        byGroup.putIfAbsent(t.groupLabel!, () => []).add(t.teamId);
      }
    }

    if (byGroup.isEmpty) {
      final groups = List.generate(groupCount, (_) => <int>[]);
      var goingDown = true;
      var g = 0;
      for (final t in sorted) {
        groups[g].add(t.teamId);
        if (goingDown) {
          if (g == groupCount - 1) {
            goingDown = false;
          } else {
            g++;
          }
        } else {
          if (g == 0) {
            goingDown = true;
          } else {
            g--;
          }
        }
      }
      for (var i = 0; i < groupCount; i++) {
        byGroup[labels[i]] = groups[i];
      }
    }

    final homeLocations = {
      for (final t in teams)
        if (t.homeLocation != null && t.homeLocation!.trim().isNotEmpty)
          t.teamId: t.homeLocation!.trim(),
    };
    final homeVenueIds = {
      for (final t in teams)
        if (t.homeVenueId != null) t.teamId: t.homeVenueId!,
    };
    final meetings = tournament.config.meetingsPerPair.clamp(1, 6);
    final drafts = <DraftMatch>[];
    for (final entry in byGroup.entries) {
      final baseRounds = circleMethodRounds(entry.value);
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
                stage: MatchStage.group,
                groupLabel: entry.key,
                homeTeamId: home,
                awayTeamId: away,
                location: homeLocations[home],
                venueId: homeVenueIds[home],
              ),
            );
          }
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
    final groupMatches =
        matches.where((m) => m.stage == MatchStage.group).toList();

    if (groupLabel != null) {
      final ids = groupMatches
          .where((m) => m.groupLabel == groupLabel)
          .expand((m) => [m.homeTeamId, m.awayTeamId])
          .whereType<int>()
          .toSet()
          .toList();
      return computeStandingsFromMatches(
        teamIds: ids,
        matches: groupMatches,
        config: tournament.config,
        groupLabel: groupLabel,
        teamsById: {for (final t in teams) t.teamId: t.team},
      );
    }

    final labels = groupMatches
        .map((m) => m.groupLabel)
        .whereType<String>()
        .toSet()
        .sorted();
    final rows = <StandingRow>[];
    for (final label in labels) {
      rows.addAll(
        computeStandings(tournament, teams, matches, groupLabel: label),
      );
    }
    return rows;
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
