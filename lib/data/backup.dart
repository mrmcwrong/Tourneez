import 'dart:convert';

import 'package:tourneez/data/database.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/domain/series_score.dart';

/// Magic string for Tourneez JSON backups.
const tourneezBackupFormat = 'tourneez-backup';

/// App version stamped into backups (keep in sync with pubspec `version`).
const tourneezAppVersion = '1.0.0+1';

/// Reject absurd logo payloads on restore (data URLs are base64-inflated).
const maxLogoDataUrlChars = 800000;

/// Soft caps for free-text fields restored from untrusted files.
const maxLocationChars = 200;
const maxNameChars = 120;

/// Planned roadmap metadata embedded in every backup for forward compatibility.
const backupPlannedSchema = <String, dynamic>{
  'nextSchemaVersion': 11,
  'phases': ['players', 'online_publish'],
  'reservedTables': ['players', 'team_players'],
  'reservedMatchColumns': ['notes'],
  'reservedTeamColumns': <String>[],
};

class BackupException implements Exception {
  BackupException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Builds a versioned backup envelope from already-serialized table rows.
Map<String, dynamic> buildBackupEnvelope({
  required int schemaVersion,
  required Map<String, List<Map<String, dynamic>>> tables,
  Map<String, dynamic>? preferences,
  DateTime? exportedAt,
}) {
  return {
    'format': tourneezBackupFormat,
    'schemaVersion': schemaVersion,
    'appVersion': tourneezAppVersion,
    'exportedAt': (exportedAt ?? DateTime.now().toUtc()).toIso8601String(),
    'planned': backupPlannedSchema,
    'preferences': preferences ?? const <String, dynamic>{},
    'tables': tables,
  };
}

/// Parses and validates a backup JSON document. Throws [BackupException].
ValidatedBackup parseAndValidateBackup(
  String raw, {
  int maxSchemaVersion = tourneezSchemaVersion,
}) {
  late final Object? decoded;
  try {
    decoded = jsonDecode(raw);
  } catch (_) {
    throw BackupException('Backup file is not valid JSON.');
  }
  if (decoded is! Map) {
    throw BackupException('Backup root must be a JSON object.');
  }
  final root = Map<String, dynamic>.from(decoded);

  if (root['format'] != tourneezBackupFormat) {
    throw BackupException('Not a Tourneez backup file.');
  }

  final schemaVersion = _readInt(root['schemaVersion']);
  if (schemaVersion == null || schemaVersion < 1) {
    throw BackupException('Backup is missing a valid schemaVersion.');
  }
  if (schemaVersion > maxSchemaVersion) {
    throw BackupException(
      'This backup needs a newer Tourneez (schema $schemaVersion; '
      'this app supports up to $maxSchemaVersion).',
    );
  }

  final tablesRaw = root['tables'];
  if (tablesRaw is! Map) {
    throw BackupException('Backup is missing table data.');
  }
  final tables = <String, List<Map<String, dynamic>>>{};
  for (final entry in tablesRaw.entries) {
    final key = entry.key.toString();
    final value = entry.value;
    if (value is! List) {
      throw BackupException('Table "$key" must be a JSON array.');
    }
    tables[key] = [
      for (final row in value)
        if (row is Map) Map<String, dynamic>.from(row)
        else
          throw BackupException('Table "$key" has a non-object row.'),
    ];
  }

  for (final required in const [
    'teams',
    'teamLists',
    'teamListMembers',
    'leagues',
    'divisions',
    'divisionTeams',
    'tournaments',
    'tournamentTeams',
    'matches',
    'venues',
  ]) {
    tables.putIfAbsent(required, () => const []);
  }

  _validateTeams(tables['teams']!);
  _validateTeamLists(tables['teamLists']!);
  _validateTeamListMembers(tables['teamListMembers']!);
  _validateLeagues(tables['leagues']!);
  _validateDivisions(tables['divisions']!);
  _validateDivisionTeams(tables['divisionTeams']!);
  _validateTournaments(tables['tournaments']!);
  _validateTournamentTeams(tables['tournamentTeams']!);
  _validateMatches(tables['matches']!);
  _validateVenues(tables['venues']!);
  // Drop leftover rows from incomplete deletes (common when FKs were off).
  _pruneOrphanRows(tables);

  final prefsRaw = root['preferences'];
  final preferences = prefsRaw is Map
      ? Map<String, dynamic>.from(prefsRaw)
      : <String, dynamic>{};

  return ValidatedBackup(
    schemaVersion: schemaVersion,
    appVersion: root['appVersion']?.toString(),
    exportedAt: root['exportedAt']?.toString(),
    tables: tables,
    preferences: preferences,
  );
}

class ValidatedBackup {
  const ValidatedBackup({
    required this.schemaVersion,
    required this.tables,
    required this.preferences,
    this.appVersion,
    this.exportedAt,
  });

