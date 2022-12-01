import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  List<int> parseInput() {
    final elfs = <int>[];
    final calories = <int>[];
    final inputLines = input.getPerLine();
    for (final line in inputLines) {
      if (line.isEmpty) {
        elfs.add(calories.reduce((a, b) => a + b));
        calories.clear();
      } else {
        calories.add(int.parse(line));
      }
    }
    elfs.sort((a, b) => b.compareTo(a));
    return elfs;
  }

  @override
  int solvePart1() {
    final results = parseInput();
    return results.first;
  }

  @override
  int solvePart2() {
    final results = parseInput();
    return results.sublist(0, 3).reduce((value, e) => value + e);
  }
}
