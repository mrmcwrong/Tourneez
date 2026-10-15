import 'package:tourneez/domain/series_score.dart';

enum TournamentCategory { bracket, league, hybrid }

enum TournamentFormat {
  // Bracket
  singleElimination,
  doubleElimination,
  // League
  roundRobin,
  swiss,
  groupsOnly,
  // Hybrid (league phase → bracket phase)
  hybrid,
}

enum TournamentStatus { draft, active, completed }

enum MatchStatus { pending, completed, bye }

enum MatchStage {
  group,
  knockout,
  swiss,
  roundRobin,
  winners,
  losers,
  grandFinal,
}

extension TournamentCategoryX on TournamentCategory {
  String get label => switch (this) {
    TournamentCategory.bracket => 'Bracket',
    TournamentCategory.league => 'League',
    TournamentCategory.hybrid => 'Hybrid',
  };

  String get description => switch (this) {
    TournamentCategory.bracket =>
      'Knockout brackets. Lose and you are out (or need two losses).',
    TournamentCategory.league =>
      'Everyone keeps playing. Ranked by points or Swiss pairing.',
    TournamentCategory.hybrid =>
      'A league or group stage first, then a knockout bracket.',
  };

  List<TournamentFormat> get formats => TournamentFormat.values
      .where((f) => f.category == this)
      .toList(growable: false);
}

extension TournamentFormatX on TournamentFormat {
  TournamentCategory get category => switch (this) {
    TournamentFormat.singleElimination ||
    TournamentFormat.doubleElimination => TournamentCategory.bracket,
    TournamentFormat.roundRobin ||
    TournamentFormat.swiss ||
    TournamentFormat.groupsOnly => TournamentCategory.league,
    TournamentFormat.hybrid => TournamentCategory.hybrid,
  };

  String get label => switch (this) {
    TournamentFormat.roundRobin => 'Round Robin',
    TournamentFormat.swiss => 'Swiss',
    TournamentFormat.singleElimination => 'Single Elimination',
    TournamentFormat.doubleElimination => 'Double Elimination',
    TournamentFormat.groupsOnly => 'Group Stage Only',
    TournamentFormat.hybrid => 'League → Bracket',
  };

  /// Label when picking a league phase inside a hybrid tournament.
  String get hybridPhaseLabel => switch (this) {
    TournamentFormat.groupsOnly => 'Group Stage',
    _ => label,
  };

  String get description => switch (this) {
    TournamentFormat.roundRobin =>
      'Every team plays every other team. Ranked by points.',
    TournamentFormat.swiss =>
      'Pair teams with similar records each round. No elimination.',
    TournamentFormat.singleElimination =>
      'Classic bracket. Lose once and you are out.',
    TournamentFormat.doubleElimination =>
      'Winners and losers brackets. Two losses to be eliminated.',
    TournamentFormat.groupsOnly =>
      'Multiple round-robin groups. No knockout stage.',
    TournamentFormat.hybrid =>
      'Pick a league format that feeds into a knockout bracket.',
  };

  /// Description when picking a league phase inside a hybrid tournament.
  String get hybridPhaseDescription => switch (this) {
    TournamentFormat.groupsOnly =>
      'Split teams into round-robin groups; top finishers advance to the bracket.',
    TournamentFormat.roundRobin =>
      'Full table first — then the top teams move into the knockout.',
    TournamentFormat.swiss =>
      'Swiss pairing first — then the top teams move into the knockout.',
    _ => description,
  };

  int get minTeams => switch (this) {
    TournamentFormat.roundRobin => 3,
    TournamentFormat.swiss => 4,
    TournamentFormat.singleElimination => 2,
    TournamentFormat.doubleElimination => 4,
    TournamentFormat.groupsOnly => 4,
    TournamentFormat.hybrid => 4,
  };

  bool get showsStandings =>
      category == TournamentCategory.league ||
      category == TournamentCategory.hybrid;

