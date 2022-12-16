import '../utils/index.dart';
import '../utils/pathfinding.dart';

class Day16 extends GenericDay {
  Day16() : super(16);

  @override
  Map<String, Valve> parseInput() {
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
    final valves = parseInput();

    // Pump that are worth opening
    final workingPumps = valves.values.where((e) => e.flowRate > 0).toList();

    int minuteRemaining = 30;
    Valve currentValve = valves.values.first;
    int totalFlow = 0;
    while (minuteRemaining > 0) {
      minuteRemaining--;
      print('== Minute ${30 - minuteRemaining} ==');
      totalFlow += calculateFlow(valves);

      if (currentValve.potentialFlowRate > 0) {
        print('You open valve ${currentValve.name}');
        currentValve.open = true;
        continue;
      }

      /// Find the next valve to open.
      final paths = dijkstraPath<Valve>(
        start: currentValve,
        goal: workingPumps.reduce((value, element) {
          return value.potentialFlowRate > element.potentialFlowRate
              ? value
              : element;
        }),
        neighborsOf: (p0) => p0.neighbors(valves),
      ).skip(1);

      if (paths.isEmpty) continue;

      final nextValve = paths.first;
      print('You move to valve ${nextValve.name}');
      currentValve = nextValve;
    }

    return totalFlow;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

int calculateFlow(Map<String, Valve> valves) {
  final openedValves = valves.values.where((e) => e.open);
  final sb = StringBuffer();
  if (openedValves.isEmpty) {
    sb.write('No valves are opened.');
  } else {
    sb.write('Valve');

    if (openedValves.length > 1) sb.write('s');
    sb.write(' ');
    for (int i = 0; i < openedValves.length; i++) {
      final valve = openedValves.elementAt(i);
      sb.write(valve.name);
      if (i < openedValves.length - 1) {
        sb.write(', ');
      }
    }
  }
  final releasedPressure = openedValves.map((e) => e.flowRate).sum;
  if (releasedPressure > 0) {
    sb.write(' released $releasedPressure pressure.');
  }
  print(sb.toString());
  return releasedPressure;
}

class Valve {
  Valve({
    required this.name,
    required this.flowRate,
    required List<String> leadsTo,
  }) : _leadsTo = leadsTo;

  final String name;
  final int flowRate;
  final List<String> _leadsTo;

  bool open = false;

  /// Flow rate gained by opening this valve.
  ///
  /// If the valve is already open, it will return 0.
  int get potentialFlowRate => open ? 0 : flowRate;

  Iterable<Valve> neighbors(Map<String, Valve> valves) {
    return _leadsTo.map((e) => valves[e]!);
  }

  @override
  String toString() {
    return 'Valve $name';
  }
}
