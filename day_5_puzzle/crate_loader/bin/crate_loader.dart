import 'dart:io';
import 'package:args/args.dart';
import 'package:crate_loader/crate_loader.dart';

const dataFilePath = 'data-file-path';
void main(List<String> arguments) {
  final parser = ArgParser()..addOption(dataFilePath, abbr: 'f');
  ArgResults parsedArgs = parser.parse(arguments);

  print("Loading data from: ${parsedArgs[dataFilePath]} \n");
  final dataMapFile = File(parsedArgs[dataFilePath]);

  List<String> crateLoaderInstructions = dataMapFile.readAsLinesSync();
  print("Parsing data... \n");
  CrateLoader cleaningCrewPlanner = CrateLoader(crateLoaderInstructions);

  final String topCrates = cleaningCrewPlanner.topCrates;

  print("Top crates after restacking: $topCrates");
}
