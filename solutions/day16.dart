import '../utils/index.dart';
import '../utils/pathfinding.dart';

class Day16 extends GenericDay {
  Day16() : super(16);

  @override
  ValveMap parseInput() {
    final valves = input.getPerLine().map<Valve>((e) {
      final match = RegExp(
        r'Valve (\w+) has flow rate=(\d+); tunnels? (?:lead|leads) to (?:valve|valves) (.*)',
      ).firstMatch(e)!;

      return Valve(
        name: match.group(1)!,
        flowRate: int.parse(match.group(2)!),
        leadsTo: match.group(3)!.split(', '),
      );
    }).toList();

    return Map.fromEntries(valves.map((e) => MapEntry(e.name, e)));
  }

  @override
  int solvePart1() {
    final valveMap = parseInput();
    final start = valveMap['AA']!;
    final destinationRooms =
        valveMap.values.where((e) => e.flowRate > 0).toList();
    final startingRooms = [start, ...destinationRooms];
    final PricesRoomMap priceMap = {};

    for (final room in startingRooms) {
      final prices = valveMap.costCalculation(
        start: room,
        goals: destinationRooms.where((e) => e.name != room.name),
      );
      priceMap[room.name] = prices;
    }

    return getMaxPressure(
      time: 30,
      destinationRooms: destinationRooms,
      priceMap: priceMap,
      valveMap: valveMap,
      start: start,
      withElephant: false,
    );
  }

  @override
  int solvePart2() {
    final valveMap = parseInput();
    final start = valveMap['AA']!;
    final destinationRooms =
        valveMap.values.where((e) => e.flowRate > 0).toList();
    final startingRooms = [start, ...destinationRooms];
    final PricesRoomMap priceMap = {};

    for (final room in startingRooms) {
      final prices = valveMap.costCalculation(
        start: room,
        goals: destinationRooms.where((e) => e.name != room.name),
      );
      priceMap[room.name] = prices;
    }

    return getMaxPressure(
      start: start,
      time: 26,
      destinationRooms: destinationRooms,
      priceMap: priceMap,
      valveMap: valveMap,
      withElephant: true,
    );
  }
}

int getMaxPressure({
  required Valve start,
  required int time,
  required List<Valve> destinationRooms,
  required PricesRoomMap priceMap,
  required ValveMap valveMap,
  required bool withElephant,
}) {
  if (withElephant) {
    return getMaxPressureWithElephant(
      start: start,
      time: time,
      destinationRooms: destinationRooms,
      priceMap: priceMap,
      valveMap: valveMap,
    );
  }

  return getAllPaths(
    start: start,
    time: time,
    destinationRooms: destinationRooms,
    priceMap: priceMap,
    valveMap: valveMap,
    withElephant: false,
  ).first.finalPressure;
}

int getMaxPressureWithElephant({
  required Valve start,
  required int time,
  required List<Valve> destinationRooms,
  required PricesRoomMap priceMap,
  required ValveMap valveMap,
}) {
  int mostPressureReleased = -1;
  final paths = getAllPaths(
    start: start,
    time: time,
    destinationRooms: destinationRooms,
    priceMap: priceMap,
    valveMap: valveMap,
    withElephant: true,
  );

  for (int human = 0; human < paths.length; human++) {
    final humanPath = paths[human];
    for (int elephant = human + 1; elephant < paths.length; elephant++) {
      final elephantPath = paths[elephant];
      if (humanPath.steps.every((s) => !elephantPath.steps.contains(s))) {
        final combinedPressure =
            humanPath.finalPressure + elephantPath.finalPressure;
        if (combinedPressure > mostPressureReleased) {
          mostPressureReleased = combinedPressure;
        }
      }
    }
  }
  return mostPressureReleased;
}

List<_Path> getAllPaths({
  required Valve start,
  required int time,
  required List<Valve> destinationRooms,
  required PricesRoomMap priceMap,
  required ValveMap valveMap,
  required bool withElephant,
}) {
  final paths = <_Path>[
    _Path(
      current: start.name,
      toVisit: destinationRooms.map((e) => e.name).toList(),
      timeLeft: time,
      finished: false,
      steps: [],
      finalPressure: 0,
    ),
  ];

  for (int n = 0; n < paths.length; n++) {
    final path = paths[n];
    if (path.timeLeft <= 0 || path.finished) {
      path.finished = true;
      continue;
    }

    final currentPrices = priceMap[path.current]!;
    bool madeNewPath = false;

    for (final room in path.toVisit) {
      final currentPrice = currentPrices[room]!;
      if (room != path.current && path.timeLeft - currentPrice > 1) {
        madeNewPath = true;
        final newTimeAfterVisitAndValveOpen = path.timeLeft - currentPrice - 1;
        paths.add(
          _Path(
            current: room,
            toVisit: path.toVisit.where((e) => e != room).toList(),
            timeLeft: newTimeAfterVisitAndValveOpen,
            finished: false,
            steps: [...path.steps, room],
            finalPressure: path.finalPressure +
                newTimeAfterVisitAndValveOpen * valveMap[room]!.flowRate,
          ),
        );

        if (withElephant) {
          paths.add(
            _Path(
              current: room,
              toVisit: [],
              timeLeft: newTimeAfterVisitAndValveOpen,
              finished: true,
              steps: [...path.steps, room],
              finalPressure: path.finalPressure +
                  newTimeAfterVisitAndValveOpen * valveMap[room]!.flowRate,
            ),
          );
        }
      }
    }

    if (!madeNewPath) path.finished = true;
  }

  final finishedPaths = paths.where((p) => p.finished).toList()
    ..sort(sortByPressure);

  return finishedPaths;
}

int sortByPressure(_Path a, _Path b) {
  return b.finalPressure - a.finalPressure;
}

class Valve {
  Valve({
    required this.name,
    required this.flowRate,
    required this.leadsTo,
  });

  final String name;
  final int flowRate;
  final List<String> leadsTo;

  Iterable<Valve> neighbors(ValveMap valves) {
    return leadsTo.map((e) => valves[e]!);
  }

  @override
  String toString() {
    return 'Valve $name';
  }
}

class _Path {
  _Path({
    required this.current,
    required this.toVisit,
    required this.timeLeft,
    required this.finished,
    required this.steps,
    required this.finalPressure,
  });

  final String current;
  final List<String> toVisit;
  final int timeLeft;
  final List<String> steps;
  final int finalPressure;

  bool finished;
}

typedef ValveMap = Map<String, Valve>;
typedef CostMap = Map<String, int>;
typedef PricesRoomMap = Map<String, CostMap>;

extension on ValveMap {
  CostMap costCalculation({
    required Valve start,
    required Iterable<Valve> goals,
  }) {
    final lowestCost = dijkstraMap<Valve>(
      start: start,
      goals: goals,
      neighborsOf: (e) => e.neighbors(this),
    );
    return Map.fromEntries(
      goals.map((e) => MapEntry(e.name, lowestCost[e]!.toInt())),
    );
  }
}
