import 'package:test/test.dart';

import '../solutions/day09.dart';

void main() {
  group('Day09', () {
    final day = Day09();

    test(
      'part1',
      () {
        final inputLines = <String>[
          'R 4',
          'U 4',
          'L 3',
          'D 1',
          'R 4',
          'D 1',
          'L 5',
          'R 2',
        ];
        day.input.inputAsList = inputLines;
        final result = day.solvePart1();
        expect(result, 13);
      },
    );

    test('part2', () {
      final inputLines = <String>[
        'R 5',
        'U 8',
        'L 8',
        'D 3',
        'R 17',
        'D 10',
        'L 25',
        'U 20',
      ];
      day.input.inputAsList = inputLines;
      final result = day.solvePart2();
      expect(result, 36);
    });
  });
}

List<CommandLine> parseInput(List<String> lines) {
  return lines.map(CommandLine.fromString).toList();
}
