import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/ui/theme.dart';
import 'package:tourneez/ui/widgets.dart';

const _matchWidth = 148.0;
const _matchHeight = 148.0;
const _simpleMatchWidth = 132.0;
const _simpleMatchHeight = 132.0;
const _roundGap = 48.0;
const _pad = 16.0;

/// Classic horizontal elimination bracket with connector lines.
class BracketView extends StatefulWidget {
  const BracketView({
    super.key,
    required this.matches,
    required this.teamsById,
    this.onMatchTap,
    this.simplified = false,
  });

  final List<Match> matches;
  final Map<int, TournamentTeam> teamsById;
  final ValueChanged<Match>? onMatchTap;
  final bool simplified;

  @override
  State<BracketView> createState() => _BracketViewState();
}

class _BracketViewState extends State<BracketView> {
  final _transform = TransformationController();
  static const _minScale = 0.4;
  static const _maxScale = 3.0;

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _zoomBy(double factor) {
    final current = _transform.value.getMaxScaleOnAxis();
    final next = (current * factor).clamp(_minScale, _maxScale);
    final focal = Offset.zero;
    final sceneFocal = _transform.toScene(focal);
    final matrix = Matrix4.identity()
      ..translateByDouble(sceneFocal.dx, sceneFocal.dy, 0, 1)
      ..scaleByDouble(next / current, next / current, 1, 1)
      ..translateByDouble(-sceneFocal.dx, -sceneFocal.dy, 0, 1);
    _transform.value = matrix * _transform.value;
  }

