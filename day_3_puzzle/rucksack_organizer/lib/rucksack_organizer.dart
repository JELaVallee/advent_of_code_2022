import 'dart:math';

import 'package:equatable/equatable.dart';

class RucksackOrganizer {
  final List<String> rucksackInventory;
  final List<Rucksack> rucksacks = [];

  RucksackOrganizer(this.rucksackInventory) {
    parseInventory();
  }

  int get totalPriorityOfSharedItems {
    return rucksacks
        .map((rucksack) => rucksack.sharedItem)
        .map((item) => item.priority)
        .reduce((value, priority) => value + priority);
  }

  void parseInventory() {
    rucksackInventory.forEach((inventoryList) {
      rucksacks.add(Rucksack(inventoryList));
    });
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