  final int schemaVersion;
  final String? appVersion;
  final String? exportedAt;
  final Map<String, List<Map<String, dynamic>>> tables;
  final Map<String, dynamic> preferences;
}

void _requireInt(Map<String, dynamic> row, String key, String table) {
  final v = _readInt(row[key]);
  if (v == null) {
    throw BackupException('$table row missing integer "$key".');
  }
  row[key] = v;
}

int? _readInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.round();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

void _requireString(Map<String, dynamic> row, String key, String table) {
  final v = row[key];
  if (v is! String || v.trim().isEmpty) {
    throw BackupException('$table row missing string "$key".');
  }
}

String _clampName(String name, {int max = maxNameChars}) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return 'Untitled';
  if (trimmed.length <= max) return trimmed;
  return trimmed.substring(0, max);
}

String? _sanitizeOptionalText(dynamic value, {int max = maxLocationChars}) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  if (text.length <= max) return text;
  return text.substring(0, max);
}

String? _sanitizeLogoPath(dynamic value) {
  if (value == null) return null;
  final text = value.toString();
  if (text.isEmpty) return null;
  if (text.startsWith('assets/')) return text;
  if (!text.startsWith('data:')) {
    throw BackupException('Team logo must be a data URL or asset path.');
  }
  if (text.length > maxLogoDataUrlChars) {
    throw BackupException('Team logo in backup is too large.');
  }
  final comma = text.indexOf(',');
  if (comma < 0) {
    throw BackupException('Team logo data URL is malformed.');
  }
  try {
    base64Decode(text.substring(comma + 1));
  } catch (_) {
    throw BackupException('Team logo data URL is not valid base64.');
  }
  return text;
}

void _validateTeams(List<Map<String, dynamic>> rows) {
  final ids = <int>{};
  for (final row in rows) {
    _requireInt(row, 'id', 'teams');
    _requireString(row, 'name', 'teams');
    final id = row['id'] as int;
    if (!ids.add(id)) {
      throw BackupException('Duplicate team id $id.');
    }
    row['name'] = _clampName(row['name'] as String, max: 80);
    row['logoPath'] = _sanitizeLogoPath(row['logoPath']);
    row['homeLocation'] = _sanitizeOptionalText(row['homeLocation']);
    row['homeVenueId'] = _readInt(row['homeVenueId']);
    final circle = row['showLogoCircle'];
    row['showLogoCircle'] = circle == null || circle == true || circle == 1;
    row['powerRating'] = _clampInt(row['powerRating'], 1, 100, fallback: 50);
    row['colorArgb'] = _asInt(row['colorArgb'], fallback: 0xFF0B6E4F);
    row['titlesWon'] = _nonNegInt(row['titlesWon']);
    row['titlesJson'] = _sanitizeTitlesJson(row['titlesJson']);
    row['promotionsWon'] = _nonNegInt(row['promotionsWon']);
    row['relegations'] = _nonNegInt(row['relegations']);
    row['careerPlayed'] = _nonNegInt(row['careerPlayed']);
    row['careerWon'] = _nonNegInt(row['careerWon']);
    row['careerDrawn'] = _nonNegInt(row['careerDrawn']);
    row['careerLost'] = _nonNegInt(row['careerLost']);
    row['careerGoalsFor'] = _nonNegInt(row['careerGoalsFor']);
    row['careerGoalsAgainst'] = _nonNegInt(row['careerGoalsAgainst']);
    row['createdAt'] = _requireEpoch(row['createdAt'], 'teams.createdAt');
  }
}

void _validateTeamLists(List<Map<String, dynamic>> rows) {
  final ids = <int>{};
  for (final row in rows) {
    _requireInt(row, 'id', 'teamLists');
    _requireString(row, 'name', 'teamLists');
    if (!ids.add(row['id'] as int)) {
      throw BackupException('Duplicate team list id ${row['id']}.');
    }
    row['name'] = _clampName(row['name'] as String, max: 80);
    row['createdAt'] = _requireEpoch(row['createdAt'], 'teamLists.createdAt');
  }
}

