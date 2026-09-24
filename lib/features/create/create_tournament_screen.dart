import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/features/create/tournament_teams_step.dart';
import 'package:tourneez/formats/standings_utils.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/ui/format_config_editor.dart';

class CreateTournamentScreen extends ConsumerStatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  ConsumerState<CreateTournamentScreen> createState() =>
      _CreateTournamentScreenState();
}

class _CreateTournamentScreenState
    extends ConsumerState<CreateTournamentScreen> {
  final _pageController = PageController();
  int _step = 0;

  final _nameController = TextEditingController();
  TournamentCategory _category = TournamentCategory.bracket;
  TournamentFormat _format = TournamentFormat.singleElimination;
  TournamentConfig _config =
      TournamentConfig.defaultsFor(TournamentFormat.singleElimination);
  final List<int> _selectedTeamIds = [];
  bool _saving = false;

  static const _totalSteps = 5;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _goTo(int step) {
    setState(() => _step = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  int get _minTeams => _format.minTeams;

  Future<void> _create({required bool startNow}) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _goTo(0);
      return;
    }
    if (_selectedTeamIds.length < _minTeams) {
      _goTo(4);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Select at least $_minTeams teams.')),
      );
      return;
    }

    setState(() => _saving = true);
    final repo = ref.read(repositoryProvider);
    try {
      var config = _config;
      final needsSwiss = _format == TournamentFormat.swiss ||
          (_format == TournamentFormat.hybrid &&
              config.leagueFormat == TournamentFormat.swiss);
      if (needsSwiss && config.swissRounds == null) {
        config = config.copyWith(
          swissRounds: defaultSwissRounds(_selectedTeamIds.length),
        );
      }

      final id = await repo.createTournament(
        name: name,
        format: _format,
        config: config,
        teamIds: _selectedTeamIds.toList(),
      );

      if (startNow) {
        final err = await repo.startTournament(id);
        if (err != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
        }
      }

      if (mounted) {
        context.go('/tournament/$id');
      }
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
          onPressed: () {
            if (_step > 0) {
              _goTo(_step - 1);
            } else if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('New tournament'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: LinearProgressIndicator(
            value: (_step + 1) / _totalSteps,
            minHeight: 3,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _NameStep(controller: _nameController),
          _CategoryStep(
            category: _category,
            onChanged: (c) => setState(() {
              _category = c;
              _format = c.formats.first;
              _config = TournamentConfig.defaultsFor(_format);
            }),
          ),
          _FormatStep(
            category: _category,
            format: _format,
            onChanged: (f) => setState(() {
              _format = f;
              _config = TournamentConfig.defaultsFor(f);
            }),
          ),
          _ConfigStep(
            format: _format,
            config: _config,
            onChanged: (c) => setState(() => _config = c),
            teamCount: _selectedTeamIds.length,
          ),
          TournamentTeamsStep(
            selected: _selectedTeamIds,
            minTeams: _minTeams,
            onToggle: (id) {
              setState(() {
                if (_selectedTeamIds.contains(id)) {
                  _selectedTeamIds.remove(id);
                } else {
                  _selectedTeamIds.add(id);
                }
              });
            },
            onReplaceSelection: (ids) {
              setState(() {
                _selectedTeamIds
                  ..clear()
                  ..addAll(ids);
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            12 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_step > 0)
                TextButton(
                  onPressed: _saving ? null : () => _goTo(_step - 1),
                  child: const Text('Back'),
                ),
              if (_step < _totalSteps - 1)
                FilledButton(
                  onPressed: () {
                    if (_step == 0 && _nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter a tournament name.'),
                        ),
                      );
                      return;
                    }
                    _goTo(_step + 1);
                  },
                  child: const Text('Next'),
                )
              else ...[
                OutlinedButton(
                  onPressed: _saving ? null : () => _create(startNow: false),
                  child: const Text('Save draft'),
                ),
                FilledButton(
                  onPressed: _saving ? null : () => _create(startNow: true),
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Start'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NameStep extends StatelessWidget {
  const _NameStep({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Name your event', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'You can host many tournaments at once — give this one a clear name.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
              ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Tournament name',
            hintText: 'e.g. Summer Cup 2026',
          ),
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
      ],
    );
  }
}

class _CategoryStep extends StatelessWidget {
  const _CategoryStep({required this.category, required this.onChanged});
  final TournamentCategory category;
  final ValueChanged<TournamentCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('What kind of event?', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Pick a category first — formats are filtered on the next step.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
              ),
        ),
        const SizedBox(height: 16),
        ...TournamentCategory.values.map((c) {
          final selected = c == category;
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            color: selected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
                : null,
            child: ListTile(
              leading: Icon(switch (c) {
                TournamentCategory.bracket => Icons.account_tree_outlined,
                TournamentCategory.league => Icons.table_rows_outlined,
                TournamentCategory.hybrid => Icons.hub_outlined,
              }),
              title: Text(c.label, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(c.description),
              trailing: selected
                  ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () => onChanged(c),
            ),
          );
        }),
      ],
    );
  }
}

class _FormatStep extends StatelessWidget {
  const _FormatStep({
    required this.category,
    required this.format,
    required this.onChanged,
  });
  final TournamentCategory category;
  final TournamentFormat format;
  final ValueChanged<TournamentFormat> onChanged;

  @override
  Widget build(BuildContext context) {
    final formats = category.formats;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          '${category.label} formats',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ...formats.map((f) {
          final selected = f == format;
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            color: selected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
                : null,
            child: ListTile(
              title: Text(f.label, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(f.description),
              trailing: selected
                  ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () => onChanged(f),
            ),
          );
        }),
      ],
    );
  }
}

class _ConfigStep extends StatelessWidget {
  const _ConfigStep({
    required this.format,
    required this.config,
    required this.onChanged,
    required this.teamCount,
  });

  final TournamentFormat format;
  final TournamentConfig config;
  final ValueChanged<TournamentConfig> onChanged;
  final int teamCount;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        FormatConfigEditor(
          format: format,
          config: config,
          onChanged: onChanged,
          teamCount: teamCount,
        ),
      ],
    );
  }
}
