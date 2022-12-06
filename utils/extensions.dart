extension NumIterableExtension<T extends num> on Iterable<T> {
  Iterable<T> topMax(int length) {
    final list = toList()..sort((a, b) => b.compareTo(a));
    return list.take(length);
  }

  Iterable<T> topMin(int length) {
    final list = toList()..sort();
    return list.take(length);
  }
}

extension IterableExtensions<T> on Iterable<T> {
  Iterable<T> takeLast(int count) {
    final list = toList();
    return list.skip(list.length - count);
  }
}

extension StringExtensions on String {
  String take(int count) {
    return String.fromCharCodes(codeUnits.take(count));
  }

  String skip(int count) {
    return String.fromCharCodes(codeUnits.skip(count));
  }

  Set<String> toSet() {
    return Set.from(split(''));
  }
}
