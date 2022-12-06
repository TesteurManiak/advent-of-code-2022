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
  /// Returns a [String] of the [count] first elements of this string.
  ///
  /// The returned [String] may contain fewer than [count] elements, if `this`
  /// contains fewer than [count] elements.
  ///
  /// The [count] must not be negative.
  String take(int count) {
    assert(count >= 0);
    return String.fromCharCodes(codeUnits.take(count));
  }

  /// Returns a [String] that provides all but the first [count] elements.
  ///
  /// If `this` contains fewer than [count] elements, then an empty string is
  /// returned.
  ///
  /// The [count] must not be negative.
  String skip(int count) {
    assert(count >= 0);
    return String.fromCharCodes(codeUnits.skip(count));
  }

  Set<String> toSet() {
    return Set.from(split(''));
  }
}
