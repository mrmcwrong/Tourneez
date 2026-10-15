import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourneez/data/logo_storage.dart';
import 'package:tourneez/domain/match_odds.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/domain/venue_maps.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/ui/hsv_color_picker.dart';
import 'package:tourneez/ui/venue_editor.dart';
import 'package:tourneez/ui/widgets.dart';

Future<Team?> showTeamEditorSheet(
  BuildContext context,
  WidgetRef ref, {
  Team? team,
}) {
  return showModalBottomSheet<Team?>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useRootNavigator: true,
    builder: (ctx) => TeamEditorSheet(team: team),
  );
}

class TeamEditorSheet extends ConsumerStatefulWidget {
  const TeamEditorSheet({super.key, this.team});
  final Team? team;

  @override
  ConsumerState<TeamEditorSheet> createState() => _TeamEditorSheetState();
}

class _TeamEditorSheetState extends ConsumerState<TeamEditorSheet> {
  late final TextEditingController _name;
  String? _pickedPath;
  String? _pickedPreview;
  bool _clearLogo = false;
  bool _saving = false;
  late int _colorArgb;
  late bool _showLogoCircle;
  late double _power;
  int? _homeVenueId;
  String? _homeVenueLabel;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.team?.name ?? '');
    _colorArgb = widget.team?.colorArgb ?? presetTeamColors.first;
    _showLogoCircle = widget.team?.showLogoCircle ?? true;
    _power = (widget.team?.powerRating ?? 50).toDouble();
    _homeVenueId = widget.team?.homeVenueId;
    _homeVenueLabel = widget.team?.homeLocation;
    if (_homeVenueId != null &&
        (_homeVenueLabel == null || _homeVenueLabel!.isEmpty)) {
      _homeVenueLabel = 'Venue #$_homeVenueId';
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (file != null) {
      final preview = await persistLogoFile(file.path);
      if (!mounted) return;
      setState(() {
        _pickedPath = file.path;
        _pickedPreview = preview;
        _clearLogo = false;
      });
    }
  }

  Future<void> _pickHomeVenue() async {
    final picked = await showVenuePickerSheet(
      context,
      ref,
      selectedId: _homeVenueId,
    );
    if (!mounted) return;
    if (picked == false) {
      setState(() {
        _homeVenueId = null;
        _homeVenueLabel = null;
      });
      return;
    }
    if (picked is! Venue) return;
    await _applyHomeVenue(picked);
  }

  Future<void> _createHomeVenue() async {
    final created = await showVenueEditorSheet(context, ref);
    if (!mounted || created == null) return;
    await _applyHomeVenue(created);
  }

  Future<void> _applyHomeVenue(Venue venue) async {
    Venue? parent;
    if (venue.parentVenueId != null) {
      parent = await ref.read(repositoryProvider).getVenue(venue.parentVenueId!);
    }
    if (!mounted) return;
    setState(() {
      _homeVenueId = venue.id;
      _homeVenueLabel = venueDisplayLabel(venue, parent: parent);
    });
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    final repo = ref.read(repositoryProvider);
    try {
      final int id;
      if (widget.team == null) {
        id = await repo.createTeam(
          name: name,
          sourceLogoPath: _pickedPath,
          colorArgb: _colorArgb,
          powerRating: _power.round(),
          homeVenueId: _homeVenueId,
          showLogoCircle: _showLogoCircle,
        );
      } else {
        id = widget.team!.id;
        await repo.updateTeam(
          id: id,
          name: name,
          sourceLogoPath: _pickedPath,
          clearLogo: _clearLogo,
          colorArgb: _colorArgb,
          powerRating: _power.round(),
          homeVenueId: _homeVenueId,
          clearHomeVenue: _homeVenueId == null,
          showLogoCircle: _showLogoCircle,
        );
      }
      final saved = await repo.getTeam(id);
      if (mounted) Navigator.pop(context, saved);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _clearStats() async {
    final team = widget.team;
    if (team == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear career stats?'),
        content: Text(
          'Clear all titles, promotions, relegations, and match stats '
          'for ${team.name}? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await ref.read(repositoryProvider).resetTeamStats(team.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final previewPath = _clearLogo
        ? null
        : (_pickedPreview ?? widget.team?.logoPath);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final teamColor = Color(_colorArgb);
    final team = widget.team;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.team == null ? 'New team' : 'Edit team',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: 'Cancel',
                  onPressed: _saving ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                const SizedBox(width: 4),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.team == null ? 'Create' : 'Save'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Changes apply everywhere this team is used.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: _pickLogo,
                child: Stack(
                  children: [
                    _showLogoCircle
                        ? Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              shape: BoxShape.circle,
                            ),
                            child: TeamLogo(
                              path: previewPath,
                              name: _name.text.isEmpty ? 'T' : _name.text,
                              colorArgb: _colorArgb,
                              size: 112,
                            ),
                          )
                        : TeamLogo(
                            path: previewPath,
                            name: _name.text.isEmpty ? 'T' : _name.text,
                            colorArgb: _colorArgb,
                            size: 140,
                          ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Background circle'),
              subtitle: const Text(
                'White disc behind the logo on the parent page. '
                'Turn off when it clashes with the logo.',
              ),
              value: _showLogoCircle,
              onChanged: (v) => setState(() => _showLogoCircle = v),
            ),
            if (previewPath != null)
              TextButton(
                onPressed: () => setState(() {
                  _pickedPath = null;
                  _pickedPreview = null;
                  _clearLogo = true;
                }),
                child: const Text('Remove logo'),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Team name',
                hintText: 'e.g. Northside FC',
              ),
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.place_outlined),
              title: const Text('Home venue'),
              subtitle: Text(_homeVenueLabel ?? 'None â€” optional'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickHomeVenue,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _createHomeVenue,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create venue'),
              ),
            ),
            Text(
              'Optional. Create a new venue or pick one from your library.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 16),
            HsvColorPicker(
              colorArgb: _colorArgb,
              onChanged: (argb) => setState(() => _colorArgb = argb),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Power rating',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                PowerBadge(power: _power.round()),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: teamColor,
                thumbColor: teamColor,
                overlayColor: teamColor.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: _power,
                min: 1,
                max: 100,
                divisions: 99,
                label: '${_power.round()}',
                onChanged: (v) => setState(() => _power = v),
              ),
            ),
            Text(
              'Higher power = better win odds when simulating match results.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            if (team != null) ...[
              const SizedBox(height: 20),
              Text(
                'Career stats',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                team.titles.isEmpty
                    ? 'Titles: none yet'
                    : 'Titles: ${team.titles.length}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (team.titles.isNotEmpty) ...[
                const SizedBox(height: 6),
                for (final title in team.titles.reversed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 8),
              Text(
                'Promotions ${team.promotionsWon} · '
                'Relegations ${team.relegations}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'P ${team.careerPlayed} · W ${team.careerWon} · '
                'D ${team.careerDrawn} · L ${team.careerLost}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'GF ${team.careerGoalsFor} · GA ${team.careerGoalsAgainst} · '
                'GD ${team.careerGoalDifference}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _clearStats,
                child: const Text('Clear stats'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
