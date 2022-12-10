import 'package:test/test.dart';

import '../solutions/day09.dart';
import 'utils/read_input.dart';

void main() {
  group('Day09', () {
    late Day09 day;

    setUp(() {
      day = Day09();
    });

    group('part1', () {
      setUp(() {
        day.input.inputAsList = readInputAsLines('aoc09-1.txt');
      });

      test('solvePart1', () {
        final result = day.solvePart1();
        expect(result, 13);
      });
    });

    group('part2', () {
      setUp(() {
        day.input.inputAsList = readInputAsLines('aoc09-2.txt');
      });

      test('part2', () {
        final result = day.solvePart2();
        expect(result, 36);
      });
    });
  });
}

List<CommandLine> parseInput(List<String> lines) {
  return lines.map(CommandLine.fromString).toList();
}