void _validateTeamListMembers(List<Map<String, dynamic>> rows) {
  for (final row in rows) {
    _requireInt(row, 'id', 'teamListMembers');
    _requireInt(row, 'listId', 'teamListMembers');
    _requireInt(row, 'teamId', 'teamListMembers');
  }
}

void _validateLeagues(List<Map<String, dynamic>> rows) {
  final ids = <int>{};
  for (final row in rows) {
    _requireInt(row, 'id', 'leagues');
    _requireString(row, 'name', 'leagues');
    _requireString(row, 'status', 'leagues');
    if (!ids.add(row['id'] as int)) {
      throw BackupException('Duplicate league id ${row['id']}.');
    }
    row['name'] = _clampName(row['name'] as String);
    try {
      parseLeagueStatus(row['status'] as String);
    } on FormatException catch (e) {
      throw BackupException(e.message);
    }
    row['format'] = parseFormatName(
      (row['format'] as String?) ?? 'roundRobin',
    ).name;
    row['configJson'] = _sanitizeConfigJson(row['configJson']);
    row['promoteCount'] = _clampInt(row['promoteCount'], 0, 20, fallback: 2);
    row['relegateCount'] = _clampInt(row['relegateCount'], 0, 20, fallback: 2);
    row['promoRelegEnabled'] = row['promoRelegEnabled'] == true ||
        row['promoRelegEnabled'] == 1;
    row['pointsForWin'] = _clampInt(row['pointsForWin'], 0, 20, fallback: 3);
    row['pointsForDraw'] = _clampInt(row['pointsForDraw'], 0, 20, fallback: 1);
    row['meetingsPerPair'] =
        _clampInt(row['meetingsPerPair'], 1, 6, fallback: 2);
    row['seasonNumber'] = _clampInt(row['seasonNumber'], 1, 9999, fallback: 1);
    row['createdAt'] = _requireEpoch(row['createdAt'], 'leagues.createdAt');
    row['updatedAt'] = _optionalEpoch(row['updatedAt']);
  }
}

void _validateDivisions(List<Map<String, dynamic>> rows) {
  final ids = <int>{};
  for (final row in rows) {
    _requireInt(row, 'id', 'divisions');
    _requireInt(row, 'leagueId', 'divisions');
    _requireString(row, 'name', 'divisions');
    _requireInt(row, 'tierIndex', 'divisions');
    if (!ids.add(row['id'] as int)) {
      throw BackupException('Duplicate division id ${row['id']}.');
    }
    row['name'] = _clampName(row['name'] as String, max: 80);
    final current = _readInt(row['currentTournamentId']);
    row['currentTournamentId'] = current;
  }
}

void _validateDivisionTeams(List<Map<String, dynamic>> rows) {
  for (final row in rows) {
    _requireInt(row, 'id', 'divisionTeams');
    _requireInt(row, 'divisionId', 'divisionTeams');
    _requireInt(row, 'teamId', 'divisionTeams');
  }
}

void _validateTournaments(List<Map<String, dynamic>> rows) {
  final ids = <int>{};
  for (final row in rows) {
    _requireInt(row, 'id', 'tournaments');
    _requireString(row, 'name', 'tournaments');
    _requireString(row, 'format', 'tournaments');
    _requireString(row, 'status', 'tournaments');
    if (!ids.add(row['id'] as int)) {
      throw BackupException('Duplicate tournament id ${row['id']}.');
    }
    row['name'] = _clampName(row['name'] as String);
    row['format'] = parseFormatName(row['format'] as String).name;
    try {
      parseStatus(row['status'] as String);
    } on FormatException catch (e) {
      throw BackupException(e.message);
    }
    row['configJson'] = _sanitizeConfigJson(row['configJson']);
    row['leagueId'] = _readInt(row['leagueId']);
    row['divisionId'] = _readInt(row['divisionId']);
    row['createdAt'] = _requireEpoch(row['createdAt'], 'tournaments.createdAt');
    row['updatedAt'] = _optionalEpoch(row['updatedAt']);
  }
}

void _validateTournamentTeams(List<Map<String, dynamic>> rows) {
  for (final row in rows) {
    _requireInt(row, 'id', 'tournamentTeams');
    _requireInt(row, 'tournamentId', 'tournamentTeams');
    _requireInt(row, 'teamId', 'tournamentTeams');
    row['seed'] = _readInt(row['seed']);
    final label = row['groupLabel'];
    if (label != null) {
      row['groupLabel'] = _sanitizeOptionalText(label, max: 8);
    }
  }
}

