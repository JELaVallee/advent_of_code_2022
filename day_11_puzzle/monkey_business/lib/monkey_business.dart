import 'dart:ffi';

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
    List<int> monkeyDivisors =
        monkeys.map((monkey) => monkey.testDivisor).toList();
    final leaseCommonDivisor =
        monkeyDivisors.reduce((value, element) => value * element);
    monkeys.forEach((monkey) => monkey.leastCommonDivisor = leaseCommonDivisor);
  }

  void processMonkeyRounds(int rounds, bool getsBored) {
    printMonkeyItemsFor(-1);
    for (var i = 0; i < rounds; i++) {
      monkeys.forEach((monkey) {
        monkey.takeTurn(monkeys, getsBored);
      });
      // printMonkeyItemsFor(i);
      if (i < 20) {
        // printMonkeyInspectionsFor(i);
        printMonkeyItemsFor(i);
      }
      if ((i + 1) % 1000 == 0) {
        // printMonkeyInspectionsFor(i);
        printMonkeyItemsFor(i);
      }
    }
    // printMonkeyInspectionsFor(rounds - 1);
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
  int leastCommonDivisor = 1;

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
      getBoredWith(item, getsBored);
      tossThe(item, monkeys[trueMonkeyIndex], monkeys[falseMonkeyIndex]);
      itemsInspected++;
    });
    holdingItems = [];
  }

  void inspectThe(Item item) {
    item.worryLevel =
        operation.evaluate(item.worryLevel % BigInt.from(leastCommonDivisor));
  }

  void getBoredWith(Item item, bool getsBored) {
    if (getsBored) {
      item.worryLevel = item.worryLevel ~/ BigInt.from(3);
    }
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
    Parser mathParser = Parser();
    Expression mathExpression = mathParser.parse(formula);
    BigInt result = BigInt.zero;
    if (mathExpression is Times) {
      if (mathExpression.first is Variable &&
          mathExpression.second is Variable) {
        result = oldValue * oldValue;
      } else {
        result = oldValue *
            BigInt.parse(double.parse(mathExpression.second.toString())
                .round()
                .toString());
      }
    } else if (mathExpression is Plus) {
      result = oldValue +
          BigInt.parse(double.parse(mathExpression.second.toString())
              .round()
              .toString());
    }
    return result;
  }
}

class Item {
  BigInt worryLevel = BigInt.from(0);
  Item(this.worryLevel);
}
