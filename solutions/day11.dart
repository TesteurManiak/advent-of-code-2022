import '../utils/extensions.dart';
import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  List<Monkey> parseInput() {
    final myInput = input.getPerLine();
    final lineGroup = <String>[];
    final monkeys = <Monkey>[];

    for (int i = 0; i < myInput.length; i++) {
      final line = myInput[i];
      if (line.isEmpty) {
        monkeys.add(Monkey.fromGroup(lineGroup));
        lineGroup.clear();
      } else {
        lineGroup.add(line);
      }
    }

    if (lineGroup.isNotEmpty) {
      monkeys.add(Monkey.fromGroup(lineGroup));
    }

    return monkeys;
  }

  @override
  int solvePart1() {
    final monkeys = parseInput();

    for (int i = 0; i < 20; i++) {
      for (final monkey in monkeys) {
        for (final item in monkey.items) {
          monkey.numberOfInspections++;
          int worryLevel = monkey.operation(item);
          worryLevel = (worryLevel / 3).floor();
          if (monkey.test(worryLevel)) {
            monkeys[monkey.targetIfTrue].items.add(worryLevel);
          } else {
            monkeys[monkey.targetIfFalse].items.add(worryLevel);
          }
        }
        monkey.items.clear();
      }
    }
    final top2 = monkeys.map((e) => e.numberOfInspections).topMax(2).toList();
    return top2[0] * top2[1];
  }

  @override
  int solvePart2() {
    final monkeys = parseInput();

    for (int i = 0; i < 10000; i++) {
      for (final monkey in monkeys) {
        for (final item in monkey.items) {
          monkey.numberOfInspections++;
          final int newItem = monkey.operation(item);
          if (monkey.test(newItem)) {
            monkeys[monkey.targetIfTrue].items.add(newItem);
          } else {
            monkeys[monkey.targetIfFalse].items.add(newItem);
          }
        }
        monkey.items.clear();
      }
    }
    final top2 = monkeys.map((e) => e.numberOfInspections).topMax(2).toList();
    return top2[0] * top2[1];
  }
}

class Monkey {
  Monkey({
    required this.id,
    required this.items,
    required this.operation,
    required this.test,
    required this.targetIfTrue,
    required this.targetIfFalse,
  });

  factory Monkey.fromGroup(List<String> group) {
    final id = group[0].skip(7).take(1);
    final startingItems = group[1].skip(18).split(',').map(int.parse).toList();
    final operation = group[2].skip(13);
    final test = group[3].skip(8);
    final targetIfTrue = group[4].skip(29);
    final targetIfFalse = group[5].skip(30);

    return Monkey(
      id: int.parse(id),
      items: startingItems,
      operation: operations[operation]!,
      test: tests[test]!,
      targetIfTrue: int.parse(targetIfTrue),
      targetIfFalse: int.parse(targetIfFalse),
    );
  }

  final int id;
  final List<int> items;
  final OperationFunction operation;
  final TestFunction test;
  final int targetIfTrue;
  final int targetIfFalse;

  int numberOfInspections = 0;
}

typedef OperationFunction = int Function(int old);

final operations = <String, OperationFunction>{
  'new = old * 13': (old) => old * 13,
  'new = old * old': (old) => old * old,
  'new = old + 6': (old) => old + 6,
  'new = old + 2': (old) => old + 2,
  'new = old + 3': (old) => old + 3,
  'new = old + 4': (old) => old + 4,
  'new = old + 8': (old) => old + 8,
  'new = old * 7': (old) => old * 7,
};

typedef TestFunction = bool Function(int worryLevel);

final tests = <String, TestFunction>{
  'divisible by 19': (worryLevel) => worryLevel % 19 == 0,
  'divisible by 7': (worryLevel) => worryLevel % 7 == 0,
  'divisible by 17': (worryLevel) => worryLevel % 17 == 0,
  'divisible by 13': (worryLevel) => worryLevel % 13 == 0,
  'divisible by 11': (worryLevel) => worryLevel % 11 == 0,
  'divisible by 5': (worryLevel) => worryLevel % 5 == 0,
  'divisible by 3': (worryLevel) => worryLevel % 3 == 0,
  'divisible by 2': (worryLevel) => worryLevel.isEven,
};
