import 'dart:math' as math;

import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  List<CommandLine> parseInput() {
    final lines = input.getPerLine();
    return lines.map(CommandLine.fromString).toList();
  }

  @override
  solvePart1([List<CommandLine>? overrideCommands]) {
    final commands = overrideCommands ?? parseInput();
    final grid = MyGrid(2);

    for (final command in commands) {
      grid.moveHead(command);
    }

    return grid.tailPositions.length;
  }

  @override
  solvePart2() {
    final commands = parseInput();
    final grid = MyGrid(10);

    for (final command in commands) {
      grid.moveHead(command);
    }

    return grid.tailPositions.length;
  }
}

enum Direction {
  left('L'),
  right('R'),
  up('U'),
  down('D');

  const Direction(this.key);
  final String key;

  static Direction fromKey(String key) {
    return Direction.values.firstWhere((e) => e.key == key);
  }
}

class CommandLine {
  const CommandLine({
    required this.steps,
    required this.direction,
  });

  CommandLine.fromString(String input)
      : steps = int.parse(input.split(' ')[1]),
        direction = Direction.fromKey(input.split(' ')[0]);

  final int steps;
  final Direction direction;
}

class MyGrid {
  MyGrid(int knots) : knotPositions = List.filled(knots, Position(0, 0));

  List<Position> knotPositions = <Position>[];
  Position get headPosition => knotPositions.first;
  set headPosition(Position value) => knotPositions[0] = value;

  final tailPositions = <Position>{
    Position(0, 0),
  };

  void moveHead(CommandLine command) {
    for (int i = 0; i < command.steps; i++) {
      switch (command.direction) {
        case Direction.left:
          moveHeadLeft();
          break;
        case Direction.right:
          moveHeadRight();
          break;
        case Direction.up:
          moveHeadUp();
          break;
        case Direction.down:
          moveHeadDown();
          break;
      }

      for (int i = 1; i < knotPositions.length; i++) {
        final headKnot = knotPositions[i - 1];
        knotPositions[i] = moveKnot(headKnot, knotPositions[i]);
      }
      tailPositions.add(knotPositions.last);
    }
  }

  void moveHeadLeft() {
    headPosition = headPosition.copyWith(x: headPosition.x - 1);
  }

  void moveHeadRight() {
    headPosition = headPosition.copyWith(x: headPosition.x + 1);
  }

  void moveHeadUp() {
    headPosition = headPosition.copyWith(y: headPosition.y + 1);
  }

  void moveHeadDown() {
    headPosition = headPosition.copyWith(y: headPosition.y - 1);
  }

  Position moveKnot(Position headKnot, Position knotTail) {
    final shouldMove = distanceBetween(headKnot, knotTail) >= 2;
    if (shouldMove) {
      return shortestDirectionTo(headKnot, knotTail);
    }
    return knotTail;
  }

  Position shortestDirectionTo(Position headKnot, Position tailKnot) {
    final adjacent = tailKnot.adjacent;
    final adjacentToHead = adjacent.where((pos) => pos.isAdjacentTo(headKnot));
    if (adjacentToHead.isNotEmpty) {
      return adjacentToHead.first;
    }

    final neighbours = tailKnot.neighbours;
    final neighboursToHead =
        neighbours.where((pos) => pos.isAdjacentTo(headKnot));
    if (neighboursToHead.isNotEmpty) {
      return neighboursToHead.first;
    }

    return tailKnot;
  }
}

class Position extends Equatable {
  const Position(this.x, this.y);

  final int x;
  final int y;

  Iterable<Position> get adjacent {
    return <Position>{
      Position(x, y - 1),
      Position(x, y + 1),
      Position(x - 1, y),
      Position(x + 1, y),
    };
  }

  bool isAdjacentTo(Position other) {
    return adjacent.contains(other);
  }

  Iterable<Position> get neighbours {
    return <Position>{
      Position(x, y - 1),
      Position(x + 1, y - 1),
      Position(x + 1, y),
      Position(x + 1, y + 1),
      Position(x, y + 1),
      Position(x - 1, y + 1),
      Position(x - 1, y),
      Position(x - 1, y - 1),
    };
  }

  bool isNeighbourOf(Position other) {
    return neighbours.contains(other);
  }

  Position copyWith({int? x, int? y}) {
    return Position(x ?? this.x, y ?? this.y);
  }

  int distanceTo(Position other) {
    final xDiff = (x - other.x).abs();
    final yDiff = (y - other.y).abs();
    return xDiff + yDiff;
  }

  @override
  List<Object?> get props => [x, y];
}

/// Returns the distance between [head] and [tail].
int distanceBetween(Position head, Position tail) {
  final xDiff = (head.x - tail.x).abs();
  final yDiff = (head.y - tail.y).abs();
  return math.max(xDiff, yDiff);
}
