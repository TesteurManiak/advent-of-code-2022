import 'dart:io';

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
  Day13(),
  Day14(),
  Day15(),
  Day16(),
];

void main(List<String?> args) {
  final parser = ArgParser()
    ..addSeparator('Usage: dart main.dart [options] [flags]')
    ..addSeparator('Options:')
    ..addOption(
      'day',
      abbr: 'd',
      defaultsTo: days.last.day.toString(),
      valueHelp: 'day',
      help: 'Show solutions for a specific day',
    )
    ..addSeparator('Flags:')
    ..addFlag(
      'all',
      abbr: 'a',
      negatable: false,
      callback: printAllSolution,
      help: 'Show all solutions',
    )
    ..addFlag('help', abbr: 'h', negatable: false, hide: true);

  final results = parser.parse(args.whereType<String>());
  final day = results['day'] as String;

  if (results.wasParsed('help')) {
    print(parser.usage);
    exit(0);
  }

  printSolutionForDay(int.parse(day));
}

void printAllSolution(bool enabled) {
  if (enabled) {
    for (final day in days) day.printSolutions();
    exit(0);
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