  void _resetZoom() {
    _transform.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    final bracket = widget.matches.where((m) => m.isBracketMatch).toList();
    if (bracket.isEmpty) {
      return const EmptyState(
        icon: Icons.account_tree_outlined,
        title: 'No bracket yet',
        message: 'Knockout matches will appear here when the bracket starts.',
      );
    }

    final stages = <MatchStage, List<Match>>{};
    for (final m in bracket) {
      stages.putIfAbsent(m.stage, () => []).add(m);
    }

    final stageOrder = [
      MatchStage.winners,
      MatchStage.knockout,
      MatchStage.losers,
      MatchStage.grandFinal,
    ];

    return Stack(
      children: [
        // Absorb horizontal pans so TabBar / outer scrollers don't steal them.
        NotificationListener<ScrollNotification>(
          onNotification: (_) => true,
          child: InteractiveViewer(
            transformationController: _transform,
            minScale: _minScale,
            maxScale: _maxScale,
            boundaryMargin: const EdgeInsets.all(200),
            constrained: false,
            panEnabled: true,
            scaleEnabled: true,
            // One layer for the whole bracket keeps panning cheap.
            child: RepaintBoundary(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 64),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final stage in stageOrder)
                      if (stages.containsKey(stage)) ...[
                        if (stages.length > 1)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                            child: Text(
                              _stageTitle(stage),
                              style: TourneezText.section,
                            ),
                          ),
                        _TreeBracket(
                          matches: stages[stage]!,
                          teamsById: widget.teamsById,
                          onMatchTap: widget.onMatchTap,
                          simplified: widget.simplified,
                        ),
                      ],
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 12,
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Zoom out',
                  onPressed: () => _zoomBy(1 / 1.25),
                  icon: const Icon(Icons.remove),
                ),
                IconButton(
                  tooltip: 'Reset zoom',
                  onPressed: _resetZoom,
                  icon: const Icon(Icons.center_focus_weak),
                ),
                IconButton(
                  tooltip: 'Zoom in',
                  onPressed: () => _zoomBy(1.25),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _stageTitle(MatchStage stage) => switch (stage) {
        MatchStage.winners => 'Winners bracket',
        MatchStage.losers => 'Losers bracket',
        MatchStage.grandFinal => 'Grand final',
        MatchStage.knockout => 'Knockout',
        _ => stage.name,
      };
}

class _TreeBracket extends StatelessWidget {
  const _TreeBracket({
    required this.matches,
    required this.teamsById,
    this.onMatchTap,
    this.simplified = false,
  });

  final List<Match> matches;
  final Map<int, TournamentTeam> teamsById;
  final ValueChanged<Match>? onMatchTap;
  final bool simplified;

  double get _mw => simplified ? _simpleMatchWidth : _matchWidth;
  double get _mh => simplified ? _simpleMatchHeight : _matchHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rounds = matches.map((m) => m.round).toSet().toList()..sort();
    if (rounds.isEmpty) return const SizedBox.shrink();

    final columns = <_BracketColumn>[];
    for (final r in rounds) {
      final list = matches
          .where((m) => m.round == r)
          .sorted(
            (a, b) => (a.bracketSlot ?? 0).compareTo(b.bracketSlot ?? 0),
          )
          .toList();
      final mains = list.where((m) => m.groupLabel != '3rd Place').toList();
      final thirds = list.where((m) => m.groupLabel == '3rd Place').toList();
      if (mains.isNotEmpty) {
        columns.add(
          _BracketColumn(
            round: r,
            matches: mains,
            label: _roundLabel(
              roundsFromEnd: rounds.length - rounds.indexOf(r),
              isThirdPlace: false,
              stage: mains.first.stage,
            ),
          ),
        );
      }
      if (thirds.isNotEmpty) {
        columns.add(
          _BracketColumn(
            round: r,
            matches: thirds,
            label: '3rd place',
          ),
        );
      }
    }

    final firstCount = columns.first.matches.length;
    final totalHeight =
        math.max(1, firstCount) * (_mh + 12) + _pad * 2;
    final totalWidth = columns.length * _mw +
        (columns.length - 1) * _roundGap +
        _pad * 2;

    final centers = <int, Offset>{};
    for (var ci = 0; ci < columns.length; ci++) {
      final list = columns[ci].matches;
      final spacing = totalHeight / list.length;
      for (var i = 0; i < list.length; i++) {
        final m = list[i];
        if (m.bracketSlot == null) continue;
        final left = _pad + ci * (_mw + _roundGap);
        final top = spacing * i + (spacing - _mh) / 2;
        centers[m.bracketSlot!] = Offset(left + _mw, top + _mh / 2);
      }
    }

    final lineColor = theme.colorScheme.outline.withValues(alpha: 0.45);

    return SizedBox(
      width: totalWidth,
      height: totalHeight + 28,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 28,
            bottom: 0,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _BracketLinesPainter(
                  matches: matches,
                  centers: centers,
                  color: lineColor,
                  matchWidth: _mw,
                ),
              ),
            ),
          ),
          for (var ci = 0; ci < columns.length; ci++) ...[
            Positioned(
              left: _pad + ci * (_mw + _roundGap),
              top: 0,
              width: _mw,
              child: Text(
                columns[ci].label,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ...() {
              final list = columns[ci].matches;
              final spacing = totalHeight / list.length;
              return [
                for (var i = 0; i < list.length; i++)
                  Positioned(
                    left: _pad + ci * (_mw + _roundGap),
                    top: 28 + spacing * i + (spacing - _mh) / 2,
                    width: _mw,
                    height: _mh,
                    child: RepaintBoundary(
                      child: _BracketMatchCard(
                        match: list[i],
                        home: list[i].homeTeamId != null
                            ? teamsById[list[i].homeTeamId!]
                            : null,
                        away: list[i].awayTeamId != null
                            ? teamsById[list[i].awayTeamId!]
                            : null,
                        simplified: simplified,
                        onTap: _canTap(list[i])
                            ? () => onMatchTap!(list[i])
                            : null,
                      ),
                    ),
                  ),
              ];
            }(),
          ],
        ],
      ),
    );
  }

  bool _canTap(Match match) {
    if (onMatchTap == null) return false;
    if (match.isBye) return false;
    return match.homeTeamId != null && match.awayTeamId != null;
  }

  String _roundLabel({
    required int roundsFromEnd,
    required bool isThirdPlace,
    required MatchStage stage,
  }) {
    if (isThirdPlace) return '3rd place';
    if (stage == MatchStage.grandFinal) return 'Grand final';
    return switch (roundsFromEnd) {
      1 => 'Final',
      2 => 'Semis',
      3 => 'Quarters',
      _ => 'R$roundsFromEnd',
    };
  }
}

class _BracketColumn {
  const _BracketColumn({
    required this.round,
    required this.matches,
    required this.label,
  });

  final int round;
  final List<Match> matches;
  final String label;
}

class _BracketLinesPainter extends CustomPainter {
  _BracketLinesPainter({
    required this.matches,
    required this.centers,
    required this.color,
    required this.matchWidth,
  });

