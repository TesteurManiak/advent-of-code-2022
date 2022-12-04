import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  List<Tuple2<Pair, Pair>> parseInput() {
    final lineInputs = input.getPerLine();
    final list = <Tuple2<Pair, Pair>>[];
    for (final line in lineInputs) {
      final splittedPairs = line.split(',');
      final firstPair = Pair.fromString(splittedPairs.first);
      final secondPair = Pair.fromString(splittedPairs.last);
      list.add(Tuple2(firstPair, secondPair));
    }
    return list;
  }

  @override
  int solvePart1() {
    final pairs = parseInput();
    int overlaps = 0;
    for (final doublePairs in pairs) {
      final firstPair = doublePairs.item1;
      final secondPair = doublePairs.item2;
      if (firstPair.isFullyOverlapping(secondPair)) {
        overlaps++;
      }
    }
    return overlaps;
  }

  @override
  int solvePart2() {
    final pairs = parseInput();
    int overlaps = 0;
    for (final doublePairs in pairs) {
      final firstPair = doublePairs.item1;
      final secondPair = doublePairs.item2;
      if (firstPair.isPartiallyOverlapping(secondPair)) {
        overlaps++;
      }
    }
    return overlaps;
  }
}

class Pair {
  final int start;
  final int end;

  const Pair(this.start, this.end);

  Pair.fromString(String str)
      : this(
          int.parse(str.split('-').first),
          int.parse(str.split('-').last),
        );

  bool isFullyOverlapping(Pair other) {
    return start <= other.start && end >= other.end ||
        other.start <= start && other.end >= end;
  }

  bool isPartiallyOverlapping(Pair other) {
    return start <= other.start && end >= other.start ||
        other.start <= start && other.end >= start;
  }
}
