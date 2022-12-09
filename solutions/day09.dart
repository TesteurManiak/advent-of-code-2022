import 'package:equatable/equatable.dart';

import '../utils/index.dart';

typedef MovementCallback = Position Function(Position knot);

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
  solvePart2([List<CommandLine>? overrideCommands]) {
    final commands = overrideCommands ?? parseInput();
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

  @override
  String toString() => '$steps on the ${direction.name}';
}

class MyGrid {
  MyGrid(int knots) : knotPositions = List.filled(knots, Position(0, 0));

  final List<Position> knotPositions;
  final tailPositions = <Position>{Position(0, 0)};

  set headPosition(Position value) => knotPositions[0] = value;
  Position get tailPosition => tailPositions.last;

  void moveHead(CommandLine command) {
    for (int i = 0; i < command.steps; i++) {
      final MovementCallback move;
      switch (command.direction) {
        case Direction.left:
          move = moveLeft;
          break;
        case Direction.right:
          move = moveRight;
          break;
        case Direction.up:
          move = moveUp;
          break;
        case Direction.down:
          move = moveDown;
          break;
      }
      knotPositions[0] = move(knotPositions.first);

      for (int i = 1; i < knotPositions.length; i++) {
        final head = knotPositions[i - 1];
        final tail = knotPositions[i];
        if (!head.isNextTo(tail)) knotPositions[i] = moveKnot(head, tail);
      }
      tailPositions.add(knotPositions.last);
    }
  }

  Position moveLeft(Position knot) {
    return knot.copyWith(x: knot.x - 1);
  }

  Position moveRight(Position knot) {
    return knot.copyWith(x: knot.x + 1);
  }

  Position moveUp(Position knot) {
    return knot.copyWith(y: knot.y + 1);
  }

  Position moveDown(Position knot) {
    return knot.copyWith(y: knot.y - 1);
  }

  Position moveUpRight(Position knot) {
    return knot.copyWith(x: knot.x + 1, y: knot.y + 1);
  }

  Position moveUpLeft(Position knot) {
    return knot.copyWith(x: knot.x - 1, y: knot.y + 1);
  }

  Position moveDownRight(Position knot) {
    return knot.copyWith(x: knot.x + 1, y: knot.y - 1);
  }

  Position moveDownLeft(Position knot) {
    return knot.copyWith(x: knot.x - 1, y: knot.y - 1);
  }

  Position moveKnot(Position head, Position tail) {
    if (head.x == tail.x) {
      if (head.y > tail.y) return moveUp(tail);
      return moveDown(tail);
    } else if (head.y == tail.y) {
      if (head.x > tail.x) return moveRight(tail);
      return moveLeft(tail);
    } else {
      if ((head.x - tail.x).abs() != 1) {
        if (head.y > tail.y) {
          if (head.x > tail.x) return moveUpRight(tail);
          return moveUpLeft(tail);
        }
        if (head.x > tail.x) return moveDownRight(tail);
        return moveDownLeft(tail);
      }
      if (head.x > tail.x) {
        if (head.y > tail.y) return moveUpRight(tail);
        return moveDownRight(tail);
      }
      if (head.y > tail.y) return moveUpLeft(tail);
      return moveDownLeft(tail);
    }
  }
}

class Position extends Equatable {
  const Position(this.x, this.y);

  final int x;
  final int y;

  Position copyWith({int? x, int? y}) {
    return Position(x ?? this.x, y ?? this.y);
  }

  bool isNextTo(Position other) {
    return (x - other.x).abs() <= 1 && (y - other.y).abs() <= 1;
  }

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() => '($x, $y)';
}
