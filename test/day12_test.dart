import 'package:test/test.dart';

import '../solutions/index.dart';
import 'utils/test_utils.dart';

void main() {
  group('Day12', () {
    final day = Day12();

    setUpAllForDay(day);

    group('solvePart1', () {
      const expectedOutput = 31;

      test('returns $expectedOutput', () {
        expect(day.solvePart1(), expectedOutput);
      });
    });

    group('solvePart2', () {
      const expectedOutput = 29;

      test('returns $expectedOutput', () {
        expect(day.solvePart2(), expectedOutput);
      });
    });
  });
}
