import 'dart:io';

import 'package:head_tail_follow/head_tail_follow.dart';
import 'package:test/test.dart';

void main() {
  test('parses the traversal command', () {
    final dataMapFile = File("./head_commands_test.txt");
    List<String> commandLines = dataMapFile.readAsLinesSync();

    final fsParser = HeadTailFollow(commandLines);

    expect(fsParser.totalHeadVisitedCells, 24);
    expect(fsParser.totalTailVisitedCells, 13);
  });
}
