import 'dart:math' as math;

extension IterableExtension<T extends num> on Iterable<T> {
  T get max => reduce(math.max);

  List<T> topMax(int length) {
    final list = toList()..sort((a, b) => b.compareTo(a));
    return list.sublist(0, length);
  }

  T get min => reduce(math.min);
}
