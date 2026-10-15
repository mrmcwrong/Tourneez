import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tourneez/data/logo_storage.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/domain/schedule_format.dart';
import 'package:tourneez/domain/venue_maps.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/providers/viewer_provider.dart';
import 'package:tourneez/ui/match_result_card.dart';
import 'package:tourneez/ui/theme.dart';
import 'package:tourneez/ui/viewer_controls.dart';
import 'package:tourneez/ui/widgets.dart';

/// The competition a parent is looking at: the team's current event, if any.
final parentEventProvider =
    FutureProvider<({Tournament tournament, League? league})?>((ref) async {
  final viewer = ref.watch(viewerProvider);
  final teamId = viewer.familyTeamId;
  if (!viewer.isFamily || teamId == null) return null;

  final repo = ref.watch(repositoryProvider);
  final enrolled = await repo.getTournamentsForTeam(teamId);
  if (enrolled.isEmpty) return null;

  final currentSeasonIds = <int>{};
  final leagues = <int, League>{};
  final seenLeagues = <int>{};
  for (final tournament in enrolled) {
    final leagueId = tournament.leagueId;
    if (leagueId == null || !seenLeagues.add(leagueId)) continue;
    final league = await repo.getLeague(leagueId);
    if (league != null) leagues[leagueId] = league;
    final divisions = await repo.getDivisions(leagueId);
    for (final division in divisions) {
      final current = division.currentTournamentId;
      if (current != null) currentSeasonIds.add(current);
    }
  }

  int rank(Tournament tournament) {
    if (currentSeasonIds.contains(tournament.id) &&
        tournament.status == TournamentStatus.active) {
      return 0;
    }
    if (tournament.status == TournamentStatus.active) return 1;
    if (currentSeasonIds.contains(tournament.id)) return 2;
    if (tournament.status == TournamentStatus.completed) return 3;
    return 4;
  }

  final ranked = [...enrolled]..sort((a, b) {
    final byRank = rank(a).compareTo(rank(b));
    if (byRank != 0) return byRank;
    return b.createdAt.compareTo(a.createdAt);
  });
  final tournament = ranked.first;
  return (
    tournament: tournament,
    league: tournament.leagueId == null ? null : leagues[tournament.leagueId],
  );
});

class ParentHomeScreen extends ConsumerWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamId = ref.watch(viewerProvider).familyTeamId;
    final teamsAsync = ref.watch(teamsProvider);

    return teamsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(friendlyErrorMessage(e)))),
      data: (teams) {
        final team = teams.where((t) => t.id == teamId).firstOrNull;
        if (team == null) {
          return _TeamPicker(teams: teams);
        }
        return _ParentKit(team: team);
      },
    );
  }
}

class _ParentKit extends ConsumerWidget {
  const _ParentKit({required this.team});

  final Team team;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(parentEventProvider);
    final kit = Color(team.colorArgb);
    final ink = _inkOn(kit);

    return Scaffold(
      backgroundColor: kit,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _shift(kit, 0.08),
              kit,
              _shift(kit, -0.12),
            ],
          ),
        ),
        child: SafeArea(
          child: eventAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(friendlyErrorMessage(e))),
            data: (event) => _KitBody(team: team, event: event, ink: ink, kit: kit),
          ),
        ),
      ),
    );
  }
}

class _KitBody extends ConsumerWidget {
  const _KitBody({
    required this.team,
    required this.event,
    required this.ink,
    required this.kit,
  });

  final Team team;
  final ({Tournament tournament, League? league})? event;
  final Color ink;
  final Color kit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournament = event?.tournament;
    final matches = tournament == null
        ? const <Match>[]
        : ref.watch(matchesProvider(tournament.id)).asData?.value ?? const [];
    final roster = tournament == null
        ? const <TournamentTeam>[]
        : ref.watch(tournamentTeamsProvider(tournament.id)).asData?.value ??
            const [];
    final standings = tournament == null
        ? const <StandingRow>[]
        : ref.watch(standingsProvider(tournament.id)).asData?.value ?? const [];