  bool get hasBracketView =>
      this == TournamentFormat.singleElimination ||
      this == TournamentFormat.doubleElimination ||
      this == TournamentFormat.hybrid;

  bool get isBracketFormat =>
      this == TournamentFormat.singleElimination ||
      this == TournamentFormat.doubleElimination;

  bool get isLeagueFormat =>
      this == TournamentFormat.roundRobin ||
      this == TournamentFormat.swiss ||
      this == TournamentFormat.groupsOnly;

  bool usesGroups(TournamentConfig config) {
    if (this == TournamentFormat.groupsOnly) return true;
    if (this == TournamentFormat.hybrid) {
      return config.leagueFormat == TournamentFormat.groupsOnly;
    }
    return false;
  }
}

/// League formats allowed as hybrid phase 1.
const hybridLeagueChoices = <TournamentFormat>[
  TournamentFormat.roundRobin,
  TournamentFormat.swiss,
  TournamentFormat.groupsOnly,
];

/// Bracket formats allowed as hybrid phase 2.
const hybridBracketChoices = <TournamentFormat>[
  TournamentFormat.singleElimination,
  TournamentFormat.doubleElimination,
];

/// Ordered criteria used when teams are level on earlier criteria.
enum Tiebreaker {
  points,
  goalDifference,
  goalsFor,
  goalsAgainst,
  wins,
  headToHead,
  alphabetical,
}

extension TiebreakerX on Tiebreaker {
  String get label => switch (this) {
    Tiebreaker.points => 'Points',
    Tiebreaker.goalDifference => 'Goal difference',
    Tiebreaker.goalsFor => 'Goals for',
    Tiebreaker.goalsAgainst => 'Goals against (fewer better)',
    Tiebreaker.wins => 'Wins',
    Tiebreaker.headToHead => 'Head to head',
    Tiebreaker.alphabetical => 'Alphabetical',
  };
}

const defaultTiebreakers = <Tiebreaker>[
  Tiebreaker.points,
  Tiebreaker.goalDifference,
  Tiebreaker.goalsFor,
];

/// Formats that can use promotion/relegation (table-based seasons).
bool formatAllowsPromoReleg(TournamentFormat format) =>
    format == TournamentFormat.roundRobin ||
    format == TournamentFormat.swiss ||
    format == TournamentFormat.groupsOnly;

class TournamentConfig {
  const TournamentConfig({
    this.pointsForWin = 3,
    this.pointsForDraw = 1,
    this.pointsForLoss = 0,
    this.meetingsPerPair = 2,
    this.includeThirdPlace = false,
    this.randomizeSeeds = false,
    this.swissRounds,
    this.groupSize = 4,
    this.advancePerGroup = 2,
    this.leagueFormat = TournamentFormat.groupsOnly,
    this.bracketFormat = TournamentFormat.singleElimination,
    this.tiebreakers = defaultTiebreakers,
    this.knockoutSeriesLength = 1,
    this.finalSeriesEnabled = true,
    this.finalSeriesLength = 1,
    this.familyView = FamilyViewSettings.defaults,
  });

  static const seriesLengthChoices = <int>[1, 2, 3, 5, 7];

  /// Sensible defaults per format (group stage meetings = 1, round robin = 2).
  factory TournamentConfig.defaultsFor(
    TournamentFormat format, {
    TournamentFormat? leagueFormat,
  }) {
    final league = leagueFormat ?? TournamentFormat.groupsOnly;
    final usesGroupMeetings =
        format == TournamentFormat.groupsOnly ||
        (format == TournamentFormat.hybrid &&
            league == TournamentFormat.groupsOnly);
    return TournamentConfig(
      meetingsPerPair: usesGroupMeetings ? 1 : 2,
      leagueFormat: league,
    );
  }

  final int pointsForWin;
  final int pointsForDraw;
  final int pointsForLoss;

  /// How many times each pairing meets (1 = once, 2 = home & away, etc.).
  final int meetingsPerPair;

  /// Add a 3rd-place match in single-elim style brackets.
  final bool includeThirdPlace;

