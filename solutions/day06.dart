import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  int parseInput([int length = 4]) {
    final inputData = input.getPerLine();
    final line = inputData[0];

    for (int i = 0; i < line.length; i++) {
      final buffer = <String>{};
      for (int j = 0; j < length; j++) {
        buffer.add(line[i + j]);
      }
      if (buffer.length == length) return i + length;
    }
    return 0;
  }

  @override
  int solvePart1() {
    return parseInput();
  }

  @override
  int solvePart2() {
    return parseInput(14);
  }
}
