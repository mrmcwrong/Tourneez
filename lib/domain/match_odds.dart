import 'dart:math';

/// Win / draw / loss probabilities for a fixture based on power ratings.
class MatchOdds {
  const MatchOdds({
    required this.homeWin,
    required this.draw,
    required this.awayWin,
  });

  final double homeWin;
  final double draw;
  final double awayWin;

  int get homeWinPct => (homeWin * 100).round();
  int get drawPct => (draw * 100).round();
  int get awayWinPct => (awayWin * 100).round();

  String get summary =>
      'H $homeWinPct% · D $drawPct% · A $awayWinPct%';
}

enum MatchOutcome { homeWin, draw, awayWin }

/// Elo-inspired three-way odds from power ratings (1–100).
MatchOdds computeMatchOdds({
  required int homePower,
  required int awayPower,
  bool allowDraw = true,
}) {
  final home = homePower.clamp(1, 100).toDouble();
  final away = awayPower.clamp(1, 100).toDouble();
  final diff = home - away;

  // Logistic home-win share among decisive results.
  final homeShare = 1 / (1 + exp(-diff / 12));

  if (!allowDraw) {
    return MatchOdds(
      homeWin: homeShare,
      draw: 0,
      awayWin: 1 - homeShare,
    );
  }

  // Closer ratings → more draws; blowouts rarely draw.
  final draw = (0.30 - 0.0022 * diff.abs()).clamp(0.06, 0.32);
  final remaining = 1 - draw;
  return MatchOdds(
    homeWin: remaining * homeShare,
    draw: draw,
    awayWin: remaining * (1 - homeShare),
  );
}

MatchOutcome sampleOutcome(MatchOdds odds, Random random) {
  final roll = random.nextDouble();
  if (roll < odds.homeWin) return MatchOutcome.homeWin;
  if (roll < odds.homeWin + odds.draw) return MatchOutcome.draw;
  return MatchOutcome.awayWin;
}

int _sampleGoals(Random random, double expected) {
  // Lightweight Poisson-ish sampler for small football scores.
  final L = exp(-expected.clamp(0.2, 4.5));
  var k = 0;
  var p = 1.0;
  do {
    k++;
    p *= random.nextDouble();
  } while (p > L && k < 10);
  return k - 1;
}

/// Sample a concrete scoreline matching [odds] (and bracket no-draw rules).
({int home, int away}) sampleScore({
  required int homePower,
  required int awayPower,
  required bool allowDraw,
  Random? random,
}) {
  final rng = random ?? Random();
  final odds = computeMatchOdds(
    homePower: homePower,
    awayPower: awayPower,
    allowDraw: allowDraw,
  );
  final outcome = sampleOutcome(odds, rng);

  final homeXg = 1.15 + (homePower - 50) / 50 * 0.9;
  final awayXg = 1.05 + (awayPower - 50) / 50 * 0.9;

  for (var attempt = 0; attempt < 40; attempt++) {
    final h = _sampleGoals(rng, homeXg);
    final a = _sampleGoals(rng, awayXg);
    final matches = switch (outcome) {
      MatchOutcome.homeWin => h > a,
      MatchOutcome.awayWin => a > h,
      MatchOutcome.draw => h == a,
    };
    if (matches) return (home: h, away: a);
  }

  // Fallback: force a valid scoreline for the rolled outcome.
  return switch (outcome) {
    MatchOutcome.homeWin => (
        home: 1 + rng.nextInt(3),
        away: rng.nextInt(2),
      ),
    MatchOutcome.awayWin => (
        home: rng.nextInt(2),
        away: 1 + rng.nextInt(3),
      ),
    MatchOutcome.draw => () {
        final g = rng.nextInt(4);
        return (home: g, away: g);
      }(),
  };
}

/// Preset team names for quick-add.
const presetTeamNames = <String>[
  'Northside FC',
  'River Hawks',
  'Ironvale United',
  'Coastal Rovers',
  'Summit Athletic',
  'Maple City',
  'Oakridge SC',
  'Thunder Bay',
  'Silver Lake',
  'Redwood Rangers',
  'Harbor Lights',
  'Prairie Storm',
  'Canyon Crest',
  'Blue Ridge FC',
  'Eastgate United',
  'Westfield Wanderers',
  'Metro Lions',
  'Capital City',
  'Highlanders',
  'Lakeshore FC',
  'Ashford Albion',
  'Brookside',
  'Cedar Point',
  'Falcon Heights',
  'Granite FC',
  'Horizon SC',
  'Ivy Athletic',
  'Jade City',
  'Kingfisher FC',
  'Lunar United',
  'Mirage FC',
  'Nova Athletic',
  'Orion SC',
  'Phoenix Rise',
  'Quarry Town',
  'Ravenwood',
  'Solstice FC',
  'Timberwolves',
  'Upland United',
  'Valiant FC',
];

class TeamColorSwatch {
  const TeamColorSwatch(this.argb, this.label);
  final int argb;
  final String label;
}

/// Compact bright kit palette (crayon order).
const presetTeamColorSwatches = <TeamColorSwatch>[
  TeamColorSwatch(0xFFFF2D2D, 'Red'),
  TeamColorSwatch(0xFFE11D48, 'Crimson'),
  TeamColorSwatch(0xFFFF6A00, 'Orange'),
  TeamColorSwatch(0xFFFFD60A, 'Yellow'),
  TeamColorSwatch(0xFFD4A017, 'Gold'),
  TeamColorSwatch(0xFF22C55E, 'Green'),
  TeamColorSwatch(0xFF2EE6D6, 'Aqua'),
  TeamColorSwatch(0xFF3B82F6, 'Blue'),
  TeamColorSwatch(0xFF9B5DE5, 'Purple'),
  TeamColorSwatch(0xFFFF4DB8, 'Pink'),
  TeamColorSwatch(0xFF111111, 'Black'),
  TeamColorSwatch(0xFF9CA3AF, 'Silver'),
];

/// Flat list for random picks / legacy callers.
final presetTeamColors = <int>[
  for (final c in presetTeamColorSwatches) c.argb,
];

String pickPresetTeamName(Random random, {Set<String> avoid = const {}}) {
  final available =
      presetTeamNames.where((n) => !avoid.contains(n)).toList();
  if (available.isEmpty) {
    return 'Team ${1000 + random.nextInt(9000)}';
  }
  return available[random.nextInt(available.length)];
}

int pickPresetTeamColor(Random random) =>
    presetTeamColors[random.nextInt(presetTeamColors.length)];

int pickRandomPower(Random random) {
  // Bell-ish around 50: most teams mid-tier, some outliers.
  final base = 35 + random.nextInt(31); // 35–65
  final swing = random.nextInt(100);
  if (swing < 10) return (base + 20 + random.nextInt(16)).clamp(1, 100);
  if (swing < 20) return (base - 20 - random.nextInt(16)).clamp(1, 100);
  return base.clamp(1, 100);
}
