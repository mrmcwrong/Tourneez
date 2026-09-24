import 'package:flutter/material.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/formats/standings_utils.dart';
import 'package:tourneez/ui/int_number_field.dart';

/// Shared tournament format options editor (create wizard + settings).
class FormatConfigEditor extends StatelessWidget {
  const FormatConfigEditor({
    super.key,
    required this.format,
    required this.config,
    required this.onChanged,
    this.teamCount = 0,
    this.enabled = true,
    this.showHybridPhasePickers = true,
    this.compact = false,
  });

  final TournamentFormat format;
  final TournamentConfig config;
  final ValueChanged<TournamentConfig> onChanged;
  final int teamCount;
  final bool enabled;
  final bool showHybridPhasePickers;
  final bool compact;

  bool get _showThirdPlace =>
      format == TournamentFormat.singleElimination ||
      (format == TournamentFormat.hybrid &&
          config.bracketFormat == TournamentFormat.singleElimination);

  bool get _showMeetings =>
      format == TournamentFormat.roundRobin ||
      format == TournamentFormat.groupsOnly ||
      (format == TournamentFormat.hybrid &&
          (config.leagueFormat == TournamentFormat.roundRobin ||
              config.leagueFormat == TournamentFormat.groupsOnly));

  bool get _showPoints =>
      format.showsStandings ||
      format == TournamentFormat.swiss ||
      format == TournamentFormat.hybrid;

  bool get _usesGroups => format.usesGroups(config);

  bool get _showSwissRounds =>
      format == TournamentFormat.swiss ||
      (format == TournamentFormat.hybrid &&
          config.leagueFormat == TournamentFormat.swiss);

