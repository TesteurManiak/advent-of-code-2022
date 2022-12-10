import 'package:test/test.dart';

import '../../utils/generic_day.dart';
import 'read_input.dart';

void setUpAllForDay(GenericDay day) {
  final dayString = day.day.toString().padLeft(2, '0');
  setUpAll(() {
    day.input.inputAsString = readInputAsString('aoc$dayString.txt');
    day.input.inputAsList = readInputAsLines('aoc$dayString.txt');
  });
}
