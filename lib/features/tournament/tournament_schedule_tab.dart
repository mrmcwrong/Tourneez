import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/domain/schedule_format.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/providers/viewer_provider.dart';
import 'package:tourneez/ui/theme.dart';
import 'package:tourneez/ui/venue_overview.dart';
import 'package:tourneez/ui/widgets.dart';

/// Week / day schedule for a tournament, plus bulk kickoff tools and ICS export.
class TournamentScheduleTab extends ConsumerStatefulWidget {
  const TournamentScheduleTab({
    super.key,
    required this.tournament,
    required this.onEditMatch,
  });

  final Tournament tournament;
  final void Function(Match match, TournamentTeam? home, TournamentTeam? away)
      onEditMatch;

  @override
  ConsumerState<TournamentScheduleTab> createState() =>
      _TournamentScheduleTabState();
}

class _TournamentScheduleTabState extends ConsumerState<TournamentScheduleTab> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  int? _teamFilterId;
  String? _teamFilterLabel;
  int? _venueFilterId;
  String? _venueFilterLabel;
  DateTime? _dateFilter;

  Tournament get tournament => widget.tournament;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool get _hasFilters =>
      _searchQuery.isNotEmpty ||
      _teamFilterId != null ||
      _venueFilterId != null ||
      _dateFilter != null;

  void _clearFilters() {
    setState(() {
      _searchCtrl.clear();
      _searchQuery = '';
      _teamFilterId = null;
      _teamFilterLabel = null;
      _venueFilterId = null;
      _venueFilterLabel = null;
      _dateFilter = null;
    });
  }

  bool _matchesFilters(
    Match match, {
    required Map<int, TournamentTeam> teamsById,
  }) {
    if (_searchQuery.isNotEmpty) {
      final home = match.homeTeamId == null
          ? 'tbd'
          : (teamsById[match.homeTeamId!]?.displayName ?? '').toLowerCase();
      final away = match.awayTeamId == null
          ? 'tbd'
          : (teamsById[match.awayTeamId!]?.displayName ?? '').toLowerCase();
      final location = (match.location ?? '').toLowerCase();
      final haystack = '$home $away $location round ${match.round}';
      if (!haystack.contains(_searchQuery)) return false;
    }

    if (_teamFilterId != null) {
      final tid = _teamFilterId!;
      if (match.homeTeamId != tid && match.awayTeamId != tid) return false;
    }

    if (_venueFilterId != null) {
      final effective =
          match.venueId ?? teamsById[match.homeTeamId]?.homeVenueId;
      if (effective != _venueFilterId) return false;
    }

    if (_dateFilter != null) {
      final kickoff = match.scheduledAt;
      if (kickoff == null) return false;
      final local = kickoff.toLocal();
      final day = DateTime(local.year, local.month, local.day);
      if (day != _dateFilter) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (tournament.status == TournamentStatus.draft) {
      return const EmptyState(
        icon: Icons.event_outlined,
        title: 'Schedule unavailable',
        message: 'Start the tournament to assign kickoff times.',
      );
    }

    final matchesAsync = ref.watch(matchesProvider(tournament.id));
    final teamsAsync = ref.watch(tournamentTeamsProvider(tournament.id));
    final manager = ref.watch(viewerProvider).isManager;
    final focusTeamId =
        manager ? null : ref.watch(viewerProvider).familyTeamId;
    final familyView = ref.watch(familyViewForTournamentProvider(tournament.id));

    return matchesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(friendlyErrorMessage(e))),
      data: (matches) {
        final teamsById = {
          for (final t in teamsAsync.value ?? const <TournamentTeam>[])
            t.teamId: t,
        };
        final playable =
            matches.where((m) => m.status != MatchStatus.bye).toList();
        final filtered = playable
            .where((m) => _matchesFilters(m, teamsById: teamsById))
            .toList();
        final scheduled = filtered.where((m) => m.scheduledAt != null).toList()
          ..sort((a, b) => a.scheduledAt!.compareTo(b.scheduledAt!));
        final unscheduled =
            filtered.where((m) => m.scheduledAt == null).toList()
              ..sort((a, b) {
                final byRound = a.round.compareTo(b.round);
                if (byRound != 0) return byRound;
                return a.id.compareTo(b.id);
              });

        final teamOptions = teamsById.values.toList()
          ..sort(
            (a, b) => a.displayName.toLowerCase().compareTo(
                  b.displayName.toLowerCase(),
                ),
          );

        // Build a flat item list for ListView.builder.
        final items = <_ScheduleListItem>[];
        void addGroup(
          List<Match> groupScheduled,
          List<Match> groupUnscheduled, {
          String? banner,
        }) {
          if (groupScheduled.isEmpty && groupUnscheduled.isEmpty) return;
          if (banner != null) items.add(_ScheduleListItem.header(banner));
          final grouped = <DateTime, List<Match>>{};
          for (final m in groupScheduled) {
            final local = m.scheduledAt!.toLocal();
            final day = DateTime(local.year, local.month, local.day);
            grouped.putIfAbsent(day, () => []).add(m);
          }
          final groupDays = grouped.keys.toList()..sort();
          for (final day in groupDays) {
            items.add(_ScheduleListItem.header(formatScheduleDay(day)));
            for (final match in grouped[day]!) {
              items.add(_ScheduleListItem.match(match));
            }
          }
          if (groupUnscheduled.isNotEmpty) {
            items.add(
              _ScheduleListItem.header(
                'Unscheduled (${groupUnscheduled.length})',
              ),
            );
            for (final match in groupUnscheduled) {
              items.add(_ScheduleListItem.match(match));
            }
          }
        }

        if (scheduled.isEmpty && unscheduled.isNotEmpty && manager) {
          items.add(const _ScheduleListItem.hint());
        }
        if (focusTeamId == null) {
          addGroup(scheduled, unscheduled);
        } else {
          bool mine(Match m) =>
              m.homeTeamId == focusTeamId || m.awayTeamId == focusTeamId;
          final yourScheduled = scheduled.where(mine).toList();
          final yourUnscheduled = unscheduled.where(mine).toList();
          addGroup(yourScheduled, yourUnscheduled, banner: 'Your games');
          addGroup(
            scheduled.where((m) => !mine(m)).toList(),
            unscheduled.where((m) => !mine(m)).toList(),
            banner: 'Other games',
          );
        }

        final allScheduled =
            playable.where((m) => m.scheduledAt != null).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (manager)
                    FilledButton.tonalIcon(
                      onPressed: playable.isEmpty
                          ? null
                          : () => _bulkAssign(context, playable),
                      icon: const Icon(Icons.schedule, size: 18),
                      label: const Text('Schedule'),
                    ),
                  OutlinedButton.icon(
                    onPressed: allScheduled.isEmpty
                        ? null
                        : () => _exportIcs(
                              context,
                              tournament: tournament,
                              matches: matches,
                              teamsById: teamsById,
                            ),
                    icon: const Icon(Icons.calendar_month_outlined, size: 18),
                    label: const Text('Export calendar'),
                  ),
                  if (manager || familyView.showVenues)
                  OutlinedButton.icon(
                    onPressed: () => showVenueOverviewSheet(
                      context,
                      ref,
                      title: 'Tournament venues',
                      tournamentIds: [tournament.id],
                    ),
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('Venues map'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search teams, venues…',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                          icon: const Icon(Icons.clear, size: 18),
                        ),
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (v) =>
                    setState(() => _searchQuery = v.trim().toLowerCase()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: Text(_teamFilterLabel ?? 'Team'),
                      selected: _teamFilterId != null,
                      onSelected: (selected) {
                        if (!selected) {
                          setState(() {
                            _teamFilterId = null;
                            _teamFilterLabel = null;
                          });
                          return;
                        }
                        _pickTeamFilter(teamOptions);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(_venueFilterLabel ?? 'Venue'),
                      selected: _venueFilterId != null,
                      onSelected: (selected) {
                        if (!selected) {
                          setState(() {
                            _venueFilterId = null;
                            _venueFilterLabel = null;
                          });
                          return;
                        }
                        _pickVenueFilter(playable);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(
                        _dateFilter == null
                            ? 'Date'
                            : formatScheduleDay(_dateFilter!),
                      ),
                      selected: _dateFilter != null,
                      onSelected: (selected) {
                        if (!selected) {
                          setState(() => _dateFilter = null);
                          return;
                        }
                        _pickDateFilter();
                      },
                    ),
                    if (_hasFilters) ...[
                      const SizedBox(width: 8),
                      ActionChip(
                        avatar: const Icon(Icons.filter_alt_off, size: 16),
                        label: const Text('Clear'),
                        onPressed: _clearFilters,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Expanded(
              child: playable.isEmpty
                  ? const EmptyState(
                      icon: Icons.event_busy_outlined,
                      title: 'No fixtures yet',
                      message: 'Matches will appear here once generated.',
                    )
                  : filtered.isEmpty
                      ? EmptyState(
                          icon: Icons.filter_alt_off_outlined,
                          title: 'No matches match filters',
                          message:
                              'Try a different team, venue, date, or search.',
                          action: TextButton(
                            onPressed: _clearFilters,
                            child: const Text('Clear filters'),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            switch (item.kind) {
                              case _ScheduleItemKind.hint:
                                return const Padding(
                                  padding: EdgeInsets.fromLTRB(4, 8, 4, 16),
                                  child: Text(
                                    'No kickoff times yet. Use Schedule to '
                                    'assign dates and times by round or all at once.',
                                  ),
                                );
                              case _ScheduleItemKind.header:
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    4,
                                    index == 0 ? 8 : 16,
                                    4,
                                    8,
                                  ),
                                  child: Text(
                                    item.header!,
                                    style: TourneezText.section,
                                  ),
                                );
                              case _ScheduleItemKind.match:
                                final match = item.match!;
                                return _ScheduleMatchTile(
                                  match: match,
                                  home: match.homeTeamId == null
                                      ? null
                                      : teamsById[match.homeTeamId!],
                                  away: match.awayTeamId == null
                                      ? null
                                      : teamsById[match.awayTeamId!],
                                  onTap: () => widget.onEditMatch(
                                        match,
                                        match.homeTeamId == null
                                            ? null
                                            : teamsById[match.homeTeamId!],
                                        match.awayTeamId == null
                                            ? null
                                            : teamsById[match.awayTeamId!],
                                      ),
                                );
                            }
                          },
                        ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickTeamFilter(List<TournamentTeam> teams) async {
    final picked = await showDialog<Object?>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Filter by team'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Any team'),
          ),
          for (final t in teams)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, t),
              child: Text(t.displayName),
            ),
        ],
      ),
    );
    if (!mounted || picked == null) return;
    setState(() {
      if (picked is TournamentTeam) {
        _teamFilterId = picked.teamId;
        _teamFilterLabel = picked.displayName;
      } else {
        _teamFilterId = null;
        _teamFilterLabel = null;
      }
    });
  }

  Future<void> _pickVenueFilter(List<Match> playable) async {
    final venues = await ref.read(venuesProvider.future);
    if (!mounted) return;
    final byId = {for (final v in venues) v.id: v};
    final teams =
        ref.read(tournamentTeamsProvider(widget.tournament.id)).asData?.value ??
            const <TournamentTeam>[];
    final byTeam = {for (final t in teams) t.teamId: t};
    final usedIds = {
      for (final m in playable)
        if ((m.venueId ?? byTeam[m.homeTeamId]?.homeVenueId) != null)
          m.venueId ?? byTeam[m.homeTeamId]!.homeVenueId!,
    };
    final options = usedIds.map((id) => byId[id]).whereType<Venue>().toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    final picked = await showDialog<Object?>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Filter by venue'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Any venue'),
          ),
          if (options.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Text('No venues assigned to matches yet.'),
            )
          else
            for (final v in options)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, v),
                child: Text(v.name),
              ),
        ],
      ),
    );
    if (!mounted || picked == null) return;
    setState(() {
      if (picked is Venue) {
        _venueFilterId = picked.id;
        _venueFilterLabel = picked.name;
      } else {
        _venueFilterId = null;
        _venueFilterLabel = null;
      }
    });
  }

  Future<void> _pickDateFilter() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateFilter ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (!mounted || picked == null) return;
    setState(() {
      _dateFilter = DateTime(picked.year, picked.month, picked.day);
    });
  }

  Future<void> _bulkAssign(
    BuildContext context,
    List<Match> playable,
  ) async {
    final rounds = playable.map((m) => m.round).toSet().toList()..sort();
    var mode = _ScheduleMode.singleRound;
    var selectedRound = rounds.first;
    var cadence = _RoundCadence.weekly;
    var date = DateTime.now();
    var time = const TimeOfDay(hour: 9, minute: 0);
    var duration = defaultMatchDurationMinutes;
    var gap = 0;
    var useHomeVenue = true;
    final durationCtrl =
        TextEditingController(text: '$defaultMatchDurationMinutes');
    final gapCtrl = TextEditingController(text: '0');

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => keyboardAware(
        context: ctx,
        child: StatefulBuilder(
          builder: (ctx, setLocal) {
            return AlertDialog(
              title: const Text('Schedule matches'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<_ScheduleMode>(
                      segments: const [
                        ButtonSegment(
                          value: _ScheduleMode.singleRound,
                          label: Text('One round'),
                          icon: Icon(Icons.looks_one_outlined, size: 16),
                        ),
                        ButtonSegment(
                          value: _ScheduleMode.allRounds,
                          label: Text('All rounds'),
                          icon: Icon(Icons.view_week_outlined, size: 16),
                        ),
                      ],
                      selected: {mode},
                      onSelectionChanged: (s) {
                        setLocal(() => mode = s.first);
                      },
                    ),
                    const SizedBox(height: 12),
                    if (mode == _ScheduleMode.singleRound)
                      InputDecorator(
                        decoration: const InputDecoration(labelText: 'Round'),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: selectedRound,
                            isExpanded: true,
                            items: [
                              for (final r in rounds)
                                DropdownMenuItem(
                                  value: r,
                                  child: Text('Round $r'),
                                ),
                            ],
                            onChanged: (v) {
                              if (v == null) return;
                              setLocal(() => selectedRound = v);
                            },
                          ),
                        ),
                      )
                    else
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Round spacing',
                          helperText:
                              'Each round starts on a new day after the previous',
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<_RoundCadence>(
                            value: cadence,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                value: _RoundCadence.daily,
                                child: Text('Daily (every day)'),
                              ),
                              DropdownMenuItem(
                                value: _RoundCadence.weekly,
                                child: Text('Weekly (every 7 days)'),
                              ),
                            ],
                            onChanged: (v) {
                              if (v == null) return;
                              setLocal(() => cadence = v);
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        mode == _ScheduleMode.allRounds
                            ? 'First round date'
                            : 'Date',
                      ),
                      subtitle: Text(formatScheduleDay(date)),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setLocal(() => date = picked);
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('First kickoff'),
                      subtitle: Text(time.format(ctx)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: ctx,
                          initialTime: time,
                        );
                        if (picked != null) {
                          setLocal(() => time = picked);
                        }
                      },
                    ),
                    TextField(
                      controller: durationCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Match length (minutes)',
                        helperText: 'Used for calendar end time and spacing',
                      ),
                      onChanged: (v) {
                        duration = int.tryParse(v.trim()) ??
                            defaultMatchDurationMinutes;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: gapCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Gap between games (minutes)',
                        helperText: 'Extra rest after each match ends',
                      ),
                      onChanged: (v) {
                        gap = int.tryParse(v.trim()) ?? 0;
                      },
                    ),
                    const SizedBox(height: 4),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Use home team venue'),
                      subtitle: const Text(
                        'Assign each match to the home team\'s venue when set',
                      ),
                      value: useHomeVenue,
                      onChanged: (v) => setLocal(() => useHomeVenue = v),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                if (mode == _ScheduleMode.singleRound)
                  TextButton(
                    onPressed: () async {
                      await ref.read(repositoryProvider).clearRoundSchedule(
                            tournamentId: tournament.id,
                            round: selectedRound,
                          );
                      if (ctx.mounted) Navigator.pop(ctx, false);
                    },
                    child: const Text('Clear round'),
                  ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        ),
      ),
    );

    durationCtrl.dispose();
    gapCtrl.dispose();
    if (ok != true || !context.mounted) return;

    showAppSnackBar('Scheduling…');

    final firstKickoff = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    final repo = ref.read(repositoryProvider);
    final String? err;
    final String success;
    if (mode == _ScheduleMode.allRounds) {
      err = await repo.scheduleAllRoundsKickoffs(
        tournamentId: tournament.id,
        firstKickoff: firstKickoff,
        daysBetweenRounds: cadence.days,
        gapMinutes: gap.clamp(0, 24 * 60),
        durationMinutes: duration.clamp(1, 24 * 60),
        useHomeTeamVenue: useHomeVenue,
      );
      success = cadence == _RoundCadence.daily
          ? 'All rounds scheduled daily'
          : 'All rounds scheduled weekly';
    } else {
      err = await repo.scheduleRoundKickoffs(
        tournamentId: tournament.id,
        round: selectedRound,
        firstKickoff: firstKickoff,
        gapMinutes: gap.clamp(0, 24 * 60),
        durationMinutes: duration.clamp(1, 24 * 60),
        useHomeTeamVenue: useHomeVenue,
      );
      success = 'Round $selectedRound scheduled';
    }
    if (!context.mounted) return;
    showAppSnackBar(err ?? success);
  }

  Future<void> _exportIcs(
    BuildContext context, {
    required Tournament tournament,
    required List<Match> matches,
    required Map<int, TournamentTeam> teamsById,
  }) async {
    try {
      final ics = buildTournamentIcs(
        tournament: tournament,
        matches: matches,
        teamsById: teamsById,
      );
      final bytes = Uint8List.fromList(utf8.encode(ics));
      final stamp = DateTime.now()
          .toUtc()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final safeName = tournament.name
          .replaceAll(RegExp(r'[^\w\-]+'), '_')
          .clampLength(40);
      final fileName = 'tourneez-$safeName-$stamp.ics';

      final useShare = !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS);
      if (useShare) {
        await SharePlus.instance.share(
          ShareParams(
            files: [
              XFile.fromData(
                bytes,
                mimeType: 'text/calendar',
                name: fileName,
              ),
            ],
            subject: '${tournament.name} schedule',
          ),
        );
      } else {
        final saved = await FilePicker.saveFile(
          dialogTitle: 'Export calendar',
          fileName: fileName,
          bytes: bytes,
          type: FileType.custom,
          allowedExtensions: const ['ics'],
          mimeType: 'text/calendar',
        );
        if (saved == null) return;
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calendar exported')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(e))),
      );
    }
  }
}

