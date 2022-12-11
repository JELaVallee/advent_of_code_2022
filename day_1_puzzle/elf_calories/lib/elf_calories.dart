class ElfCalories {
  final List<String> calorieList;
  final List<Elf> elves = [];

  ElfCalories(this.calorieList) {
    processCalorieList();
  }

  Elf get elfWithTheMostest {
    elves.sort(((a, b) => a.totalCalories - b.totalCalories));
    return elves.last;
  }

  List<Elf> get threeElvesWithTheMostest {
    elves.sort(((a, b) => a.totalCalories - b.totalCalories));
    return elves.sublist(elves.length - 3, elves.length);
  }

  void processCalorieList() {
    Elf currentElf = Elf();

    calorieList.forEach((calorieEntry) {
      if (calorieEntry.isEmpty) {
        elves.add(currentElf);
        currentElf = Elf();
      } else {
        final calories = int.parse(calorieEntry);
        currentElf.calories.add(calories);
      }
    });
    elves.add(currentElf);
  }
}

class Elf {
  List<int> calories = [];
  Elf();

  int get totalCalories {
    return calories.reduce((value, calorie) => value + calorie);
  }
}
