import 'dart:io';
import 'package:test/test.dart';
import 'package:rock_paper_scissors/rock_paper_scissors.dart';

void main() {
  test('processes the guide book and score the match', () {
    final dataMapFile = File("./rps_guide_test.txt");
    List<String> rockPaperScissorsGuide = dataMapFile.readAsLinesSync();

    RockPaperScissors rockPaperScissors =
        RockPaperScissors(rockPaperScissorsGuide);

    expect(rockPaperScissors.totalScoreWithGuide, 15);
  });
}
