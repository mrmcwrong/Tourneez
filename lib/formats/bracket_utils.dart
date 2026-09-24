import 'package:collection/collection.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/formats/standings_utils.dart';

/// Shared single-elim style tree builder (winners path only).
List<DraftMatch> buildSingleElimTree({
  required List<int> seededTeamIds,
  required MatchStage stage,
  String? groupLabel,
  int slotOffset = 0,
  int roundOffset = 0,
  bool includeThirdPlace = false,
}) {
  final n = nextPowerOfTwo(seededTeamIds.length);
  final slots = List<int?>.filled(n, null);
  final positions = seedPositions(n);
  for (var i = 0; i < seededTeamIds.length; i++) {
    slots[positions[i]] = seededTeamIds[i];
  }

  final drafts = <DraftMatch>[];
  var roundMatches = n ~/ 2;
  var round = 1 + roundOffset;
  var matchIndex = slotOffset;

  final firstRound = <DraftMatch>[];
  for (var i = 0; i < roundMatches; i++) {
    final home = slots[i * 2];
    final away = slots[i * 2 + 1];
    firstRound.add(_leafMatch(
      round: round,
      stage: stage,
      groupLabel: groupLabel,
      bracketSlot: matchIndex++,
      home: home,
      away: away,
    ));
  }
  drafts.addAll(firstRound);

  var prevSlots = firstRound.map((m) => m.bracketSlot!).toList();
  while (roundMatches > 1) {
    round++;
    roundMatches ~/= 2;
    final thisRoundSlots = <int>[];
    for (var i = 0; i < roundMatches; i++) {
      final slot = matchIndex++;
      thisRoundSlots.add(slot);
      drafts.add(
        DraftMatch(
          round: round,
          stage: stage,
          groupLabel: groupLabel,
          bracketSlot: slot,
        ),
      );
    }

    for (var i = 0; i < prevSlots.length; i++) {
      final childSlot = prevSlots[i];
      final parentSlot = thisRoundSlots[i ~/ 2];
      final idx = drafts.indexWhere((d) => d.bracketSlot == childSlot);
      if (idx >= 0) {
        drafts[idx] = drafts[idx].copyWith(winnerAdvancesTo: parentSlot);
      }
    }
    prevSlots = thisRoundSlots;
  }

  if (includeThirdPlace && n >= 4) {
    // Semi-finals are the round before the final.
    final finalSlot = prevSlots.single;
    final semis = drafts
        .where((d) => d.winnerAdvancesTo == finalSlot)
        .map((d) => d.bracketSlot!)
        .toList()
      ..sort();
    if (semis.length == 2) {
      final thirdSlot = matchIndex;
      drafts.add(
        DraftMatch(
          round: round,
          stage: MatchStage.knockout,
          groupLabel: '3rd Place',
          bracketSlot: thirdSlot,
        ),
      );
      for (final semi in semis) {
        final idx = drafts.indexWhere((d) => d.bracketSlot == semi);
        if (idx >= 0) {
          drafts[idx] = drafts[idx].copyWith(loserAdvancesTo: thirdSlot);
        }
      }
    }
  }

  return drafts;
}

DraftMatch _leafMatch({
  required int round,
  required MatchStage stage,
  required int bracketSlot,
  String? groupLabel,
  int? home,
  int? away,
}) {
  if (home != null && away == null) {
    return DraftMatch(
      round: round,
      stage: stage,
      groupLabel: groupLabel,
      bracketSlot: bracketSlot,
      homeTeamId: home,
      status: MatchStatus.bye,
      homeScore: 1,
      awayScore: 0,
    );
  }
  if (away != null && home == null) {
    return DraftMatch(
      round: round,
      stage: stage,
      groupLabel: groupLabel,
      bracketSlot: bracketSlot,
      homeTeamId: away,
      status: MatchStatus.bye,
      homeScore: 1,
      awayScore: 0,
    );
  }
  return DraftMatch(
    round: round,
    stage: stage,
    groupLabel: groupLabel,
    bracketSlot: bracketSlot,
    homeTeamId: home,
    awayTeamId: away,
  );
}

