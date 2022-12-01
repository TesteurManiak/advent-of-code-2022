import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  List<List<int>> parseInput() {
    final elfs = <List<int>>[];
    final calories = <int>[];
    final inputLines = input.getPerLine();
    for (final line in inputLines) {
      if (line.isEmpty) {
        elfs.add(List<int>.from(calories));
        calories.clear();
      } else {
        calories.add(int.parse(line));
      }
    }
    return elfs;
  }

  @override
  int solvePart1() {
    final results = parseInput();

    int maxCalories = -1;
    for (final elf in results) {
      final calories = elf.reduce((value, e) => value + e);
      if (calories > maxCalories) {
        maxCalories = calories;
      }
    }
    return maxCalories;
  }

  @override
  int solvePart2() {
    final results = parseInput();
    final topThreeMaxCalories = <int>[-1, -1, -1];

    for (final elf in results) {
      final calories = elf.reduce((value, e) => value + e);
      topThreeMaxCalories.sort();
      if (topThreeMaxCalories[0] < calories) {
        topThreeMaxCalories[0] = calories;
      }
    }
    return topThreeMaxCalories.reduce((value, e) => value + e);
  }
}