void _validateMatches(List<Map<String, dynamic>> rows) {
  final ids = <int>{};
  for (final row in rows) {
    _requireInt(row, 'id', 'matches');
    _requireInt(row, 'tournamentId', 'matches');
    _requireInt(row, 'round', 'matches');
    _requireString(row, 'stage', 'matches');
    _requireString(row, 'status', 'matches');
    if (!ids.add(row['id'] as int)) {
      throw BackupException('Duplicate match id ${row['id']}.');
    }
    try {
      parseMatchStage(row['stage'] as String);
      parseMatchStatus(row['status'] as String);
    } on FormatException catch (e) {
      throw BackupException(e.message);
    }
    for (final key in const [
      'bracketSlot',
      'homeTeamId',
      'awayTeamId',
      'homeScore',
      'awayScore',
      'winnerAdvancesTo',
      'loserAdvancesTo',
    ]) {
      final parsed = _readInt(row[key]);
      if (row[key] != null && parsed == null) {
        throw BackupException('matches.$key must be an int.');
      }
      row[key] = parsed;
    }
    row['location'] = _sanitizeOptionalText(row['location']);
    row['scheduledAt'] = _optionalEpoch(row['scheduledAt']);
    row['venueId'] = _readInt(row['venueId']);
    if (row['durationMinutes'] != null) {
      final duration = _readInt(row['durationMinutes']);
      if (duration == null || duration < 1 || duration > 24 * 60) {
        throw BackupException('matches.durationMinutes must be 1–1440.');
      }
      row['durationMinutes'] = duration;
    }
    final series = row['seriesJson'];
    if (series != null) {
      if (series is! String) {
        throw BackupException('matches.seriesJson must be a string.');
      }
      if (SeriesScore.tryParse(series) == null && series.trim().isNotEmpty) {
        throw BackupException('matches.seriesJson is invalid.');
      }
    }
  }
}

void _validateVenues(List<Map<String, dynamic>> rows) {
  final ids = <int>{};
  for (final row in rows) {
    _requireInt(row, 'id', 'venues');
    _requireString(row, 'name', 'venues');
    final id = row['id'] as int;
    if (!ids.add(id)) {
      throw BackupException('Duplicate venue id $id.');
    }
    row['name'] = _clampName(row['name'] as String);
    row['address'] = _sanitizeOptionalText(row['address'], max: 300);
    row['mapUrl'] = _sanitizeOptionalText(row['mapUrl'], max: 500);
    row['notes'] = _sanitizeOptionalText(row['notes'], max: 500);
    row['parentVenueId'] = _readInt(row['parentVenueId']);
    row['createdAt'] = _requireEpoch(row['createdAt'], 'venues.createdAt');
    final layout = row['layoutImagePath'];
    if (layout != null) {
      row['layoutImagePath'] = _sanitizeLogoPath(layout);
    }
  }
}

