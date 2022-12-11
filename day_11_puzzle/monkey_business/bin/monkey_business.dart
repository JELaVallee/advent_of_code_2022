import 'dart:io';
import 'package:args/args.dart';
import 'package:monkey_business/monkey_business.dart';

const monkeyNotesFilePath = 'monkey-notes-file-path';
void main(List<String> arguments) {
  final parser = ArgParser()..addOption(monkeyNotesFilePath, abbr: 'f');
  ArgResults parsedArgs = parser.parse(arguments);

  // Open the grove datamap file and parse it
  print(
      "Loading instruction set data from: ${parsedArgs[monkeyNotesFilePath]} \n");
  final dataMapFile = File(parsedArgs[monkeyNotesFilePath]);

  List<String> monkeyNotes = dataMapFile.readAsLinesSync();

  // Initialize a Grove with the provided datamap
  print("Parsing instruction set data... \n");
  final monkeyBusiness = MonkeyBusiness(monkeyNotes);

  final total_monkey_business_after_20 = monkeyBusiness.totalAfter(20, true);

  print(
      "Total amount of Monkey Business after 20 rounds: $total_monkey_business_after_20");

  final total_monkey_business_after_10K =
      monkeyBusiness.totalAfter(10000, false);

  print(
      "Total amount of Monkey Business after 10000 rounds: $total_monkey_business_after_10K");
}
