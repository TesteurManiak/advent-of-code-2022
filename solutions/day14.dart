import 'dart:math' as math;

import '../utils/index.dart';

class Day14 extends GenericDay {
  Day14() : super(14);

  @override
  List<Segment> parseInput() {
    return input
        .getPerLine()
        .map(
          (e) => e.split(' -> ').map((e) {
            final parts = e.split(',').map(int.parse);
            return Position(parts.first, parts.last);
          }).toList(),
        )
        .fold<List<Segment>>([], (prev, e) {
      final rockSegments = <Segment>[];
      for (int i = 1; i < e.length; i++) {
        rockSegments.add(Segment(e[i - 1], e[i]));
      }
      return prev..addAll(rockSegments);
    }).toList();
  }

  static const sandSource = Position(500, 0);

  @override
  int solvePart1() {
    final segments = parseInput();
    final walls = segments.expand((e) => e.points).toSet();
    final limitY = segments.map((e) => math.max(e.start.y, e.end.y)).max;
    final sandWalls = <Position>{};

    Position sandPos = sandSource;
    while (sandPos.y < limitY) {
      Position nextPos = sandPos.dropDown;

      if (isBlocked(nextPos, walls, sandWalls)) {
        if (!isBlocked(nextPos.dropLeft, walls, sandWalls)) {
          nextPos = nextPos.dropLeft;
        } else if (!isBlocked(
          nextPos.dropRight,
          walls,
          sandWalls,
        )) {
          nextPos = nextPos.dropRight;
        } else {
          nextPos = sandPos;
        }
      }

      if (nextPos == sandPos) {
        sandWalls.add(sandPos);
        sandPos = sandSource;
      } else {
        sandPos = nextPos;
      }
    }

    return sandWalls.length;
  }

  @override
  int solvePart2() {
    final segments = parseInput();
    final limitY = segments.map((e) => math.max(e.start.y, e.end.y)).max;
    final sandWalls = <Position>{};

    segments.add(Segment(Position(0, limitY + 2), Position(1000, limitY + 2)));

    final walls = segments.expand((e) => e.points).toSet();

    Position sandPos = sandSource;
    while (!sandWalls.contains(sandSource)) {
      Position nextPos = sandPos.dropDown;

      if (isBlocked(nextPos, walls, sandWalls)) {
        if (!isBlocked(nextPos.dropLeft, walls, sandWalls)) {
          nextPos = nextPos.dropLeft;
        } else if (!isBlocked(
          nextPos.dropRight,
          walls,
          sandWalls,
        )) {
          nextPos = nextPos.dropRight;
        } else {
          nextPos = sandPos;
        }
      }

      if (nextPos == sandPos) {
        sandWalls.add(sandPos);
        sandPos = sandSource;
      } else {
        sandPos = nextPos;
      }
    }

    return sandWalls.length;
  }

  bool isBlocked(
    Position pos,
    Set<Position> rockWalls,
    Set<Position> sandWalls,
  ) {
    return rockWalls.contains(pos) || sandWalls.contains(pos);
  }
}

extension on Position {
  Position get dropDown => this + const Position(0, 1);
  Position get dropLeft => this + const Position(-1, 0);
  Position get dropRight => this + const Position(1, 0);
}
