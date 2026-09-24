import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/domain/team_templates.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/ui/widgets.dart';

/// App-bar actions: Quick add + Templates menu.
List<Widget> teamLibraryActions(BuildContext context, WidgetRef ref) {
  return [
    IconButton(
      tooltip: 'Quick add',
      onPressed: () async {
        final team = await ref.read(repositoryProvider).quickCreateTeam();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added ${team.name} (PWR ${team.powerRating})'),
            ),
          );
        }
      },
      icon: const Icon(Icons.flash_on),
    ),
    IconButton(
      tooltip: 'Templates',
      onPressed: () => _showTemplatePicker(context, ref),
      icon: const Icon(Icons.collections_bookmark_outlined),
    ),
  ];
}

Future<void> _showTemplatePicker(BuildContext context, WidgetRef ref) async {
  final selected = <int>{};

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => StatefulBuilder(
      builder: (sheetContext, setLocal) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.75,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Add template teams',
                        style: Theme.of(sheetContext).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cancel',
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Select templates to add. If a template is already in your '
                  'library, another copy is added as “Name 2”, “Name 3”, and so on.',
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: teamTemplates.length,
                  itemBuilder: (context, index) {
                    final template = teamTemplates[index];
                    return CheckboxListTile(
                      value: selected.contains(index),
                      onChanged: (value) => setLocal(() {
                        if (value == true) {
                          selected.add(index);
                        } else {
                          selected.remove(index);
                        }
                      }),
                      secondary: TeamLogo(
                        path: template.assetPath,
                        name: template.name,
                        colorArgb: template.colorArgb,
                      ),
                      title: Text(template.name),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: selected.isEmpty
                      ? null
                      : () async {
                          final repo = ref.read(repositoryProvider);
                          for (final index in selected.toList()..sort()) {
                            await repo.createDuplicateTeamFromTemplate(
                              teamTemplates[index],
                            );
                          }
                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext);
                          }
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added ${selected.length} template '
                                  'team${selected.length == 1 ? '' : 's'}.',
                                ),
                              ),
                            );
                          }
                        },
                  child: Text('Add selected (${selected.length})'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

enum TeamRosterSort { nameAsc, nameDesc, powerHigh, powerLow }

/// Teams / Lists picker used in tournament create and league roster sheets.
class TeamListPicker extends StatefulWidget {
  const TeamListPicker({
    super.key,
    required this.library,
    required this.lists,
    required this.selected,
    required this.onToggleTeam,
    required this.onApplyList,
    this.occupiedElsewhere = const {},
    this.showSeedHint = false,
  });

  final List<Team> library;
  final List<TeamList> lists;
  final Set<int> selected;
  final ValueChanged<int> onToggleTeam;
  final void Function(TeamList list) onApplyList;
  final Map<int, String> occupiedElsewhere;
  final bool showSeedHint;

  @override
  State<TeamListPicker> createState() => _TeamListPickerState();
}

class _TeamListPickerState extends State<TeamListPicker> {
  TeamRosterSort _sort = TeamRosterSort.nameAsc;

  List<Team> get _sortedLibrary {
    final list = List<Team>.from(widget.library);
    switch (_sort) {
      case TeamRosterSort.nameAsc:
        list.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      case TeamRosterSort.nameDesc:
        list.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
      case TeamRosterSort.powerHigh:
        list.sort((a, b) {
          final byPower = b.powerRating.compareTo(a.powerRating);
          if (byPower != 0) return byPower;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      case TeamRosterSort.powerLow:
        list.sort((a, b) {
          final byPower = a.powerRating.compareTo(b.powerRating);
          if (byPower != 0) return byPower;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Teams'),
              Tab(text: 'Lists'),
            ],
          ),
          if (widget.showSeedHint)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${widget.selected.length} selected',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            child: SegmentedButton<TeamRosterSort>(
              segments: const [
                ButtonSegment(
                  value: TeamRosterSort.nameAsc,
                  label: Text('A–Z'),
                  icon: Icon(Icons.sort_by_alpha, size: 16),
                ),
                ButtonSegment(
                  value: TeamRosterSort.powerHigh,
                  label: Text('Power'),
                  icon: Icon(Icons.bolt, size: 16),
                ),
              ],
              emptySelectionAllowed: false,
              showSelectedIcon: false,
              selected: {
                _sort == TeamRosterSort.nameDesc
                    ? TeamRosterSort.nameAsc
                    : (_sort == TeamRosterSort.powerLow
                        ? TeamRosterSort.powerHigh
                        : _sort),
              },
              onSelectionChanged: (s) {
                final next = s.first;
                setState(() {
                  if (next == TeamRosterSort.nameAsc) {
                    _sort = _sort == TeamRosterSort.nameAsc
                        ? TeamRosterSort.nameDesc
                        : TeamRosterSort.nameAsc;
                  } else {
                    _sort = _sort == TeamRosterSort.powerHigh
                        ? TeamRosterSort.powerLow
                        : TeamRosterSort.powerHigh;
                  }
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              switch (_sort) {
                TeamRosterSort.nameAsc => 'Sorted by name (A–Z)',
                TeamRosterSort.nameDesc => 'Sorted by name (Z–A)',
                TeamRosterSort.powerHigh => 'Sorted by power (high → low)',
                TeamRosterSort.powerLow => 'Sorted by power (low → high)',
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.55),
                  ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _TeamsPane(
                  library: _sortedLibrary,
                  selected: widget.selected,
                  occupiedElsewhere: widget.occupiedElsewhere,
                  onToggleTeam: widget.onToggleTeam,
                ),
                _ListsPane(
                  lists: widget.lists,
                  onApplyList: widget.onApplyList,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamsPane extends StatelessWidget {
  const _TeamsPane({
    required this.library,
    required this.selected,
    required this.occupiedElsewhere,
    required this.onToggleTeam,
  });

  final List<Team> library;
  final Set<int> selected;
  final Map<int, String> occupiedElsewhere;
  final ValueChanged<int> onToggleTeam;

  @override
  Widget build(BuildContext context) {
    if (library.isEmpty) {
      return const Center(
        child: Text('No teams in your library yet.'),
      );
    }
    return ListView.builder(
      itemCount: library.length,
      itemBuilder: (context, index) {
        final team = library[index];
        final elsewhere = occupiedElsewhere[team.id];
        final taken = elsewhere != null;
        return Card(
          color: selected.contains(team.id) && !taken
              ? teamRowTint(team.colorArgb)
              : null,
          margin: const EdgeInsets.only(bottom: 6, top: 2),
          child: CheckboxListTile(
            value: selected.contains(team.id),
            title: Text(team.name),
            subtitle: taken
                ? Text('In $elsewhere')
                : Text('Power ${team.powerRating}'),
            secondary: TeamLogo(
              path: team.logoPath,
              name: team.name,
              colorArgb: team.colorArgb,
            ),
            enabled: !taken,
            onChanged: taken ? null : (_) => onToggleTeam(team.id),
          ),
        );
      },
    );
  }
}

class _ListsPane extends StatelessWidget {
  const _ListsPane({
    required this.lists,
    required this.onApplyList,
  });

  final List<TeamList> lists;
  final void Function(TeamList list) onApplyList;

  @override
  Widget build(BuildContext context) {
    if (lists.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No saved lists yet. Create one on the Teams → Lists tab.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: lists.length,
      separatorBuilder: (_, _) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final list = lists[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.playlist_add_check),
            title: Text(list.name),
            subtitle: Text('${list.teamIds.length} teams'),
            trailing: const Icon(Icons.add_circle_outline),
            onTap: () => onApplyList(list),
          ),
        );
      },
    );
  }
}
