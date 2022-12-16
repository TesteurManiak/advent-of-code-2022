import 'package:collection/collection.dart';

// Credit to darrenaustin for those utils: https://github.com/darrenaustin/advent-of-code-dart/blob/main/lib/src/util/pathfinding.dart

typedef CostTo<L> = double Function(L, L);
typedef NeighborsOf<L> = Iterable<L> Function(L);

List<L> dijkstraPath<L>({
  required L start,
  required L goal,
  required NeighborsOf<L> neighborsOf,
  CostTo<L>? costTo,
}) {
  final localCostTo = costTo ?? (a, b) => 1.0;
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
      while (prev.containsKey(current)) {
        current = prev[current] as L;
        path.insert(0, current);
      }
      return path;
    }
    for (final neighbor in neighborsOf(current)) {
      final score = dist[current]! + localCostTo(current, neighbor);
      if (score < (dist[neighbor] ?? double.infinity)) {
        dist[neighbor] = score;
        prev[neighbor] = current;
        queue.add(neighbor);
      }
    }
  }
  return [];
}

double? dijkstraLowestCost<L>({
  required L start,
  required L goal,
  required NeighborsOf<L> neighborsOf,
  CostTo<L>? costTo,
}) {
  final localCostTo = costTo ?? (a, b) => 1.0;
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
      final score = dist[current]! + localCostTo(current, neighbor);
      if (score < (dist[neighbor] ?? double.infinity)) {
        dist[neighbor] = score;
        prev[neighbor] = current;
        queue.add(neighbor);
      }
    }
  }
  return null;
}

Map<L, double> dijkstraMap<L>({
  required L start,
  required Iterable<L> goals,
  required NeighborsOf<L> neighborsOf,
  CostTo<L>? costTo,
}) {
  final localCostTo = costTo ?? (a, b) => 1.0;
  final visited = <L>{};
  final dist = <L, double>{start: 0};

  int compareByDist(L a, L b) =>
      (dist[a] ?? double.infinity).compareTo(dist[b] ?? double.infinity);

  final queue = PriorityQueue<L>(compareByDist)..add(start);

  while (queue.isNotEmpty) {
    final current = queue.removeFirst();

    if (visited.contains(current)) continue;

    final worthItAdj = neighborsOf(current).where((e) {
      return !visited.contains(e);
    });

    queue.addAll(worthItAdj);

    final costToCurrent = dist[current]!;

    for (final neighbor in worthItAdj) {
      final newCostToNeighbor = costToCurrent + localCostTo(current, neighbor);
      final costToNeighbor = dist[neighbor] ?? newCostToNeighbor;

      if (newCostToNeighbor <= costToNeighbor) {
        dist[neighbor] = newCostToNeighbor;
      }
    }
    visited.add(current);
  }

  return dist;
}
