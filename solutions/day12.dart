import '../utils/extensions.dart';
import '../utils/index.dart';
import '../utils/pathfinding.dart';

class Day12 extends GenericDay {
  Day12() : super(12);

  @override
  HeightsGrid parseInput() {
    final content = input
        .getPerLine()
        .where((e) => e.isNotEmpty)
        .map((e) => e.split(''))
        .where((e) => e.isNotEmpty)
        .toList();
    return HeightsGrid.fromLines(content);
  }

  @override
  int? solvePart1() {
    final grid = parseInput();
    return grid.leastStepsToEnd(grid.start);
  }

  @override
  int? solvePart2() {
    final grid = parseInput();
    final starts = grid.grid.locationsWhere((e) => e == 'a');

    return starts.map(grid.leastStepsToEnd).min;
  }
}

class HeightsGrid {
  const HeightsGrid({
    required this.grid,
    required this.start,
    required this.end,
  });

  factory HeightsGrid.fromLines(List<List<String>> lines) {
    final grid = Field<String>(lines);
    final start = grid.locationsWhere((e) => e == 'S').first;
    final end = grid.locationsWhere((e) => e == 'E').first;

    grid.setValueAtPosition(start, 'a');
    grid.setValueAtPosition(end, 'z');

    return HeightsGrid(grid: grid, start: start, end: end);
  }

  final Field<String> grid;
  final Position start;
  final Position end;

  int? leastStepsToEnd(Position startPoint) {
    return dijkstraLowestCost<Position>(
      start: startPoint,
      goal: end,
      costTo: (a, b) => 1,
      neighborsOf: (pos) => grid.adjacent(pos.x, pos.y).where((e) {
        final elemVal = grid.getValueAtPosition(e);
        final posVal = grid.getValueAtPosition(pos);

        return elemVal.codeUnitAt(0) - posVal.codeUnitAt(0) <= 1;
      }),
    )?.toInt();
  }
}
