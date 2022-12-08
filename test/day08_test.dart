import 'package:test/test.dart';

import '../solutions/day08.dart';

void main() {
  group('Day08', () {
    final day = Day08();

    final grid = TreeGrid({
      0: [3, 0, 3, 7, 3],
      1: [2, 5, 5, 1, 2],
      2: [6, 5, 3, 3, 2],
      3: [3, 3, 5, 4, 9],
      4: [3, 5, 3, 9, 0],
    });

    group('part1', () {
      test('should find 21 visible trees', () {
        final result = day.solvePart1(grid);
        expect(grid.numberOfOutsideTrees, 16);
        expect(result, 21);
      });
    });

    group('part2', () {
      test('max scenic score should be 8', () {
        final result = day.solvePart2(grid);
        expect(result, 8);
      });

      test('scoreFromTop middle 5 in second row', () {
        final result = day.scoreFromTop(2, 1, grid.grid);
        expect(result, 1);
      });

      test('scoreFromBottom middle 5 in second row', () {
        final result = day.scoreFromBottom(2, 1, grid.grid);
        expect(result, 2);
      });

      test('scoreFromLeft middle 5 in second row', () {
        final result = day.scoreFromLeft(2, 1, grid.grid);
        expect(result, 1);
      });

      test('scoreFromRight middle 5 in second row', () {
        final result = day.scoreFromRight(2, 1, grid.grid);
        expect(result, 2);
      });
    });
  });
}