    final byId = {for (final t in roster) t.teamId: t};
    final venues =
        ref.watch(venuesProvider).asData?.value ?? const <Venue>[];
    final mine = matches
        .where(
          (m) =>
              !m.isBye &&
              (m.homeTeamId == team.id || m.awayTeamId == team.id),
        )
        .toList();
    final next = _nextMatch(mine);
    final place = _placeFor(standings, team.id);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            tooltip: 'Whole league',
            onPressed: event == null
                ? null
                : () => _confirmFullLeague(context, event!),
            icon: Icon(Icons.apps_outlined, color: ink),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              const SizedBox(height: 8),
              Center(
                child: team.showLogoCircle
                    ? Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: TeamLogo(
                          path: team.logoPath,
                          name: team.name,
                          colorArgb: team.colorArgb,
                          size: 120,
                        ),
                      )
                    : TeamLogo(
                        path: team.logoPath,
                        name: team.name,
                        colorArgb: team.colorArgb,
                        size: 156,
                      ),
              ),
              const SizedBox(height: 18),
              Text(
                team.name,
                textAlign: TextAlign.center,
                style: TourneezText.brand.copyWith(
                  color: ink,
                  fontSize: 34,
                  height: 1.05,
                ),
              ),
              if (event != null) ...[
                const SizedBox(height: 6),
                Text(
                  event!.league == null
                      ? event!.tournament.name
                      : '${event!.league!.name} · Season ${event!.league!.seasonNumber}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ink.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 28),
              _GlassCard(
                ink: ink,
                onTap: next == null || event == null
                    ? null
                    : () => _openGame(
                          context,
                          match: next,
                          roster: byId,
                          title: event!.tournament.name,
                        ),
                child: next == null
                    ? Text(
                        mine.isEmpty
                            ? 'No games on the calendar yet.'
                            : 'Season complete. Every game is played.',
                        style: TextStyle(
                          color: ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : _NextGame(
                        match: next,
                        teamId: team.id,
                        roster: byId,
                        ink: ink,
                        venue: resolveMatchVenue(
                          venueId: next.venueId,
                          homeVenueId: next.homeTeamId == null
                              ? null
                              : byId[next.homeTeamId]?.homeVenueId,
                          venues: venues,
                        ),
                      ),
              ),
              const SizedBox(height: 14),
              _GlassCard(
                ink: ink,
                onTap: event == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ParentStandingsScreen(
                              tournamentId: event!.tournament.id,
                              highlightTeamId: team.id,
                              title: event!.tournament.name,
                            ),
                          ),
                        );
                      },
                child: place == null
                    ? Text(
                        _recordLine(mine, team.id),
                        style: TextStyle(
                          color: ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : _StandingStrip(place: place, ink: ink),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: ink,
                  foregroundColor: kit,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ParentGamesScreen(
                        team: team,
                        tournamentId: event?.tournament.id,
                        title: event?.tournament.name ?? team.name,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_month_outlined),
                label: const Text('My games'),
              ),
              const SizedBox(height: 28),
              Center(
                child: TextButton(
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
                  child: Text(
                    'Switch view',
                    style: TextStyle(color: ink.withValues(alpha: 0.7)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmFullLeague(
    BuildContext context,
    ({Tournament tournament, League? league}) event,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('See the whole league?'),
        content: const Text(
          'This shows every team’s games, standings, and venues. '
          'Your page stays focused on your team.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Stay here'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Show everything'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final leagueId = event.league?.id ?? event.tournament.leagueId;
    if (leagueId != null) {
      context.push('/league/$leagueId');
    } else {
      context.push('/tournament/${event.tournament.id}');
    }
  }
}

class _NextGame extends StatelessWidget {
  const _NextGame({
    required this.match,
    required this.teamId,
    required this.roster,
    required this.ink,
    this.venue,
  });

  final Match match;
  final int teamId;
  final Map<int, TournamentTeam> roster;
  final Color ink;
  final ResolvedMatchVenue? venue;

  @override
  Widget build(BuildContext context) {
    final home = match.homeTeamId == teamId;
    final opponentId = home ? match.awayTeamId : match.homeTeamId;
    final opponent = opponentId == null ? null : roster[opponentId];
    final when = match.scheduledAt == null
        ? 'Kickoff not set'
        : formatMatchKickoff(match.scheduledAt!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NEXT GAME',
          style: TextStyle(
            color: ink.withValues(alpha: 0.62),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          when,
          style: TextStyle(
            color: ink,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'vs ${opponent?.displayName ?? 'TBD'}',
          style: TourneezText.heading.copyWith(color: ink, fontSize: 26),
        ),
        if (venue != null ||
            (match.location != null && match.location!.trim().isNotEmpty)) ...[
          const SizedBox(height: 6),
          Text(
            venue?.label ?? match.location!.trim(),
            style: TextStyle(color: ink.withValues(alpha: 0.8)),
          ),
        ],
      ],
    );
  }
}

class _StandingStrip extends StatelessWidget {
  const _StandingStrip({required this.place, required this.ink});

  final ({int rank, StandingRow row, int of}) place;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final row = place.row;
    return Row(
      children: [
        Text(
          _ordinal(place.rank),
          style: TourneezText.brand.copyWith(color: ink, fontSize: 36),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            '${row.points} pts\n'
            '${row.won}-${row.drawn}-${row.lost}  ·  '
            '${row.played} played',
            style: TextStyle(
              color: ink,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class ParentGamesScreen extends ConsumerStatefulWidget {
  const ParentGamesScreen({
    super.key,
    required this.team,
    required this.tournamentId,
    required this.title,
  });

  final Team team;
  final int? tournamentId;
  final String title;

  @override
  ConsumerState<ParentGamesScreen> createState() => _ParentGamesScreenState();
}

class _ParentGamesScreenState extends ConsumerState<ParentGamesScreen> {
  bool _simple = true;

  @override
  Widget build(BuildContext context) {
    final kit = Color(widget.team.colorArgb);
    final ink = _inkOn(kit);
    final tournamentId = widget.tournamentId;
    final matches = tournamentId == null
        ? const <Match>[]
        : ref.watch(matchesProvider(tournamentId)).asData?.value ?? const [];
    final roster = tournamentId == null
        ? const <TournamentTeam>[]
        : ref.watch(tournamentTeamsProvider(tournamentId)).asData?.value ??
            const [];
    final byId = {for (final t in roster) t.teamId: t};
    final venues =
        ref.watch(venuesProvider).asData?.value ?? const <Venue>[];
    final ordered = matches
        .where(
          (m) =>
              !m.isBye &&
              (m.homeTeamId == widget.team.id ||
                  m.awayTeamId == widget.team.id),
        )
        .toList()
      ..sort(_byKickoff);

    return Scaffold(
      backgroundColor: _shift(kit, -0.08),
      appBar: AppBar(
        backgroundColor: kit,
        foregroundColor: ink,
        title: const Text('My games'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('Simple'),
              selected: _simple,
              onSelected: (v) => setState(() => _simple = v),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
      body: ordered.isEmpty
          ? Center(
              child: Text(
                'No games yet.',
                style: TextStyle(color: ink, fontWeight: FontWeight.w700),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                for (final match in ordered)
                  MatchResultCard(
                    match: match,
                    home: match.homeTeamId == null
                        ? null
                        : byId[match.homeTeamId!],
                    away: match.awayTeamId == null
                        ? null
                        : byId[match.awayTeamId!],
                    simplified: _simple,
                    venueLabel: resolveMatchVenue(
                      venueId: match.venueId,
                      homeVenueId: match.homeTeamId == null
                          ? null
                          : byId[match.homeTeamId]?.homeVenueId,
                      venues: venues,
                    )?.label,
                    onTap: () => _openGame(
                      context,
                      match: match,
                      roster: byId,
                      title: widget.title,
                    ),
                  ),
              ],
            ),
    );
  }
}

class ParentStandingsScreen extends ConsumerStatefulWidget {
  const ParentStandingsScreen({
    super.key,
    required this.tournamentId,
    required this.highlightTeamId,
    required this.title,
  });

  final int tournamentId;
  final int highlightTeamId;
  final String title;

  @override
  ConsumerState<ParentStandingsScreen> createState() =>
      _ParentStandingsScreenState();
}

class _ParentStandingsScreenState extends ConsumerState<ParentStandingsScreen> {
  bool _simple = true;

  @override
  Widget build(BuildContext context) {
    final standings =
        ref.watch(standingsProvider(widget.tournamentId)).asData?.value ??
            const <StandingRow>[];
    final groups = <String, List<StandingRow>>{};
    for (final row in standings) {
      groups.putIfAbsent(row.groupLabel ?? '', () => []).add(row);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('Simple'),
              selected: _simple,
              onSelected: (v) => setState(() => _simple = v),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
      body: standings.isEmpty
          ? const Center(child: Text('Standings appear after games are played.'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                for (final entry in groups.entries) ...[
                  if (entry.key.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                      child: Text(entry.key, style: TourneezText.section),
                    ),
                  _simple
                      ? _SimpleTable(
                          rows: entry.value,
                          highlightTeamId: widget.highlightTeamId,
                        )
                      : _FullTable(
                          rows: entry.value,
                          highlightTeamId: widget.highlightTeamId,
                        ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }
}

class _SimpleTable extends StatelessWidget {
  const _SimpleTable({required this.rows, required this.highlightTeamId});

  final List<StandingRow> rows;
  final int highlightTeamId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final logoSize = (width * 0.16).clamp(52.0, 76.0);
    final rowH = logoSize + 18;
    final statW = width < 360 ? 44.0 : 52.0;

    Widget header(String text, {double? width, bool expand = false}) {
      final cell = SizedBox(
        width: width,
        height: 32,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
      );
      return expand ? Expanded(child: cell) : cell;
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Row(
            children: [
              header('#', width: 32),
              header('', expand: true),
              header('GD', width: statW),
              header('Pts', width: statW),
            ],
          ),
          for (var i = 0; i < rows.length; i++)
            Container(
              height: rowH,
              decoration: BoxDecoration(
                color: teamRowTint(rows[i].team?.colorArgb ?? 0xFF0B6E4F),
                border: rows[i].teamId == highlightTeamId
                    ? Border(
                        left: BorderSide(color: scheme.primary, width: 4),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: TeamLogo(
                        path: rows[i].team?.logoPath,
                        name: rows[i].displayName,
                        colorArgb: rows[i].team?.colorArgb,
                        size: logoSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: statW,
                    child: Center(
                      child: Text(
                        rows[i].goalDifference > 0
                            ? '+${rows[i].goalDifference}'
                            : '${rows[i].goalDifference}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: statW,
                    child: Center(
                      child: Text(
                        '${rows[i].points}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _FullTable extends StatelessWidget {
  const _FullTable({required this.rows, required this.highlightTeamId});

  final List<StandingRow> rows;
  final int highlightTeamId;

  @override
  Widget build(BuildContext context) {
    const labels = ['P', 'W', 'D', 'L', 'GF', 'GA', 'GD', 'Pts'];
    return Card(
      clipBehavior: Clip.hardEdge,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 44, height: 36),
                SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(
                    child: Text(
                      '#',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(
                  width: 140,
                  height: 36,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Team',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                for (final label in labels)
                  SizedBox(
                    width: 44,
                    height: 36,
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
              ],
            ),
            for (var i = 0; i < rows.length; i++)
              _FullRow(
                rank: i + 1,
                row: rows[i],
                highlight: rows[i].teamId == highlightTeamId,
              ),
          ],
        ),
      ),
    );
  }
}

class _FullRow extends StatelessWidget {
  const _FullRow({
    required this.rank,
    required this.row,
    required this.highlight,
  });

  final int rank;
  final StandingRow row;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final gd = row.goalDifference;
    final values = [
      '${row.played}',
      '${row.won}',
      '${row.drawn}',
      '${row.lost}',
      '${row.goalsFor}',
      '${row.goalsAgainst}',
      gd > 0 ? '+$gd' : '$gd',
      '${row.points}',
    ];
    return Container(
      color: teamRowTint(row.team?.colorArgb ?? 0xFF0B6E4F),
      foregroundDecoration: highlight
          ? BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                ),
              ),
            )
          : null,
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 48,
            child: Center(
              child: TeamLogo(
                path: row.team?.logoPath,
                name: row.displayName,
                colorArgb: row.team?.colorArgb,
                size: 28,
              ),
            ),
          ),
          SizedBox(
            width: 36,
            height: 48,
            child: Center(child: Text('$rank')),
          ),
          SizedBox(
            width: 140,
            height: 48,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                row.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: highlight ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ),
          ),
          for (var i = 0; i < values.length; i++)
            SizedBox(
              width: 44,
              height: 48,
              child: Center(
                child: Text(
                  values[i],
                  style: TextStyle(
                    fontWeight: i == values.length - 1
                        ? FontWeight.w800
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ParentGameDetailScreen extends ConsumerStatefulWidget {
  const ParentGameDetailScreen({
    super.key,
    required this.match,
    required this.home,
    required this.away,
    required this.title,
  });

  final Match match;
  final TournamentTeam? home;
  final TournamentTeam? away;
  final String title;

  @override
  ConsumerState<ParentGameDetailScreen> createState() =>
      _ParentGameDetailScreenState();
}

class _ParentGameDetailScreenState
    extends ConsumerState<ParentGameDetailScreen> {
  bool _simple = true;

  @override
  Widget build(BuildContext context) {
    final venues =
        ref.watch(venuesProvider).asData?.value ?? const <Venue>[];
    final resolved = resolveMatchVenue(
      venueId: widget.match.venueId,
      homeVenueId: widget.home?.homeVenueId,
      venues: venues,
    );
    final venue = resolved?.venue;
    final parent = resolved?.parent;
    final address = resolved?.address;
    final layout = resolved?.layoutPath;
    final kickoff = widget.match.scheduledAt == null
        ? 'Kickoff not set'
        : formatMatchKickoff(widget.match.scheduledAt!);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('Simple'),
              selected: _simple,
              onSelected: (v) => setState(() => _simple = v),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          MatchResultCard(
            match: widget.match,
            home: widget.home,
            away: widget.away,
            simplified: _simple,
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Kickoff'),
            subtitle: Text(kickoff),
          ),
          if (venue != null) ...[
            ListTile(
              leading: const Icon(Icons.place_outlined),
              title: Text(venueDisplayLabel(venue, parent: parent)),
              subtitle: Text(
                [
                  if (resolved!.fromHomeTeam) 'Home venue',
                  address ?? 'No address saved for this venue.',
                ].join('\n'),
              ),
              isThreeLine: resolved.fromHomeTeam,
            ),
            if (venueMapsUri(venue, parent: parent) != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: FilledButton.icon(
                  onPressed: () => openVenueInMaps(venue, parent: parent),
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Open in Maps'),
                ),
              ),
            if (layout != null) _VenueLayout(path: layout),
          ] else if (widget.match.location != null &&
              widget.match.location!.trim().isNotEmpty)
            ListTile(
              leading: const Icon(Icons.place_outlined),
              title: const Text('Venue'),
              subtitle: Text(widget.match.location!.trim()),
            ),
        ],
      ),
    );
  }
}

class _VenueLayout extends StatelessWidget {
  const _VenueLayout({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final bytes = decodeDataUrl(path);
    if (bytes == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Field map', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Image.memory(bytes, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}

int _byKickoff(Match a, Match b) {
  final as = a.scheduledAt;
  final bs = b.scheduledAt;
  if (as != null && bs != null) {
    final byTime = as.compareTo(bs);
    if (byTime != 0) return byTime;
  } else if (as != null) {
    return -1;
  } else if (bs != null) {
    return 1;
  }
  final byRound = a.round.compareTo(b.round);
  if (byRound != 0) return byRound;
  return a.id.compareTo(b.id);
}

class _TeamPicker extends ConsumerWidget {
  const _TeamPicker({required this.teams});

  final List<Team> teams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            Text('Your team', style: TourneezText.brand),
            const SizedBox(height: 8),
            Text(
              'Pick the team you follow. This page will use their colors.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            for (final team in teams)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Color(team.colorArgb),
                  borderRadius: BorderRadius.circular(16),
                  child: ListTile(
                    leading: TeamLogo(
                      path: team.logoPath,
                      name: team.name,
                      colorArgb: team.colorArgb,
                      size: 44,
                    ),
                    title: Text(
                      team.name,
                      style: TextStyle(
                        color: _inkOn(Color(team.colorArgb)),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onTap: () =>
                        ref.read(viewerProvider.notifier).setFamilyTeam(team.id),
                  ),
                ),
              ),
            TextButton(
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
              child: const Text('Switch view'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.ink, required this.child, this.onTap});

  final Color ink;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final paleInk = ink.computeLuminance() > 0.5;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: paleInk
                ? Colors.white.withValues(alpha: 0.16)
                : Colors.black.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ink.withValues(alpha: 0.18)),
          ),
          child: onTap == null
              ? child
              : Row(
                  children: [
                    Expanded(child: child),
                    Icon(
                      Icons.chevron_right,
                      color: ink.withValues(alpha: 0.55),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

void _openGame(
  BuildContext context, {
  required Match match,
  required Map<int, TournamentTeam> roster,
  required String title,
}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ParentGameDetailScreen(
        match: match,
        home: match.homeTeamId == null ? null : roster[match.homeTeamId!],
        away: match.awayTeamId == null ? null : roster[match.awayTeamId!],
        title: title,
      ),
    ),
  );
}

Match? _nextMatch(List<Match> mine) {
  final upcoming = mine.where((m) => !m.isCompleted).toList()
    ..sort((a, b) {
      final as = a.scheduledAt;
      final bs = b.scheduledAt;
      if (as != null && bs != null) return as.compareTo(bs);
      if (as != null) return -1;
      if (bs != null) return 1;
      return a.round.compareTo(b.round);
    });
  if (upcoming.isEmpty) return null;
  return upcoming.first;
}

({int rank, StandingRow row, int of})? _placeFor(
  List<StandingRow> standings,
  int teamId,
) {
  final row = standings.where((s) => s.teamId == teamId).firstOrNull;
  if (row == null) return null;
  final table = standings
      .where((s) => s.groupLabel == row.groupLabel)
      .toList();
  final index = table.indexWhere((s) => s.teamId == teamId);
  if (index < 0) return null;
  return (rank: index + 1, row: row, of: table.length);
}

String _recordLine(List<Match> mine, int teamId) {
  var w = 0, d = 0, l = 0;
  for (final m in mine.where((m) => m.isCompleted)) {
    final winner = m.winnerTeamId;
    if (winner == null) {
      d++;
    } else if (winner == teamId) {
      w++;
    } else {
      l++;
    }
  }
  if (w + d + l == 0) return 'Standings appear after games are played.';
  return '$w–$d–$l';
}

String _ordinal(int n) {
  final mod = n % 100;
  if (mod >= 11 && mod <= 13) return '${n}th';
  return switch (n % 10) {
    1 => '${n}st',
    2 => '${n}nd',
    3 => '${n}rd',
    _ => '${n}th',
  };
}

Color _inkOn(Color kit) =>
    kit.computeLuminance() > 0.55 ? const Color(0xFF122019) : Colors.white;

Color _shift(Color color, double delta) {
  final hsl = HSLColor.fromColor(color);
  return hsl
      .withLightness((hsl.lightness + delta).clamp(0.0, 1.0))
      .toColor();
}
