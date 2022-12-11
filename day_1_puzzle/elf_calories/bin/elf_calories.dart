import 'dart:io';
import 'package:args/args.dart';
import 'package:elf_calories/elf_calories.dart';

const dataFilePath = 'data-file-path';
void main(List<String> arguments) {
  final parser = ArgParser()..addOption(dataFilePath, abbr: 'f');
  ArgResults parsedArgs = parser.parse(arguments);

  // Open the grove datamap file and parse it
  print("Loading data from: ${parsedArgs[dataFilePath]} \n");
  final dataMapFile = File(parsedArgs[dataFilePath]);

  List<String> elfCaloriesList = dataMapFile.readAsLinesSync();

  // Initialize a Grove with the provided datamap
  print("Parsing data... \n");
  ElfCalories elfCalories = ElfCalories(elfCaloriesList);

  final total_calories_elf_w_the_mostest =
      elfCalories.elfWithTheMostest.totalCalories;

  print(
      "Total calories for the Elf with the mostest caloric foods: $total_calories_elf_w_the_mostest");

  final total_calories_three_elves_w_the_mostest = elfCalories
      .threeElvesWithTheMostest
      .map((elf) => elf.totalCalories)
      .reduce((value, calorie) => value + calorie);

  print(
      "Total calories for the Elf with the mostest caloric foods: $total_calories_three_elves_w_the_mostest");
}