  /// Shuffle seeds when starting (instead of enrollment order).
  final bool randomizeSeeds;
  final int? swissRounds;
  final int groupSize;
  final int advancePerGroup;

  /// Hybrid: first phase format (must be a league format).
  final TournamentFormat leagueFormat;

  /// Hybrid: second phase format (must be a bracket format).
  final TournamentFormat bracketFormat;

  /// Ordered tiebreakers for standings (first criterion first).
  final List<Tiebreaker> tiebreakers;

  /// Knockout series length: 1=single, 2=two legs, 3/5/7=best of.
  final int knockoutSeriesLength;

  /// When true, finals can use [finalSeriesLength]; otherwise finals are single.
  final bool finalSeriesEnabled;

  /// Series length for the final (same allowed values as knockout).
  final int finalSeriesLength;

  /// What the coach/parent view of this league or standalone event may show.
  final FamilyViewSettings familyView;

  static int _normalizeSeriesLength(int value) {
    if (seriesLengthChoices.contains(value)) return value;
    return 1;
  }

  /// Series length for a specific bracket match.
  ///
  /// SE final: knockout stage with [winnerAdvancesTo] null (not 3rd place).
  /// DE final: [MatchStage.grandFinal] only (WB final advances to GF).
  int seriesLengthForMatch({
    required MatchStage stage,
    String? groupLabel,
    int? winnerAdvancesTo,
  }) {
    if (stage == MatchStage.group ||
        stage == MatchStage.roundRobin ||
        stage == MatchStage.swiss) {
      return 1;
    }
    final isThird = groupLabel == '3rd Place';
    final isFinal = stage == MatchStage.grandFinal ||
        (!isThird &&
            winnerAdvancesTo == null &&
            (stage == MatchStage.knockout || stage == MatchStage.winners));
    // Note: WB final has winnerAdvancesTo to GF in DE, so only grandFinal is DE final.
    // For SE, final has winnerAdvancesTo null.
    if (isFinal) {
      if (!finalSeriesEnabled) return 1;
      return finalSeriesLength.clamp(1, 7);
    }
    return knockoutSeriesLength.clamp(1, 7);
  }

  Map<String, dynamic> toJson() => {
    'pointsForWin': pointsForWin,
    'pointsForDraw': pointsForDraw,
    'pointsForLoss': pointsForLoss,
    'meetingsPerPair': meetingsPerPair,
    'includeThirdPlace': includeThirdPlace,
    'randomizeSeeds': randomizeSeeds,
    'swissRounds': swissRounds,
    'groupSize': groupSize,
    'advancePerGroup': advancePerGroup,
    'leagueFormat': leagueFormat.name,
    'bracketFormat': bracketFormat.name,
    'tiebreakers': tiebreakers.map((t) => t.name).toList(),
    'knockoutSeriesLength': knockoutSeriesLength,
    'finalSeriesEnabled': finalSeriesEnabled,
    'finalSeriesLength': finalSeriesLength,
    'familyView': familyView.toJson(),
  };

