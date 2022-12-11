class CathodeRayTube {
  final List<String> instructionsSet;
  final List<Cycle> processCycles = [];
  final List<List<String>> crtBuffer = [];

  CathodeRayTube(this.instructionsSet) {
    parseInstructions();
    processInstructions();
  }

  sumOfSignalStrengthsAt(List<int> cycleNumberList) {
    int sumOfSignalStrengths = 0;
    cycleNumberList.forEach((cycleNumber) {
      final cycle = processCycles[cycleNumber - 1];
      final signalStrength = cycleNumber * cycle.xReg;
      print("$cycleNumber : $signalStrength");
      sumOfSignalStrengths += signalStrength;
    });

    return sumOfSignalStrengths;
  }

  void parseInstructions() {
    instructionsSet.forEach((instruction) {
      if (instruction.contains("noop")) {
        final newCycle = Cycle(Operation.noop);
        processCycles.add(newCycle);
      } else if (instruction.contains("addx")) {
        final newCycle1 = Cycle(Operation.addx1);
        newCycle1.addAmount = int.parse(instruction.split(" ")[1]);
        processCycles.add(newCycle1);
        final newCycle2 = Cycle(Operation.addx2);
        newCycle2.addAmount = newCycle1.addAmount;
        processCycles.add(newCycle2);
      }
    });
  }

  void processInstructions() {
    int currentX = 1;
    processCycles.forEach((cycle) {
      switch (cycle.operation) {
        case Operation.noop:
        case Operation.addx1:
          cycle.xReg = currentX;
          break;
        case Operation.addx2:
        default:
          cycle.xReg = currentX;
          currentX += cycle.addAmount;
      }
    });
  }

  void renderCrtBuffer() {
    for (var scan = 0; scan < 6; scan++) {
      final List<String> currentCrtBuffer = [];
      final int startCycleIndex = 0 + (scan * 40);
      final int endCycleIndex = 40 + (scan * 40);
      final currentScanCycles =
          processCycles.sublist(startCycleIndex, endCycleIndex);
      int cycleIndex = 0;
      currentScanCycles.forEach((scanCycle) {
        final spriteBuffer = spriteBufferAt(scanCycle.xReg);
        final pixel = spriteBuffer[cycleIndex];
        currentCrtBuffer.add(pixel);
        cycleIndex++;
      });
      crtBuffer.add(currentCrtBuffer);
    }
    crtBuffer.forEach((crtScanBuffer) {
      print(crtScanBuffer.join());
    });
  }

  List<String> spriteBufferAt(int x) {
    final List<String> spriteBuffer = [];
    for (var i = 0; i < 40; i++) {
      if ((i == x - 1 || i == x) || i == x + 1) {
        spriteBuffer.add("#");
      } else {
        spriteBuffer.add(".");
      }
    }
    return spriteBuffer;
  }
}

class Cycle {
  final Operation operation;
  int addAmount = 0;
  int xReg = 0;

  Cycle(this.operation);
}

enum Operation { noop, addx1, addx2 }
