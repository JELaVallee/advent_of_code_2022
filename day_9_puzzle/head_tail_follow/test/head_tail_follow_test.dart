import 'dart:io';

import 'package:head_tail_follow/head_tail_follow.dart';
import 'package:test/test.dart';

void main() {
  test('parses the traversal command with just 2 knots', () {
    final dataMapFile = File("./head_commands_test.txt");
    List<String> commandLines = dataMapFile.readAsLinesSync();

    final fsParser = HeadTailFollow(commandLines, 2);

    expect(fsParser.totalTailVisitedCells, 13);
    expect(fsParser.totalHeadVisitedCells, 21);
  });
  test('parses the traversal command with 10 knots and full data', () {
    final dataMapFile = File("./head_commands_full.txt");
    List<String> commandLines = dataMapFile.readAsLinesSync();

    final fsParser = HeadTailFollow(commandLines, 10);

    expect(fsParser.totalTailVisitedCells, 13);
    expect(fsParser.totalHeadVisitedCells, 21);
  });
  test('parses the traversal command with 10 knots with test data', () {
    final dataMapFile = File("./head_commands_test3.txt");
    List<String> commandLines = dataMapFile.readAsLinesSync();

    final fsParser = HeadTailFollow(commandLines, 10);

    expect(fsParser.totalTailVisitedCells, 36);
  });
}
