import 'package:collection/collection.dart';

// Credit to darrenaustin for those utils: https://github.com/darrenaustin/advent-of-code-dart/blob/main/lib/src/util/pathfinding.dart

Iterable<L>? dijkstraPath<L>({
  required L start,
  required L goal,
  required double Function(L, L) costTo,
  required Iterable<L> Function(L) neighborsOf,
}) {
  final dist = <L, double>{start: 0};
  final prev = <L, L>{};
  int compareByDist(L a, L b) =>
      (dist[a] ?? double.infinity).compareTo(dist[b] ?? double.infinity);
  final queue = PriorityQueue<L>(compareByDist)..add(start);

  while (queue.isNotEmpty) {
    L current = queue.removeFirst();
    if (current == goal) {
      // Reconstruct the path in reverse.
      final path = [current];
      while (prev.keys.contains(current)) {
        current = prev[current] as L;
        path.insert(0, current);
      }
      return path;
    }
    for (final neighbor in neighborsOf(current)) {
      final score = dist[current]! + costTo(current, neighbor);
      if (score < (dist[neighbor] ?? double.infinity)) {
        dist[neighbor] = score;
        prev[neighbor] = current;
        queue.add(neighbor);
      }
    }
  }
  return null;
}

double? dijkstraLowestCost<L>({
  required L start,
  required L goal,
  required double Function(L, L) costTo,
  required Iterable<L> Function(L) neighborsOf,
}) {
  final dist = <L, double>{start: 0};
  final prev = <L, L>{};
  int compareByDist(L a, L b) =>
      (dist[a] ?? double.infinity).compareTo(dist[b] ?? double.infinity);
  final queue = PriorityQueue<L>(compareByDist)..add(start);

  while (queue.isNotEmpty) {
    final current = queue.removeFirst();
    if (current == goal) {
      return dist[goal];
    }

    final neighbors = neighborsOf(current);
    for (final neighbor in neighbors) {
      final score = dist[current]! + costTo(current, neighbor);
      if (score < (dist[neighbor] ?? double.infinity)) {
        dist[neighbor] = score;
        prev[neighbor] = current;
        queue.add(neighbor);
      }
    }
  }
  return null;
}
