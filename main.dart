import 'package:collection/collection.dart';

import 'solutions/index.dart';
import 'utils/generic_day.dart';

/// List holding all the solution classes.
final days = <GenericDay>[
  Day01(),
  Day02(),
  Day03(),
  Day04(),
  Day05(),
  Day06(),
  Day07(),
  Day08(),
  Day09(),
  Day10(),
  Day11(),
];

void main(List<String?> args) {
  if (args.length == 1 && args[0].isHelperArgument()) {
    printHelper();
    return;
  } else if (args.length == 1 && args[0].isAllArgument()) {
    for (final day in days) day.printSolutions();
    return;
  } else if (args.length == 2 && args[0].isDayArgument()) {
    final day = int.parse(args[1]!);
    printSolutionForDay(day);
    return;
  }

  days.last.printSolutions();
}

void printHelper() {
  print(
    '''
Usage: dart main.dart <command>

Global Options:
  -h, --help             Show this help message
  -a, --all              Show all solutions
  -d <day>, --day <day>  Show solutions for a specific day
''',
  );
}

void printSolutionForDay(int day) {
  final daySolution = days.firstWhereOrNull((e) => e.day == day);
  if (daySolution == null) {
    print('No solution found for day $day');
  } else {
    daySolution.printSolutions();
  }
}

extension ArgsMatcher on String? {
  bool isHelperArgument() {
    return this == '-h' || this == '--help';
  }

  bool isAllArgument() {
    return this == '-a' || this == '--all';
  }

  bool isDayArgument() {
    return this == '-d' || this == '--day';
  }
}
