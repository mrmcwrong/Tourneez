import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tourneez/domain/match_odds.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/domain/schedule_format.dart';
import 'package:tourneez/domain/series_score.dart';
import 'package:tourneez/domain/venue_maps.dart';
import 'package:tourneez/features/tournament/bracket_view.dart';
import 'package:tourneez/features/tournament/tournament_schedule_tab.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/ui/format_config_editor.dart';
import 'package:tourneez/ui/theme.dart';
import 'package:tourneez/ui/team_editor.dart';
import 'package:tourneez/ui/venue_editor.dart';
import 'package:tourneez/ui/venue_overview.dart';
import 'package:tourneez/ui/widgets.dart';

class TournamentHubScreen extends ConsumerStatefulWidget {
  const TournamentHubScreen({super.key, required this.tournamentId});

  final int tournamentId;

  @override
  ConsumerState<TournamentHubScreen> createState() =>
      _TournamentHubScreenState();
}

class _TournamentHubScreenState extends ConsumerState<TournamentHubScreen> {
  bool _randomizing = false;
  bool _showBracket = false;
  bool _simplifiedView = false;

  List<_HubTab> _tabsFor(Tournament tournament) {
    final tabs = <_HubTab>[
      const _HubTab('Matches', Icons.sports_soccer),
      const _HubTab('Schedule', Icons.event_outlined),
    ];
    if (tournament.format.showsStandings) {
      tabs.add(const _HubTab('Standings', Icons.table_chart_outlined));
    }
    tabs
      ..add(const _HubTab('Teams', Icons.groups_outlined))
      ..add(const _HubTab('Settings', Icons.settings_outlined));
    return tabs;
  }

