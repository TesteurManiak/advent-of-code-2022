extension NumIterableExtension<T extends num> on Iterable<T> {
  /// Returns an [Iterable] of the top [count] elements with the highest value.
  ///
  /// The returned [Iterable] may contain fewer than [count] elements if this
  /// [Iterable] contains fewer than [count] elements.
  ///
  /// The [count] must not be negative.
  Iterable<T> topMax(int count) {
    assert(count >= 0);
    final list = toList()..sort((a, b) => b.compareTo(a));
    return list.take(count);
  }

  /// Returns an [Iterable] of the top [count] elements with the lowest value.
  ///
  /// The returned [Iterable] may contain fewer than [count] elements if this
  /// [Iterable] contains fewer than [count] elements.
  ///
  /// The [count] must not be negative.
  Iterable<T> topMin(int count) {
    assert(count >= 0);
    final list = toList()..sort();
    return list.take(count);
  }
}

extension IterableExtensions<T> on Iterable<T> {
  /// Returns a new [Iterable] of the [count] last elements of this iterable.
  ///
  /// The returned [Iterable] may contain less than [count] elements if this
  /// iterable contains fewer than [count] elements.
  ///
  /// The [count] must not be negative.
  Iterable<T> takeLast(int count) {
    assert(count >= 0);
    final list = toList();
    final realCount = list.length - count;

    if (realCount < 0) return [];
    return list.skip(realCount);
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

  /// Returns a [Set] of the characters in this string.
  ///
  /// Example:
  /// ```dart
  /// 'hello'.toSet(); // {'h', 'e', 'l', 'o'}
  /// ```
  Set<String> toSet() {
    return Set.from(split(''));
  }
}
