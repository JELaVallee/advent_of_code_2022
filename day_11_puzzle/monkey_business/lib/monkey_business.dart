import 'package:math_expressions/math_expressions.dart';

class MonkeyBusiness {
  List<String> monkeyNotesText;
  List<Monkey> monkeys = [];

  MonkeyBusiness(this.monkeyNotesText) {
    processMonkeyNotes();
  }

  int totalAfter(int rounds) {
    processMonkeyRounds(rounds);
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

  void processMonkeyRounds(int rounds) {
    for (var i = 0; i < rounds; i++) {
      monkeys.forEach((monkey) {
        monkey.takeTurn(monkeys);
      });
      printMonkeyItemsFor(i);
    }
  }

  void printMonkeyItemsFor(int round) {
    print("Round ${round + 1}:");
    monkeys.forEach((monkey) {
      print(
          "\tMonkey ${monkey.id}: ${monkey.itemsInspected} : ${monkey.holdingItems.map(((item) => "${item.worryLevel}, ")).join()}");
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
      holdingItems.add(Item(int.parse(itemWorry)));
    });
    operation = Operation(monkeyNote[2].split("= ")[1]);
  }

  void takeTurn(List<Monkey> monkeys) {
    holdingItems.forEach((item) {
      itemsInspected++;
      inspectThe(item);
      getBoredWith(item);
      tossThe(item, monkeys[trueMonkeyIndex], monkeys[falseMonkeyIndex]);
    });
    holdingItems = [];
  }

  void inspectThe(Item item) {
    item.worryLevel = operation.evaluate(item.worryLevel);
  }

  void getBoredWith(Item item) {
    item.worryLevel = (item.worryLevel / 3).floor();
  }

  void tossThe(Item item, Monkey trueMonkey, Monkey falseMonkey) {
    final decisionRemainder = item.worryLevel % testDivisor;
    if (decisionRemainder == 0) {
      trueMonkey.holdingItems.add(item);
    } else {
      falseMonkey.holdingItems.add(item);
    }
  }
}

class Operation {
  final String formula;

  Operation(this.formula);

  int evaluate(int oldValue) {
    final varSubFormula = formula.replaceAll("old", oldValue.toString());
    Parser mathParser = Parser();
    Expression mathExpression = mathParser.parse(varSubFormula);
    double result =
        mathExpression.evaluate(EvaluationType.REAL, ContextModel());
    return result.floor();
  }
}

class Item {
  int worryLevel = 0;
  Item(this.worryLevel);
}
