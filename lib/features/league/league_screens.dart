import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/providers/viewer_provider.dart';
import 'package:tourneez/ui/viewer_controls.dart';
import 'package:tourneez/ui/format_config_editor.dart';
import 'package:tourneez/ui/int_number_field.dart';
import 'package:tourneez/ui/team_list_picker.dart';
import 'package:tourneez/ui/venue_overview.dart';
import 'package:tourneez/ui/widgets.dart';

void _goBack(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go('/');
  }
}

Future<void> _offerResetLeagueScores(
  BuildContext context,
  WidgetRef ref,
  League league,
) async {
  if (league.status != LeagueStatus.active &&
      league.status != LeagueStatus.completed) {
    return;
  }
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Reset all scores?'),
      content: Text(
        'Clear every score in the current season of “${league.name}” '
        'and restart each division’s fixtures. Career stats from any '
        'completed division seasons will be undone. This cannot be undone.',
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
  if (confirmed != true || !context.mounted) return;
  final err = await ref
      .read(repositoryProvider)
      .resetLeagueSeasonScores(league.id);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(err ?? 'All scores reset')),
  );
}

class CreateLeagueScreen extends ConsumerStatefulWidget {
  const CreateLeagueScreen({super.key});

  @override
  ConsumerState<CreateLeagueScreen> createState() => _CreateLeagueScreenState();
}

class _CreateLeagueScreenState extends ConsumerState<CreateLeagueScreen> {
  final _name = TextEditingController();
  final _divisions = <TextEditingController>[
    TextEditingController(text: 'Division 1'),
  ];
  TournamentFormat _format = TournamentFormat.roundRobin;
  late TournamentConfig _config =
      TournamentConfig.defaultsFor(TournamentFormat.roundRobin);
  int _promote = 2;
  int _relegate = 2;
  bool _promoEnabled = true;
  bool _saving = false;

  bool get _showPromoUi =>
      _divisions.length >= 2 && formatAllowsPromoReleg(_format);

  @override
  void dispose() {
    _name.dispose();
    for (final c in _divisions) {
      c.dispose();
    }
    super.dispose();
  }

  void _setFormat(TournamentFormat format) {
    setState(() {
      _format = format;
      _config = TournamentConfig.defaultsFor(format);
      if (!formatAllowsPromoReleg(format)) {
        _promoEnabled = false;
      } else if (_divisions.length >= 2) {
        _promoEnabled = true;
      }
    });
  }

  void _addDivision() {
    setState(() {
      _divisions.add(
        TextEditingController(text: 'Division ${_divisions.length + 1}'),
      );
      if (formatAllowsPromoReleg(_format) && _divisions.length >= 2) {
        _promoEnabled = true;
      }
    });
  }

  void _removeDivision(int index) {
    if (_divisions.length <= 1) return;
    final removed = _divisions.removeAt(index);
    setState(() {});
    // Dispose after the TextField unmounts — disposing mid-build causes
    // `_dependents.isEmpty` assertion failures.
    WidgetsBinding.instance.addPostFrameCallback((_) => removed.dispose());
  }

