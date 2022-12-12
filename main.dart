import 'package:args/args.dart';
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
  Day12(),
];

void main(List<String?> args) {
  final parser = ArgParser()
    ..addFlag('all', abbr: 'a', negatable: false, callback: printAllSolution)
    ..addFlag('help', abbr: 'h', negatable: false, callback: printHelper)
    ..addOption('day', abbr: 'd', defaultsTo: days.last.day.toString());

  final results = parser.parse(args.whereType<String>());
  final all = results['all'] as bool;
  final help = results['help'] as bool;
  final day = results['day'] as String;

  if (all || help) {
    return;
  } else {
    printSolutionForDay(int.parse(day));
  }
}

void printHelper(bool enabled) {
  if (enabled) {
    print(
      '''
Usage: dart main.dart <command>

Options:
  -h, --help             Show this help message
  -a, --all              Show all solutions
  -d <day>, --day <day>  Show solutions for a specific day
''',
    );
  }
}

void printAllSolution(bool enabled) {
  if (enabled) {
    for (final day in days) day.printSolutions();
  }
}

void printSolutionForDay(int day) {
  final daySolution = days.firstWhereOrNull((e) => e.day == day);
  if (daySolution == null) {
    print('No solution found for day $day');
  } else {
    daySolution.printSolutions();
  }
}
