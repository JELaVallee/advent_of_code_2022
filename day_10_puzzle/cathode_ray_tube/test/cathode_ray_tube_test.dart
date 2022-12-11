import 'dart:io';
import 'package:test/test.dart';
import 'package:cathode_ray_tube/cathode_ray_tube.dart';

void main() {
  test('processes the instructions and samples correctly', () {
    final dataMapFile = File("./instruction_set_test.txt");
    List<String> instructionSet = dataMapFile.readAsLinesSync();

    final cathodRayTube = CathodeRayTube(instructionSet);

    expect(cathodRayTube.sumOfSignalStrengthsAt([20, 60, 100, 140, 180, 220]),
        13140);
  });
}
