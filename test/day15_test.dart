import 'package:test/test.dart';

import '../solutions/index.dart';
import '../utils/field.dart';
import 'utils/test_utils.dart';

void main() {
  group('Day15', () {
    final day = Day15();

    setUpAllForDay(day);

    group('solvePart1', () {
      const expectedOutput = 26;

      test('returns $expectedOutput', () {
        expect(day.solvePart1(10), expectedOutput);
      });
    });

    group('solvePart2', () {
      const expectedOutput = 56000011;

      test('returns $expectedOutput', () {
        expect(day.solvePart2(), expectedOutput);
      });

      test('manhattanDistance for 8,7 and 2,10', () {
        expect(
          manhattanDistance(const Position(8, 7), const Position(2, 10)),
          9,
        );
      });
    });
  });
}
