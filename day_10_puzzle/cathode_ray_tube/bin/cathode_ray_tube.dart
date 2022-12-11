import 'dart:io';
import 'package:args/args.dart';
import 'package:cathode_ray_tube/cathode_ray_tube.dart';

const instructionSetFilePath = 'instruction-set-file-path';
void main(List<String> arguments) {
  final parser = ArgParser()..addOption(instructionSetFilePath, abbr: 'f');
  ArgResults parsedArgs = parser.parse(arguments);

  // Open the grove datamap file and parse it
  print(
      "Loading instruction set data from: ${parsedArgs[instructionSetFilePath]} \n");
  final dataMapFile = File(parsedArgs[instructionSetFilePath]);

  List<String> instructionSet = dataMapFile.readAsLinesSync();

  // Initialize a Grove with the provided datamap
  print("Parsing instruction set data... \n");
  final cathodeRayTube = CathodeRayTube(instructionSet);

  final sum_of_signal_strengths =
      cathodeRayTube.sumOfSignalStrengthsAt([20, 60, 100, 140, 180, 220]);

  print("Sum of signal strengths: $sum_of_signal_strengths");
  cathodeRayTube.renderCrtBuffer();
}
