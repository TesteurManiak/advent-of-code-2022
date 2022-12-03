import '../utils/index.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final inputLines = parseInput();
    int sumOfPriorities = 0;
    for (final line in inputLines) {
      final part1 = line.substring(0, line.length ~/ 2);
      final part2 = line.substring(line.length ~/ 2);

      final commonCharacters =
          part1.findCommonCharacters((e) => part2.contains(e));
      sumOfPriorities += commonCharacters.sumOfPriorities();
    }

    return sumOfPriorities;
  }

  @override
  int solvePart2() {
    final inputLines = parseInput();
    int sumOfPriorities = 0;

    for (int i = 0; i < inputLines.length; i += 3) {
      final line1 = inputLines[i];
      final line2 = inputLines[i + 1];
      final line3 = inputLines[i + 2];
      final commonCharacters = line1
          .findCommonCharacters((e) => line2.contains(e) && line3.contains(e));

      sumOfPriorities += commonCharacters.sumOfPriorities();
    }
    return sumOfPriorities;
  }
}

extension on String {
  Set<String> findCommonCharacters(bool test(String element)) {
    return split('').where(test).toSet();
  }
}

extension on Iterable<String> {
  int sumOfPriorities() {
    return map((e) => characterValue(e)).reduce((value, e) => value + e);
  }
}

int characterValue(String character) {
  final asciiValue = character.codeUnitAt(0);
  if (asciiValue >= 97 && asciiValue <= 122) {
    return asciiValue - 96;
  } else if (asciiValue >= 65 && asciiValue <= 90) {
    return asciiValue - 64 + 26;
  } else {
    return 0;
  }
}
