import 'dart:io';
import 'package:test/test.dart';
import 'package:rucksack_organizer/rucksack_organizer.dart';

void main() {
  test(
      'processes the rucksack inventory and sum the priorities of the shared items [test]',
      () {
    final dataMapFile = File("./rucksack_inventory_test.txt");
    List<String> rucksackInventory = dataMapFile.readAsLinesSync();

    RucksackOrganizer rucksackOrganizer = RucksackOrganizer(rucksackInventory);

    expect(rucksackOrganizer.totalPriorityOfSharedItems, 157);
  });
  test(
      'processes the rucksack inventory and sum the priorities of the shared items [full]',
      () {
    final dataMapFile = File("./rucksack_inventory_full.txt");
    List<String> rucksackInventory = dataMapFile.readAsLinesSync();

    RucksackOrganizer rucksackOrganizer = RucksackOrganizer(rucksackInventory);

    expect(rucksackOrganizer.totalPriorityOfSharedItems, 8176);
  });
}
