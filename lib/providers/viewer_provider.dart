import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/providers/theme_provider.dart';

const viewerRoleKey = 'viewer_role';
const viewerFamilyTeamKey = 'viewer_family_team_id';

class ViewerNotifier extends Notifier<ViewerSettings> {
  @override
  ViewerSettings build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final role = prefs.getString(viewerRoleKey) == AppRole.family.name
        ? AppRole.family
        : AppRole.manager;
    return ViewerSettings(
      role: role,
      familyTeamId: prefs.getInt(viewerFamilyTeamKey),
    );
  }

  Future<void> setRole(AppRole role) async {
    state = state.copyWith(role: role);
    await ref.read(sharedPreferencesProvider).setString(viewerRoleKey, role.name);
  }

  Future<void> setFamilyTeam(int? teamId) async {
    state = state.copyWith(
      familyTeamId: teamId,
      clearFamilyTeam: teamId == null,
    );
    final prefs = ref.read(sharedPreferencesProvider);
    if (teamId == null) {
      await prefs.remove(viewerFamilyTeamKey);
    } else {
      await prefs.setInt(viewerFamilyTeamKey, teamId);
    }
  }
}

final viewerProvider =
    NotifierProvider<ViewerNotifier, ViewerSettings>(ViewerNotifier.new);

/// Family visibility for a tournament. League-linked events use the league's flags.
final familyViewForTournamentProvider =
    Provider.family<FamilyViewSettings, int>((ref, tournamentId) {
  final tournament = ref.watch(tournamentProvider(tournamentId)).asData?.value;
  if (tournament == null) return FamilyViewSettings.defaults;
  final leagueId = tournament.leagueId;
  if (leagueId != null) {
    final league = ref.watch(leagueProvider(leagueId)).asData?.value;
    if (league != null) return league.config.familyView;
  }
  return tournament.config.familyView;
});
