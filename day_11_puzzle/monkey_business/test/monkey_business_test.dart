import 'dart:io';
import 'package:test/test.dart';
import 'package:monkey_business/monkey_business.dart';

void main() {
  test('processes the instructions and samples correctly', () {
    final dataMapFile = File("./monkey_notes_test.txt");
    List<String> monkeyNotes = dataMapFile.readAsLinesSync();

    final monkeyBusiness = MonkeyBusiness(monkeyNotes);

    expect(monkeyBusiness.totalAfter(20), 10605);
  });
}
