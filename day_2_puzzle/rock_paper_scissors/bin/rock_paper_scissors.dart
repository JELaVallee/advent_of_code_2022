import 'dart:io';
import 'package:args/args.dart';
import 'package:rock_paper_scissors/rock_paper_scissors.dart';

const dataFilePath = 'data-file-path';
void main(List<String> arguments) {
  final parser = ArgParser()..addOption(dataFilePath, abbr: 'f');
  ArgResults parsedArgs = parser.parse(arguments);

  print("Loading data from: ${parsedArgs[dataFilePath]} \n");
  final dataMapFile = File(parsedArgs[dataFilePath]);

  List<String> rockPaperScissorsGuide = dataMapFile.readAsLinesSync();
  print("Parsing data... \n");
  RockPaperScissors rockPaperScissors =
      RockPaperScissors(rockPaperScissorsGuide);

  final int total_score_with_guide = rockPaperScissors.totalScoreWithGuide;

  print("Total score if playing with the guide: $total_score_with_guide");

  final int total_score_with_hints = rockPaperScissors.totalScoreWithHints;

  print("Total score if playing with the hints: $total_score_with_hints");
}
