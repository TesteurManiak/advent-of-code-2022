import 'package:equatable/equatable.dart';

import '../utils/index.dart';

typedef MovementCallback = Position Function(Position knot);

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  int parseInput([int knotCount = 2]) {
    final lines = input.getPerLine();
    final commands = lines.map(CommandLine.fromString).toList();
    final grid = MyGrid(knotCount);

    for (final command in commands) {
      grid.moveHead(command);
    }
    return grid.tailPositions.length;
  }

  @override
  int solvePart1() => parseInput();

  @override
  int solvePart2() => parseInput(10);
}

enum Direction {
  left('L', moveLeft),
  right('R', moveRight),
  up('U', moveUp),
  down('D', moveDown);

  const Direction(this.key, this.move);
  final String key;
  final MovementCallback move;

  static Direction fromKey(String key) {
    return Direction.values.firstWhere((e) => e.key == key);
  }
}

class CommandLine {
  CommandLine.fromString(String input)
      : steps = int.parse(input.split(' ')[1]),
        direction = Direction.fromKey(input.split(' ')[0]);

  final int steps;
  final Direction direction;
}

class MyGrid {
  MyGrid(int knots) : knotPositions = List.filled(knots, const Position(0, 0));

  final List<Position> knotPositions;
  final tailPositions = <Position>{const Position(0, 0)};

  void moveHead(CommandLine command) {
    for (int i = 0; i < command.steps; i++) {
      knotPositions[0] = command.direction.move(knotPositions.first);

      for (int i = 1; i < knotPositions.length; i++) {
        final head = knotPositions[i - 1];
        final tail = knotPositions[i];
        if (!head.isNextTo(tail)) knotPositions[i] = moveKnot(head, tail);
      }
      tailPositions.add(knotPositions.last);
    }
  }

  Position moveKnot(Position head, Position tail) {
    final diffX = head.x - tail.x;
    final diffY = head.y - tail.y;
    return Position(
      tail.x + diffX.sign,
      tail.y + diffY.sign,
    );
  }
}

class Position extends Equatable {
  const Position(this.x, this.y);

  final int x;
  final int y;

  bool isNextTo(Position other) {
    return (x - other.x).abs() <= 1 && (y - other.y).abs() <= 1;
  }

  @override
  List<Object?> get props => [x, y];
}

Position moveLeft(Position knot) => Position(knot.x - 1, knot.y);
Position moveRight(Position knot) => Position(knot.x + 1, knot.y);
Position moveUp(Position knot) => Position(knot.x, knot.y + 1);
Position moveDown(Position knot) => Position(knot.x, knot.y - 1);