List<int> seedPositions(int n) {
  var positions = [0];
  while (positions.length < n) {
    final next = <int>[];
    final size = positions.length * 2;
    for (final p in positions) {
      next.add(p);
      next.add(size - 1 - p);
    }
    positions = next;
  }
  return positions;
}

/// Propagate winners (and losers) into parent bracket slots.
List<Match> advanceBracketParticipants(List<Match> matches) {
  final bySlot = {
    for (final m in matches)
      if (m.bracketSlot != null) m.bracketSlot!: m,
  };

  Match copyParent(Match parent, {int? homeTeamId, int? awayTeamId}) {
    return Match(
      id: parent.id,
      tournamentId: parent.tournamentId,
      round: parent.round,
      stage: parent.stage,
      groupLabel: parent.groupLabel,
      bracketSlot: parent.bracketSlot,
      homeTeamId: homeTeamId,
      awayTeamId: awayTeamId,
      homeScore: parent.homeScore,
      awayScore: parent.awayScore,
      status: parent.status,
      winnerAdvancesTo: parent.winnerAdvancesTo,
      loserAdvancesTo: parent.loserAdvancesTo,
    );
  }

  void applyFeeder({
    required Match match,
    required int parentSlot,
    required int teamId,
    required bool fromWinnerPath,
    required Map<int, Match> working,
    required List<Match> updates,
  }) {
    final parent = working[parentSlot];
    if (parent == null) return;

    final winnerFeeders = matches
        .where((m) => m.winnerAdvancesTo == parentSlot)
        .sorted((a, b) => (a.bracketSlot ?? 0).compareTo(b.bracketSlot ?? 0))
        .toList();
    final loserFeeders = matches
        .where((m) => m.loserAdvancesTo == parentSlot)
        .sorted((a, b) => (a.bracketSlot ?? 0).compareTo(b.bracketSlot ?? 0))
        .toList();

    // Winner-path feeders fill home first (lower slot), then away.
    // Loser-path feeders fill remaining sides; if both kinds feed the same
    // match, winners take home/away first, then losers fill what's left.
    final bool isHome;
    if (fromWinnerPath) {
      isHome = winnerFeeders.isEmpty || winnerFeeders.first.id == match.id;
    } else {
      if (winnerFeeders.isEmpty) {
        isHome = loserFeeders.isEmpty || loserFeeders.first.id == match.id;
      } else if (winnerFeeders.length == 1) {
        // One winner feeder already owns home → loser goes away (or home if only).
        isHome = false;
      } else {
        isHome = loserFeeders.isEmpty || loserFeeders.first.id == match.id;
      }
    }

    var newHome = parent.homeTeamId;
    var newAway = parent.awayTeamId;
    if (isHome) {
      if (newHome == teamId) return;
      newHome = teamId;
    } else {
      if (newAway == teamId) return;
      newAway = teamId;
    }

    final updated = copyParent(parent, homeTeamId: newHome, awayTeamId: newAway);
    working[parentSlot] = updated;
    final existing = updates.indexWhere((u) => u.id == parent.id);
    if (existing >= 0) {
      updates[existing] = updated;
    } else {
      updates.add(updated);
    }
  }

  final updates = <Match>[];
  final working = Map<int, Match>.from(bySlot);

  for (final match in matches) {
    if (!match.isCompleted) continue;

    final winner = match.winnerTeamId;
    if (winner != null && match.winnerAdvancesTo != null) {
      applyFeeder(
        match: match,
        parentSlot: match.winnerAdvancesTo!,
        teamId: winner,
        fromWinnerPath: true,
        working: working,
        updates: updates,
      );
    }

    final loser = match.loserTeamId;
    if (loser != null && match.loserAdvancesTo != null) {
      applyFeeder(
        match: match,
        parentSlot: match.loserAdvancesTo!,
        teamId: loser,
        fromWinnerPath: false,
        working: working,
        updates: updates,
      );
    }
  }

  return updates;
}