  bool get _showSeriesOptions =>
      format.category == TournamentCategory.bracket ||
      (format == TournamentFormat.hybrid &&
          config.bracketFormat.isBracketFormat);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final muted = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.65),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          expandedAlignment: Alignment.centerLeft,
          maintainState: true,
          initiallyExpanded: false,
          title: Text('Format options', style: titleStyle),
          subtitle: Text(
            'Fixture and scoring settings for ${format.label}.',
            style: muted,
          ),
          children: [
            if (format == TournamentFormat.hybrid &&
                showHybridPhasePickers) ...[
              Text(
                'League phase',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              SegmentedButton<TournamentFormat>(
                segments: [
                  for (final f in hybridLeagueChoices)
                    ButtonSegment(value: f, label: Text(f.hybridPhaseLabel)),
                ],
                selected: {config.leagueFormat},
                onSelectionChanged: (s) {
                  if (!enabled) return;
                  final league = s.first;
                  onChanged(
                    config.copyWith(
                      leagueFormat: league,
                      meetingsPerPair:
                          league == TournamentFormat.groupsOnly ? 1 : 2,
                    ),
                  );
                },
              ),
              const SizedBox(height: 6),
              Text(config.leagueFormat.hybridPhaseDescription, style: muted),
              const SizedBox(height: 16),
              Text(
                'Bracket phase',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              SegmentedButton<TournamentFormat>(
                segments: [
                  for (final f in hybridBracketChoices)
                    ButtonSegment(value: f, label: Text(f.label)),
                ],
                selected: {config.bracketFormat},
                onSelectionChanged: (s) {
                  if (!enabled) return;
                  onChanged(config.copyWith(bracketFormat: s.first));
                },
              ),
              const SizedBox(height: 6),
              Text(config.bracketFormat.description, style: muted),
              const Divider(height: 28),
            ],
            if (_showPoints) ...[
              IntNumberField(
                label: 'Points for a win',
                value: config.pointsForWin,
                min: 1,
                max: 10,
                enabled: enabled,
                onChanged: (v) => onChanged(config.copyWith(pointsForWin: v)),
              ),
              IntNumberField(
                label: 'Points for a draw',
                value: config.pointsForDraw,
                min: 0,
                max: 10,
                enabled: enabled,
                onChanged: (v) => onChanged(config.copyWith(pointsForDraw: v)),
              ),
              IntNumberField(
                label: 'Points for a loss',
                value: config.pointsForLoss,
                min: 0,
                max: 10,
                enabled: enabled,
                onChanged: (v) => onChanged(config.copyWith(pointsForLoss: v)),
              ),
            ],
            if (_showMeetings)
              IntNumberField(
                label: 'Times each pair meets',
                value: config.meetingsPerPair,
                min: 1,
                max: 6,
                enabled: enabled,
                helperText: config.meetingsPerPair == 1
                    ? 'Each pairing plays once. Home/away is assigned automatically.'
                    : 'Home and away alternate each meeting.',
                onChanged: (v) =>
                    onChanged(config.copyWith(meetingsPerPair: v)),
              ),
            if (_showSwissRounds)
              IntNumberField(
                label: 'Swiss rounds',
                value: config.swissRounds ??
                    defaultSwissRounds(teamCount.clamp(4, 128)),
                min: 1,
                max: 30,
                enabled: enabled,
                helperText:
                    'How many Swiss pairing rounds before standings settle.',
                onChanged: (v) => onChanged(config.copyWith(swissRounds: v)),
              ),
            if (_usesGroups)
              IntNumberField(
                label: 'Group size',
                value: config.groupSize,
                min: 2,
                max: 12,
                enabled: enabled,
                onChanged: (v) => onChanged(config.copyWith(groupSize: v)),
              ),
            if (format == TournamentFormat.hybrid)
              IntNumberField(
                label: _usesGroups
                    ? 'Advance per group'
                    : 'Teams advancing to knockout',
                value: config.advancePerGroup,
                min: 1,
                max: _usesGroups ? config.groupSize : null,
                enabled: enabled,
                helperText: _usesGroups
                    ? 'How many teams from each group enter the bracket.'
                    : 'No upper limit — must not exceed enrolled teams when starting.',
                onChanged: (v) =>
                    onChanged(config.copyWith(advancePerGroup: v)),
              ),
            if (_showThirdPlace)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('3rd-place match'),
                subtitle: const Text(
                  'Losers of the semi-finals play for bronze.',
                ),
                value: config.includeThirdPlace,
                onChanged: enabled
                    ? (v) => onChanged(config.copyWith(includeThirdPlace: v))
                    : null,
              ),
            if (_showSeriesOptions) ...[
              Text(
                'Knockout series',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              _SeriesLengthChips(
                value: TournamentConfig.seriesLengthChoices
                        .contains(config.knockoutSeriesLength)
                    ? config.knockoutSeriesLength
                    : 1,
                enabled: enabled,
                onChanged: (v) =>
                    onChanged(config.copyWith(knockoutSeriesLength: v)),
              ),
              const SizedBox(height: 4),
              Text(
                'Single match, two-leg aggregate, or best-of series for knockout ties.',
                style: muted,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Series for final'),
                subtitle: const Text(
                  'Use a separate series length for the final / grand final.',
                ),
                value: config.finalSeriesEnabled,
                onChanged: enabled
                    ? (v) => onChanged(config.copyWith(finalSeriesEnabled: v))
                    : null,
              ),
              if (config.finalSeriesEnabled) ...[
                _SeriesLengthChips(
                  value: TournamentConfig.seriesLengthChoices
                          .contains(config.finalSeriesLength)
                      ? config.finalSeriesLength
                      : 1,
                  enabled: enabled,
                  onChanged: (v) =>
                      onChanged(config.copyWith(finalSeriesLength: v)),
                ),
              ],
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Randomize seeds at start'),
              subtitle: const Text(
                'Shuffle seeding when the tournament starts instead of enrollment order.',
              ),
              value: config.randomizeSeeds,
              onChanged: enabled
                  ? (v) => onChanged(config.copyWith(randomizeSeeds: v))
                  : null,
            ),
          ],
        ),
        if (_showPoints) ...[
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            expandedAlignment: Alignment.centerLeft,
            maintainState: true,
            title: Text('Tiebreakers', style: titleStyle),
            subtitle: Text(
              'Choose and prioritize ranking criteria.',
              style: muted,
            ),
            children: [
              Text(
                'Drag to set priority when teams are level. First item is checked first.',
                style: muted,
              ),
              const SizedBox(height: 8),
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: config.tiebreakers.length,
                onReorderItem: enabled
                    ? (oldIndex, newIndex) {
                        final list = List<Tiebreaker>.from(config.tiebreakers);
                        final item = list.removeAt(oldIndex);
                        list.insert(newIndex, item);
                        onChanged(config.copyWith(tiebreakers: list));
                      }
                    : (oldIndex, newIndex) {},
                itemBuilder: (context, index) {
                  final t = config.tiebreakers[index];
                  return ListTile(
                    key: ValueKey(t.name),
                    dense: true,
                    title: Text('${index + 1}. ${t.label}'),
                    trailing: enabled ? const Icon(Icons.drag_handle) : null,
                  );
                },
              ),
              Wrap(
                spacing: 6,
                children: [
                  for (final t in Tiebreaker.values)
                    if (!config.tiebreakers.contains(t))
                      ActionChip(
                        label: Text('+ ${t.label}'),
                        onPressed: enabled
                            ? () => onChanged(
                                  config.copyWith(
                                    tiebreakers: [...config.tiebreakers, t],
                                  ),
                                )
                            : null,
                      ),
                ],
              ),
              if (config.tiebreakers.length > 1)
                TextButton(
                  onPressed: enabled
                      ? () {
                          final list = List<Tiebreaker>.from(config.tiebreakers)
                            ..removeLast();
                          onChanged(config.copyWith(tiebreakers: list));
                        }
                      : null,
                  child: const Text('Remove last tiebreaker'),
                ),
            ],
          ),
        ],
        if (format.category == TournamentCategory.bracket && !compact) ...[
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bracket tips',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    format == TournamentFormat.doubleElimination
                        ? 'Two losses eliminate a team. The winners-bracket champ meets the losers-bracket champ in the grand final.'
                        : 'Byes fill the bracket to the next power of two. Higher seeds get preferred placement.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SeriesLengthChips extends StatelessWidget {
  const _SeriesLengthChips({
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final bool enabled;

  static String _label(int length) => switch (length) {
        1 => 'Single',
        2 => 'Two legs',
        3 => 'Best of 3',
        5 => 'Best of 5',
        7 => 'Best of 7',
        _ => 'Single',
      };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final len in TournamentConfig.seriesLengthChoices)
          ChoiceChip(
            label: Text(_label(len)),
            selected: value == len,
            onSelected: !enabled
                ? null
                : (selected) {
                    if (selected) onChanged(len);
                  },
          ),
      ],
    );
  }
}
