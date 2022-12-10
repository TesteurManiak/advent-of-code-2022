import 'dart:math' as math;

import '../utils/index.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  @override
  TreeGrid parseInput() {
    final lineInputs = input.getPerLine();
    final gridMap = <int, List<int>>{};
    for (int i = 0; i < lineInputs.length; i++) {
      final line = lineInputs[i];
      final lineParts = line.split('').map(int.parse).toList();
      gridMap[i] = lineParts;
    }
    return TreeGrid(gridMap);
  }

  @override
  int solvePart1() {
    final grid = parseInput();

    int visibleTrees = grid.numberOfOutsideTrees;
    for (int y = 1; y < grid.height - 1; y++) {
      for (int x = 1; x < grid.width - 1; x++) {
        final currentTree = grid.grid[y]![x];
        final isVisibleFromLeft =
            visibleFrom(currentTree, grid.grid[y]!.sublist(0, x));
        final isVisibleFromRight =
            visibleFrom(currentTree, grid.grid[y]!.sublist(x + 1));
        final isVisibleFromTop = visibleFrom(
          currentTree,
          grid.grid.values.map((e) => e[x]).toList().sublist(0, y),
        );
        final isVisibleFromBottom = visibleFrom(
          currentTree,
          grid.grid.values.map((e) => e[x]).toList().sublist(y + 1),
        );

        if (isVisibleFromLeft ||
            isVisibleFromRight ||
            isVisibleFromTop ||
            isVisibleFromBottom) {
          visibleTrees++;
        }
      }
    }
    return visibleTrees;
  }

  @override
  int solvePart2() {
    final grid = parseInput();

    int maxScenicScore = 0;
    for (int y = 1; y < grid.height; y++) {
      for (int x = 1; x < grid.width; x++) {
        final scenicScore = calculateScenicScore(
          scoreFromTop(x, y, grid.grid),
          scoreFromBottom(x, y, grid.grid),
          scoreFromLeft(x, y, grid.grid),
          scoreFromRight(x, y, grid.grid),
        );
        maxScenicScore = math.max(scenicScore, maxScenicScore);
      }
    }
    return maxScenicScore;
  }

  bool visibleFrom(int tree, List<int> otherTrees) {
    return otherTrees.every((otherTree) => otherTree < tree);
  }

  int scoreFromTop(int x, int y, Map<int, List<int>> grid) {
    final currentTree = grid[y]![x];
    int score = 0;

    for (int i = y - 1; i >= 0; i--) {
      final tree = grid[i]![x];
      if (tree >= currentTree) return score + 1;
      score++;
    }
    return score;
  }

  int scoreFromBottom(int x, int y, Map<int, List<int>> grid) {
    final currentTree = grid[y]![x];

    int score = 0;
    for (int i = y + 1; i < grid.length; i++) {
      final tree = grid[i]![x];
      if (tree >= currentTree) return score + 1;
      score++;
    }
    return score;
  }

  int scoreFromLeft(int x, int y, Map<int, List<int>> grid) {
    final currentTree = grid[y]![x];

    int score = 0;
    for (int i = x - 1; i >= 0; i--) {
      final tree = grid[y]![i];
      if (tree >= currentTree) return score + 1;
      score++;
    }
    return score;
  }

  int scoreFromRight(int x, int y, Map<int, List<int>> grid) {
    final currentTree = grid[y]![x];

    int score = 0;
    for (int i = x + 1; i < grid[0]!.length; i++) {
      final tree = grid[y]![i];
      if (tree >= currentTree) return score + 1;
      score++;
    }
    return score;
  }

  int calculateScenicScore(
    int top,
    int bottom,
    int left,
    int right,
  ) {
    return top * bottom * left * right;
  }
}

class TreeGrid {
  const TreeGrid(this.grid);

  final Map<int, List<int>> grid;

  int get height => grid.length;
  int get width => grid[0]!.length;

  int get numberOfOutsideTrees {
    final outsideTrees = height * 2 + (width - 2) * 2;
    return outsideTrees;
  }
}
