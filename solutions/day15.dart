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
      final distance = sensor.manhattanDistance(sensor.beaconPosition);
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
      positionToCheck.addAll(sensor.getExternalBorderForPosition());
    }

    for (final sensor in sensors) {
      final distance = sensor.manhattanDistance(sensor.beaconPosition);

      positionToCheck.removeWhere(
        (e) => sensor.manhattanDistance(e) <= distance,
      );
    }

    for (final sensor in sensors) {
      for (final pos in positionToCheck.where((e) => e.valid)) {
        final d1 = sensor.manhattanDistance(pos);
        final d2 = sensor.manhattanDistance(sensor.beaconPosition);

        if (d1 > d2) return pos.tuningFrequency;
      }
    }

    return 0;
  }
}

class Sensor {
  const Sensor({
    required this.position,
    required this.beaconPosition,
  });

  final Position position;
  final Position beaconPosition;

  int manhattanDistance(Position b) {
    return (position.x - b.x).abs() + (position.y - b.y).abs();
  }

  Iterable<Position> getExternalBorderForPosition() sync* {
    final distance = manhattanDistance(beaconPosition) + 1;
    final topPos = Position(position.x, position.y - distance);
    final bottomPos = Position(position.x, position.y + distance);

    int offset = 0;
    for (int y = topPos.y; y < position.y; y++) {
      yield Position(position.x - offset, y);
      yield Position(position.x + offset, y);
      offset++;
    }

    yield Position(position.x - distance, position.y);
    yield Position(position.x + distance, position.y);

    offset = 0;
    for (int y = position.y; y > bottomPos.y; y--) {
      yield Position(position.x - offset, y);
      yield Position(position.x + offset, y);
      offset++;
    }
  }
}

extension PositionParser on Position {
  static Position fromString(String input) {
    final parts = input.replaceAll('x=', '').replaceAll('y=', '').split(',');
    return Position(int.parse(parts[0]), int.parse(parts[1]));
  }

  bool get valid => x >= 0 && x <= 4000000 && y >= 0 && y <= 4000000;
  int get tuningFrequency => x * 4000000 + y;
}
