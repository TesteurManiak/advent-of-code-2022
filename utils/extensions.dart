import 'dart:math' as math;

extension IterableExtension<T extends num> on Iterable<T> {
  T get max => reduce(math.max);
  T get min => reduce(math.min);

  Iterable<T> topMax(int length) {
    final list = toList()..sort((a, b) => b.compareTo(a));
    return list.take(length);
  }

  Iterable<T> topMin(int length) {
    final list = toList()..sort();
    return list.take(length);
  }
}
