import 'package:math_expressions/math_expressions.dart';

class MonkeyBusiness {
  List<String> monkeyNotesText;
  List<Monkey> monkeys = [];

  MonkeyBusiness(this.monkeyNotesText) {
    processMonkeyNotes();
  }

  int totalAfter(int rounds) {
    return 0;
  }

  void processMonkeyNotes() {
    for (var noteIndex = 0;
        noteIndex < monkeyNotesText.length / 7;
        noteIndex++) {
      final int startLine = 0;
      final int endLine = 7;
      final monkeyNoteText = monkeyNotesText.sublist(startLine, endLine);
      monkeys.add(Monkey(monkeyNoteText, noteIndex));
    }
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
