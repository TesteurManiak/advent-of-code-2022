import 'package:test/test.dart';

import '../solutions/day08.dart';

void main() {
  group('Day08', () {
    final day = Day08();

    setUpAll(() {
      day.input.inputAsList = [
        '30373',
        '25512',
        '65332',
        '33549',
        '35390',
      ];
    });

    group('solvePart1', () {
      test('should find 21 visible trees', () {
        final result = day.solvePart1();
        expect(result, 21);
      });
    });

    group('solvePart2', () {
      test('max scenic score should be 8', () {
        final result = day.solvePart2();
        expect(result, 8);
      });
    });
  });
}
