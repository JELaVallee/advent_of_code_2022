import 'dart:io';
import 'package:test/test.dart';
import 'package:elf_calories/elf_calories.dart';

void main() {
  test('processes the calories list and finds the Elf with the most calories',
      () {
    final dataMapFile = File("./elf_calorie_list_test.txt");
    List<String> elfCalorieList = dataMapFile.readAsLinesSync();

    ElfCalories elfCalories = ElfCalories(elfCalorieList);

    expect(elfCalories.elfWithTheMostest.totalCalories, 24000);
  });
}
