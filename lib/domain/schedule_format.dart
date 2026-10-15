import 'package:intl/intl.dart';
import 'package:tourneez/domain/models.dart';

/// Default planned match length when [Match.durationMinutes] is unset.
const defaultMatchDurationMinutes = 90;

/// Human-readable kickoff, e.g. `Sat, Sep 20 · 9:00 AM`.
String formatMatchKickoff(DateTime when) {
  final local = when.toLocal();
  try {
    return DateFormat('EEE, MMM d · h:mm a').format(local);
  } catch (_) {
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final suffix = local.hour < 12 ? 'AM' : 'PM';
    return '${local.month}/${local.day} · $hour:$minute $suffix';
  }
}

/// Compact day header for schedule lists, e.g. `Saturday, Sep 20`.
String formatScheduleDay(DateTime day) {
  final local = day.toLocal();
  try {
    return DateFormat('EEEE, MMM d').format(local);
  } catch (_) {
    return '${local.month}/${local.day}/${local.year}';
  }
}

DateTime matchEndTime(Match match) {
  final start = match.scheduledAt!;
  final minutes = match.durationMinutes ?? defaultMatchDurationMinutes;
  return start.add(Duration(minutes: minutes));
}

/// Builds a standard `.ics` calendar for [matches] that have a kickoff.
String buildTournamentIcs({
  required Tournament tournament,
  required List<Match> matches,
  required Map<int, TournamentTeam> teamsById,
}) {
  final stamped = DateTime.now().toUtc();
  final buffer = StringBuffer()
    ..writeln('BEGIN:VCALENDAR')
    ..writeln('VERSION:2.0')
    ..writeln('PRODID:-//Tourneez//EN')
    ..writeln('CALSCALE:GREGORIAN')
    ..writeln('METHOD:PUBLISH')
    ..writeln('X-WR-CALNAME:${_escapeIcsText(tournament.name)}');

  final scheduled = matches
      .where((m) => m.scheduledAt != null && m.status != MatchStatus.bye)
      .toList()
    ..sort((a, b) => a.scheduledAt!.compareTo(b.scheduledAt!));

  for (final match in scheduled) {
    final home = match.homeTeamId == null
        ? 'TBD'
        : (teamsById[match.homeTeamId!]?.displayName ?? 'Team');
    final away = match.awayTeamId == null
        ? 'TBD'
        : (teamsById[match.awayTeamId!]?.displayName ?? 'Team');
    final start = match.scheduledAt!.toUtc();
    final end = matchEndTime(match).toUtc();
    final uid = 'tourneez-match-${match.id}@tourneez.local';
    final summary = '$home vs $away';
    final description = [
      tournament.name,
      'Round ${match.round}',
      if (match.location != null && match.location!.trim().isNotEmpty)
        match.location!.trim(),
    ].join('\\n');

    buffer
      ..writeln('BEGIN:VEVENT')
      ..writeln('UID:$uid')
      ..writeln('DTSTAMP:${_formatIcsUtc(stamped)}')
      ..writeln('DTSTART:${_formatIcsUtc(start)}')
      ..writeln('DTEND:${_formatIcsUtc(end)}')
      ..writeln('SUMMARY:${_escapeIcsText(summary)}')
      ..writeln('DESCRIPTION:${_escapeIcsText(description)}');
    if (match.location != null && match.location!.trim().isNotEmpty) {
      buffer.writeln(
        'LOCATION:${_escapeIcsText(match.location!.trim())}',
      );
    }
    buffer.writeln('END:VEVENT');
  }

  buffer.writeln('END:VCALENDAR');
  return buffer.toString();
}

String _formatIcsUtc(DateTime value) {
  final utc = value.toUtc();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${utc.year}'
      '${two(utc.month)}'
      '${two(utc.day)}'
      'T'
      '${two(utc.hour)}'
      '${two(utc.minute)}'
      '${two(utc.second)}'
      'Z';
}

String _escapeIcsText(String value) {
  return value
      .replaceAll('\\', '\\\\')
      .replaceAll(';', '\\;')
      .replaceAll(',', '\\,')
      .replaceAll('\n', '\\n')
      .replaceAll('\r', '');
}
