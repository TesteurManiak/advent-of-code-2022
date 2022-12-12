import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:collection/collection.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:http/http.dart' as http;

/// Small Program to be used to generate files and boilerplate for a given day.\
/// Call with `dart run day_generator.dart <day>`
Future<void> main(List<String?> args) async {
  const session =
      '53616c7465645f5fbaa4b5351d60110dd4c7a466cfd7b671d03b77d110ef2c634f5b2188afbf39a852d3c7d6944bb2edd4b9f556b13760f7129045fdd68e637c';

  final parser = ArgParser()
    ..addSeparator('Usage: dart day_generator.dart <day> [options] [flags]')
    ..addSeparator('Options:')
    ..addOption(
      'year',
      abbr: 'y',
      defaultsTo: DateTime.now().year.toString(),
      valueHelp: 'year',
      help: 'The year for which to generate the files.',
    )
    ..addSeparator('Flags:')
    ..addFlag(
      'with-test',
      negatable: false,
      help: 'Generate test files as well.',
    )
    ..addFlag('help', abbr: 'h', negatable: false, hide: true);

  final results = parser.parse(args.whereType<String>());
  final year = results['year'] as String;
  final int dayInt;
  final String dayNumber;

  // input through terminal
  if (args.length == 0) {
    print('Please enter a day for which to generate files');
    final input = stdin.readLineSync();
    if (input == null) {
      print('No input given, exiting');
      exit(0);
    }
    dayInt = int.parse(input);
    // pad day number to have 2 digits
    dayNumber = dayInt.toString().padLeft(2, '0');
    // input from CLI call
  } else {
    if (results.wasParsed('help')) {
      print(parser.usage);
      exit(0);
    }
    dayInt = int.parse(args[0]!);
    dayNumber = dayInt.toString().padLeft(2, '0');
  }

  // inform user
  print('Creating day: $dayNumber files');

  final futures = <Future>[];

  // Create lib file
  final dayFileName = 'day$dayNumber.dart';
  futures.add(
    File('solutions/$dayFileName').writeDayFile(
      dayString: dayNumber,
      dayInt: dayInt,
    ),
  );

  // Create test file
  if (results.wasParsed('with-test')) {
    futures.addAll([
      File('test/test_input/aoc${dayNumber}.txt')
          .writeTestInputFile(year: year, day: dayInt),
      File('test/day${dayNumber}_test.dart').writeTestFile(dayNumber),
    ]);
  }

  // export new day in index file
  futures.add(
    File('solutions/index.dart').writeAsString(
      "export 'day$dayNumber.dart';\n",
      mode: FileMode.append,
    ),
  );

  await Future.wait(futures);

  // Create input file
  print('Loading input from adventofcode.com...');
  try {
    final request = await HttpClient().getUrl(
      Uri.parse(
        'https://adventofcode.com/$year/day/${int.parse(dayNumber)}/input',
      ),
    );
    request.cookies.add(Cookie("session", session));
    final response = await request.close();
    final dataPath = 'input/aoc$dayNumber.txt';

    await response.pipe(File(dataPath).openWrite());
  } catch (e) {
    print('Error loading file: $e');
    exit(2);
  }

  print('All set, Good luck!');
}

extension WriteTemplateExtension on File {
  Future<void> writeDayFile({
    required String dayString,
    required int dayInt,
  }) async {
    final alreadyExists = await exists();
    if (alreadyExists) return;

    String template = await readTemplateFileAsString('day.dart');
    template = template.replaceAll(RegExp('{{dayString}}'), dayString);
    template = template.replaceAll(RegExp('{{dayInt}}'), dayInt.toString());

    await writeAsString(template);
  }

  Future<void> writeTestFile(String dayString) async {
    final alreadyExists = await exists();
    if (alreadyExists) return;

    String template = await readTemplateFileAsString('day_test.dart');
    template = template.replaceAll(RegExp('{{dayString}}'), dayString);

    await writeAsString(template);
  }

  Future<void> writeTestInputFile({
    required String year,
    required int day,
  }) async {
    final alreadyExists = await exists();
    if (alreadyExists) return;

    try {
      final example = await scrapExample(year, day);
      await writeAsString(example);
    } catch (e) {
      print('Error fetching example: $e');
    }
  }
}

Future<String> readTemplateFileAsString(String name) {
  return File('templates/$name.mustache').readAsString();
}

/// Return the first code block found in the page's body which is often the
/// example input.
Future<String> scrapExample(String year, int day) async {
  final uri = Uri.parse('https://adventofcode.com/$year/day/$day');
  final response = await http.Client().get(uri);
  final document = htmlParser.parse(response.body);

  return document.body
          ?.querySelector('main')
          ?.querySelector('article')
          ?.querySelectorAll('pre')
          .firstOrNull
          ?.querySelectorAll('code')
          .firstOrNull
          ?.text ??
      '';
}
