import '../utils/index.dart';

class Day17 extends GenericDay {
  Day17() : super(17);

  @override
  List<Position> parseInput() {
    const moves = [Position(-1, 0), Position(1, 0)];
    const patterns = '<>';
    return input
        .getPerLine()
        .first
        .split('')
        .map((e) => moves[patterns.indexOf(e)])
        .toList();
  }

  @override
  int solvePart1() {
    final jetPattern = parseInput();
    return 0;
  }

  @override
  int solvePart2() {
    final jetPattern = parseInput();
    return 0;
  }
}

enum Tetrimino {
  horizontalBar(
    [Position(0, 0), Position(1, 0), Position(2, 0), Position(3, 0)],
    4,
  ),
  plus(
    [Position(1, 0), Position(0, 1), Position(2, 1), Position(1, 2)],
    3,
  ),
  mirrorL(
    [
      Position(0, 0),
      Position(1, 0),
      Position(2, 0),
      Position(2, 1),
      Position(2, 2)
    ],
    3,
  ),
  verticalBar(
    [Position(0, 0), Position(0, 1), Position(0, 2), Position(0, 3)],
    1,
  ),
  square(
    [Position(0, 0), Position(1, 0), Position(0, 1), Position(1, 1)],
    2,
  );

  const Tetrimino(this.shape, this.width);
  final List<Position> shape;
  final int width;
}
