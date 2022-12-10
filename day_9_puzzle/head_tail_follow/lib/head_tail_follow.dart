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
    });
  }

  void processCommand(Command command) {
    final int numberOfSteps = command.distance;
    print("\tHead[start]: ${headTraversals.last}");
    print("\tTail[start]: ${tailTraversals.last}");
    for (var i = 0; i < numberOfSteps; i++) {
      moveHead(command.direction);
      if (tailNeedsToMove()) {
        moveTailToHead();
      }
    }
    print("\tHead[end]: ${headTraversals.last}");
    print("\tTail[end]: ${tailTraversals.last}");
  }

  void moveHead(Direction direction) {
    final Cell currentHeadCell = headTraversals.last;
    final int newX = currentHeadCell.x + direction.offset.x;
    final int newY = currentHeadCell.y + direction.offset.y;
    final Cell nextCell = Cell(newX, newY);
    nextCell.headVisited = true;
    headTraversals.add(nextCell);
  }

  bool tailNeedsToMove() {
    final currentHead = headTraversals.last;
    final currentTail = tailTraversals.last;

    final int distanceToHead = currentTail.distanceTo(currentHead);
    final bool needsToMove = distanceToHead > 1;

    return needsToMove;
  }

  void moveTailToHead() {
    final currentHead = headTraversals.last;
    final currentTail = tailTraversals.last;
    Cell lastHead = headTraversals[headTraversals.length - 2];
    lastHead.tailVisited = true;
    tailTraversals.add(lastHead);
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
