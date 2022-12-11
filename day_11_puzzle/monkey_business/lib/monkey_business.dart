import 'package:math_expressions/math_expressions.dart';

class MonkeyBusiness {
  List<String> monkeyNotesText;
  List<Monkey> monkeys = [];

  MonkeyBusiness(this.monkeyNotesText) {
    processMonkeyNotes();
  }

  int totalAfter(int rounds, bool getsBored) {
    processMonkeyRounds(rounds, getsBored);
    final sortedTotals =
        monkeys.map((monkey) => monkey.itemsInspected).toList();
    sortedTotals.sort();
    final int totalAfter = sortedTotals.elementAt(sortedTotals.length - 1) *
        sortedTotals.elementAt(sortedTotals.length - 2);
    return totalAfter;
  }

  void processMonkeyNotes() {
    for (var noteIndex = 0;
        noteIndex < monkeyNotesText.length / 7;
        noteIndex++) {
      final int startLine = 0 + (noteIndex * 7);
      final int endLine = 7 + (noteIndex * 7) >= monkeyNotesText.length
          ? monkeyNotesText.length
          : (7 + (noteIndex * 7));

      final monkeyNoteText = monkeyNotesText.sublist(startLine, endLine);
      monkeys.add(Monkey(monkeyNoteText, noteIndex));
    }
  }

  void processMonkeyRounds(int rounds, bool getsBored) {
    for (var i = 0; i < rounds; i++) {
      monkeys.forEach((monkey) {
        monkey.takeTurn(monkeys, getsBored);
      });
      printMonkeyItemsFor(i);
      // printMonkeyInspectionsFor(i);
    }
  }

  void printMonkeyItemsFor(int round) {
    print("Round ${round + 1}:");
    monkeys.forEach((monkey) {
      print(
          "\tMonkey ${monkey.id}: ${monkey.itemsInspected} : ${monkey.holdingItems.map(((item) => "${item.worryLevel}, ")).join()}");
    });
  }

  void printMonkeyInspectionsFor(int round) {
    print("== After Round ${round + 1} ==");
    monkeys.forEach((monkey) {
      print("\tMonkey ${monkey.id} inspected items ${monkey.itemsInspected}");
    });
  }
}

class Monkey {
  final int id;
  final List<String> monkeyNote;
  List<Item> holdingItems = [];
  int itemsInspected = 0;
  int falseMonkeyIndex = 0;
  int trueMonkeyIndex = 0;
  int testDivisor = 1;

  Operation operation = Operation("1 + 1");

  Monkey(this.monkeyNote, this.id) {
    processMonkeyNote();
  }

  void processMonkeyNote() {
    testDivisor = int.parse(monkeyNote[3].split("by")[1]);
    trueMonkeyIndex = int.parse(monkeyNote[4].split("to monkey")[1]);
    falseMonkeyIndex = int.parse(monkeyNote[5].split("to monkey")[1]);
    final startingItemsList = monkeyNote[1].split(":")[1].split(",");
    startingItemsList.forEach((itemWorry) {
      holdingItems.add(Item(BigInt.parse(itemWorry)));
    });
    operation = Operation(monkeyNote[2].split("= ")[1]);
  }

  void takeTurn(List<Monkey> monkeys, bool getsBored) {
    holdingItems.forEach((item) {
      inspectThe(item);
      if (getsBored) getBoredWith(item);
      tossThe(item, monkeys[trueMonkeyIndex], monkeys[falseMonkeyIndex]);
      itemsInspected++;
    });
    holdingItems = [];
  }

  void inspectThe(Item item) {
    item.worryLevel = operation.evaluate(item.worryLevel);
  }

  void getBoredWith(Item item) {
    item.worryLevel = item.worryLevel ~/ BigInt.from(3);
  }

  void tossThe(Item item, Monkey trueMonkey, Monkey falseMonkey) {
    final decisionRemainder = item.worryLevel % BigInt.from(testDivisor);
    // item.worryLevel = decisionRemainder + BigInt.from(testDivisor);
    if (decisionRemainder == BigInt.zero) {
      trueMonkey.holdingItems.add(item);
    } else {
      falseMonkey.holdingItems.add(item);
    }
  }
}

class Operation {
  final String formula;

  Operation(this.formula);

  BigInt evaluate(BigInt oldValue) {
    // final varSubFormula = formula.replaceAll("old", oldValue.toString());
    Parser mathParser = Parser();
    Expression mathExpression = mathParser.parse(formula);
    ContextModel cm = ContextModel();
    cm.bindVariableName("old", Number(oldValue.toInt()));
    double result = mathExpression.evaluate(EvaluationType.REAL, cm);
    return BigInt.from(result);
  }
}

class Item {
  BigInt worryLevel = BigInt.from(0);
  Item(this.worryLevel);
}
