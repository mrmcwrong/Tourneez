import 'package:tourneez/domain/format_engine.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/formats/double_elim.dart';
import 'package:tourneez/formats/groups_only.dart';
import 'package:tourneez/formats/hybrid.dart';
import 'package:tourneez/formats/round_robin.dart';
import 'package:tourneez/formats/single_elim.dart';
import 'package:tourneez/formats/swiss.dart';

final roundRobinEngine = RoundRobinEngine();
final swissEngine = SwissEngine();
final singleElimEngine = SingleEliminationEngine();
final doubleElimEngine = DoubleEliminationEngine();
final groupsOnlyEngine = GroupsOnlyEngine();
final hybridEngine = HybridEngine();

FormatEngine engineFor(TournamentFormat format) {
  return switch (format) {
    TournamentFormat.roundRobin => roundRobinEngine,
    TournamentFormat.swiss => swissEngine,
    TournamentFormat.singleElimination => singleElimEngine,
    TournamentFormat.doubleElimination => doubleElimEngine,
    TournamentFormat.groupsOnly => groupsOnlyEngine,
    TournamentFormat.hybrid => hybridEngine,
  };
}
