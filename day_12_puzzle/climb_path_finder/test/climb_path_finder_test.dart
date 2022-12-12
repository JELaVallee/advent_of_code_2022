import 'dart:io';
import 'package:test/test.dart';
import 'package:climb_path_finder/climb_path_finder.dart';

void main() {
  test(
      'process the topology map, determine optimal path, and return number of steps [test]',
      () {
    final dataMapFile = File("./topo_map_data_test.txt");
    List<String> topologyMapData = dataMapFile.readAsLinesSync();

    ClimbPathFinder climbPathFinder = ClimbPathFinder(topologyMapData);

    expect(climbPathFinder.optimalPath.numberOfSteps, 31);
  });
  test(
      'process the topology map, determine optimal path, and return number of steps [full]',
      () {
    final dataMapFile = File("./topo_map_data_full.txt");
    List<String> topologyMapData = dataMapFile.readAsLinesSync();

    ClimbPathFinder climbPathFinder = ClimbPathFinder(topologyMapData);

    expect(climbPathFinder.optimalPath.numberOfSteps, -1);
  });
}
