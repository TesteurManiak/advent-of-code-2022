import 'dart:math' as math;

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
    return elfs;
  }

  @override
  int solvePart1() {
    final results = parseInput();

    int maxCalories = -1;
    for (final elf in results) {
      maxCalories = math.max(maxCalories, elf);
    }
    return maxCalories;
  }

  @override
  int solvePart2() {
    final results = parseInput();
    final topThreeMaxCalories = <int>[-1, -1, -1];

    for (final elf in results) {
      topThreeMaxCalories.sort();
      if (topThreeMaxCalories[0] < elf) {
        topThreeMaxCalories[0] = elf;
      }
    }
    return topThreeMaxCalories.reduce((value, e) => value + e);
  }
}
