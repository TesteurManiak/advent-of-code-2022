import '../utils/index.dart';

class Day16 extends GenericDay {
  Day16() : super(16);

  @override
  List<Valve> parseInput() {
    return input.getPerLine().map<Valve>((e) {
      final match = RegExp(
        r'Valve (\w+) has flow rate=(\d+); tunnels? (?:lead|leads) to (?:valve|valves) (.*)',
      ).firstMatch(e)!;

      return Valve(
        name: match.group(1)!,
        flowRate: int.parse(match.group(2)!),
        leadsTo: match.group(3)!.split(', '),
      );
    }).toList();
  }

  @override
  int solvePart1() {
    final valves = parseInput();

    int pressureReleased = 0;
    int minuteRemaining = 30;
    Valve currentValve = valves.first;
    while (minuteRemaining > 0) {
      if (currentValve.open) {
        pressureReleased += currentValve.flowRate;
      }
      if (currentValve.shouldOpen(minuteRemaining - 1)) {
        currentValve.open = true;
        minuteRemaining -= 1;
      }
      currentValve = currentValve.leadsTo(valves).first;
      minuteRemaining -= 1;
    }

    return pressureReleased;
  }

  @override
  int solvePart2() {
    return 0;
  }
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

  List<Valve> leadsTo(List<Valve> valves) {
    return valves.where((e) => _leadsTo.contains(e.name)).toList();
  }

  bool shouldOpen(int remainingMinutes) {
    return !open && potentialFlow(remainingMinutes) >= 1;
  }

  int potentialFlow(int remainingMinutes) {
    return flowRate * remainingMinutes;
  }

  @override
  String toString() {
    return 'Valve $name has flow rate=$flowRate; tunnels lead to valves ${_leadsTo.join(', ')}';
  }
}
