import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/ui/team_editor.dart';
import 'package:tourneez/ui/team_list_picker.dart';
import 'package:tourneez/ui/widgets.dart';

/// Tournament create wizard — team selection with Teams / Lists tabs.
/// Seeding can be adjusted later in tournament settings.

class TournamentTeamsStep extends ConsumerWidget {
  const TournamentTeamsStep({
    super.key,
    required this.selected,
    required this.minTeams,
    required this.onToggle,
    required this.onReplaceSelection,
  });

  final List<int> selected;
  final int minTeams;
  final ValueChanged<int> onToggle;
  final ValueChanged<List<int>> onReplaceSelection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(teamsProvider);
    final listsAsync = ref.watch(teamListsProvider);
    final selectedSet = selected.toSet();

    return teamsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(friendlyErrorMessage(e))),
      data: (teams) {
        final lists = listsAsync.value ?? const <TeamList>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select teams',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${selected.length} selected · need at least $minTeams. '
                    'Seeding can be edited after creation in tournament settings.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.65),
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final team = await ref
                                .read(repositoryProvider)
                                .quickCreateTeam();
                            if (!context.mounted) return;
                            onToggle(team.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Added ${team.name}')),
                            );
                          },
                          icon: const Icon(Icons.flash_on),
                          label: const Text('Quick add'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: () => showTeamEditorSheet(context, ref),
                          icon: const Icon(Icons.add),
                          label: const Text('New team'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: TeamListPicker(
                  library: teams,
                  lists: lists,
                  selected: selectedSet,
                  onToggleTeam: onToggle,
                  onApplyList: (list) {
                    onReplaceSelection(list.teamIds.toList());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Loaded "${list.name}" (${list.teamIds.length} teams)',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (selected.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final nameCtrl = TextEditingController();
                    final name = await showDialog<String>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Save as team list'),
                        content: TextField(
                          controller: nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'List name',
                            hintText: 'e.g. Friday league',
                          ),
                          autofocus: true,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () =>
                                Navigator.pop(ctx, nameCtrl.text.trim()),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => nameCtrl.dispose(),
                    );
                    if (name == null || name.isEmpty) return;
                    await ref
                        .read(repositoryProvider)
                        .createTeamList(name: name, teamIds: selected.toList());
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Saved list "$name"')),
                      );
                    }
                  },
                  icon: const Icon(Icons.playlist_add),
                  label: const Text('Save selection as list'),
                ),
              ),
          ],
        );
      },
    );
  }
}
