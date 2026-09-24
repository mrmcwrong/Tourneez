import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourneez/data/database.dart';
import 'package:tourneez/data/repository.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/formats/format_registry.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final repositoryProvider = Provider<TourneezRepository>((ref) {
  return TourneezRepository(ref.watch(databaseProvider));
});

final teamsProvider = StreamProvider<List<Team>>((ref) {
  return ref.watch(repositoryProvider).watchTeams();
});

final venuesProvider = StreamProvider<List<Venue>>((ref) {
  return ref.watch(repositoryProvider).watchVenues();
});

final venueProvider = FutureProvider.family<Venue?, int>((ref, id) async {
  return ref.watch(repositoryProvider).getVenue(id);
});

final tournamentsProvider = StreamProvider<List<Tournament>>((ref) {
  return ref.watch(repositoryProvider).watchTournaments();
});

final tournamentProvider =
    StreamProvider.family<Tournament?, int>((ref, id) {
  return ref.watch(repositoryProvider).watchTournament(id);
});

final tournamentTeamsProvider =
    StreamProvider.family<List<TournamentTeam>, int>((ref, id) {
  return ref.watch(repositoryProvider).watchTournamentTeams(id);
});

final matchesProvider =
    StreamProvider.family<List<Match>, int>((ref, id) {
  return ref.watch(repositoryProvider).watchMatches(id);
});

final standingsProvider =
    Provider.family<AsyncValue<List<StandingRow>>, int>((ref, tournamentId) {
  final tournamentAsync = ref.watch(tournamentProvider(tournamentId));
  final teamsAsync = ref.watch(tournamentTeamsProvider(tournamentId));
  final matchesAsync = ref.watch(matchesProvider(tournamentId));

  if (tournamentAsync.isLoading ||
      teamsAsync.isLoading ||
      matchesAsync.isLoading) {
    return const AsyncValue.loading();
  }

  final tournament = tournamentAsync.value;
  final teams = teamsAsync.value;
  final matches = matchesAsync.value;

  if (tournament == null || teams == null || matches == null) {
    return AsyncValue.error('Missing data', StackTrace.current);
  }

  final engine = engineFor(tournament.format);
  return AsyncValue.data(
    engine.computeStandings(tournament, teams, matches),
  );
});

final teamListsProvider = StreamProvider<List<TeamList>>((ref) {
  return ref.watch(repositoryProvider).watchTeamLists();
});

final leaguesProvider = StreamProvider<List<League>>((ref) {
  return ref.watch(repositoryProvider).watchLeagues();
});

final leagueProvider = StreamProvider.family<League?, int>((ref, id) {
  return ref.watch(repositoryProvider).watchLeague(id);
});

final divisionsProvider =
    StreamProvider.family<List<Division>, int>((ref, leagueId) {
  return ref.watch(repositoryProvider).watchDivisions(leagueId);
});

final divisionTeamsProvider =
    StreamProvider.family<List<DivisionTeam>, int>((ref, divisionId) {
  return ref.watch(repositoryProvider).watchDivisionTeams(divisionId);
});

/// True when every division season tournament is completed (promo/releg ready).
final leaguePromoReadyProvider =
    FutureProvider.autoDispose.family<bool, int>((ref, leagueId) async {
  final divisions = await ref.watch(divisionsProvider(leagueId).future);
  if (divisions.isEmpty) return false;
  for (final d in divisions) {
    final tid = d.currentTournamentId;
    if (tid == null) return false;
    final tournament = await ref.watch(tournamentProvider(tid).future);
    if (tournament == null ||
        tournament.status != TournamentStatus.completed) {
      return false;
    }
  }
  return true;
});

/// True when the season can advance without promo/releg (tournaments done).
final leagueNextSeasonReadyProvider =
    FutureProvider.autoDispose.family<bool, int>((ref, leagueId) async {
  final league = await ref.watch(leagueProvider(leagueId).future);
  if (league == null || league.canUsePromoReleg) return false;
  final divisions = await ref.watch(divisionsProvider(leagueId).future);
  if (divisions.isEmpty) return false;
  var anyCurrent = false;
  for (final d in divisions) {
    final tid = d.currentTournamentId;
    if (tid == null) continue;
    anyCurrent = true;
    final tournament = await ref.watch(tournamentProvider(tid).future);
    if (tournament == null ||
        tournament.status != TournamentStatus.completed) {
      return false;
    }
  }
  return anyCurrent;
});

final leagueArchiveProvider =
    StreamProvider.family<List<Tournament>, int>((ref, leagueId) {
  return ref.watch(repositoryProvider).watchLeagueArchive(leagueId);
});

final canReorderSeedsProvider =
    Provider.family<bool, int>((ref, tournamentId) {
  final tournament = ref.watch(tournamentProvider(tournamentId)).asData?.value;
  if (tournament == null ||
      tournament.status == TournamentStatus.completed) {
    return false;
  }
  if (tournament.status == TournamentStatus.draft) return true;
  final matches = ref.watch(matchesProvider(tournamentId)).asData?.value;
  if (matches == null) return false;
  return !matches.any((m) => m.status == MatchStatus.completed);
});