  Future<void> _editScore(
    Match match,
    TournamentTeam? home,
    TournamentTeam? away,
  ) async {
    // Resolve series length from match data or tournament config.
    var series = match.series;
    if (series == null || series.length <= 1) {
      final tournament =
          ref.read(tournamentProvider(match.tournamentId)).asData?.value;
      if (tournament != null) {
        final len = tournament.config.seriesLengthForMatch(
          stage: match.stage,
          groupLabel: match.groupLabel,
          winnerAdvancesTo: match.winnerAdvancesTo,
        );
        if (len > 1) series = SeriesScore.empty(len);
      }
    }

    if (series != null && series.length > 1) {
      await _editSeriesScore(match, home, away, series);
      return;
    }

    final homeCtrl = TextEditingController(
      text: match.homeScore?.toString() ?? '0',
    );
    final awayCtrl = TextEditingController(
      text: match.awayScore?.toString() ?? '0',
    );
    final locationCtrl = TextEditingController(text: match.location ?? '');
    final durationCtrl = TextEditingController(
      text: '${match.durationMinutes ?? defaultMatchDurationMinutes}',
    );
    DateTime? scheduledAt = match.scheduledAt;
    int? selectedVenueId = match.venueId;
    String? venueLabel;
    if (selectedVenueId != null) {
      final venues = await ref.read(venuesProvider.future);
      final venue = venues.where((v) => v.id == selectedVenueId).firstOrNull;
      if (venue != null) {
        final parent = venue.parentVenueId == null
            ? null
            : venues.where((v) => v.id == venue.parentVenueId).firstOrNull;
        venueLabel = venueDisplayLabel(venue, parent: parent);
      }
    }
    var swapped = false;
    var currentHome = home;
    var currentAway = away;

    if (!mounted) return;
    final result = await showDialog<Object>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            final odds = computeMatchOdds(
              homePower: currentHome?.powerRating ?? 50,
              awayPower: currentAway?.powerRating ?? 50,
              allowDraw: !match.isBracketMatch,
            );
            return keyboardAware(
              context: ctx,
              child: AlertDialog(
              title: Text(match.isCompleted ? 'Edit match' : 'Enter score'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      odds.summary,
                      style: Theme.of(ctx).textTheme.labelMedium?.copyWith(
                        color: Theme.of(
                          ctx,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PWR ${currentHome?.powerRating ?? 50} vs ${currentAway?.powerRating ?? 50}',
                      style: Theme.of(ctx).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: homeCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText:
                                  '${currentHome?.displayName ?? 'Home'} (H)',
                            ),
                            autofocus: true,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('–'),
                        ),
                        Expanded(
                          child: TextField(
                            controller: awayCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText:
                                  '${currentAway?.displayName ?? 'Away'} (A)',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          final tmpScore = homeCtrl.text;
                          homeCtrl.text = awayCtrl.text;
                          awayCtrl.text = tmpScore;
                          setLocal(() {
                            swapped = !swapped;
                            final tmp = currentHome;
                            currentHome = currentAway;
                            currentAway = tmp;
                          });
                        },
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        label: const Text('Swap home / away'),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.place_outlined),
                      title: const Text('Venue'),
                      subtitle: Text(
                        venueLabel ??
                            (selectedVenueId == null
                                ? 'Not assigned'
                                : 'Venue #$selectedVenueId'),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final picked = await showVenuePickerSheet(
                          ctx,
                          ref,
                          selectedId: selectedVenueId,
                        );
                        if (!ctx.mounted) return;
                        if (picked == false) {
                          setLocal(() {
                            selectedVenueId = null;
                            venueLabel = null;
                          });
                          return;
                        }
                        if (picked is! Venue) return;
                        final venues = await ref.read(venuesProvider.future);
                        Venue? parent;
                        if (picked.parentVenueId != null) {
                          parent = venues
                              .where((v) => v.id == picked.parentVenueId)
                              .firstOrNull;
                        }
                        if (!ctx.mounted) return;
                        setLocal(() {
                          selectedVenueId = picked.id;
                          venueLabel =
                              venueDisplayLabel(picked, parent: parent);
                          locationCtrl.text =
                              venueLocationText(picked, parent: parent);
                        });
                      },
                    ),
                    TextField(
                      controller: locationCtrl,
                      decoration: InputDecoration(
                        labelText: 'Location text',
                        hintText: currentHome?.homeLocation ?? 'Venue',
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Kickoff'),
                      subtitle: Text(
                        scheduledAt == null
                            ? 'Not scheduled'
                            : formatMatchKickoff(scheduledAt!),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (scheduledAt != null)
                            IconButton(
                              tooltip: 'Clear kickoff',
                              onPressed: () =>
                                  setLocal(() => scheduledAt = null),
                              icon: const Icon(Icons.clear),
                            ),
                          IconButton(
                            tooltip: 'Pick date & time',
                            onPressed: () async {
                              final now = DateTime.now();
                              final initial = scheduledAt ?? now;
                              final date = await showDatePicker(
                                context: ctx,
                                initialDate: initial,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (date == null || !ctx.mounted) return;
                              final time = await showTimePicker(
                                context: ctx,
                                initialTime: TimeOfDay.fromDateTime(initial),
                              );
                              if (time == null) return;
                              setLocal(() {
                                scheduledAt = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                            },
                            icon: const Icon(Icons.event_outlined),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: durationCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Duration (minutes)',
                        hintText: '90',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(ctx, 'simulate'),
                  icon: const Icon(Icons.casino_outlined, size: 18),
                  label: const Text('Simulate'),
                ),
                FilledButton(
                  onPressed: () {
                    final h = int.tryParse(homeCtrl.text.trim());
                    final a = int.tryParse(awayCtrl.text.trim());
                    if (h == null || a == null) return;
                    final duration =
                        int.tryParse(durationCtrl.text.trim()) ??
                            defaultMatchDurationMinutes;
                    Navigator.pop(ctx, (
                      scores: (h, a),
                      swap: swapped,
                      location: locationCtrl.text,
                      scheduledAt: scheduledAt,
                      durationMinutes: duration.clamp(1, 24 * 60),
                      venueId: selectedVenueId,
                    ));
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
            );
          },
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeCtrl.dispose();
      awayCtrl.dispose();
      locationCtrl.dispose();
      durationCtrl.dispose();
    });
    if (result == null) return;

    final repo = ref.read(repositoryProvider);

    if (result == 'simulate') {
      final err = await repo.randomizeMatchResult(match.id);
      if (mounted && err != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err)));
      }
      return;
    }

    if (result
        is ({
          (int, int) scores,
          bool swap,
          String location,
          DateTime? scheduledAt,
          int durationMinutes,
          int? venueId,
        })) {
      if (result.venueId != null && result.scheduledAt != null) {
        final warning = await repo.venueConflictWarning(
          venueId: result.venueId!,
          kickoff: result.scheduledAt!,
          durationMinutes: result.durationMinutes,
          ignoreMatchId: match.id,
        );
        if (warning != null && mounted) {
          final proceed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Possible venue conflict'),
              content: Text(warning),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Save anyway'),
                ),
              ],
            ),
          );
          if (proceed != true) return;
        }
      }
      final detailErr = await repo.updateMatchDetails(
        matchId: match.id,
        swapHomeAway: result.swap,
        location: result.location,
        clearLocation: result.location.trim().isEmpty,
        scheduledAt: result.scheduledAt,
        clearScheduledAt: result.scheduledAt == null,
        durationMinutes: result.durationMinutes,
        venueId: result.venueId,
        clearVenue: result.venueId == null,
      );
      if (detailErr != null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(detailErr)));
        }
        return;
      }
      final err = await repo.recordScore(
        matchId: match.id,
        homeScore: result.scores.$1,
        awayScore: result.scores.$2,
      );
      if (mounted && err != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err)));
      }
    }
  }

  Future<void> _editSeriesScore(
    Match match,
    TournamentTeam? home,
    TournamentTeam? away,
    SeriesScore series,
  ) async {
    final homeName = home?.displayName ?? 'Home';
    final awayName = away?.displayName ?? 'Away';
    final maxLegs = series.maxLegs;

    final homeCtrls = <TextEditingController>[
      for (var i = 0; i < maxLegs; i++)
        TextEditingController(
          text: i < series.legs.length ? '${series.legs[i].home}' : '',
        ),
    ];
    final awayCtrls = <TextEditingController>[
      for (var i = 0; i < maxLegs; i++)
        TextEditingController(
          text: i < series.legs.length ? '${series.legs[i].away}' : '',
        ),
    ];

    /// Index of the first game that should be greyed out (series already won).
    int? firstUnnecessaryGame() {
      final filled = <({int home, int away})>[];
      for (var i = 0; i < maxLegs; i++) {
        final probe = SeriesScore(length: series.length, legs: filled);
        if (probe.isDecided) return i;
        final ht = homeCtrls[i].text.trim();
        final at = awayCtrls[i].text.trim();
        if (ht.isEmpty && at.isEmpty) return null;
        final h = int.tryParse(ht);
        final a = int.tryParse(at);
        if (h == null || a == null) return null;
        filled.add((home: h, away: a));
      }
      final probe = SeriesScore(length: series.length, legs: filled);
      return probe.isDecided ? filled.length : null;
    }

    final result = await showDialog<Object>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            final label = series.length == 2
                ? 'Two-leg series'
                : 'Best of ${series.length}';
            final lockedFrom = firstUnnecessaryGame();
            final scheme = Theme.of(ctx).colorScheme;
            return keyboardAware(
              context: ctx,
              child: AlertDialog(
              title: Text(label),
              content: SizedBox(
                width: (MediaQuery.sizeOf(ctx).width - 48).clamp(240.0, 360.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '$homeName vs $awayName',
                        style: Theme.of(ctx).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        series.length == 2
                            ? 'Enter both legs. Aggregate score decides the series.'
                            : 'All $maxLegs games are listed. Once a side has '
                                'enough wins, remaining games are locked.',
                        style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.65),
                            ),
                      ),
                      const SizedBox(height: 12),
                      for (var i = 0; i < maxLegs; i++) ...[
                        Builder(
                          builder: (_) {
                            final locked =
                                lockedFrom != null && i >= lockedFrom;
                            final muted = locked
                                ? scheme.onSurface.withValues(alpha: 0.38)
                                : null;
                            return Opacity(
                              opacity: locked ? 0.45 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    locked
                                        ? 'Game ${i + 1} (not needed)'
                                        : 'Game ${i + 1}',
                                    style: Theme.of(ctx)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: muted,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: homeCtrls[i],
                                          enabled: !locked,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: homeName,
                                          ),
                                          onChanged: (_) => setLocal(() {
                                            final lock = firstUnnecessaryGame();
                                            if (lock == null) return;
                                            for (var j = lock;
                                                j < maxLegs;
                                                j++) {
                                              if (homeCtrls[j]
                                                      .text
                                                      .isNotEmpty ||
                                                  awayCtrls[j]
                                                      .text
                                                      .isNotEmpty) {
                                                homeCtrls[j].clear();
                                                awayCtrls[j].clear();
                                              }
                                            }
                                          }),
                                          autofocus: !locked &&
                                              i ==
                                                  (series.legs.length < maxLegs
                                                      ? series.legs.length
                                                      : maxLegs - 1),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text('–'),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: awayCtrls[i],
                                          enabled: !locked,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: awayName,
                                          ),
                                          onChanged: (_) => setLocal(() {
                                            final lock = firstUnnecessaryGame();
                                            if (lock == null) return;
                                            for (var j = lock;
                                                j < maxLegs;
                                                j++) {
                                              if (homeCtrls[j]
                                                      .text
                                                      .isNotEmpty ||
                                                  awayCtrls[j]
                                                      .text
                                                      .isNotEmpty) {
                                                homeCtrls[j].clear();
                                                awayCtrls[j].clear();
                                              }
                                            }
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(ctx, 'simulate'),
                  icon: const Icon(Icons.casino_outlined, size: 18),
                  label: const Text('Simulate'),
                ),
                FilledButton(
                  onPressed: () {
                    final legs = <({int home, int away})>[];
                    final lockAt = firstUnnecessaryGame();
                    for (var i = 0; i < maxLegs; i++) {
                      if (lockAt != null && i >= lockAt) break;
                      final ht = homeCtrls[i].text.trim();
                      final at = awayCtrls[i].text.trim();
                      if (ht.isEmpty && at.isEmpty) break;
                      final h = int.tryParse(ht);
                      final a = int.tryParse(at);
                      if (h == null || a == null) return;
                      legs.add((home: h, away: a));
                    }
                    Navigator.pop(ctx, legs);
                  },
                  child: const Text('Save series'),
                ),
              ],
            ),
            );
          },
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final c in homeCtrls) {
        c.dispose();
      }
      for (final c in awayCtrls) {
        c.dispose();
      }
    });
    if (result == null) return;

    final repo = ref.read(repositoryProvider);
    if (result == 'simulate') {
      final err = await repo.randomizeMatchResult(match.id);
      if (mounted && err != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err)));
      }
      return;
    }

    if (result is List<({int home, int away})>) {
      final err = await repo.setSeriesLegs(matchId: match.id, legs: result);
      if (mounted && err != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err)));
      }
    }
  }

  Future<void> _simulateMatch(Match match) async {
    final err = await ref
        .read(repositoryProvider)
        .randomizeMatchResult(match.id);
    if (mounted && err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  Future<void> _randomize(Tournament tournament) async {
    if (_randomizing) return;
    setState(() => _randomizing = true);
    try {
      final n = await ref
          .read(repositoryProvider)
          .randomizePendingResults(tournament.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              n == 0
                  ? 'No pending matches ready to fill.'
                  : 'Randomized $n match${n == 1 ? '' : 'es'}.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _randomizing = false);
    }
  }

  Future<void> _offerResetScores(Tournament tournament) async {
    if (tournament.status != TournamentStatus.completed &&
        tournament.status != TournamentStatus.active) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset all scores?'),
        content: Text(
          tournament.status == TournamentStatus.completed
              ? 'Clear every score in “${tournament.name}”, undo career '
                  'stats from completion, and restart fixtures from round one. '
                  'This cannot be undone.'
              : 'Clear every score in “${tournament.name}” and restart '
                  'fixtures from round one. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset scores'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final err = await ref
        .read(repositoryProvider)
        .resetTournamentScores(tournament.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(err ?? 'All scores reset')),
    );
  }

  void _goBack([Tournament? tournament]) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    final leagueId = tournament?.leagueId;
    if (leagueId != null) {
      context.go('/league/$leagueId');
      return;
    }
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final tournamentAsync = ref.watch(tournamentProvider(widget.tournamentId));

    return tournamentAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goBack,
          ),
        ),
        body: EmptyState(
          icon: Icons.error_outline,
          title: 'Tournament not found',
          message: friendlyErrorMessage(e),
        ),
      ),
      data: (tournament) {
        if (tournament == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goBack,
              ),
            ),
            body: const EmptyState(
              icon: Icons.search_off,
              title: 'Tournament not found',
              message: 'It may have been deleted.',
            ),
          );
        }

        final tabs = _tabsFor(tournament);

        return DefaultTabController(
          key: ValueKey('${tournament.format.name}-${tabs.length}'),
          length: tabs.length,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back',
                onPressed: () => _goBack(tournament),
              ),
              title: Text(tournament.name),
              actions: [
                if (tournament.status != TournamentStatus.draft)
                  IconButton(
                    tooltip: 'Venues on map',
                    onPressed: () => showVenueOverviewSheet(
                      context,
                      ref,
                      title: 'Tournament venues',
                      tournamentIds: [tournament.id],
                    ),
                    icon: const Icon(Icons.map_outlined),
                  ),
                if (tournament.status == TournamentStatus.active)
                  IconButton(
                    tooltip: 'Simulate all pending by power',
                    onPressed: _randomizing
                        ? null
                        : () => _randomize(tournament),
                    icon: _randomizing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.casino_outlined),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(
                    child: StatusChip(
                      status: tournament.status,
                      onTap:
                          tournament.status == TournamentStatus.completed ||
                              tournament.status == TournamentStatus.active
                          ? () => _offerResetScores(tournament)
                          : null,
                    ),
                  ),
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  for (final t in tabs)
                    Tab(text: t.label, icon: Icon(t.icon, size: 18)),
                ],
              ),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final tab in tabs)
                  switch (tab.label) {
                    'Matches' => _MatchesTab(
                      tournament: tournament,
                      showBracket: _showBracket,
                      simplifiedView: _simplifiedView,
                      onToggleView: tournament.format.hasBracketView
                          ? (bracket) => setState(() => _showBracket = bracket)
                          : null,
                      onToggleSimplified: (v) =>
                          setState(() => _simplifiedView = v),
                      onEditScore: _editScore,
                      onSimulate: tournament.status == TournamentStatus.active
                          ? _simulateMatch
                          : null,
                    ),
                    'Schedule' => TournamentScheduleTab(
                      tournament: tournament,
                      onEditMatch: _editScore,
                    ),
                    'Standings' => _StandingsTab(tournament: tournament),
                    'Teams' => _TeamsTab(
                      tournamentId: widget.tournamentId,
                      isDraft: tournament.status == TournamentStatus.draft,
                    ),
                    'Settings' => _SettingsTab(
                      tournament: tournament,
                      onRandomize: () => _randomize(tournament),
                      randomizing: _randomizing,
                    ),
                    _ => const SizedBox.shrink(),
                  },
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HubTab {
  const _HubTab(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _MatchesTab extends ConsumerWidget {
  const _MatchesTab({
    required this.tournament,
    required this.showBracket,
    required this.simplifiedView,
    required this.onEditScore,
    required this.onToggleSimplified,
    this.onToggleView,
    this.onSimulate,
  });

  final Tournament tournament;
  final bool showBracket;
  final bool simplifiedView;
  final ValueChanged<bool>? onToggleView;
  final ValueChanged<bool> onToggleSimplified;
  final void Function(Match match, TournamentTeam? home, TournamentTeam? away)
  onEditScore;
  final Future<void> Function(Match match)? onSimulate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesProvider(tournament.id));
    final teamsAsync = ref.watch(tournamentTeamsProvider(tournament.id));

    if (tournament.status == TournamentStatus.draft) {
      return EmptyState(
        icon: Icons.play_circle_outline,
        title: 'Not started yet',
        message:
            'Add teams on the Teams tab, then start the tournament to generate fixtures.',
        action: FilledButton(
          onPressed: () async {
            final err = await ref
                .read(repositoryProvider)
                .startTournament(tournament.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(err ?? 'Tournament started')),
              );
            }
          },
          child: const Text('Start tournament'),
        ),
      );
    }

    return matchesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(friendlyErrorMessage(e))),
      data: (matches) {
        final teams = {
          for (final t in teamsAsync.value ?? <TournamentTeam>[]) t.teamId: t,
        };

        if (matches.isEmpty) {
          return const EmptyState(
            icon: Icons.sports_soccer,
            title: 'No matches',
            message: 'Fixtures will appear here once generated.',
          );
        }

        final canEdit =
            tournament.status == TournamentStatus.active ||
            tournament.status == TournamentStatus.completed;

        void openMatch(Match m) {
          if (!canEdit) return;
          if (m.isBye) return;
          if (m.homeTeamId == null || m.awayTeamId == null) return;
          onEditScore(m, teams[m.homeTeamId!], teams[m.awayTeamId!]);
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final narrow = constraints.maxWidth < 360;
                  final segment = onToggleView == null
                      ? const SizedBox.shrink()
                      : SegmentedButton<bool>(
                          segments: [
                            ButtonSegment(
                              value: false,
                              label: narrow ? null : const Text('List'),
                              icon: const Icon(Icons.view_list, size: 18),
                              tooltip: 'List',
                            ),
                            ButtonSegment(
                              value: true,
                              label: narrow ? null : const Text('Bracket'),
                              icon: const Icon(
                                Icons.account_tree_outlined,
                                size: 18,
                              ),
                              tooltip: 'Bracket',
                            ),
                          ],
                          selected: {showBracket},
                          onSelectionChanged: (s) => onToggleView!(s.first),
                        );
                  final simple = FilterChip(
                    avatar: Icon(
                      simplifiedView
                          ? Icons.image_outlined
                          : Icons.image_not_supported_outlined,
                      size: 18,
                    ),
                    label: const Text('Simple'),
                    selected: simplifiedView,
                    onSelected: onToggleSimplified,
                    visualDensity: VisualDensity.compact,
                  );
                  if (narrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (onToggleView != null) segment,
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: simple,
                        ),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      if (onToggleView != null) Expanded(child: segment),
                      if (onToggleView == null) const Spacer(),
                      const SizedBox(width: 8),
                      simple,
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: showBracket && onToggleView != null
                  ? BracketView(
                      matches: matches,
                      teamsById: teams,
                      simplified: simplifiedView,
                      onMatchTap: canEdit ? openMatch : null,
                    )
                  : _MatchesList(
                      matches: matches,
                      teams: teams,
                      canEdit: canEdit,
                      simplified: simplifiedView,
                      onEditScore: onEditScore,
                      onSimulate: onSimulate,
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _MatchesList extends StatelessWidget {
  const _MatchesList({
    required this.matches,
    required this.teams,
    required this.canEdit,
    required this.onEditScore,
    this.simplified = false,
    this.onSimulate,
  });

  final List<Match> matches;
  final Map<int, TournamentTeam> teams;
  final bool canEdit;
  final bool simplified;
  final void Function(Match match, TournamentTeam? home, TournamentTeam? away)
  onEditScore;
  final Future<void> Function(Match match)? onSimulate;

  @override
  Widget build(BuildContext context) {
    // Group once instead of filtering the whole list inside every item build.
    final byRound = <int, List<Match>>{};
    for (final m in matches) {
      byRound.putIfAbsent(m.round, () => <Match>[]).add(m);
    }
    final rounds = byRound.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: rounds.length,
      addAutomaticKeepAlives: false,
      itemBuilder: (context, index) {
        final round = rounds[index];
        final roundMatches = byRound[round]!;
        final stageLabel = _stageLabel(roundMatches.first, round);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
              child: Text(stageLabel, style: TourneezText.section),
            ),
            ...roundMatches.map(
              (m) => RepaintBoundary(
                child: _MatchCard(
                  match: m,
                  home: m.homeTeamId != null ? teams[m.homeTeamId!] : null,
                  away: m.awayTeamId != null ? teams[m.awayTeamId!] : null,
                  canEdit: canEdit,
                  simplified: simplified,
                  onEdit: () => onEditScore(
                    m,
                    m.homeTeamId != null ? teams[m.homeTeamId!] : null,
                    m.awayTeamId != null ? teams[m.awayTeamId!] : null,
                  ),
                  onSimulate:
                      onSimulate != null &&
                          m.status == MatchStatus.pending &&
                          m.homeTeamId != null &&
                          m.awayTeamId != null
                      ? () => onSimulate!(m)
                      : null,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _stageLabel(Match match, int round) {
    return switch (match.stage) {
      MatchStage.group => 'Group stage · Round $round',
      MatchStage.knockout => 'Knockout · Round $round',
      MatchStage.winners => 'Winners · Round $round',
      MatchStage.losers => 'Losers · Round $round',
      MatchStage.grandFinal => 'Grand final',
      MatchStage.swiss => 'Swiss · Round $round',
      MatchStage.roundRobin => 'Round $round',
    };
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({
    required this.match,
    required this.home,
    required this.away,
    required this.canEdit,
    required this.onEdit,
    this.simplified = false,
    this.onSimulate,
  });

  final Match match;
  final TournamentTeam? home;
  final TournamentTeam? away;
  final bool canEdit;
  final bool simplified;
  final VoidCallback onEdit;
  final VoidCallback? onSimulate;

  @override
  Widget build(BuildContext context) {
    final series = match.series;
    final scoreText = match.isBye
        ? 'BYE'
        : match.isCompleted
            ? '${match.homeScore} – ${match.awayScore}'
            : (series != null &&
                    series.length > 1 &&
                    series.legs.isNotEmpty)
                ? '${series.seriesHomeScore} – ${series.seriesAwayScore}'
                : (series != null && series.length > 1)
                    ? (series.length == 2 ? '2 legs' : 'Bo${series.length}')
                    : 'vs';

    final odds =
        (home != null && away != null && match.status == MatchStatus.pending)
        ? computeMatchOdds(
            homePower: home!.powerRating,
            awayPower: away!.powerRating,
            allowDraw: !match.isBracketMatch,
          )
        : null;

    final scheme = Theme.of(context).colorScheme;
    final tint = home?.colorArgb != null
        ? teamRowTint(home!.colorArgb, alpha: 0.10)
        : scheme.surface;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: tint,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap:
            canEdit &&
                !match.isBye &&
                match.homeTeamId != null &&
                match.awayTeamId != null
            ? onEdit
            : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: simplified ? 12 : 12,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _TeamSide(
                      team: home,
                      placeholder: match.homeTeamId == null ? 'TBD' : null,
                      alignEnd: false,
                      simplified: simplified,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surface.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: scheme.outline.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            scoreText,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: simplified ? 18 : 16,
                              letterSpacing: 0.2,
                            ),
                          ),
                          if (!simplified && match.groupLabel != null)
                            Text(
                              match.groupLabel!,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _TeamSide(
                      team: away,
                      placeholder: match.isBye
                          ? 'Bye'
                          : (match.awayTeamId == null ? 'TBD' : null),
                      alignEnd: true,
                      simplified: simplified,
                    ),
                  ),
                  if (!simplified && onSimulate != null)
                    IconButton(
                      tooltip: 'Simulate this match',
                      onPressed: onSimulate,
                      icon: const Icon(Icons.casino_outlined),
                    ),
                ],
              ),
              if (!simplified) ...[
                Builder(
                  builder: (context) {
                    final meta = [
                      if (match.scheduledAt != null)
                        formatMatchKickoff(match.scheduledAt!),
                      if (match.location != null &&
                          match.location!.trim().isNotEmpty)
                        match.location!.trim(),
                    ];
                    if (meta.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        meta.join(' · '),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.55),
                            ),
                      ),
                    );
                  },
                ),
              ],
              if (!simplified && odds != null) ...[
                const SizedBox(height: 6),
                Text(
                  '${odds.summary}  ·  PWR ${home!.powerRating}–${away!.powerRating}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.58),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamSide extends StatelessWidget {
  const _TeamSide({
    required this.team,
    required this.alignEnd,
    this.placeholder,
    this.simplified = false,
  });

  final TournamentTeam? team;
  final bool alignEnd;
  final String? placeholder;
  final bool simplified;

  @override
  Widget build(BuildContext context) {
    final name = team?.displayName ?? placeholder ?? '—';
    final logo = TeamLogo(
      path: team?.logoPath,
      name: name,
      colorArgb: team?.colorArgb,
      size: simplified ? 40 : 32,
    );
    if (simplified) {
      return Align(
        alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
        child: logo,
      );
    }

    final children = [
      logo,
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          name,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    ];

    return Row(
      mainAxisAlignment: alignEnd
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: alignEnd ? children.reversed.toList() : children,
    );
  }
}

/// Where a coloured cut-off line sits under the standings, and why.
class _StandingsMarker {
  const _StandingsMarker({
    required this.afterIndex,
    required this.label,
    required this.color,
  });

  /// Line is drawn under the row at this index.
  final int afterIndex;
  final String label;
  final Color color;
}

class _StandingsTab extends ConsumerStatefulWidget {
  const _StandingsTab({required this.tournament});
  final Tournament tournament;

  @override
  ConsumerState<_StandingsTab> createState() => _StandingsTabState();
}

class _StandingsTabState extends ConsumerState<_StandingsTab> {
  bool _simple = false;
  bool _showLines = true;

  /// Qualification (bracket/group advance) plus league promotion/relegation.
  ///
  /// The top division never shows promotion and the bottom division never
  /// shows relegation.
  List<_StandingsMarker> _markersFor(
    int rowCount,
    League? league,
    List<Division> divisions,
  ) {
    final tournament = widget.tournament;
    final scheme = Theme.of(context).colorScheme;
    final markers = <_StandingsMarker>[];

    if (tournament.format == TournamentFormat.hybrid) {
      final advance = tournament.config.advancePerGroup;
      if (advance > 0 && advance < rowCount) {
        markers.add(
          _StandingsMarker(
            afterIndex: advance - 1,
            label: 'Qualification',
            color: scheme.primary,
          ),
        );
      }
    }

    if (league != null && league.promoRelegEnabled) {
      final tiers = divisions.map((d) => d.tierIndex).toList()..sort();
      final division = divisions.firstWhereOrNull(
        (d) => d.id == tournament.divisionId,
      );
      final tier = division?.tierIndex;
      final isTop = tier == null || tiers.isEmpty || tier <= tiers.first;
      final isBottom = tier == null || tiers.isEmpty || tier >= tiers.last;

      final promote = league.promoteCount;
      final relegate = league.relegateCount;
      if (!isTop && promote > 0 && promote < rowCount) {
        markers.add(
          _StandingsMarker(
            afterIndex: promote - 1,
            label: 'Promotion',
            color: scheme.primary,
          ),
        );
      }
      if (!isBottom && relegate > 0 && relegate < rowCount) {
        markers.add(
          _StandingsMarker(
            afterIndex: rowCount - relegate - 1,
            label: 'Relegation',
            color: scheme.error,
          ),
        );
      }
    }

    markers.sort((a, b) => a.afterIndex.compareTo(b.afterIndex));
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final tournament = widget.tournament;
    if (tournament.status == TournamentStatus.draft) {
      return const EmptyState(
        icon: Icons.table_chart_outlined,
        title: 'Standings unavailable',
        message: 'Start the tournament to see the table.',
      );
    }

    final standingsAsync = ref.watch(standingsProvider(tournament.id));
    final league = tournament.leagueId == null
        ? null
        : ref.watch(leagueProvider(tournament.leagueId!)).value;
    final divisions = tournament.leagueId == null
        ? const <Division>[]
        : (ref.watch(divisionsProvider(tournament.leagueId!)).value ??
            const <Division>[]);

    return standingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(friendlyErrorMessage(e))),
      data: (rows) {
        if (rows.isEmpty) {
          return const EmptyState(
            icon: Icons.table_chart_outlined,
            title: 'No standings yet',
            message: 'Results will update the table automatically.',
          );
        }

        final toolbar = Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 2),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      avatar: Icon(
                        _simple
                            ? Icons.image_outlined
                            : Icons.image_not_supported_outlined,
                        size: 18,
                      ),
                      label: const Text('Simple'),
                      selected: _simple,
                      onSelected: (v) => setState(() => _simple = v),
                      visualDensity: VisualDensity.compact,
                    ),
                    FilterChip(
                      avatar: const Icon(Icons.horizontal_rule, size: 18),
                      label: const Text('Lines'),
                      selected: _showLines,
                      onSelected: (v) => setState(() => _showLines = v),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        Widget table(List<StandingRow> groupRows) => _StandingsTable(
              rows: groupRows,
              simple: _simple,
              markers: _showLines
                  ? _markersFor(groupRows.length, league, divisions)
                  : const [],
            );

        if (tournament.format.usesGroups(tournament.config)) {
          final groups = rows
              .map((r) => r.groupLabel)
              .whereType<String>()
              .toSet()
              .sorted();

          return Column(
            children: [
              toolbar,
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 24),
                  children: [
                    for (final g in groups) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 8),
                        child: Text('Group $g', style: TourneezText.section),
                      ),
                      table(rows.where((r) => r.groupLabel == g).toList()),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            toolbar,
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 24),
                children: [table(rows)],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StandingsTable extends StatelessWidget {
  const _StandingsTable({
    required this.rows,
    this.simple = false,
    this.markers = const [],
  });

  final List<StandingRow> rows;
  final bool simple;
  final List<_StandingsMarker> markers;

  static const _headerHeight = 40.0;
  static const _rowHeight = 52.0;
  static const _lineThickness = 2.5;

  /// Lines span the full table width, including the horizontally scrolled
  /// middle columns, so they read as one continuous cut-off.
  List<Widget> _lineOverlays() {
    return [
      for (final m in markers)
        Positioned(
          left: 0,
          right: 0,
          top: _headerHeight +
              _rowHeight * (m.afterIndex + 1) -
              _lineThickness / 2,
          height: _lineThickness,
          child: IgnorePointer(
            child: ColoredBox(color: m.color),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final table = simple ? _buildSimple(context) : _buildFull(context);
    if (markers.isEmpty) return table;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(children: [table, ..._lineOverlays()]),
        _legend(context),
      ],
    );
  }

  Widget _legend(BuildContext context) {
    if (markers.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 10, 6, 0),
      child: Wrap(
        spacing: 12,
        runSpacing: 6,
        children: [
          for (final m in markers)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 14, height: 2.5, color: m.color),
                const SizedBox(width: 6),
                Text(
                  m.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: m.color,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Logo + goal difference + points only.
  Widget _buildSimple(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget header(String text, {double? width, bool expand = false}) {
      final cell = SizedBox(
        width: width,
        height: _headerHeight,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      );
      return expand ? Expanded(child: cell) : cell;
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Row(
            children: [
              header('#', width: 36),
              header('Team', expand: true),
              header('GD', width: 52),
              header('Pts', width: 52),
            ],
          ),
          for (var i = 0; i < rows.length; i++)
            Container(
              height: _rowHeight,
              color: teamRowTint(rows[i].team?.colorArgb ?? 0xFF0B6E4F),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TeamLogo(
                        path: rows[i].team?.logoPath,
                        name: rows[i].displayName,
                        colorArgb: rows[i].team?.colorArgb,
                        size: 34,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 52,
                    child: Center(
                      child: Text(
                        rows[i].goalDifference > 0
                            ? '+${rows[i].goalDifference}'
                            : '${rows[i].goalDifference}',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 52,
                    child: Center(
                      child: Text(
                        '${rows[i].points}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFull(BuildContext context) {
    const logoWidth = 44.0;
    const pointsWidth = 58.0;
    const rankWidth = 40.0;
    const minNameWidth = 140.0;
    const statWidth = 48.0;
    // # + Team + P W D L GF GA GD
    const fixedStatsWidth = rankWidth + (7 * statWidth);

    Widget headerCell(String text, double width) => SizedBox(
          width: width,
          height: _headerHeight,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        );

    Widget valueCell(String text, double width, {bool bold = false}) =>
        SizedBox(
          width: width,
          height: _rowHeight,
          child: Center(
            child: Text(
              text,
              style: bold ? const TextStyle(fontWeight: FontWeight.w700) : null,
            ),
          ),
        );

    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Frozen logos only.
              Column(
                children: [
                  SizedBox(width: logoWidth, height: _headerHeight),
                  for (var i = 0; i < rows.length; i++)
                    Container(
                      width: logoWidth,
                      height: _rowHeight,
                      color: teamRowTint(
                        rows[i].team?.colorArgb ?? 0xFF0B6E4F,
                      ),
                      alignment: Alignment.center,
                      child: TeamLogo(
                        path: rows[i].team?.logoPath,
                        name: rows[i].displayName,
                        colorArgb: rows[i].team?.colorArgb,
                        size: 28,
                      ),
                    ),
                ],
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Stretch the name column so GD sits flush against frozen
                    // Pts when there is leftover horizontal space.
                    final nameWidth = (constraints.maxWidth - fixedStatsWidth)
                        .clamp(minNameWidth, double.infinity);

                    Widget statsRow({
                      required Widget Function(StandingRow row, int i) buildRow,
                    }) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              headerCell('#', rankWidth),
                              headerCell('Team', nameWidth),
                              for (final label in const [
                                'P',
                                'W',
                                'D',
                                'L',
                                'GF',
                                'GA',
                                'GD',
                              ])
                                headerCell(label, statWidth),
                            ],
                          ),
                          for (var i = 0; i < rows.length; i++)
                            Container(
                              height: _rowHeight,
                              color: teamRowTint(
                                rows[i].team?.colorArgb ?? 0xFF0B6E4F,
                              ),
                              child: buildRow(rows[i], i),
                            ),
                        ],
                      );
                    }

                    final table = statsRow(
                      buildRow: (row, i) => Row(
                        children: [
                          valueCell('${i + 1}', rankWidth),
                          SizedBox(
                            width: nameWidth,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  row.displayName,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          valueCell('${row.played}', statWidth),
                          valueCell('${row.won}', statWidth),
                          valueCell('${row.drawn}', statWidth),
                          valueCell('${row.lost}', statWidth),
                          valueCell('${row.goalsFor}', statWidth),
                          valueCell('${row.goalsAgainst}', statWidth),
                          valueCell(
                            row.goalDifference > 0
                                ? '+${row.goalDifference}'
                                : '${row.goalDifference}',
                            statWidth,
                          ),
                        ],
                      ),
                    );

                    // Only scroll when columns overflow the available width.
                    if (minNameWidth + fixedStatsWidth <= constraints.maxWidth) {
                      return table;
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: table,
                    );
                  },
                ),
              ),
              // Frozen points.
              Column(
                children: [
                  headerCell('Pts', pointsWidth),
                  for (var i = 0; i < rows.length; i++)
                    Container(
                      color: teamRowTint(
                        rows[i].team?.colorArgb ?? 0xFF0B6E4F,
                      ),
                      child: valueCell(
                        '${rows[i].points}',
                        pointsWidth,
                        bold: true,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeamsTab extends ConsumerWidget {
  const _TeamsTab({required this.tournamentId, required this.isDraft});

  final int tournamentId;
  final bool isDraft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(tournamentTeamsProvider(tournamentId));
    final libraryAsync = ref.watch(teamsProvider);
    final canReorder = ref.watch(canReorderSeedsProvider(tournamentId));

    return teamsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(friendlyErrorMessage(e))),
      data: (teams) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      canReorder
                          ? (isDraft
                                ? 'Drag to set seeds · add or remove before starting.'
                                : 'Drag to change seeds (no games played yet).')
                          : 'Tap a team to edit (updates the global library).',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  if (isDraft)
                    FilledButton.tonalIcon(
                      onPressed: () => _addTeamsSheet(
                        context,
                        ref,
                        enrolledIds: teams.map((t) => t.teamId).toSet(),
                        library: libraryAsync.value ?? const [],
                      ),
                      icon: const Icon(Icons.person_add_alt_1, size: 18),
                      label: const Text('Add'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: teams.isEmpty
                  ? EmptyState(
                      icon: Icons.groups_outlined,
                      title: 'No teams enrolled',
                      message: isDraft
                          ? 'Add teams from your library to this draft.'
                          : 'This tournament has no teams.',
                      action: isDraft
                          ? FilledButton.icon(
                              onPressed: () => _addTeamsSheet(
                                context,
                                ref,
                                enrolledIds: {},
                                library: libraryAsync.value ?? const [],
                              ),
                              icon: const Icon(Icons.person_add_alt_1),
                              label: const Text('Add teams'),
                            )
                          : null,
                    )
                  : ReorderableListView.builder(
                      padding: const EdgeInsets.all(16),
                      buildDefaultDragHandles: false,
                      itemCount: teams.length,
                      onReorderItem: (oldIndex, newIndex) async {
                        if (!canReorder) return;
                        final ordered = List<TournamentTeam>.from(teams);
                        final item = ordered.removeAt(oldIndex);
                        ordered.insert(newIndex, item);
                        final err = await ref
                            .read(repositoryProvider)
                            .reorderTournamentSeeds(
                              tournamentId: tournamentId,
                              orderedTeamIds: ordered
                                  .map((t) => t.teamId)
                                  .toList(),
                            );
                        if (context.mounted && err != null) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(err)));
                        }
                      },
                      itemBuilder: (context, index) {
                        final t = teams[index];
                        return Card(
                          key: ValueKey(t.id),
                          color: teamRowTint(t.colorArgb),
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (canReorder)
                                  ReorderableDragStartListener(
                                    index: index,
                                    child: const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Icon(Icons.drag_handle),
                                    ),
                                  ),
                                TeamLogo(
                                  path: t.logoPath,
                                  name: t.displayName,
                                  colorArgb: t.colorArgb,
                                ),
                              ],
                            ),
                            title: Text(t.displayName),
                            subtitle: Text(
                              [
                                'Seed ${t.seed ?? (index + 1)}',
                                if (t.groupLabel != null)
                                  'Group ${t.groupLabel}',
                                'PWR ${t.powerRating}',
                                if (t.homeLocation != null &&
                                    t.homeLocation!.trim().isNotEmpty)
                                  t.homeLocation!,
                              ].join(' · '),
                            ),
                            trailing: isDraft
                                ? IconButton(
                                    tooltip: 'Remove',
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    onPressed: () async {
                                      final err = await ref
                                          .read(repositoryProvider)
                                          .removeTeamFromTournament(
                                            tournamentId: tournamentId,
                                            teamId: t.teamId,
                                          );
                                      if (context.mounted && err != null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text(err)),
                                        );
                                      }
                                    },
                                  )
                                : const Icon(Icons.edit_outlined),
                            onTap: t.team == null
                                ? null
                                : () => showTeamEditorSheet(
                                    context,
                                    ref,
                                    team: t.team,
                                  ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addTeamsSheet(
    BuildContext context,
    WidgetRef ref, {
    required Set<int> enrolledIds,
    required List<Team> library,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        final available = library
            .where((t) => !enrolledIds.contains(t.id))
            .toList();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Add teams', style: Theme.of(ctx).textTheme.titleLarge),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final team = await ref
                              .read(repositoryProvider)
                              .quickCreateTeam();
                          await ref
                              .read(repositoryProvider)
                              .addTeamToTournament(
                                tournamentId: tournamentId,
                                teamId: team.id,
                              );
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                        icon: const Icon(Icons.flash_on),
                        label: const Text('Quick add new'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (available.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'All library teams are already enrolled. Quick-add creates a new one.',
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  SizedBox(
                    height: 320,
                    child: ListView.builder(
                      itemCount: available.length,
                      itemBuilder: (context, index) {
                        final team = available[index];
                        return ListTile(
                          leading: TeamLogo(
                            path: team.logoPath,
                            name: team.name,
                            colorArgb: team.colorArgb,
                          ),
                          title: Text(team.name),
                          subtitle: Text('PWR ${team.powerRating}'),
                          trailing: const Icon(Icons.add),
                          onTap: () async {
                            final err = await ref
                                .read(repositoryProvider)
                                .addTeamToTournament(
                                  tournamentId: tournamentId,
                                  teamId: team.id,
                                );
                            if (ctx.mounted) {
                              if (err != null) {
                                ScaffoldMessenger.of(
                                  ctx,
                                ).showSnackBar(SnackBar(content: Text(err)));
                              } else {
                                Navigator.pop(ctx);
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SettingsTab extends ConsumerStatefulWidget {
  const _SettingsTab({
    required this.tournament,
    required this.onRandomize,
    required this.randomizing,
  });

  final Tournament tournament;
  final VoidCallback onRandomize;
  final bool randomizing;

  @override
  ConsumerState<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<_SettingsTab> {
  late final TextEditingController _name;
  late TournamentConfig _config;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.tournament.name);
    _config = widget.tournament.config;
  }

  @override
  void didUpdateWidget(covariant _SettingsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tournament.id != widget.tournament.id ||
        oldWidget.tournament.updatedAt != widget.tournament.updatedAt) {
      _name.text = widget.tournament.name;
      _config = widget.tournament.config;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _isDraft => widget.tournament.status == TournamentStatus.draft;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(repositoryProvider)
          .updateTournamentMeta(
            id: widget.tournament.id,
            name: _name.text.trim(),
            config: _config,
          );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Settings saved')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tournament = widget.tournament;
    final teamsAsync = ref.watch(tournamentTeamsProvider(tournament.id));
    final teamCount = teamsAsync.value?.length ?? 0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Format'),
          subtitle: Text(
            '${tournament.format.category.label} · ${tournament.format.label}',
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Status'),
          subtitle: Text(tournament.status.name),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _name,
          decoration: const InputDecoration(labelText: 'Tournament name'),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        FormatConfigEditor(
          format: tournament.format,
          config: _config,
          onChanged: (c) => setState(() => _config = c),
          teamCount: teamCount,
          enabled: true,
          showHybridPhasePickers: _isDraft,
          compact: true,
        ),
        if (!_isDraft)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Hybrid phases are locked after start. Other options still apply to standings.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save settings'),
        ),
        const Divider(height: 32),
        if (tournament.status == TournamentStatus.draft)
          FilledButton(
            onPressed: () async {
              final err = await ref
                  .read(repositoryProvider)
                  .startTournament(tournament.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(err ?? 'Tournament started')),
                );
              }
            },
            child: const Text('Start tournament'),
          ),
        if (tournament.status == TournamentStatus.active) ...[
          FilledButton.tonalIcon(
            onPressed: widget.randomizing ? null : widget.onRandomize,
            icon: const Icon(Icons.casino_outlined),
            label: Text(
              widget.randomizing
                  ? 'Simulating…'
                  : 'Simulate all pending (by power)',
            ),
          ),
          const SizedBox(height: 8),
        ],
        OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete tournament?'),
                content: Text('Delete "${tournament.name}" permanently?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
            if (ok == true && context.mounted) {
              await ref
                  .read(repositoryProvider)
                  .deleteTournament(tournament.id);
              if (context.mounted) context.go('/');
            }
          },
          child: const Text('Delete tournament'),
        ),
      ],
    );
  }
}
