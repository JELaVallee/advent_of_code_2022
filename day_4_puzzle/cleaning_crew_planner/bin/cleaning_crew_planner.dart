import 'dart:io';
import 'package:args/args.dart';
import 'package:cleaning_crew_planner/cleaning_crew_planner.dart';

const dataFilePath = 'data-file-path';
void main(List<String> arguments) {
  final parser = ArgParser()..addOption(dataFilePath, abbr: 'f');
  ArgResults parsedArgs = parser.parse(arguments);

  print("Loading data from: ${parsedArgs[dataFilePath]} \n");
  final dataMapFile = File(parsedArgs[dataFilePath]);

  List<String> crewAssignments = dataMapFile.readAsLinesSync();
  print("Parsing data... \n");
  CleaningCrewPlanner cleaningCrewPlanner =
      CleaningCrewPlanner(crewAssignments);

  final int numberOfFullyOverlappedAssignments =
      cleaningCrewPlanner.numberOfFullyOverlappedAssignments;

  print(
      "Number of fully overlapping assignments: $numberOfFullyOverlappedAssignments");
}