enum _ScheduleMode { singleRound, allRounds }

enum _RoundCadence {
  daily(1),
  weekly(7);

  const _RoundCadence(this.days);
  final int days;
}

enum _ScheduleItemKind { hint, header, match }

class _ScheduleListItem {
  const _ScheduleListItem.hint()
      : kind = _ScheduleItemKind.hint,
        header = null,
        match = null;

  const _ScheduleListItem.header(this.header)
      : kind = _ScheduleItemKind.header,
        match = null;

  const _ScheduleListItem.match(this.match)
      : kind = _ScheduleItemKind.match,
        header = null;

  final _ScheduleItemKind kind;
  final String? header;
  final Match? match;
}

extension on String {
  String clampLength(int max) => length <= max ? this : substring(0, max);
}

class _ScheduleMatchTile extends StatelessWidget {
  const _ScheduleMatchTile({
    required this.match,
    required this.home,
    required this.away,
    this.onTap,
  });

  final Match match;
  final TournamentTeam? home;
  final TournamentTeam? away;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final kickoff = match.scheduledAt;
    final place = (match.location != null && match.location!.trim().isNotEmpty)
        ? match.location!.trim()
        : home?.homeLocation?.trim();
    final subtitle = [
      if (kickoff != null) formatMatchKickoff(kickoff),
      'Round ${match.round}',
      if (place != null && place.isNotEmpty) place,
    ].join(' · ');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          kickoff == null ? Icons.event_busy_outlined : Icons.event_available,
          color: kickoff == null ? scheme.outline : scheme.primary,
        ),
        title: Text(
          '${home?.displayName ?? 'TBD'} vs ${away?.displayName ?? 'TBD'}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: match.isCompleted
            ? Text(
                '${match.homeScore ?? 0}–${match.awayScore ?? 0}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              )
            : const Icon(Icons.chevron_right),
      ),
    );
  }
}