/// Removes child rows that point at missing parents so older / dirty backups
/// can still restore. Mutates [tables] in place.
void _pruneOrphanRows(Map<String, List<Map<String, dynamic>>> tables) {
  final teamIds = {for (final r in tables['teams']!) r['id'] as int};
  final listIds = {for (final r in tables['teamLists']!) r['id'] as int};
  final leagueIds = {for (final r in tables['leagues']!) r['id'] as int};

  // Venues: keep top-level first, then fields whose parent survived.
  final topVenues = [
    for (final r in tables['venues']!)
      if (r['parentVenueId'] == null) r,
  ];
  final topIds = {for (final r in topVenues) r['id'] as int};
  final childVenues = [
    for (final r in tables['venues']!)
      if (r['parentVenueId'] != null &&
          topIds.contains(r['parentVenueId'] as int))
        r,
  ];
  tables['venues'] = [...topVenues, ...childVenues];
  final venueIds = {for (final r in tables['venues']!) r['id'] as int};

  for (final r in tables['teams']!) {
    final homeVenueId = r['homeVenueId'] as int?;
    if (homeVenueId != null && !venueIds.contains(homeVenueId)) {
      r['homeVenueId'] = null;
      r['homeLocation'] = null;
    }
  }

  tables['divisions'] = [
    for (final r in tables['divisions']!)
      if (leagueIds.contains(r['leagueId'] as int)) r,
  ];
  final divisionIds = {for (final r in tables['divisions']!) r['id'] as int};

  tables['tournaments'] = [
    for (final r in tables['tournaments']!)
      if ((r['leagueId'] == null ||
              leagueIds.contains(r['leagueId'] as int)) &&
          (r['divisionId'] == null ||
              divisionIds.contains(r['divisionId'] as int)))
        r,
  ];
  // Soft-clear dangling optional FKs that survived the filter.
  for (final r in tables['tournaments']!) {
    final leagueId = r['leagueId'] as int?;
    if (leagueId != null && !leagueIds.contains(leagueId)) {
      r['leagueId'] = null;
    }
    final divisionId = r['divisionId'] as int?;
    if (divisionId != null && !divisionIds.contains(divisionId)) {
      r['divisionId'] = null;
    }
  }
  final tournamentIds = {
    for (final r in tables['tournaments']!) r['id'] as int,
  };

  for (final r in tables['divisions']!) {
    final current = r['currentTournamentId'] as int?;
    if (current != null && !tournamentIds.contains(current)) {
      r['currentTournamentId'] = null;
    }
  }

  tables['teamListMembers'] = [
    for (final r in tables['teamListMembers']!)
      if (listIds.contains(r['listId'] as int) &&
          teamIds.contains(r['teamId'] as int))
        r,
  ];
  tables['divisionTeams'] = [
    for (final r in tables['divisionTeams']!)
      if (divisionIds.contains(r['divisionId'] as int) &&
          teamIds.contains(r['teamId'] as int))
        r,
  ];
  tables['tournamentTeams'] = [
    for (final r in tables['tournamentTeams']!)
      if (tournamentIds.contains(r['tournamentId'] as int) &&
          teamIds.contains(r['teamId'] as int))
        r,
  ];
  tables['matches'] = [
    for (final r in tables['matches']!)
      if (tournamentIds.contains(r['tournamentId'] as int)) r,
  ];
  for (final r in tables['matches']!) {
    for (final key in const ['homeTeamId', 'awayTeamId']) {
      final id = r[key] as int?;
      if (id != null && !teamIds.contains(id)) {
        r[key] = null;
      }
    }
    final venueId = r['venueId'] as int?;
    if (venueId != null && !venueIds.contains(venueId)) {
      r['venueId'] = null;
    }
  }
}

int _asInt(dynamic value, {required int fallback}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return fallback;
}

int _nonNegInt(dynamic value) {
  final n = _asInt(value, fallback: 0);
  return n < 0 ? 0 : n;
}

int _clampInt(dynamic value, int min, int max, {required int fallback}) {
  final n = _asInt(value, fallback: fallback);
  if (n < min) return min;
  if (n > max) return max;
  return n;
}

int _requireEpoch(dynamic value, String label) {
  final asInt = _readInt(value);
  if (asInt != null) return asInt;
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed.millisecondsSinceEpoch;
  }
  throw BackupException('$label must be a Unix epoch millis or ISO date.');
}

int? _optionalEpoch(dynamic value) {
  if (value == null) return null;
  final asInt = _readInt(value);
  if (asInt != null) return asInt;
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed.millisecondsSinceEpoch;
  }
  throw BackupException('Optional date must be epoch millis or ISO date.');
}

String _sanitizeConfigJson(dynamic value) {
  if (value == null) return '{}';
  if (value is Map) {
    return jsonEncode(TournamentConfig.fromJson(
      Map<String, dynamic>.from(value),
    ).toJson());
  }
  if (value is! String) {
    throw BackupException('configJson must be a string or object.');
  }
  try {
    final decoded = jsonDecode(value);
    if (decoded is! Map) return '{}';
    return jsonEncode(TournamentConfig.fromJson(
      Map<String, dynamic>.from(decoded),
    ).toJson());
  } catch (_) {
    throw BackupException('configJson is not valid JSON.');
  }
}

String _sanitizeTitlesJson(dynamic value) {
  if (value == null) return '[]';
  if (value is List) {
    final titles = value
        .map((e) => e.toString().trim())
        .where((s) => s.isNotEmpty)
        .take(100)
        .toList();
    return jsonEncode(titles);
  }
  if (value is! String) return '[]';
  try {
    final decoded = jsonDecode(value);
    if (decoded is! List) return '[]';
    final titles = decoded
        .map((e) => e.toString().trim())
        .where((s) => s.isNotEmpty)
        .take(100)
        .toList();
    return jsonEncode(titles);
  } catch (_) {
    return '[]';
  }
}
