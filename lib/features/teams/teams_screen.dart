import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/ui/team_editor.dart';
import 'package:tourneez/ui/team_list_picker.dart';
import 'package:tourneez/ui/widgets.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
          title: const Text('Teams'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Library'),
              Tab(text: 'Lists'),
            ],
          ),
          actions: teamLibraryActions(context, ref),
        ),
        body: const TabBarView(children: [_TeamLibraryTab(), _TeamListsTab()]),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Custom team',
          onPressed: () => showTeamEditorSheet(context, ref),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _TeamLibraryTab extends ConsumerWidget {
  const _TeamLibraryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(teamsProvider);

    return teamsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EmptyState(
        icon: Icons.error_outline,
        title: 'Could not load teams',
        message: friendlyErrorMessage(e),
      ),
      data: (teams) {
        if (teams.isEmpty) {
          return EmptyState(
            icon: Icons.groups_outlined,
            title: 'No teams yet',
            message:
                'Quick-add a random team, pick a logo template, or create a custom one.',
            action: FilledButton.icon(
              onPressed: () => showTeamEditorSheet(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Custom team'),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: teams.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final team = teams[index];
            final subtitle = [
              if (team.titles.isNotEmpty)
                '${team.titles.length} '
                    '${team.titles.length == 1 ? 'title' : 'titles'}',
              if (team.promotionsWon > 0) '${team.promotionsWon} promotions',
              if (team.homeLocation != null &&
                  team.homeLocation!.trim().isNotEmpty)
                team.homeLocation!,
            ].join(' · ');
            return Card(
              color: teamRowTint(team.colorArgb),
              child: ListTile(
                leading: TeamLogo(
                  path: team.logoPath,
                  name: team.name,
                  colorArgb: team.colorArgb,
                  size: 48,
                ),
                title: Text(
                  team.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: subtitle.isEmpty ? null : Text(subtitle),
                trailing: PowerBadge(power: team.powerRating),
                onTap: () => showTeamEditorSheet(context, ref, team: team),
                onLongPress: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete team?'),
                      content: Text('Remove "${team.name}" from the library?'),
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
                  if (ok == true) {
                    await ref.read(repositoryProvider).deleteTeam(team.id);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _TeamListsTab extends ConsumerWidget {
  const _TeamListsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(teamListsProvider);
    final teamsAsync = ref.watch(teamsProvider);

    return listsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(friendlyErrorMessage(e))),
      data: (lists) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Reuse the same roster across tournaments.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => _editList(
                      context,
                      ref,
                      library: teamsAsync.value ?? const [],
                    ),
                    icon: const Icon(Icons.playlist_add),
                    label: const Text('New list'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: lists.isEmpty
                  ? const EmptyState(
                      icon: Icons.playlist_add_check,
                      title: 'No team lists',
                      message:
                          'Save a set of teams once, then load it when creating a tournament.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: lists.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final list = lists[index];
                        return Card(
                          child: ListTile(
                            title: Text(list.name),
                            subtitle: Text('${list.teamIds.length} teams'),
                            trailing: const Icon(Icons.edit_outlined),
                            onTap: () => _editList(
                              context,
                              ref,
                              library: teamsAsync.value ?? const [],
                              existing: list,
                            ),
                            onLongPress: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete list?'),
                                  content: Text('Delete "${list.name}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (ok == true) {
                                await ref
                                    .read(repositoryProvider)
                                    .deleteTeamList(list.id);
                              }
                            },
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

  Future<void> _editList(
    BuildContext context,
    WidgetRef ref, {
    required List<Team> library,
    TeamList? existing,
  }) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final selected = {...?existing?.teamIds};

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                16 + MediaQuery.viewInsetsOf(ctx).bottom,
              ),
              child: SizedBox(
                height: MediaQuery.sizeOf(ctx).height * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      existing == null ? 'New team list' : 'Edit team list',
                      style: Theme.of(ctx).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'List name'),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView(
                        children: [
                          for (final team in library)
                            Card(
                              color: selected.contains(team.id)
                                  ? teamRowTint(team.colorArgb)
                                  : null,
                              child: CheckboxListTile(
                                value: selected.contains(team.id),
                                title: Text(team.name),
                                secondary: TeamLogo(
                                  path: team.logoPath,
                                  name: team.name,
                                  colorArgb: team.colorArgb,
                                ),
                                onChanged: (on) {
                                  setLocal(() {
                                    if (on == true) {
                                      selected.add(team.id);
                                    } else {
                                      selected.remove(team.id);
                                    }
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () async {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty || selected.isEmpty) return;
                        final repo = ref.read(repositoryProvider);
                        if (existing == null) {
                          await repo.createTeamList(
                            name: name,
                            teamIds: selected.toList(),
                          );
                        } else {
                          await repo.updateTeamList(
                            id: existing.id,
                            name: name,
                            teamIds: selected.toList(),
                          );
                        }
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                      child: Text(
                        existing == null
                            ? 'Create list (${selected.length})'
                            : 'Save (${selected.length})',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => nameCtrl.dispose());
  }
}
