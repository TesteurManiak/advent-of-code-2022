import '../utils/extensions.dart';
import '../utils/index.dart';
import '../utils/int_utils.dart';

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
          if (worryLevel.isDivisibleBy(monkey.mod)) {
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
    final mod = monkeys.map((m) => m.mod).reduce(lcm);

    for (int i = 0; i < 10000; i++) {
      for (final monkey in monkeys) {
        for (final item in monkey.items) {
          monkey.numberOfInspections++;
          int worryLevel = monkey.operation(item);
          worryLevel %= mod;
          if (worryLevel.isDivisibleBy(monkey.mod)) {
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
}

class Monkey {
  Monkey({
    required this.id,
    required this.items,
    required this.operation,
    required this.targetIfTrue,
    required this.targetIfFalse,
    required this.mod,
  });

  factory Monkey.fromGroup(List<String> group) {
    final id = group[0].skip(7).take(1);
    final startingItems = group[1].skip(18).split(',').map(int.parse).toList();
    final operation = group[2].skip(13);
    final mod = int.parse(group[3].split(' ').last);
    final targetIfTrue = group[4].skip(29);
    final targetIfFalse = group[5].skip(30);

    return Monkey(
      id: int.parse(id),
      items: startingItems,
      operation: operations[operation]!,
      targetIfTrue: int.parse(targetIfTrue),
      targetIfFalse: int.parse(targetIfFalse),
      mod: mod,
    );
  }

  final int id;
  final List<int> items;
  final OperationFunction operation;
  final int targetIfTrue;
  final int targetIfFalse;
  final int mod;

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

extension on int {
  bool isDivisibleBy(int number) {
    return this % number == 0;
  }
}
