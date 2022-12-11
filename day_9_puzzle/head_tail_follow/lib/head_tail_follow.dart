import 'package:equatable/equatable.dart';

class HeadTailFollow {
  final List<String> commandList;
  List<Command> commandStack = [];
  List<Cell> headTraversals = [];
  List<Cell> tailTraversals = [];
  List<List<Cell>> knotTraversals = [];
  int numberOfKnots = 2;

  HeadTailFollow(this.commandList, this.numberOfKnots) {
    parseCommands();
    initializeTraversalLists();
    runTraversal();
  }

  int get totalTailVisitedCells {
    return tailTraversals.toSet().length;
  }

  int get totalHeadVisitedCells {
    return headTraversals.toSet().length;
  }

  void initializeTraversalLists() {
    final startingCell = Cell(0, 0);
    startingCell.isStart = true;

    for (var i = 0; i < numberOfKnots; i++) {
      final List<Cell> traversalList = [startingCell];
      knotTraversals.add(traversalList);
    }
    headTraversals = knotTraversals[0];
    headTraversals.last.headVisited = true;
    tailTraversals = knotTraversals.last;
    tailTraversals.last.tailVisited = true;
  }

  void parseCommands() {
    commandList.forEach((commandLine) {
      final currentCommand = commandLine.split(" ");
      commandStack.add(Command(Direction.values.byName(currentCommand[0]),
          int.parse(currentCommand[1])));
    });
  }

  void runTraversal() {
    var currentHeadCell = headTraversals.last;
    var currentTailCell = tailTraversals.last;

    commandStack.forEach((command) {
      print("Processing command: ${command.direction} ${command.distance}");
      processCommand(command);
      printCurrentGrid(40, 20, Coordinate2D(19, 9));
    });
    // printCurrentGrid(40, 20, Coordinate2D(19, 9));
  }

  void processCommand(Command command) {
    final int numberOfSteps = command.distance;
    // print("\tHead[start]: ${headTraversals.last}");
    // print("\tTail[start]: ${tailTraversals.last}");
    for (var i = 0; i < numberOfSteps; i++) {
      moveHead(command.direction);
      moveKnots();
    }
    // print("\tHead[end]: ${headTraversals.last}");
    // print("\tTail[end]: ${tailTraversals.last}");
  }

  void moveHead(Direction direction) {
    final Cell currentHeadCell = headTraversals.last;
    final int newX = currentHeadCell.x + direction.offset.x;
    final int newY = currentHeadCell.y + direction.offset.y;
    final Cell nextCell = Cell(newX, newY);
    nextCell.headVisited = true;
    headTraversals.add(nextCell);
  }

  void moveKnots() {
    final otherKnotsTraversalLists = knotTraversals.sublist(1);

    otherKnotsTraversalLists.forEach((currentTraversals) {
      final currentKnotCell = currentTraversals.last;
      final previousTraversals = knotTraversals
          .elementAt(knotTraversals.indexOf(currentTraversals) - 1);
      final previousCell = previousTraversals.last;
      if (cellNeedsToMove(currentKnotCell, previousCell)) {
        moveCellNextToCell(currentKnotCell, previousCell, currentTraversals,
            previousTraversals);
      }
    });
  }

  bool cellNeedsToMove(Cell testCell, Cell comparisonCell) {
    final int distanceToComparisonCell = testCell.distanceTo(comparisonCell);
    final bool needsToMove = distanceToComparisonCell > 1;

    return needsToMove;
  }

  void moveCellNextToCell(Cell currentCell, Cell testCell,
      List<Cell> traversals, List<Cell> previousTraversals) {
    final Cell lastLeadCell = previousTraversals[previousTraversals.length - 2];
    final Coordinate2D moveOffset =
        Coordinate2D(testCell.x - lastLeadCell.x, testCell.y - lastLeadCell.y);
    final Coordinate2D currentOffset =
        Coordinate2D(testCell.x - currentCell.x, testCell.y - currentCell.y);
    Cell newCell = Cell(testCell.x - moveOffset.x, testCell.y - moveOffset.y);
    if (currentOffset.x == 0) {
      newCell = Cell(currentCell.x, currentCell.y + moveOffset.y);
    } else if (currentOffset.y == 0) {
      newCell = Cell(currentCell.x + moveOffset.x, currentCell.y);
    } else if (moveOffset.x.abs() == 1 && moveOffset.y.abs() == 1) {
      newCell =
          Cell(currentCell.x + moveOffset.x, currentCell.y + moveOffset.y);
    }

    if (knotTraversals.indexOf(traversals) == knotTraversals.length - 1) {
      // At the tail traversal list
      newCell.tailVisited = true;
    }

    traversals.add(newCell);
  }

  void printCurrentGrid(int width, int height, Coordinate2D offset) {
    final int gridWidth = width;
    final int gridHeight = height;
    final Coordinate2D originOffset = offset;
    final originCell = knotTraversals.first.first;
    final tailTrailChar = "#";
    String outputGrid = "";

    for (var yPos = -originOffset.y;
        yPos < gridHeight - originOffset.y;
        yPos++) {
      String currentLineOut = "";
      for (var xPos = -originOffset.x;
          xPos < gridWidth - originOffset.x;
          xPos++) {
        String traversalOutValue = ".";
        if (originCell.x == xPos && originCell.y == yPos) {
          traversalOutValue = "X";
        } else {
          final Set<Cell> tailMatch = tailTraversals
              .toSet()
              .where((tailVisitedCell) =>
                  (tailVisitedCell.x == xPos && tailVisitedCell.y == yPos))
              .toSet();
          if (tailMatch.isNotEmpty) {
            traversalOutValue = tailTrailChar;
          }
        }
        knotTraversals.reversed.forEach((currentTraversals) {
          final currentCell = currentTraversals.last;
          if (currentCell.x == xPos && currentCell.y == yPos) {
            if (knotTraversals.indexOf(currentTraversals) == 0) {
              traversalOutValue = "H";
            } else if (knotTraversals.indexOf(currentTraversals) ==
                knotTraversals.length - 1) {
              traversalOutValue = "T";
            } else {
              traversalOutValue =
                  knotTraversals.indexOf(currentTraversals).toString();
            }
          }
        });
        currentLineOut += traversalOutValue;
      }
      outputGrid = currentLineOut + "\n" + outputGrid;
    }
    print(outputGrid);
  }
}

class Command {
  final int distance;
  final Direction direction;

  Command(this.direction, this.distance);
}

class Coordinate2D {
  final int x;
  final int y;

  const Coordinate2D(this.x, this.y);
}

enum Direction {
  U(Coordinate2D(0, 1)),
  D(Coordinate2D(0, -1)),
  L(Coordinate2D(-1, 0)),
  R(Coordinate2D(1, 0));

  final Coordinate2D offset;

  const Direction(this.offset);
}

class Cell extends Coordinate2D with EquatableMixin {
  bool headVisited = false;
  bool tailVisited = false;
  bool isStart = false;

  Cell(x, y) : super(x, y);

  int distanceTo(Cell toCell) {
    final int distanceX = (toCell.x - x).abs();
    final int distanceY = (toCell.y - y).abs();
    final int distanceToCell = distanceX >= distanceY ? distanceX : distanceY;

    return distanceToCell;
  }

  @override
  String toString() {
    return "($x, $y) head?: $headVisited, tail?: $tailVisited";
  }

  @override
  List<Object?> get props => [x, y, headVisited, tailVisited];
}
