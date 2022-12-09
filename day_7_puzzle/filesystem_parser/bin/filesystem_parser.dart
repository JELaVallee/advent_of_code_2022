import 'dart:io';
import 'package:args/args.dart';
import 'package:filesystem_parser/filesystem_parser.dart';

const filesystemLogFilePath = 'filesystem-log-file-path';
void main(List<String> arguments) {
  final parser = ArgParser()..addOption(filesystemLogFilePath, abbr: 'f');
  ArgResults parsedArgs = parser.parse(arguments);

  // Open the grove datamap file and parse it
  print(
      "Loading Filesystem history data from: ${parsedArgs[filesystemLogFilePath]} \n");
  final dataMapFile = File(parsedArgs[filesystemLogFilePath]);

  List<String> logLines = dataMapFile.readAsLinesSync();

  // Initialize a Grove with the provided datamap
  print("Parsing Filesystem history data... \n");
  final fsParser = FilesystemParser(logLines, 70000000);

  final total_size_of_sub100k_directories =
      fsParser.totalFileSizeOfDirectoriesLessThan(100000);

  final smallest_dir_to_free_30M = fsParser.directoryThatWillFree(30000000);

  print(
      "Total size of directories under 100k in size: $total_size_of_sub100k_directories");
  print(
      "Size of directory to free 30M: ${smallest_dir_to_free_30M.totalFileSize}");
}
