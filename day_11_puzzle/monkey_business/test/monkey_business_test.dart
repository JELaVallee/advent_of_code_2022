import 'dart:io';
import 'package:test/test.dart';
import 'package:monkey_business/monkey_business.dart';

void main() {
  test('processes the instructions and samples correctly', () {
    final dataMapFile = File("./monkey_notes_test.txt");
    List<String> monkeyNotes = dataMapFile.readAsLinesSync();

    MonkeyBusiness monkeyBusiness = MonkeyBusiness(monkeyNotes);

    expect(monkeyBusiness.totalAfter(20, true), 10605);

    monkeyBusiness = MonkeyBusiness(monkeyNotes);

    expect(monkeyBusiness.totalAfter(20, false), 2713310158);
  });
}
