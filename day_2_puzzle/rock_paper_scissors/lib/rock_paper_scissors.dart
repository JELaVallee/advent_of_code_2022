class RockPaperScissors {
  final List<String> playGuide;
  final List<Bout> guideBouts = [];
  final List<Bout> hintsBouts = [];

  RockPaperScissors(this.playGuide) {
    parsePlayGuide();
  }

  int get totalScoreWithGuide {
    return guideBouts
        .map((bout) => bout.playerScore)
        .reduce((value, score) => value + score);
  }

  int get totalScoreWithHints {
    return hintsBouts
        .map((bout) => bout.playerScore)
        .reduce((value, score) => value + score);
  }

  void parsePlayGuide() {
    playGuide.forEach((guideBoutEntry) {
      final guideBoutPlays = guideBoutEntry.split(" ");
      final opponentHand = Hand.forOpponentRune(guideBoutPlays[0]);
      final playerHand = Hand.forPlayerRune(guideBoutPlays[1]);
      guideBouts.add(Bout(playerHand, opponentHand));
      final hintChoice = Decision.forChoice(guideBoutPlays[1]);
      final hintPlayerHand = Hand.forPlayerChoice(hintChoice, opponentHand);
      hintsBouts.add(Bout(hintPlayerHand, opponentHand));
    });
  }
}

class Bout {
  final Hand opponentHand;
  final Hand playerHand;
  Decision decision = Decision.loss;

  Bout(this.playerHand, this.opponentHand) {
    decision = Decision.forBout(opponentHand, playerHand);
  }

  int get playerScore {
    int boutPlayerScore = 0;
    boutPlayerScore += playerHand.play.spec.points;
    boutPlayerScore += decision.spec.points;
    return boutPlayerScore;
  }
}

class Hand {
  final Play play;

  Hand(this.play);

  static forPlayerRune(String playerRune) {
    final Play playerPlay =
        Play.values.where((play) => play.spec.playerRune == playerRune).first;
    return Hand(playerPlay);
  }

  static forOpponentRune(String opponentRune) {
    final Play opponentPlay = Play.values
        .where((play) => play.spec.opponentRune == opponentRune)
        .first;
    return Hand(opponentPlay);
  }

  static Hand forPlayerChoice(Decision hintChoice, Hand againstHand) {
    switch (hintChoice) {
      case Decision.loss:
        if (againstHand.play == Play.rock) return Hand(Play.scissors);
        if (againstHand.play == Play.paper) return Hand(Play.rock);
        if (againstHand.play == Play.scissors) return Hand(Play.paper);
        break;
      case Decision.draw:
        if (againstHand.play == Play.rock) return Hand(Play.rock);
        if (againstHand.play == Play.paper) return Hand(Play.paper);
        if (againstHand.play == Play.scissors) return Hand(Play.scissors);
        break;
      case Decision.win:
        if (againstHand.play == Play.rock) return Hand(Play.paper);
        if (againstHand.play == Play.paper) return Hand(Play.scissors);
        if (againstHand.play == Play.scissors) return Hand(Play.rock);
        break;
      default:
        return Hand(Play.paper);
    }
    return Hand(Play.paper);
  }
}

enum Decision {
  loss(DecisionSpec(0, "X")),
  draw(DecisionSpec(3, "Y")),
  win(DecisionSpec(6, "Z"));

  final DecisionSpec spec;

  const Decision(this.spec);

  static Decision forChoice(String choiceRune) {
    final Decision choice = Decision.values
        .where((decision) => decision.spec.choiceRune == choiceRune)
        .first;
    return choice;
  }

  static forBout(Hand opponentHand, Hand playerHand) {
    switch (opponentHand.play) {
      case Play.rock:
        if (playerHand.play == Play.paper) return Decision.win;
        if (playerHand.play == Play.rock) return Decision.draw;
        if (playerHand.play == Play.scissors) return Decision.loss;
        break;
      case Play.paper:
        if (playerHand.play == Play.paper) return Decision.draw;
        if (playerHand.play == Play.rock) return Decision.loss;
        if (playerHand.play == Play.scissors) return Decision.win;
        break;
      case Play.scissors:
        if (playerHand.play == Play.paper) return Decision.loss;
        if (playerHand.play == Play.rock) return Decision.win;
        if (playerHand.play == Play.scissors) return Decision.draw;
        break;
      default:
        return Decision.loss;
    }
  }
}

class DecisionSpec {
  final int points;
  final String choiceRune;
  const DecisionSpec(this.points, this.choiceRune);
}

enum Play {
  rock(PlaySpec(1, "X", "A")),
  paper(PlaySpec(2, "Y", "B")),
  scissors(PlaySpec(3, "Z", "C"));

  final PlaySpec spec;

  const Play(this.spec);
}

class PlaySpec {
  final int points;
  final String playerRune;
  final String opponentRune;

  const PlaySpec(this.points, this.playerRune, this.opponentRune);
}
