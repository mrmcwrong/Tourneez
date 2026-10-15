import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/features/home/parent_home_screen.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/providers/viewer_provider.dart';
import 'package:tourneez/ui/theme.dart';
import 'package:tourneez/ui/viewer_controls.dart';
import 'package:tourneez/ui/widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(tournamentsProvider);
    final leaguesAsync = ref.watch(leaguesProvider);
    final manager = ref.watch(viewerProvider).isManager;
    if (!manager) return const ParentHomeScreen();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            title: Text(
              'Tourneez',
              style: TourneezText.brand.copyWith(color: scheme.onSurface),
            ),
            actions: [
              ActionChip(
                avatar: Icon(
                  manager
                      ? Icons.admin_panel_settings_outlined
                      : Icons.family_restroom_outlined,
                  size: 18,
                ),
                label: Text(manager ? 'Manager' : 'Family'),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    builder: (ctx) => const SafeArea(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: ViewerSwitcherCard(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
              if (manager)
              IconButton(
                tooltip: 'Teams',
                onPressed: () => context.push('/teams'),
                icon: const Icon(Icons.groups_outlined),
              ),
              IconButton(
                tooltip: 'Venues',
                onPressed: () => context.push('/venues'),
                icon: const Icon(Icons.place_outlined),
              ),
              IconButton(
                tooltip: 'App settings',
                onPressed: () => context.push('/settings'),
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Text(
                'Leagues, brackets, and seasons — all in one pocket.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.62),
                  height: 1.35,
                ),
              ),
            ),
          ),
          leaguesAsync.when(
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            data: (leagues) {
              if (leagues.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                sliver: SliverList.list(
                  children: [
                    const SectionHeader(title: 'Leagues'),
                    ...leagues.map(
                      (l) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                scheme.primary.withValues(alpha: 0.12),
                            child: Icon(
                              Icons.layers_outlined,
                              color: scheme.primary,
                            ),
                          ),
                          title: Text(
                            l.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text('Season ${l.seasonNumber}'),
                          trailing: LeagueStatusChip(status: l.status),
                          onTap: () => context.push('/league/${l.id}'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          tournamentsAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                icon: Icons.error_outline,
                title: 'Could not load tournaments',
                message: friendlyErrorMessage(e),
              ),
            ),
            data: (tournaments) {
              final leagues = leaguesAsync.value ?? const <League>[];
              if (tournaments.isEmpty && leagues.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    icon: Icons.emoji_events_outlined,
                    title: 'Ready when you are',
                    message: manager
                        ? 'Spin up a knockout bracket or a multi-division league with promotion and relegation.'
                        : 'When a league is published for families, its schedule and scores show up here.',
                  ),
                );
              }

              final active = tournaments
                  .where((t) => t.status == TournamentStatus.active)
                  .toList();
              final drafts = manager
                  ? tournaments
                      .where((t) => t.status == TournamentStatus.draft)
                      .toList()
                  : const <Tournament>[];
              final done = tournaments
                  .where((t) => t.status == TournamentStatus.completed)
                  .toList();

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                sliver: SliverList.list(
                  children: [
                    if (active.isNotEmpty) ...[
                      const SectionHeader(title: 'Active'),
                      ...active.map((t) => _TournamentTile(tournament: t)),
                    ],
                    if (drafts.isNotEmpty) ...[
                      const SectionHeader(title: 'Drafts'),
                      ...drafts.map((t) => _TournamentTile(tournament: t)),
                    ],
                    if (done.isNotEmpty) ...[
                      const SectionHeader(title: 'Completed'),
                      ...done.map((t) => _TournamentTile(tournament: t)),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: manager
          ? _CreateSpeedDial(
              onLeague: () => context.push('/create-league'),
              onTournament: () => context.push('/create'),
            )
          : null,
    );
  }
}

class _CreateSpeedDial extends StatefulWidget {
  const _CreateSpeedDial({
    required this.onLeague,
    required this.onTournament,
  });

  final VoidCallback onLeague;
  final VoidCallback onTournament;

  @override
  State<_CreateSpeedDial> createState() => _CreateSpeedDialState();
}

class _CreateSpeedDialState extends State<_CreateSpeedDial>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _ctrl.forward();
      } else {
        _ctrl.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizeTransition(
          sizeFactor: CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
          axis: Axis.vertical,
          child: FadeTransition(
            opacity: _ctrl,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: 'league',
                        onPressed: () {
                          _toggle();
                          widget.onLeague();
                        },
                        backgroundColor: scheme.secondary,
                        icon: const Icon(Icons.layers_outlined),
                        label: const Text('New league'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: 'tournament',
                        onPressed: () {
                          _toggle();
                          widget.onTournament();
                        },
                        icon: const Icon(Icons.account_tree_outlined),
                        label: const Text('New tournament'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'create',
              onPressed: _toggle,
              child: AnimatedRotation(
                turns: _open ? 0.125 : 0,
                duration: const Duration(milliseconds: 220),
                child: Icon(_open ? Icons.close : Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TournamentTile extends ConsumerWidget {
  const _TournamentTile({required this.tournament});
  final Tournament tournament;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final icon = switch (tournament.format.category) {
      TournamentCategory.bracket => Icons.account_tree_outlined,
      TournamentCategory.league => Icons.table_rows_outlined,
      TournamentCategory.hybrid => Icons.hub_outlined,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.primary.withValues(alpha: 0.12),
          child: Icon(icon, color: scheme.primary, size: 22),
        ),
        title: Text(
          tournament.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(tournament.format.label),
        trailing: StatusChip(status: tournament.status),
        onTap: () => context.push('/tournament/${tournament.id}'),
        onLongPress: ref.watch(viewerProvider).isManager
            ? () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => keyboardAware(
              context: ctx,
              child: AlertDialog(
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
            ),
          );
          if (confirm == true) {
            await ref.read(repositoryProvider).deleteTournament(tournament.id);
          }
        }
            : null,
      ),
    );
  }
}