  Future<void> _create() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a league name.')),
      );
      return;
    }
    final names = _divisions
        .map((c) => c.text.trim())
        .where((n) => n.isNotEmpty)
        .toList();
    if (names.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Need at least 1 named division.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final id = await ref.read(repositoryProvider).createLeague(
            name: name,
            divisionNames: names,
            format: _format,
            config: _config,
            promoteCount: _promote,
            relegateCount: _relegate,
            promoRelegEnabled: _promoEnabled &&
                formatAllowsPromoReleg(_format) &&
                names.length >= 2,
          );
      if (mounted) context.go('/league/$id');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _goBack(context),
        ),
        title: const Text('New league'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'League name',
              hintText: 'e.g. National Pyramid',
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),
          Text(
            'Divisions (top → bottom)',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < _divisions.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            TextField(
              controller: _divisions[i],
              decoration: InputDecoration(
                labelText: i == 0 ? 'Top division' : 'Division ${i + 1}',
                suffixIcon: _divisions.length > 1
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _removeDivision(i),
                      )
                    : null,
              ),
            ),
          ],
          TextButton.icon(
            onPressed: _addDivision,
            icon: const Icon(Icons.add),
            label: const Text('Add division'),
          ),
          const Divider(height: 28),
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Format',
              border: OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<TournamentFormat>(
                isExpanded: true,
                value: _format,
                items: [
                  for (final f in TournamentFormat.values)
                    DropdownMenuItem(
                      value: f,
                      child: Text(f.label),
                    ),
                ],
                onChanged: (f) {
                  if (f != null) _setFormat(f);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          FormatConfigEditor(
            format: _format,
            config: _config,
            teamCount: 0,
            onChanged: (c) => setState(() => _config = c),
          ),
          if (_showPromoUi) ...[
            const Divider(height: 28),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Promotion & relegation'),
              subtitle: const Text(
                'Move teams between divisions at the end of a season.',
              ),
              value: _promoEnabled,
              onChanged: (v) => setState(() => _promoEnabled = v),
            ),
            if (_promoEnabled) ...[
              IntNumberField(
                label: 'Promoted per boundary',
                value: _promote,
                min: 0,
                max: 10,
                helperText: 'How many teams move up from each lower division.',
                onChanged: (v) => setState(() => _promote = v),
              ),
              IntNumberField(
                label: 'Relegated per boundary',
                value: _relegate,
                min: 0,
                max: 10,
                helperText: 'How many teams drop from each higher division.',
                onChanged: (v) => setState(() => _relegate = v),
              ),
            ],
          ],
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _saving ? null : _create,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create league'),
          ),
        ],
      ),
    );
  }
}

class LeagueHubScreen extends ConsumerWidget {
  const LeagueHubScreen({super.key, required this.leagueId});

  final int leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagueAsync = ref.watch(leagueProvider(leagueId));
    final divisionsAsync = ref.watch(divisionsProvider(leagueId));
    final promoReadyAsync = ref.watch(leaguePromoReadyProvider(leagueId));
    final nextSeasonReadyAsync =
        ref.watch(leagueNextSeasonReadyProvider(leagueId));

