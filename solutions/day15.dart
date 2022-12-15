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

    for (int y = 0; y <= 4000000; y++) {
      for (int x = 0; x <= 4000000; x++) {
        final pos = Position(x, y);

        if (!pos.isValid()) continue;

        final distanceToBeacon = sensors;
        if (distanceToBeacon.every(
          (sensor) =>
              manhattanDistance(sensor.position, pos) !=
              manhattanDistance(sensor.beaconPosition, pos),
        )) {
          print(pos);
          return pos.tuningFrequency;
        }
      }
    }

    return 0;
  }

  int manhattanDistance(Position a, Position b) {
    return (a.x - b.x).abs() + (a.y - b.y).abs();
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
