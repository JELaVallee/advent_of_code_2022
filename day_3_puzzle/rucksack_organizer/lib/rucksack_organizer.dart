import 'package:equatable/equatable.dart';

class RucksackOrganizer {
  final List<String> rucksackInventory;
  final List<Rucksack> rucksacks = [];
  final List<ElfGroup> elfGroups = [];

  RucksackOrganizer(this.rucksackInventory) {
    parseInventory();
  }

  int get totalPriorityOfSharedItems {
    return rucksacks
        .map((rucksack) => rucksack.sharedItem)
        .map((item) => item.priority)
        .reduce((value, priority) => value + priority);
  }

  int get totalPriorityOfBadgeItems {
    return elfGroups
        .map((elfGroup) => elfGroup.badgeItem.priority)
        .reduce((value, priority) => value + priority);
  }

  void parseInventory() {
    List<Rucksack> elfGroupSacks = [];
    rucksackInventory.forEach((inventoryList) {
      final rucksack = Rucksack(inventoryList);
      rucksacks.add(rucksack);
      elfGroupSacks.add(rucksack);
      if (elfGroupSacks.length == 3) {
        elfGroups.add(ElfGroup(elfGroupSacks));
        elfGroupSacks = [];
      }
    });
  }
}

class ElfGroup {
  final List<Rucksack> groupRucksacks;
  ElfGroup(this.groupRucksacks);
  Item get badgeItem {
    final inventory1 = <Item>{
      ...groupRucksacks[0].compartment1,
      ...groupRucksacks[0].compartment2
    }.toSet().toList();

    final inventory2 = <Item>{
      ...groupRucksacks[1].compartment1,
      ...groupRucksacks[1].compartment2
    }.toSet().toList();

    final inventory3 = <Item>{
      ...groupRucksacks[2].compartment1,
      ...groupRucksacks[2].compartment2
    }.toSet().toList();

    final Item badgeItem = inventory1
        .toSet()
        .intersection(inventory2.toSet().intersection(inventory3.toSet()))
        .first;
    return badgeItem;
  }
}

class Rucksack {
  final String inventoryList;
  final List<Item> compartment1 = [];
  final List<Item> compartment2 = [];

  Rucksack(this.inventoryList) {
    final int listLength = inventoryList.length;
    final firstList = inventoryList.substring(0, listLength ~/ 2);
    final secondList = inventoryList.substring(listLength ~/ 2, listLength);
    fillInventoryFor(compartment1, firstList);
    fillInventoryFor(compartment2, secondList);
  }

  Item get sharedItem {
    return compartment1.toSet().intersection(compartment2.toSet()).first;
  }

  void fillInventoryFor(List<Item> compartment, String fillList) {
    fillList.split("").forEach((itemRune) {
      final existingItem = compartment.where((item) => item.rune == itemRune);
      if (existingItem.isNotEmpty) {
        existingItem.last.count++;
      } else {
        compartment.add(Item(itemRune));
      }
    });
  }
}

class Item extends Equatable {
  static final String _priorityMap =
      "abcdefghijklmnopqrstuvwxyz" + "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  final String rune;
  int priority = 0;
  int count = 1;

  Item(this.rune) {
    priority = _priorityMap.indexOf(rune) + 1;
  }

  @override
  List<Object?> get props => [rune, priority];
}
