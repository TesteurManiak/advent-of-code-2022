import 'dart:io' as io;

String readInputAsString(String name) {
  return io.File('test/test_input/$name').readAsStringSync();
}

List<String> readInputAsLines(String name) {
  return io.File('test/test_input/$name').readAsLinesSync();
}
