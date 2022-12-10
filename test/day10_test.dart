import 'package:test/test.dart';

import '../solutions/day10.dart';
import 'utils/test_utils.dart';

void main() {
  group('Day10', () {
    final day = Day10();

    setUpAllForDay(day);

    group('part1', () {
      test('solvePart1', () {
        expect(day.solvePart1(), 13140);
      });
    });

    group('part2', () {
      test('solvePart2', () {
        final result = day.solvePart2();
        print(result);
      });
    });
  });
}
