import '../utils/index.dart';
import '../utils/extensions.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  Tuple2<Map<int, List<String>>, List<Movement>> parseInput() {
    const width = 4;

    final stacks = <int, List<String>>{};
    final moves = <Movement>[];
    final inputLines = input.getPerLine();

    int y = 0;
    while (y < inputLines.length) {
      final line = inputLines[y];

      int column = 0;
      for (int x = 0; x < line.length; x += width) {
        final subStr = line.substring(x);
        final str = String.fromCharCodes(subStr.codeUnits.take(width));

        stacks.putIfAbsent(column, () => []);

        if (!RegExp(r'\d').hasMatch(str)) {
          final cleaned = str.replaceAll(RegExp(r'[\[\]]'), '').trim();
          if (cleaned.isNotEmpty) {
            stacks[column]?.add(cleaned);
          }
        }
        column++;
      }
      y++;
      if (line.isEmpty) break;
    }

    while (y < inputLines.length) {
      final line = inputLines[y];
      moves.add(Movement.fromString(line));
      y++;
    }

    return Tuple2(reverseStacks(stacks), moves);
  }

  @override
  String solvePart1() {
    final parsed = parseInput();
    Map<int, List<String>> stacks = parsed.item1;
    final moves = parsed.item2;

    for (final move in moves) {
      stacks = moveStacksOneByOne(move, stacks);
    }

    return stacks.values.map((e) => e.last).join();
  }

  @override
  String solvePart2() {
    final parsed = parseInput();
    Map<int, List<String>> stacks = parsed.item1;
    final moves = parsed.item2;

    for (final move in moves) {
      stacks = moveStackesAllTogether(move, stacks);
    }

    return stacks.values.map((e) => e.last).join();
  }
}

Map<int, List<String>> reverseStacks(Map<int, List<String>> stacks) {
  final reversed = <int, List<String>>{};

  for (final stack in stacks.entries) {
    reversed.putIfAbsent(stack.key, () => []);
    reversed[stack.key]?.addAll(stack.value.reversed);
  }
  return reversed;
}

Map<int, List<String>> moveStacksOneByOne(
  Movement move,
  Map<int, List<String>> stacks,
) {
  final newStacks = Map<int, List<String>>.from(stacks);
  final startStack = newStacks[move.start]!;
  final endStack = newStacks[move.end]!;

  for (int i = 0; i < move.numberOfSteps; i++) {
    final elem = startStack.lastOrNull;

    if (elem == null) break;
    startStack.removeLast();
    endStack.add(elem);
  }

  return newStacks;
}

Map<int, List<String>> moveStackesAllTogether(
  Movement move,
  Map<int, List<String>> stacks,
) {
  final newStacks = Map<int, List<String>>.from(stacks);
  final startStack = newStacks[move.start]!;
  final endStack = newStacks[move.end]!;

  final elems = startStack.takeLast(move.numberOfSteps).toList();
  startStack.removeRange(
      startStack.length - move.numberOfSteps, startStack.length);
  endStack.addAll(elems);

  return newStacks;
}

class Movement {
  final int numberOfSteps;
  final int start;
  final int end;

  const Movement(this.numberOfSteps, this.start, this.end);

  factory Movement.fromString(String input) {
    final parts = input.split(' ')
      ..removeWhere((e) => !RegExp(r'\d').hasMatch(e));

    final numberOfSteps = int.parse(parts[0]);
    final start = int.parse(parts[1]) - 1;
    final end = int.parse(parts[2]) - 1;

    return Movement(numberOfSteps, start, end);
  }
}
