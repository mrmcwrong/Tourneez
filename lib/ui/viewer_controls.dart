import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/providers/viewer_provider.dart';

/// Persistent strip so a family-view session is obvious on a single device.
class ViewerModeBanner extends ConsumerWidget {
  const ViewerModeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewer = ref.watch(viewerProvider);
    if (viewer.isManager) return const SizedBox.shrink();

    final teams = ref.watch(teamsProvider).asData?.value ?? const <Team>[];
    final team = teams.where((t) => t.id == viewer.familyTeamId).firstOrNull;
    final scheme = Theme.of(context).colorScheme;
    final label = team == null
        ? 'Viewing as coach / parent · all teams'
        : 'Viewing as coach / parent · ${team.name}';

    return Material(
      color: scheme.tertiaryContainer,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 32,
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.onTertiaryContainer,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class ViewerSwitcherCard extends ConsumerWidget {
  const ViewerSwitcherCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewer = ref.watch(viewerProvider);
    final teams = ref.watch(teamsProvider).asData?.value ?? const <Team>[];
    final selected = teams.where((t) => t.id == viewer.familyTeamId).firstOrNull;
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('View as', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              'Switch on this device to preview the coach/parent screens. '
              'Leagues stay in one database.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.65),
                  ),
            ),
            const SizedBox(height: 12),
            SegmentedButton<AppRole>(
              segments: const [
                ButtonSegment(
                  value: AppRole.manager,
                  label: Text('Manager'),
                  icon: Icon(Icons.admin_panel_settings_outlined),
                ),
                ButtonSegment(
                  value: AppRole.family,
                  label: Text('Coach / parent'),
                  icon: Icon(Icons.family_restroom_outlined),
                ),
              ],
              selected: {viewer.role},
              onSelectionChanged: (next) {
                ref.read(viewerProvider.notifier).setRole(next.first);
              },
            ),
            if (viewer.isFamily) ...[
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.groups_outlined),
                title: const Text('Looking as'),
                subtitle: Text(selected?.name ?? 'All teams'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _pickTeam(context, ref, teams, viewer.familyTeamId),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickTeam(
    BuildContext context,
    WidgetRef ref,
    List<Team> teams,
    int? selectedId,
  ) async {
    final picked = await showModalBottomSheet<Object?>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: const Text('All teams'),
              trailing: selectedId == null ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(ctx, false),
            ),
            for (final team in teams)
              ListTile(
                title: Text(team.name),
                trailing: selectedId == team.id ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(ctx, team),
              ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    if (picked == false) {
      await ref.read(viewerProvider.notifier).setFamilyTeam(null);
    } else if (picked is Team) {
      await ref.read(viewerProvider.notifier).setFamilyTeam(picked.id);
    }
  }
}

/// Toggles a manager uses to decide what coach/parent screens include.
class FamilyViewSettingsCard extends StatelessWidget {
  const FamilyViewSettingsCard({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final FamilyViewSettings settings;
  final ValueChanged<FamilyViewSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'What families see',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Text(
                'Coach and parent view stays read-only. These toggles hide sections.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.65),
                    ),
              ),
            ),
            SwitchListTile(
              title: const Text('Schedule'),
              value: settings.showSchedule,
              onChanged: (v) => onChanged(settings.copyWith(showSchedule: v)),
            ),
            SwitchListTile(
              title: const Text('Scores and bracket'),
              value: settings.showScores,
              onChanged: (v) => onChanged(settings.copyWith(showScores: v)),
            ),
            SwitchListTile(
              title: const Text('Standings'),
              value: settings.showStandings,
              onChanged: (v) => onChanged(settings.copyWith(showStandings: v)),
            ),
            SwitchListTile(
              title: const Text('Venues and field map'),
              value: settings.showVenues,
              onChanged: (v) => onChanged(settings.copyWith(showVenues: v)),
            ),
            SwitchListTile(
              title: const Text('Power ratings'),
              subtitle: const Text('Off by default'),
              value: settings.showPower,
              onChanged: (v) => onChanged(settings.copyWith(showPower: v)),
            ),
          ],
        ),
      ),
    );
  }
}
