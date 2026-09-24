import 'package:go_router/go_router.dart';
import 'package:tourneez/features/create/create_tournament_screen.dart';
import 'package:tourneez/features/home/home_screen.dart';
import 'package:tourneez/features/league/league_screens.dart';
import 'package:tourneez/features/settings/app_settings_screen.dart';
import 'package:tourneez/features/teams/teams_screen.dart';
import 'package:tourneez/features/tournament/tournament_hub_screen.dart';
import 'package:tourneez/features/venues/venues_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/teams',
      builder: (context, state) => const TeamsScreen(),
    ),
    GoRoute(
      path: '/venues',
      builder: (context, state) => const VenuesScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const AppSettingsScreen(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreateTournamentScreen(),
    ),
    GoRoute(
      path: '/create-league',
      builder: (context, state) => const CreateLeagueScreen(),
    ),
    GoRoute(
      path: '/league/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return LeagueHubScreen(leagueId: id);
      },
      routes: [
        GoRoute(
          path: 'archive',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return LeagueArchiveScreen(leagueId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/tournament/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return TournamentHubScreen(tournamentId: id);
      },
    ),
  ],
);
