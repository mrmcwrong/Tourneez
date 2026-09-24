import 'dart:convert';

/// Multi-leg series score for a bracket (or hybrid knockout) match.
///
/// [length] is the configured series length:
/// - 1 = single match
/// - 2 = two legs, aggregate score
/// - 3 / 5 / 7 = best-of
class SeriesScore {
  const SeriesScore({
    required this.length,
    this.legs = const [],
  });

  final int length;
  final List<({int home, int away})> legs;

  static const allowedLengths = {1, 2, 3, 5, 7};

  int get winsNeeded => length == 2 ? 0 : (length + 1) ~/ 2;

  int get homeWins => legs.where((l) => l.home > l.away).length;

  int get awayWins => legs.where((l) => l.away > l.home).length;

  int get aggregateHome => legs.fold(0, (s, l) => s + l.home);

  int get aggregateAway => legs.fold(0, (s, l) => s + l.away);

  /// Display score: win counts for best-of, aggregate for two legs.
  int? get seriesHomeScore {
    if (legs.isEmpty) return null;
    if (length == 2) return aggregateHome;
    return homeWins;
  }

  int? get seriesAwayScore {
    if (legs.isEmpty) return null;
    if (length == 2) return aggregateAway;
    return awayWins;
  }

  bool get isDecided {
    if (length <= 1) return legs.isNotEmpty;
    if (length == 2) return legs.length >= 2;
    final need = winsNeeded;
    return homeWins >= need || awayWins >= need;
  }

  SeriesScore addLeg(int home, int away) {
    return SeriesScore(
      length: length,
      legs: [...legs, (home: home, away: away)],
    );
  }

  SeriesScore withLegs(List<({int home, int away})> nextLegs) {
    return SeriesScore(length: length, legs: List.of(nextLegs));
  }

  /// Max legs that can still be played (or already played).
  int get maxLegs => length == 2 ? 2 : length;

  Map<String, dynamic> toJson() => {
        'length': length,
        'legs': [
          for (final l in legs) {'home': l.home, 'away': l.away},
        ],
      };

  String encode() => jsonEncode(toJson());

  factory SeriesScore.fromJson(Map<String, dynamic> json) {
    final rawLegs = json['legs'];
    final legs = <({int home, int away})>[];
    if (rawLegs is List) {
      for (final item in rawLegs) {
        if (item is Map) {
          final h = item['home'];
          final a = item['away'];
          if (h is int && a is int) {
            legs.add((home: h, away: a));
          }
        }
      }
    }
    var length = json['length'] as int? ?? 1;
    if (!allowedLengths.contains(length)) length = 1;
    return SeriesScore(length: length, legs: legs);
  }

  static SeriesScore? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return SeriesScore.fromJson(decoded);
      }
      if (decoded is Map) {
        return SeriesScore.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
    return null;
  }

  static SeriesScore empty(int length) {
    final len = allowedLengths.contains(length) ? length : 1;
    return SeriesScore(length: len, legs: const []);
  }
}
