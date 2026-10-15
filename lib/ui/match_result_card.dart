import 'package:flutter/material.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/domain/schedule_format.dart';
import 'package:tourneez/ui/widgets.dart';

/// Match row used on the parent games list. Simple shows logos and the score;
/// the full view adds names, kickoff, and venue.
class MatchResultCard extends StatelessWidget {
  const MatchResultCard({
    super.key,
    required this.match,
    required this.home,
    required this.away,
    required this.simplified,
    this.onTap,
    this.venueLabel,
  });

  final Match match;
  final TournamentTeam? home;
  final TournamentTeam? away;
  final bool simplified;
  final VoidCallback? onTap;
  final String? venueLabel;

  @override
  Widget build(BuildContext context) {
    final series = match.series;
    final scoreText = match.isBye
        ? 'BYE'
        : match.isCompleted
            ? '${match.homeScore} – ${match.awayScore}'
            : (series != null && series.length > 1 && series.legs.isNotEmpty)
                ? '${series.seriesHomeScore} – ${series.seriesAwayScore}'
                : (series != null && series.length > 1)
                    ? (series.length == 2 ? '2 legs' : 'Bo${series.length}')
                    : 'vs';

    final scheme = Theme.of(context).colorScheme;
    final tint = home?.colorArgb != null
        ? teamRowTint(home!.colorArgb, alpha: 0.10)
        : scheme.surface;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: tint,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: simplified ? 8 : 12,
            vertical: simplified ? 16 : 12,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _Side(
                      team: home,
                      placeholder: match.homeTeamId == null ? 'TBD' : null,
                      alignEnd: false,
                      simplified: simplified,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surface.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: scheme.outline.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            scoreText,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: simplified ? 18 : 16,
                            ),
                          ),
                          if (!simplified && match.groupLabel != null)
                            Text(
                              match.groupLabel!,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _Side(
                      team: away,
                      placeholder: match.isBye
                          ? 'Bye'
                          : (match.awayTeamId == null ? 'TBD' : null),
                      alignEnd: true,
                      simplified: simplified,
                    ),
                  ),
                ],
              ),
              Builder(
                builder: (context) {
                  final place = (venueLabel != null &&
                          venueLabel!.trim().isNotEmpty)
                      ? venueLabel!.trim()
                      : (match.location != null &&
                              match.location!.trim().isNotEmpty)
                          ? match.location!.trim()
                          : home?.homeLocation?.trim();
                  final meta = [
                    if (!simplified && match.scheduledAt != null)
                      formatMatchKickoff(match.scheduledAt!),
                    if (place != null && place.isNotEmpty) place,
                  ];
                  if (meta.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      meta.join(' · '),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.55),
                          ),
                    ),
                  );
                },
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
    required this.alignEnd,
    required this.simplified,
    this.placeholder,
  });

  final TournamentTeam? team;
  final bool alignEnd;
  final bool simplified;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final name = team?.displayName ?? placeholder ?? '—';
    if (simplified) {
      final width = MediaQuery.sizeOf(context).width;
      final logoSize = (width * 0.2).clamp(56.0, 92.0);
      return Center(
        child: TeamLogo(
          path: team?.logoPath,
          name: name,
          colorArgb: team?.colorArgb,
          size: logoSize,
        ),
      );
    }
    final logo = TeamLogo(
      path: team?.logoPath,
      name: name,
      colorArgb: team?.colorArgb,
      size: 32,
    );
    final children = [
      logo,
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          name,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    ];
    return Row(
      mainAxisAlignment:
          alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: alignEnd ? children.reversed.toList() : children,
    );
  }
}
