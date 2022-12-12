import 'dart:io';
import 'package:args/args.dart';
import 'package:climb_path_finder/climb_path_finder.dart';

const dataFilePath = 'data-file-path';
void main(List<String> arguments) {
  final parser = ArgParser()..addOption(dataFilePath, abbr: 'f');
  ArgResults parsedArgs = parser.parse(arguments);

  print("Loading data from: ${parsedArgs[dataFilePath]} \n");
  final dataMapFile = File(parsedArgs[dataFilePath]);

  List<String> topologyMapData = dataMapFile.readAsLinesSync();
  print("Parsing data... \n");
  ClimbPathFinder cleaningCrewPlanner = ClimbPathFinder(topologyMapData);

  final int optimalPathSteps = cleaningCrewPlanner.optimalPath.numberOfSteps;

  print("Top crates after restacking: $optimalPathSteps");
}
