import 'package:tourneez/domain/models.dart';

List<StandingRow> computeStandingsFromMatches({
  required List<int> teamIds,
  required List<Match> matches,
  required TournamentConfig config,
  String? groupLabel,
  Map<int, Team?>? teamsById,
}) {
  final stats = <int, _Agg>{for (final id in teamIds) id: _Agg()};

  for (final match in matches) {
    if (groupLabel != null && match.groupLabel != groupLabel) continue;

    // Byes count as a win for the sole team (common in Swiss).
    if (match.status == MatchStatus.bye) {
      final byeTeam = match.homeTeamId ?? match.awayTeamId;
      final agg = byeTeam != null ? stats[byeTeam] : null;
      if (agg != null) {
        agg.played++;
        agg.won++;
        agg.points += config.pointsForWin;
      }
      continue;
    }

    if (match.status != MatchStatus.completed) continue;
    if (match.homeTeamId == null || match.awayTeamId == null) continue;
    if (match.homeScore == null || match.awayScore == null) continue;

    final home = stats[match.homeTeamId];
    final away = stats[match.awayTeamId];
    if (home == null || away == null) continue;

    final hs = match.homeScore!;
    final as_ = match.awayScore!;

    home.played++;
    away.played++;
    home.gf += hs;
    home.ga += as_;
    away.gf += as_;
    away.ga += hs;

    if (hs > as_) {
      home.won++;
      away.lost++;
      home.points += config.pointsForWin;
      away.points += config.pointsForLoss;
    } else if (as_ > hs) {
      away.won++;
      home.lost++;
      away.points += config.pointsForWin;
      home.points += config.pointsForLoss;
    } else {
      home.drawn++;
      away.drawn++;
      home.points += config.pointsForDraw;
      away.points += config.pointsForDraw;
    }
  }

  final rows = stats.entries
      .map(
        (e) => StandingRow(
          teamId: e.key,
          played: e.value.played,
          won: e.value.won,
          drawn: e.value.drawn,
          lost: e.value.lost,
          goalsFor: e.value.gf,
          goalsAgainst: e.value.ga,
          points: e.value.points,
          groupLabel: groupLabel,
          team: teamsById?[e.key],
        ),
      )
      .toList();

  final ties = config.tiebreakers.isEmpty
      ? defaultTiebreakers
      : config.tiebreakers;

  rows.sort((a, b) {
    for (final t in ties) {
      final cmp = switch (t) {
        Tiebreaker.points => b.points.compareTo(a.points),
        Tiebreaker.goalDifference => b.goalDifference.compareTo(
          a.goalDifference,
        ),
        Tiebreaker.goalsFor => b.goalsFor.compareTo(a.goalsFor),
        Tiebreaker.goalsAgainst => a.goalsAgainst.compareTo(b.goalsAgainst),
        Tiebreaker.wins => b.won.compareTo(a.won),
        Tiebreaker.headToHead => _compareHeadToHead(
          a.teamId,
          b.teamId,
          matches,
          config,
          groupLabel,
        ),
        Tiebreaker.alphabetical => a.displayName.toLowerCase().compareTo(
          b.displayName.toLowerCase(),
        ),
      };
      if (cmp != 0) return cmp;
    }
    return a.teamId.compareTo(b.teamId);
  });

  return rows;
}

/// Pairwise head-to-head: points, then GD, then GF from mutual matches.
int _compareHeadToHead(
  int teamA,
  int teamB,
  List<Match> matches,
  TournamentConfig config,
  String? groupLabel,
) {
  var aPts = 0, bPts = 0, aGd = 0, bGd = 0, aGf = 0, bGf = 0;
  var played = 0;

  for (final match in matches) {
    if (groupLabel != null && match.groupLabel != groupLabel) continue;
    if (match.status != MatchStatus.completed) continue;
    if (match.homeTeamId == null || match.awayTeamId == null) continue;
    if (match.homeScore == null || match.awayScore == null) continue;

    final home = match.homeTeamId!;
    final away = match.awayTeamId!;
    final involves =
        (home == teamA && away == teamB) || (home == teamB && away == teamA);
    if (!involves) continue;

    played++;
    final hs = match.homeScore!;
    final as_ = match.awayScore!;

    void apply(int teamId, int scored, int conceded, bool won, bool draw) {
      if (teamId == teamA) {
        aGf += scored;
        aGd += scored - conceded;
        if (won) {
          aPts += config.pointsForWin;
        } else if (draw) {
          aPts += config.pointsForDraw;
        } else {
          aPts += config.pointsForLoss;
        }
      } else if (teamId == teamB) {
        bGf += scored;
        bGd += scored - conceded;
        if (won) {
          bPts += config.pointsForWin;
        } else if (draw) {
          bPts += config.pointsForDraw;
        } else {
          bPts += config.pointsForLoss;
        }
      }
    }

    if (hs > as_) {
      apply(home, hs, as_, true, false);
      apply(away, as_, hs, false, false);
    } else if (as_ > hs) {
      apply(away, as_, hs, true, false);
      apply(home, hs, as_, false, false);
    } else {
      apply(home, hs, as_, false, true);
      apply(away, as_, hs, false, true);
    }
  }

  if (played == 0) return 0;
  final pts = bPts.compareTo(aPts);
  if (pts != 0) return pts;
  final gd = bGd.compareTo(aGd);
  if (gd != 0) return gd;
  return bGf.compareTo(aGf);
}

class _Agg {
  int played = 0;
  int won = 0;
  int drawn = 0;
  int lost = 0;
  int gf = 0;
  int ga = 0;
  int points = 0;
}

/// Circle method round-robin pairing.
List<List<(int, int)>> circleMethodRounds(List<int> teamIds) {
  if (teamIds.length < 2) return [];

  final ids = List<int>.from(teamIds);
  final hasBye = ids.length.isOdd;
  if (hasBye) {
    ids.add(-1); // bye marker
  }

  final n = ids.length;
  final rounds = n - 1;
  final half = n ~/ 2;
  final rotating = List<int>.from(ids);
  final result = <List<(int, int)>>[];

  for (var r = 0; r < rounds; r++) {
    final pairs = <(int, int)>[];
    for (var i = 0; i < half; i++) {
      final a = rotating[i];
      final b = rotating[n - 1 - i];
      if (a == -1 || b == -1) continue;
      // Alternate home/away by round for fairness
      if (r.isEven) {
        pairs.add((a, b));
      } else {
        pairs.add((b, a));
      }
    }
    result.add(pairs);

    // Rotate all but first
    final fixed = rotating.first;
    final rest = rotating.sublist(1);
    final last = rest.removeLast();
    rotating
      ..clear()
      ..add(fixed)
      ..add(last)
      ..addAll(rest);
  }

  return result;
}

int nextPowerOfTwo(int n) {
  var p = 1;
  while (p < n) {
    p *= 2;
  }
  return p;
}

int defaultSwissRounds(int teamCount) {
  if (teamCount <= 1) return 0;
  // ceil(log2(n))
  var rounds = 0;
  var p = 1;
  while (p < teamCount) {
    p *= 2;
    rounds++;
  }
  return rounds.clamp(1, 10);
}
