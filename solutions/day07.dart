import '../utils/index.dart';

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  FileEntry parseInput() {
    final inputLines = input.asString;
    final commandGroups =
        inputLines.split(RegExp(r'\n\$ ')).skip(1).map((e) => e.split('\n'));

    final root = FileEntry.dir(name: '/');
    FileEntry currentDir = root;

    for (final group in commandGroups) {
      final command = group.first;

      if (command.startsWith('cd')) {
        String path = command.substring(3);
        FileEntry? parentDir = currentDir.parent;

        if (path.startsWith('..') && parentDir != null) {
          currentDir = parentDir;
          parentDir = currentDir.parent;
          continue;
        }
        currentDir = currentDir.children[path] ?? currentDir;
      } else if (command.startsWith('ls')) {
        for (int i = 1; i < group.length; i++) {
          final line = group[i];
          if (line.isEmpty) continue;

          final parts = line.split(' ');
          final name = parts[1];
          final size = int.tryParse(parts[0]);

          final FileEntry file;
          if (size == null) {
            file = FileEntry.dir(name: name, parent: currentDir);
          } else {
            file = FileEntry.file(name: name, size: size, parent: currentDir);
          }
          currentDir.children[name] = file;
        }
      }
    }

    return root;
  }

  @override
  solvePart1() {
    final files = parseInput()
        .getAllFiles()
        .where((e) => e.type == FileType.dir && e.totalSize <= 100000);
    return files.map((e) => e.totalSize).sum;
  }

  @override
  solvePart2() {
    final files = parseInput();
    final freeSpace = 70000000 - files.totalSize;
    final neededSpace = 30000000 - freeSpace;

    return files
        .getAllFiles()
        .where((e) => e.type == FileType.dir && e.totalSize >= neededSpace)
        .map((e) => e.totalSize)
        .min;
  }
}

enum FileType { file, dir }

class FileEntry {
  final String name;
  final FileEntry? parent;
  final Map<String, FileEntry> children;
  final int size;
  final FileType type;

  FileEntry.file({
    required this.name,
    required this.size,
    required this.parent,
  })  : children = {},
        type = FileType.file;

  FileEntry.dir({
    required this.name,
    this.parent,
  })  : children = {},
        size = 0,
        type = FileType.dir;

  int get totalSize {
    if (_cachedTotalSize != null) return _cachedTotalSize!;
    int total = size;
    for (final child in children.values) {
      total += child.totalSize;
    }
    _cachedTotalSize = total;
    return total;
  }

  int? _cachedTotalSize;

  Iterable<FileEntry> getAllFiles() sync* {
    yield this;
    for (final child in children.values) {
      for (final file in child.getAllFiles()) {
        yield file;
      }
    }
  }
}
