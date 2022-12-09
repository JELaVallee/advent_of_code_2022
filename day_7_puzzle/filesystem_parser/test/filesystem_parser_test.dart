import 'dart:io';

import 'package:filesystem_parser/filesystem_parser.dart';
import 'package:test/test.dart';

void main() {
  test('parses the filesystem tree', () {
    final dataMapFile = File("./fs_cli_log_test.txt");
    List<String> logLines = dataMapFile.readAsLinesSync();

    final fsParser = FilesystemParser(logLines, 70000000);

    expect(fsParser.directories.length, 4);
    expect(fsParser.directories[0].totalFileSize, 48381165);
    expect(fsParser.directories[1].totalFileSize, 94853);
    expect(fsParser.directories[2].totalFileSize, 24933642);
    expect(fsParser.directories[3].totalFileSize, 584);
    expect(fsParser.totalFileSizeOfDirectoriesLessThan(100000), 95437);
    expect(fsParser.directoryThatWillFree(30000000).totalFileSize, 24933642);
  });
}
