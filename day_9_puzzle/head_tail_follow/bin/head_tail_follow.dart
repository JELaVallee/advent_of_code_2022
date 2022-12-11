import 'dart:io';
import 'package:args/args.dart';
import 'package:head_tail_follow/head_tail_follow.dart';

const headCommandFilePath = 'head-command-file-path';
void main(List<String> arguments) {
  final parser = ArgParser()..addOption(headCommandFilePath, abbr: 'f');
  ArgResults parsedArgs = parser.parse(arguments);

  // Open the grove datamap file and parse it
  print(
      "Loading Head command data from: ${parsedArgs[headCommandFilePath]} \n");
  final dataMapFile = File(parsedArgs[headCommandFilePath]);

  List<String> commandLines = dataMapFile.readAsLinesSync();

  // Initialize a Grove with the provided datamap
  print("Parsing Filesystem history data... \n");
  final fsParser = HeadTailFollow(commandLines, 10);

  final total_tail_visited_cells = fsParser.totalTailVisitedCells;
  final total_head_visited_cells = fsParser.totalHeadVisitedCells;

  print(
      "Total number of Cells visited by the Tail : $total_tail_visited_cells");
  print(
      "Total number of Cells visited by the Head : $total_head_visited_cells");
}
