import '../utils/index.dart';

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
    final startingRoom = valveMap['AA']!;
    final destinationRooms =
        valveMap.values.where((e) => e.flowRate > 0).toList();
    final startingRooms = [startingRoom, ...destinationRooms];
    final PricesRoomMap roomsMovePrices = {};
    for (final room in startingRooms) {
      final prices = costCalculation(
        start: room,
        goals: destinationRooms.where((e) => e.name != room.name),
        valveMap: valveMap,
      );
      roomsMovePrices[room.name] = prices;
    }

    return getMaxPressure(
      time: 30,
      destinationRooms: destinationRooms,
      priceMap: roomsMovePrices,
      valveMap: valveMap,
      start: startingRoom,
    );
  }

  @override
  int solvePart2() {
    return 0;
  }
}

CostMap costCalculation({
  required Valve start,
  required Iterable<Valve> goals,
  required ValveMap valveMap,
}) {
  final visited = <Valve>{};
  final toVisit = <Valve>[start];
  final lowestCost = <Valve, int>{start: 0};

  while (toVisit.isNotEmpty) {
    final current = toVisit.removeAt(0);

    if (visited.contains(current)) continue;

    final worthItAdj = current.neighbors(valveMap).where((e) {
      return !visited.contains(e);
    });

    toVisit.addAll(worthItAdj);

    final costToCurrent = lowestCost[current]!;

    for (final neighbor in worthItAdj) {
      final newCostToNeighbor = costToCurrent + 1;
      final costToNeighbor = lowestCost[neighbor] ?? newCostToNeighbor;

      if (newCostToNeighbor <= costToNeighbor) {
        lowestCost[neighbor] = newCostToNeighbor;
      }
    }

    visited.add(current);
  }
  return Map.fromEntries(goals.map((e) => MapEntry(e.name, lowestCost[e]!)));
}

int getMaxPressure({
  required Valve start,
  required int time,
  required List<Valve> destinationRooms,
  required PricesRoomMap priceMap,
  required ValveMap valveMap,
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
        paths.add(
          _Path(
            current: room,
            toVisit: path.toVisit.where((e) => e != room).toList(),
            timeLeft: path.timeLeft - currentPrice - 1,
            finished: false,
            steps: [...path.steps, room],
            finalPressure: path.finalPressure +
                (path.timeLeft - currentPrice - 1) * valveMap[room]!.flowRate,
          ),
        );
      }
    }

    if (!madeNewPath) path.finished = true;
  }

  final finishedPaths = paths.where((p) => p.finished).toList();
  finishedPaths.sort((a, b) {
    return b.finalPressure - a.finalPressure;
  });

  return finishedPaths.first.finalPressure;
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