  factory TournamentConfig.fromJson(Map<String, dynamic> json) {
    // Migrate legacy doubleRoundRobin
    var meetings = json['meetingsPerPair'] as int?;
    if (meetings == null) {
      final legacy = json['doubleRoundRobin'] as bool?;
      meetings = legacy == true ? 2 : (legacy == false ? 1 : 2);
    }

    TournamentFormat parseSub(String? name, TournamentFormat fallback) {
      if (name == null) return fallback;
      if (name == 'worldCup' || name == 'consolation') return fallback;
      return TournamentFormat.values.firstWhere(
        (e) => e.name == name,
        orElse: () => fallback,
      );
    }

    List<Tiebreaker> parseTies(dynamic raw) {
      if (raw is! List) return List.of(defaultTiebreakers);
      final parsed = <Tiebreaker>[];
      for (final item in raw) {
        final name = item?.toString();
        if (name == null) continue;
        for (final t in Tiebreaker.values) {
          if (t.name == name) {
            parsed.add(t);
            break;
          }
        }
      }
      return parsed.isEmpty ? List.of(defaultTiebreakers) : parsed;
    }

    return TournamentConfig(
      pointsForWin: json['pointsForWin'] as int? ?? 3,
      pointsForDraw: json['pointsForDraw'] as int? ?? 1,
      pointsForLoss: json['pointsForLoss'] as int? ?? 0,
      meetingsPerPair: meetings.clamp(1, 6),
      includeThirdPlace: json['includeThirdPlace'] as bool? ?? false,
      randomizeSeeds: json['randomizeSeeds'] as bool? ?? false,
      swissRounds: json['swissRounds'] as int?,
      groupSize: json['groupSize'] as int? ?? 4,
      advancePerGroup: json['advancePerGroup'] as int? ?? 2,
      leagueFormat: parseSub(
        json['leagueFormat'] as String?,
        TournamentFormat.groupsOnly,
      ),
      bracketFormat: parseSub(
        json['bracketFormat'] as String?,
        TournamentFormat.singleElimination,
      ),
      tiebreakers: parseTies(json['tiebreakers']),
      knockoutSeriesLength: _normalizeSeriesLength(
        json['knockoutSeriesLength'] as int? ?? 1,
      ),
      finalSeriesEnabled: json['finalSeriesEnabled'] as bool? ?? true,
      finalSeriesLength: _normalizeSeriesLength(
        json['finalSeriesLength'] as int? ?? 1,
      ),
      familyView: FamilyViewSettings.fromJson(json['familyView']),
    );
  }

  TournamentConfig copyWith({
    int? pointsForWin,
    int? pointsForDraw,
    int? pointsForLoss,
    int? meetingsPerPair,
    bool? includeThirdPlace,
    bool? randomizeSeeds,
    int? swissRounds,
    bool clearSwissRounds = false,
    int? groupSize,
    int? advancePerGroup,
    TournamentFormat? leagueFormat,
    TournamentFormat? bracketFormat,
    List<Tiebreaker>? tiebreakers,
    int? knockoutSeriesLength,
    bool? finalSeriesEnabled,
    int? finalSeriesLength,
    FamilyViewSettings? familyView,
  }) {
    return TournamentConfig(
      pointsForWin: pointsForWin ?? this.pointsForWin,
      pointsForDraw: pointsForDraw ?? this.pointsForDraw,
      pointsForLoss: pointsForLoss ?? this.pointsForLoss,
      meetingsPerPair: meetingsPerPair ?? this.meetingsPerPair,
      includeThirdPlace: includeThirdPlace ?? this.includeThirdPlace,
      randomizeSeeds: randomizeSeeds ?? this.randomizeSeeds,
      swissRounds: clearSwissRounds ? null : (swissRounds ?? this.swissRounds),
      groupSize: groupSize ?? this.groupSize,
      advancePerGroup: advancePerGroup ?? this.advancePerGroup,
      leagueFormat: leagueFormat ?? this.leagueFormat,
      bracketFormat: bracketFormat ?? this.bracketFormat,
      tiebreakers: tiebreakers ?? this.tiebreakers,
      knockoutSeriesLength: knockoutSeriesLength != null
          ? _normalizeSeriesLength(knockoutSeriesLength)
          : this.knockoutSeriesLength,
      finalSeriesEnabled: finalSeriesEnabled ?? this.finalSeriesEnabled,
      finalSeriesLength: finalSeriesLength != null
          ? _normalizeSeriesLength(finalSeriesLength)
          : this.finalSeriesLength,
      familyView: familyView ?? this.familyView,
    );
  }
}

/// Coach/parent visibility for a league (or a standalone tournament).
///
/// Stored inside [TournamentConfig] JSON so backups keep it without a schema bump.
class FamilyViewSettings {
  const FamilyViewSettings({
    this.showSchedule = true,
    this.showScores = true,
    this.showStandings = true,
    this.showVenues = true,
    this.showPower = false,
  });

