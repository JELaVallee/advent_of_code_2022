import 'package:stack/stack.dart';

class CrateLoader {
  final List<String> crateLoaderInstructions;
  final List<Stack<Crate>> crateStacks = [];
  final List<Instruction> loaderInstructions = [];

  CrateLoader(this.crateLoaderInstructions) {
    parseLoaderInstructions();
    processInstructions();
  }

  String get topCrates {
    return crateStacks
        .map((stack) => stack.top().id)
        .reduce(((value, id) => value + id));
  }

  void parseLoaderInstructions() {
    final instructionsStart = crateLoaderInstructions.indexOf(
            crateLoaderInstructions.where((line) => line.isEmpty).last) +
        1;
    final crateStackMap =
        crateLoaderInstructions.sublist(0, instructionsStart - 2);

    final instructionSets = crateLoaderInstructions.sublist(
        instructionsStart, crateLoaderInstructions.length);

    parseCrateStacks(crateStackMap);

    parseInstructionSets(instructionSets);
  }

  void parseCrateStacks(List<String> crateStackMap) {
    final crateStackCount = crateStackMap.last.split(" ").length;
    for (var i = 0; i < crateStackCount; i++) {
      crateStacks.add(Stack<Crate>());
    }

    crateStackMap.reversed.forEach((mapRow) {
      for (int i = 0; i < crateStackCount; i++) {
        final startIndex = i * 4;
        final endIndex =
            (startIndex + 4) > mapRow.length ? mapRow.length : startIndex + 4;
        if (startIndex > endIndex) continue;
        final mapCell = mapRow.substring(startIndex, endIndex);
        if (mapCell.trim().isEmpty) {
          continue;
        }
        crateStacks.elementAt(i).push(Crate.fromMapCell(mapCell.trim()));
      }
    });
  }

  void parseInstructionSets(List<String> instructionSets) {
    instructionSets.forEach((instructionSet) {
      loaderInstructions
          .add(Instruction.fromInstructionSet(instructionSet, crateStacks));
    });
  }

  void processInstructions() {
    loaderInstructions.forEach((instruction) {
      for (var i = 0; i < instruction.quantity; i++) {
        final moveCrate = instruction.fromStack.pop();
        instruction.toStack.push(moveCrate);
      }
    });
  }
}

class Instruction {
  final Stack<Crate> fromStack;
  final Stack<Crate> toStack;
  final int quantity;
  Instruction(this.quantity, this.fromStack, this.toStack);

  static Instruction fromInstructionSet(
      String instructionSet, List<Stack<Crate>> crateStacks) {
    final parsedSet = instructionSet.split(" ");
    final quantity = int.parse(parsedSet[1]);
    final fromStack = crateStacks.elementAt(int.parse(parsedSet[3]) - 1);
    final toStack = crateStacks.elementAt(int.parse(parsedSet[5]) - 1);
    return Instruction(quantity, fromStack, toStack);
  }
}

class Crate {
  final String id;
  Crate(this.id);

  static Crate fromMapCell(String mapCell) {
    final id = mapCell.substring(1, 2);
    return Crate(id);
  }
}
