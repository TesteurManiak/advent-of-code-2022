import 'dart:async';
import 'dart:io';

const year = '2022';
const session =
    '53616c7465645f5fbaa4b5351d60110dd4c7a466cfd7b671d03b77d110ef2c634f5b2188afbf39a852d3c7d6944bb2edd4b9f556b13760f7129045fdd68e637c';

/// Small Program to be used to generate files and boilerplate for a given day.\
/// Call with `dart run day_generator.dart <day>`
void main(List<String?> args) async {
  if (args.length > 1) {
    print('Please call with: <dayNumber>');
    return;
  }

  final String dayNumber;

  // input through terminal
  if (args.length == 0) {
    print('Please enter a day for which to generate files');
    final input = stdin.readLineSync();
    if (input == null) {
      print('No input given, exiting');
      return;
    }
    // pad day number to have 2 digits
    dayNumber = int.parse(input).toString().padLeft(2, '0');
    // input from CLI call
  } else {
    dayNumber = int.parse(args[0]!).toString().padLeft(2, '0');
  }

  // inform user
  print('Creating day: $dayNumber');

  // Create lib file
  final dayFileName = 'day$dayNumber.dart';
  unawaited(
    File('solutions/$dayFileName').writeDayFile(
      dayString: dayNumber,
      dayInt: int.parse(dayNumber),
    ),
  );

  // Create test file
  unawaited(File('test/test_input/aoc${dayNumber}.txt').writeAsString(''));
  unawaited(File('test/day${dayNumber}_test.dart').writeTestFile(dayNumber));

  // export new day in index file
  await File('solutions/index.dart').writeAsString(
    "export 'day$dayNumber.dart';\n",
    mode: FileMode.append,
  );

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
    // unawaited(File(dataPath).create());
    await response.pipe(File(dataPath).openWrite());
  } catch (e) {
    print('Error loading file: $e');
  }

  print('All set, Good luck!');
}

extension WriteTemplateExtension on File {
  Future<void> writeDayFile({
    required String dayString,
    required int dayInt,
  }) async {
    String template = await readTemplateFileAsString('day.dart');
    template = template.replaceAll(RegExp('{{dayString}}'), dayString);
    template = template.replaceAll(RegExp('{{dayInt}}'), dayInt.toString());

    await writeAsString(template);
  }

  Future<void> writeTestFile(String dayString) async {
    String template = await readTemplateFileAsString('day_test.dart');
    template = template.replaceAll(RegExp('{{dayString}}'), dayString);

    await writeAsString(template);
  }
}

Future<String> readTemplateFileAsString(String name) {
  return File('templates/$name.mustache').readAsString();
}