  static const defaults = FamilyViewSettings();

  final bool showSchedule;
  final bool showScores;
  final bool showStandings;
  final bool showVenues;
  final bool showPower;

  FamilyViewSettings copyWith({
    bool? showSchedule,
    bool? showScores,
    bool? showStandings,
    bool? showVenues,
    bool? showPower,
  }) {
    return FamilyViewSettings(
      showSchedule: showSchedule ?? this.showSchedule,
      showScores: showScores ?? this.showScores,
      showStandings: showStandings ?? this.showStandings,
      showVenues: showVenues ?? this.showVenues,
      showPower: showPower ?? this.showPower,
    );
  }

  Map<String, dynamic> toJson() => {
    'showSchedule': showSchedule,
    'showScores': showScores,
    'showStandings': showStandings,
    'showVenues': showVenues,
    'showPower': showPower,
  };

  factory FamilyViewSettings.fromJson(Object? raw) {
    if (raw is! Map) return defaults;
    bool flag(String key, {required bool fallback}) {
      final value = raw[key];
      return value is bool ? value : fallback;
    }

    return FamilyViewSettings(
      showSchedule: flag('showSchedule', fallback: true),
      showScores: flag('showScores', fallback: true),
      showStandings: flag('showStandings', fallback: true),
      showVenues: flag('showVenues', fallback: true),
      showPower: flag('showPower', fallback: false),
    );
  }
}

enum AppRole { manager, family }

class ViewerSettings {
  const ViewerSettings({
    this.role = AppRole.manager,
    this.familyTeamId,
  });

  final AppRole role;
  final int? familyTeamId;

  bool get isManager => role == AppRole.manager;
  bool get isFamily => role == AppRole.family;

  ViewerSettings copyWith({
    AppRole? role,
    int? familyTeamId,
    bool clearFamilyTeam = false,
  }) {
    return ViewerSettings(
      role: role ?? this.role,
      familyTeamId: clearFamilyTeam ? null : (familyTeamId ?? this.familyTeamId),
    );
  }
}

