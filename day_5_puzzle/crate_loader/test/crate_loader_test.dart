import 'dart:io';
import 'package:test/test.dart';
import 'package:crate_loader/crate_loader.dart';

void main() {
  test(
      'processes the loading instructions and return the top-most crates [test]',
      () {
    final dataMapFile = File("./crate_loader_instructions_test.txt");
    List<String> crateLoaderInstructions = dataMapFile.readAsLinesSync();

    CrateLoader cleaningCrewPlanner = CrateLoader(crateLoaderInstructions);

    expect(cleaningCrewPlanner.topCrates, "CMZ");
  });
  test(
      'processes the loading instructions and return the top-most crates [full]',
      () {
    final dataMapFile = File("./crate_loader_instructions_full.txt");
    List<String> crateLoaderInstructions = dataMapFile.readAsLinesSync();

    CrateLoader cleaningCrewPlanner = CrateLoader(crateLoaderInstructions);

    expect(cleaningCrewPlanner.topCrates, "MQTPGLLDN");
  });
}
