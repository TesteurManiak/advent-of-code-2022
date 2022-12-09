import 'package:test/test.dart';

import '../solutions/day09.dart';

void main() {
  group('Day09', () {
    final day = Day09();
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

    group('Position', () {
      test('distanceBetween', () {
        final p1 = Position(0, 0);
        final p2 = Position(0, 0);
        final p3 = Position(0, 1);
        final p4 = Position(1, 1);
        final p5 = Position(1, 2);

        expect(distanceBetween(p2, p1), 0);
        expect(distanceBetween(p3, p1), 1);
        expect(distanceBetween(p4, p1), 1);
        expect(distanceBetween(p5, p1), 2);
      });
    });

    test('part1', () {
      final result = day.solvePart1(parseInput(inputLines));
      expect(result, 13);
    });
  });
}

List<CommandLine> parseInput(List<String> lines) {
  return lines.map(CommandLine.fromString).toList();
}