  final List<Match> matches;
  final Map<int, Offset> centers;
  final Color color;
  final double matchWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final m in matches) {
      final parentSlot = m.winnerAdvancesTo;
      if (parentSlot == null || m.bracketSlot == null) continue;
      final from = centers[m.bracketSlot!];
      final to = centers[parentSlot];
      if (from == null || to == null) continue;

      final midX = (from.dx + to.dx) / 2;
      final path = Path()
        ..moveTo(from.dx, from.dy)
        ..lineTo(midX, from.dy)
        ..lineTo(midX, to.dy)
        ..lineTo(to.dx - matchWidth, to.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BracketLinesPainter oldDelegate) =>
      oldDelegate.matches != matches ||
      oldDelegate.centers != centers ||
      oldDelegate.matchWidth != matchWidth;
}

class _BracketMatchCard extends StatelessWidget {
  const _BracketMatchCard({
    required this.match,
    required this.home,
    required this.away,
    this.onTap,
    this.simplified = false,
  });

  final Match match;
  final TournamentTeam? home;
  final TournamentTeam? away;
  final VoidCallback? onTap;
  final bool simplified;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isThird = match.groupLabel == '3rd Place';
    final isGrandFinal = match.stage == MatchStage.grandFinal;
    final score = match.isBye
        ? 'BYE'
        : match.isCompleted
            ? '${match.homeScore}–${match.awayScore}'
            : 'vs';

    final badge = isThird
        ? '3RD PLACE'
        : isGrandFinal
            ? 'GRAND FINAL'
            : (match.winnerAdvancesTo == null &&
                    match.stage == MatchStage.knockout &&
                    !isThird
                ? 'FINAL'
                : null);

    final homeHighlight = match.isCompleted &&
        match.winnerTeamId != null &&
        match.winnerTeamId == match.homeTeamId;
    final awayHighlight = match.isCompleted &&
        match.winnerTeamId != null &&
        match.winnerTeamId == match.awayTeamId;

    return Material(
      color: scheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isThird || isGrandFinal || badge == 'FINAL'
              ? scheme.primary.withValues(alpha: 0.55)
              : scheme.outline.withValues(alpha: 0.25),
          width: isThird || isGrandFinal || badge == 'FINAL' ? 1.6 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            simplified ? 10 : 8,
            simplified ? 10 : 4,
            simplified ? 10 : 8,
            simplified ? 10 : 4,
          ),
          child: simplified
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Side(
                      team: home,
                      placeholder:
                          match.homeTeamId == null ? 'TBD' : null,
                      highlight: homeHighlight,
                      simplified: true,
                      scoreText: match.isBye
                          ? ''
                          : match.isCompleted
                              ? '${match.homeScore}'
                              : '–',
                    ),
                    _Side(
                      team: away,
                      placeholder: match.isBye
                          ? 'Bye'
                          : (match.awayTeamId == null ? 'TBD' : null),
                      highlight: awayHighlight,
                      simplified: true,
                      scoreText: match.isBye
                          ? 'BYE'
                          : match.isCompleted
                              ? '${match.awayScore}'
                              : '–',
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (badge != null)
                      Text(
                        badge,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                          color: scheme.primary,
                        ),
                      ),
                    _Side(
                      team: home,
                      placeholder:
                          match.homeTeamId == null ? 'TBD' : null,
                      highlight: homeHighlight,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                        score,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          height: 1.1,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                    _Side(
                      team: away,
                      placeholder: match.isBye
                          ? 'Bye'
                          : (match.awayTeamId == null ? 'TBD' : null),
                      highlight: awayHighlight,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({
    required this.team,
    this.placeholder,
    this.highlight = false,
    this.simplified = false,
    this.scoreText,
  });

  final TournamentTeam? team;
  final String? placeholder;
  final bool highlight;
  final bool simplified;
  final String? scoreText;

  @override
  Widget build(BuildContext context) {
    final name = team?.displayName ?? placeholder ?? '—';
    final logo = TeamLogo(
      path: team?.logoPath,
      name: name,
      colorArgb: team?.colorArgb,
      size: simplified ? 58 : 28,
    );
    if (simplified) {
      return Row(
        children: [
          DecoratedBox(
            decoration: highlight
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  )
                : const BoxDecoration(),
            child: logo,
          ),
          const Spacer(),
          Text(
            scoreText ?? '–',
            style: TextStyle(
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w700,
              fontSize: 16,
              color: highlight
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        logo,
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
              color: highlight
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
