import 'dart:io';
import 'package:args/args.dart';
import 'package:rucksack_organizer/rucksack_organizer.dart';

const dataFilePath = 'data-file-path';
void main(List<String> arguments) {
  final parser = ArgParser()..addOption(dataFilePath, abbr: 'f');
  ArgResults parsedArgs = parser.parse(arguments);

  print("Loading data from: ${parsedArgs[dataFilePath]} \n");
  final dataMapFile = File(parsedArgs[dataFilePath]);

  List<String> rucksackInventory = dataMapFile.readAsLinesSync();
  print("Parsing data... \n");
  RucksackOrganizer rucksackOrganizer = RucksackOrganizer(rucksackInventory);

  final int totalPriorityOfSharedItems =
      rucksackOrganizer.totalPriorityOfSharedItems;

  print("Total priority of shared Items: $totalPriorityOfSharedItems");
}