    return leagueAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _goBack(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _goBack(context),
          ),
        ),
        body: EmptyState(
          icon: Icons.error_outline,
          title: 'League not found',
          message: friendlyErrorMessage(e),
        ),
      ),
      data: (league) {
        if (league == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _goBack(context),
              ),
            ),
            body: const EmptyState(
              icon: Icons.search_off,
              title: 'League not found',
              message: 'It may have been deleted.',
            ),
          );
        }

        final manager = ref.watch(viewerProvider).isManager;
        final showVenues =
            manager || league.config.familyView.showVenues;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _goBack(context),
            ),
            title: Text(league.name),
            actions: [
              if (showVenues)
              IconButton(
                tooltip: 'League venues map',
                onPressed: () {
                  final divisions = divisionsAsync.value ?? const <Division>[];
                  final ids = [
                    for (final d in divisions)
                      if (d.currentTournamentId != null) d.currentTournamentId!,
                  ];
                  showVenueOverviewSheet(
                    context,
                    ref,
                    title: 'League venues',
                    tournamentIds: ids,
                  );
                },
                icon: const Icon(Icons.map_outlined),
              ),
              LeagueStatusChip(
                status: league.status,
                onTap: manager &&
                        (league.status == LeagueStatus.active ||
                            league.status == LeagueStatus.completed)
                    ? () => _offerResetLeagueScores(context, ref, league)
                    : null,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: divisionsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(friendlyErrorMessage(e))),
            data: (divisions) {
              final promoReady = promoReadyAsync.asData?.value == true;
              final nextSeasonReady =
                  nextSeasonReadyAsync.asData?.value == true;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    league.canUsePromoReleg
                        ? 'Season ${league.seasonNumber} · ${league.format.label} · '
                            'Promote ${league.promoteCount} / Relegate ${league.relegateCount}'
                        : 'Season ${league.seasonNumber} · ${league.format.label}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.65),
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (manager)
                    FamilyViewSettingsCard(
                      settings: league.config.familyView,
                      onChanged: (next) {
                        ref.read(repositoryProvider).updateLeague(
                              id: league.id,
                              config: league.config.copyWith(familyView: next),
                            );
                      },
                    ),
                  const SizedBox(height: 12),
                  ...divisions.map(
                    (d) => _DivisionCard(league: league, division: d),
                  ),
                  const SizedBox(height: 16),
                  if (manager &&
                      (league.status == LeagueStatus.draft ||
                          divisions.every((d) => d.currentTournamentId == null)))
                    FilledButton.icon(
                      onPressed: () async {
                        final err = await ref
                            .read(repositoryProvider)
                            .startLeagueSeason(leagueId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(err ?? 'Season started'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text(
                        league.seasonNumber == 1
                            ? 'Start season'
                            : 'Start season ${league.seasonNumber}',
                      ),
                    ),
                  if (manager && league.canUsePromoReleg && promoReady)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: FilledButton.tonalIcon(
                        onPressed: () =>
                            _showPromoReleg(context, ref, league),
                        icon: const Icon(Icons.swap_vert),
                        label: const Text('Apply promotion & relegation'),
                      ),
                    ),
                  if (manager && !league.canUsePromoReleg && nextSeasonReady)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: FilledButton(
                        onPressed: () async {
                          final err = await ref
                              .read(repositoryProvider)
                              .advanceLeagueToNextSeason(leagueId);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  err ??
                                      'Advanced to season ${league.seasonNumber + 1}',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Next season'),
                      ),
                    ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/league/$leagueId/archive'),
                    icon: const Icon(Icons.history),
                    label: const Text('Past seasons'),
                  ),
                  if (manager) ...[
                  const SizedBox(height: 8),
                  OutlinedButton(
                    style:
                        OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete league?'),
                          content: Text(
                              'Delete "${league.name}" and its seasons?'),
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
                            .deleteLeague(leagueId);
                        if (context.mounted) context.go('/');
                      }
                    },
                    child: const Text('Delete league'),
                  ),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showPromoReleg(
    BuildContext context,
    WidgetRef ref,
    League league,
  ) async {
    final moves =
        await ref.read(repositoryProvider).previewPromoReleg(league.id);
    if (!context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Promotion & relegation'),
        content: SizedBox(
          width: 400,
          child: moves.isEmpty
              ? const Text('No moves with current settings.')
              : ListView(
                  shrinkWrap: true,
                  children: [
                    for (final m in moves)
                      ListTile(
                        dense: true,
                        leading: Icon(
                          m.promoted
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: m.promoted ? Colors.green : Colors.orange,
                        ),
                        title: Text(m.teamName ?? 'Team #${m.teamId}'),
                        subtitle: Text(
                          '${m.fromDivisionName} → ${m.toDivisionName}',
                        ),
                      ),
                  ],
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      final err = await ref.read(repositoryProvider).applyPromoReleg(league.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              err ?? 'Rosters updated for season ${league.seasonNumber + 1}.',
            ),
          ),
        );
      }
    }
  }
}

class _DivisionCard extends ConsumerWidget {
  const _DivisionCard({required this.league, required this.division});

  final League league;
  final Division division;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(divisionTeamsProvider(division.id));
    final tournamentAsync = division.currentTournamentId == null
        ? const AsyncValue<Tournament?>.data(null)
        : ref.watch(tournamentProvider(division.currentTournamentId!));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${division.tierIndex + 1}. ${division.name}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                tournamentAsync.when(
                  data: (t) => t == null
                      ? const SizedBox.shrink()
                      : StatusChip(status: t.status),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            teamsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text(friendlyErrorMessage(e)),
              data: (teams) => Text(
                '${teams.length} teams'
                '${teams.isEmpty ? '' : ': ${teams.map((t) => t.team?.name ?? '#${t.teamId}').take(4).join(', ')}${teams.length > 4 ? '…' : ''}'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (ref.watch(viewerProvider).isManager)
                  OutlinedButton(
                    onPressed: () => _editRoster(context, ref),
                    child: const Text('Edit roster'),
                  ),
                if (division.currentTournamentId != null)
                  FilledButton.tonal(
                    onPressed: () => context.push(
                      '/tournament/${division.currentTournamentId}',
                    ),
                    child: const Text('Open season'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editRoster(BuildContext context, WidgetRef ref) async {
    final current =
        await ref.read(repositoryProvider).getDivisionTeams(division.id);
    final selected = current.map((t) => t.teamId).toSet();
    final occupied = await ref.read(repositoryProvider).teamsInOtherDivisions(
          leagueId: league.id,
          excludeDivisionId: division.id,
        );

    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (ctx) => _DivisionRosterSheet(
        division: division,
        initialSelected: selected,
        occupied: occupied,
      ),
    );
  }
}

class _DivisionRosterSheet extends ConsumerStatefulWidget {
  const _DivisionRosterSheet({
    required this.division,
    required this.initialSelected,
    required this.occupied,
  });

  final Division division;
  final Set<int> initialSelected;
  final Map<int, String> occupied;

  @override
  ConsumerState<_DivisionRosterSheet> createState() =>
      _DivisionRosterSheetState();
}

class _DivisionRosterSheetState extends ConsumerState<_DivisionRosterSheet> {
  late final Set<int> _selected = {...widget.initialSelected};

  @override
  Widget build(BuildContext context) {
    final library = ref.watch(teamsProvider).value ?? const <Team>[];
    final lists = ref.watch(teamListsProvider).value ?? const <TeamList>[];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${widget.division.name} roster',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Teams already assigned to another division cannot be selected.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.65),
                    ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TeamListPicker(
                  library: library,
                  lists: lists,
                  selected: _selected,
                  occupiedElsewhere: widget.occupied,
                  onToggleTeam: (id) {
                    setState(() {
                      if (_selected.contains(id)) {
                        _selected.remove(id);
                      } else {
                        _selected.add(id);
                      }
                    });
                  },
                  onApplyList: (list) {
                    final available = list.teamIds
                        .where((tid) => !widget.occupied.containsKey(tid))
                        .toSet();
                    final skipped = list.teamIds.length - available.length;
                    setState(() {
                      _selected
                        ..clear()
                        ..addAll(available);
                    });
                    if (skipped > 0) {
                      showAppSnackBar(
                        'Skipped $skipped team${skipped == 1 ? '' : 's'} already in another division.',
                      );
                    } else {
                      showAppSnackBar(
                        'Loaded "${list.name}" (${available.length} teams)',
                      );
                    }
                  },
                ),
              ),
              FilledButton(
                onPressed: () async {
                  final nav = Navigator.of(context);
                  final err = await ref.read(repositoryProvider).setDivisionTeams(
                        divisionId: widget.division.id,
                        teamIds: _selected.toList(),
                      );
                  if (!mounted) return;
                  if (err != null) {
                    showAppSnackBar(err);
                  } else {
                    nav.pop();
                  }
                },
                child: Text('Save (${_selected.length} teams)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeagueArchiveScreen extends ConsumerWidget {
  const LeagueArchiveScreen({super.key, required this.leagueId});

  final int leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagueAsync = ref.watch(leagueProvider(leagueId));
    final archiveAsync = ref.watch(leagueArchiveProvider(leagueId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _goBack(context),
        ),
        title: Text(
          leagueAsync.asData?.value?.name != null
              ? '${leagueAsync.asData!.value!.name} · Past seasons'
              : 'Past seasons',
        ),
      ),
      body: archiveAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(friendlyErrorMessage(e))),
        data: (seasons) {
          if (seasons.isEmpty) {
            return const EmptyState(
              icon: Icons.history,
              title: 'No past seasons yet',
              message:
                  'Completed division seasons will appear here so you can revisit results.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: seasons.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final t = seasons[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.emoji_events_outlined),
                  title: Text(t.name),
                  subtitle: Text(t.format.label),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/tournament/${t.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
