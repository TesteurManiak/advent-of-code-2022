import 'package:test/test.dart';

import '../solutions/index.dart';
import 'utils/test_utils.dart';

void main() {
  group('Day13', () {
    final day = Day13();

    setUpAllForDay(day);

    group('solvePart1', () {
      const expectedOutput = 13;

      test('returns $expectedOutput', () {
        expect(day.solvePart1(), expectedOutput);
      });
    });

    group('solvePart2', () {
      const expectedOutput = 140;

      test('returns $expectedOutput', () {
        expect(day.solvePart2(), expectedOutput);
      });
    });
  });
}
