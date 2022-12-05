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
