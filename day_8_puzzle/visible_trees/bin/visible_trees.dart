import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:visible_trees/models/grove.dart';
import 'package:args/args.dart';

const groveFilePath = 'grove-file-path';
void main(List<String> arguments) {
  int exitCode = 0;

  final parser = ArgParser()..addOption(groveFilePath, abbr: 'f');
  ArgResults parsedArgs = parser.parse(arguments);

  // Open the grove datamap file and parse it
  print("Loading Grove data from: ${parsedArgs[groveFilePath]} \n");
  final dataMapFile = new File(parsedArgs[groveFilePath]);
  List<List<int>> dataMap = [];

  List<String> lines = dataMapFile.readAsLinesSync();
  int rowIndex = 0;
  lines.forEach((dataLine) {
    dataMap.add([]);
    dataLine.split('').forEach((char) {
      dataMap[rowIndex].add(int.parse(char));
    });
    rowIndex++;
  });

  // Initialize a Grove with the provided datamap
  print("Parsing Grove data... \n");
  final treeGrove = Grove(dataMap);

  final number_of_visible_trees = treeGrove.visibleTrees.length;
  final number_of_hidden_trees = treeGrove.hiddenTrees.length;
  final highest_visibility_score =
      treeGrove.highestVisibilityTree.visibilityScore;

  print('Number of visible trees: $number_of_visible_trees');
  print('Number of hidden trees: $number_of_hidden_trees');
  print('The highest visibility score is: $highest_visibility_score');
}
