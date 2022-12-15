import '../utils/index.dart';

class Day15 extends GenericDay {
  Day15() : super(15);

  @override
  Iterable<Sensor> parseInput() sync* {
    final inputLines = input.getPerLine();

    for (final line in inputLines) {
      final regex = RegExp(r'x=-?(\d+), y=-?(\d+)');
      final match = regex.allMatches(line);
      yield Sensor(
        position: PositionParser.fromString(match.elementAt(0).group(0)!),
        beaconPosition: PositionParser.fromString(match.elementAt(1).group(0)!),
      );
    }
  }

  @override
  int solvePart1([int row = 2000000]) {
    final int localRow = row;
    final sensors = parseInput();
    final positionsWithoutBeacon = <Position>{};

    for (final sensor in sensors) {
      final distance =
          manhattanDistance(sensor.position, sensor.beaconPosition);
      final sensorX = sensor.position.x;
      final sensorY = sensor.position.y;

      if (sensorY < localRow && sensorY + distance > localRow) {
        final yToGoal = localRow - sensorY;
        for (int xOnY = sensorX - (distance - yToGoal);
            xOnY <= sensorX + (distance - yToGoal);
            xOnY++) {
          positionsWithoutBeacon.add(Position(xOnY, localRow));
        }
      } else if (sensorY > localRow && sensorY - distance <= localRow) {
        final yToGoal = sensorY - localRow;
        for (int xOnY = sensorX - (distance - yToGoal);
            xOnY <= sensorX + (distance - yToGoal);
            xOnY++) {
          positionsWithoutBeacon.add(Position(xOnY, localRow));
        }
      }
    }

    return positionsWithoutBeacon.length - 1;
  }

  @override
  int solvePart2() {
    final sensors = parseInput();
    final positionToCheck = <Position>{};

    for (final sensor in sensors) {
      final distance =
          manhattanDistance(sensor.position, sensor.beaconPosition);

      positionToCheck
          .addAll(getExternalBorderForPosition(sensor.position, distance));
    }

    for (final sensor in sensors) {
      final distance =
          manhattanDistance(sensor.position, sensor.beaconPosition);

      positionToCheck.removeWhere(
        (e) => manhattanDistance(sensor.position, e) <= distance,
      );
    }

    for (final sensor in sensors) {
      for (final pos in positionToCheck) {
        if (!pos.isValid()) continue;

        final d1 = manhattanDistance(sensor.position, pos);
        final d2 = manhattanDistance(sensor.position, sensor.beaconPosition);

        if (d1 > d2) {
          return pos.tuningFrequency;
        }
      }
    }

    return 0;
  }
}

int manhattanDistance(Position a, Position b) {
  return (a.x - b.x).abs() + (a.y - b.y).abs();
}

/// Return all the position that are on the border of the radius [distance] with
/// a center at [pos].
Iterable<Position> getExternalBorderForPosition(
  Position pos,
  int distance,
) sync* {
  final effectiveDistance = distance + 1;
  final topPos = Position(pos.x, pos.y - effectiveDistance);
  final bottomPos = Position(pos.x, pos.y + effectiveDistance);

  int offset = 0;
  for (int y = topPos.y; y < pos.y; y++) {
    yield Position(pos.x - offset, y);
    yield Position(pos.x + offset, y);
    offset++;
  }

  yield Position(pos.x - effectiveDistance, pos.y);
  yield Position(pos.x + effectiveDistance, pos.y);

  offset = 0;
  for (int y = pos.y; y > bottomPos.y; y--) {
    yield Position(pos.x - offset, y);
    yield Position(pos.x + offset, y);
    offset++;
  }
}

class Sensor {
  const Sensor({
    required this.position,
    required this.beaconPosition,
  });

  final Position position;
  final Position beaconPosition;
}

extension PositionParser on Position {
  static Position fromString(String input) {
    final parts = input.replaceAll('x=', '').replaceAll('y=', '').split(',');
    return Position(int.parse(parts[0]), int.parse(parts[1]));
  }

  bool isValid() {
    return x >= 0 && x <= 4000000 && y >= 0 && y <= 4000000;
  }

  int get tuningFrequency => x * 4000000 + y;
}