class Team {
  const Team({
    required this.id,
    required this.name,
    this.logoPath,
    this.colorArgb = 0xFF0B6E4F,
    this.powerRating = 50,
    this.homeLocation,
    this.homeVenueId,
    this.showLogoCircle = true,
    this.titles = const [],
    this.promotionsWon = 0,
    this.relegations = 0,
    this.careerPlayed = 0,
    this.careerWon = 0,
    this.careerDrawn = 0,
    this.careerLost = 0,
    this.careerGoalsFor = 0,
    this.careerGoalsAgainst = 0,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String? logoPath;
  final int colorArgb;
  final int powerRating;

  /// Denormalized label from [homeVenueId] (optional — teams need no home).
  final String? homeLocation;

  /// Soft FK to a [Venue]; null when the team has no home ground.
  final int? homeVenueId;

  /// White disc behind the logo on the parent page.
  final bool showLogoCircle;

  /// Specific tournament/league titles won (newest last).
  final List<String> titles;
  final int promotionsWon;
  final int relegations;
  final int careerPlayed;
  final int careerWon;
  final int careerDrawn;
  final int careerLost;
  final int careerGoalsFor;
  final int careerGoalsAgainst;
  final DateTime createdAt;

  int get titlesWon => titles.length;
  int get careerGoalDifference => careerGoalsFor - careerGoalsAgainst;
}

class Tournament {
  const Tournament({
    required this.id,
    required this.name,
    required this.format,
    required this.status,
    required this.config,
    required this.createdAt,
    this.updatedAt,
    this.leagueId,
    this.divisionId,
  });

  final int id;
  final String name;
  final TournamentFormat format;
  final TournamentStatus status;
  final TournamentConfig config;
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// When set, this tournament is a division season within a multi-tier league.
  final int? leagueId;
  final int? divisionId;
}

class TeamList {
  const TeamList({
    required this.id,
    required this.name,
    required this.createdAt,
    this.teamIds = const [],
  });

  final int id;
  final String name;
  final DateTime createdAt;
  final List<int> teamIds;
}

enum LeagueStatus { draft, active, completed }

class League {
  const League({
    required this.id,
    required this.name,
    required this.status,
    required this.format,
    required this.config,
    required this.promoteCount,
    required this.relegateCount,
    required this.promoRelegEnabled,
    required this.seasonNumber,
    required this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final LeagueStatus status;
  final TournamentFormat format;
  final TournamentConfig config;
  final int promoteCount;
  final int relegateCount;
  final bool promoRelegEnabled;
  final int seasonNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;

  bool get canUsePromoReleg =>
      promoRelegEnabled && formatAllowsPromoReleg(format);
}

class Division {
  const Division({
    required this.id,
    required this.leagueId,
    required this.name,
    required this.tierIndex,
    this.currentTournamentId,
  });

  final int id;
  final int leagueId;
  final String name;

  /// 0 = top tier.
  final int tierIndex;
  final int? currentTournamentId;
}

class DivisionTeam {
  const DivisionTeam({
    required this.id,
    required this.divisionId,
    required this.teamId,
    this.team,
  });

  final int id;
  final int divisionId;
  final int teamId;
  final Team? team;
}

class PromoRelegMove {
  const PromoRelegMove({
    required this.teamId,
    required this.fromDivisionId,
    required this.toDivisionId,
    required this.promoted,
    this.teamName,
    this.fromDivisionName,
    this.toDivisionName,
  });

  final int teamId;
  final int fromDivisionId;
  final int toDivisionId;
  final bool promoted;
  final String? teamName;
  final String? fromDivisionName;
  final String? toDivisionName;
}

class TournamentTeam {
  const TournamentTeam({
    required this.id,
    required this.tournamentId,
    required this.teamId,
    this.seed,
    this.groupLabel,
    this.team,
  });

  final int id;
  final int tournamentId;
  final int teamId;
  final int? seed;
  final String? groupLabel;
  final Team? team;

  String get displayName => team?.name ?? 'Team #$teamId';
  String? get logoPath => team?.logoPath;
  int get colorArgb => team?.colorArgb ?? 0xFF0B6E4F;
  int get powerRating => team?.powerRating ?? 50;
  String? get homeLocation => team?.homeLocation;
  int? get homeVenueId => team?.homeVenueId;
}

/// A place to play: standalone site, multi-field complex, or a field under one.
class Venue {
  const Venue({
    required this.id,
    required this.name,
    this.address,
    this.mapUrl,
    this.notes,
    this.layoutImagePath,
    this.parentVenueId,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String? address;
  final String? mapUrl;
  final String? notes;

  /// PNG/JPEG site diagram stored as a data URL.
  final String? layoutImagePath;

  /// When set, this row is a named field inside the parent complex.
  final int? parentVenueId;
  final DateTime createdAt;

  bool get isField => parentVenueId != null;
  bool get isTopLevel => parentVenueId == null;
}

class Match {
  const Match({
    required this.id,
    required this.tournamentId,
    required this.round,
    required this.stage,
    this.groupLabel,
    this.bracketSlot,
    this.homeTeamId,
    this.awayTeamId,
    this.homeScore,
    this.awayScore,
    required this.status,
    this.winnerAdvancesTo,
    this.loserAdvancesTo,
    this.location,
    this.scheduledAt,
    this.durationMinutes,
    this.venueId,
    this.seriesJson,
    this.series,
  });

  final int id;
  final int tournamentId;
  final int round;
  final MatchStage stage;
  final String? groupLabel;
  final int? bracketSlot;
  final int? homeTeamId;
  final int? awayTeamId;
  final int? homeScore;
  final int? awayScore;
  final MatchStatus status;
  final int? winnerAdvancesTo;
  final int? loserAdvancesTo;
  final String? location;

  /// When the match is scheduled to kick off.
  final DateTime? scheduledAt;

  /// Planned length in minutes (UI treats null as 90).
  final int? durationMinutes;

  /// Soft FK to a [Venue].
  final int? venueId;

  /// Raw JSON for multi-leg series (nullable when single-match).
  final String? seriesJson;

  /// Parsed series state when [seriesJson] is present.
  final SeriesScore? series;

  bool get isBye => status == MatchStatus.bye;
  bool get isCompleted =>
      status == MatchStatus.completed || status == MatchStatus.bye;

  bool get isBracketMatch =>
      stage == MatchStage.knockout ||
      stage == MatchStage.winners ||
      stage == MatchStage.losers ||
      stage == MatchStage.grandFinal;

  int? get winnerTeamId {
    if (status == MatchStatus.bye) {
      return homeTeamId ?? awayTeamId;
    }
    if (status != MatchStatus.completed ||
        homeScore == null ||
        awayScore == null) {
      return null;
    }
    if (homeScore! > awayScore!) return homeTeamId;
    if (awayScore! > homeScore!) return awayTeamId;
    return null;
  }

  int? get loserTeamId {
    if (status == MatchStatus.bye) return null;
    if (status != MatchStatus.completed ||
        homeScore == null ||
        awayScore == null ||
        homeTeamId == null ||
        awayTeamId == null) {
      return null;
    }
    if (homeScore! > awayScore!) return awayTeamId;
    if (awayScore! > homeScore!) return homeTeamId;
    return null;
  }
}

class StandingRow {
  const StandingRow({
    required this.teamId,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
    this.groupLabel,
    this.team,
  });

  final int teamId;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;
  final int points;
  final String? groupLabel;
  final Team? team;

  int get goalDifference => goalsFor - goalsAgainst;
  String get displayName => team?.name ?? 'Team #$teamId';
}

class DraftMatch {
  const DraftMatch({
    required this.round,
    required this.stage,
    this.groupLabel,
    this.bracketSlot,
    this.homeTeamId,
    this.awayTeamId,
    this.status = MatchStatus.pending,
    this.winnerAdvancesTo,
    this.loserAdvancesTo,
    this.homeScore,
    this.awayScore,
    this.location,
    this.venueId,
  });

  final int round;
  final MatchStage stage;
  final String? groupLabel;
  final int? bracketSlot;
  final int? homeTeamId;
  final int? awayTeamId;
  final MatchStatus status;
  final int? winnerAdvancesTo;
  final int? loserAdvancesTo;
  final int? homeScore;
  final int? awayScore;
  final String? location;
  final int? venueId;

  DraftMatch copyWith({
    int? round,
    MatchStage? stage,
    String? groupLabel,
    int? bracketSlot,
    int? homeTeamId,
    int? awayTeamId,
    MatchStatus? status,
    int? winnerAdvancesTo,
    int? loserAdvancesTo,
    int? homeScore,
    int? awayScore,
    String? location,
    int? venueId,
  }) {
    return DraftMatch(
      round: round ?? this.round,
      stage: stage ?? this.stage,
      groupLabel: groupLabel ?? this.groupLabel,
      bracketSlot: bracketSlot ?? this.bracketSlot,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      awayTeamId: awayTeamId ?? this.awayTeamId,
      status: status ?? this.status,
      winnerAdvancesTo: winnerAdvancesTo ?? this.winnerAdvancesTo,
      loserAdvancesTo: loserAdvancesTo ?? this.loserAdvancesTo,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      location: location ?? this.location,
      venueId: venueId ?? this.venueId,
    );
  }
}

/// Parse stored format names, migrating removed enums.
TournamentFormat parseFormatName(String value) {
  if (value == 'consolation') return TournamentFormat.singleElimination;
  if (value == 'worldCup') return TournamentFormat.hybrid;
  return TournamentFormat.values.firstWhere(
    (e) => e.name == value,
    orElse: () => TournamentFormat.roundRobin,
  );
}
