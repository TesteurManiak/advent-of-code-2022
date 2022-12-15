import 'package:test/test.dart';

import '../solutions/index.dart';
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
    });
  });
}
