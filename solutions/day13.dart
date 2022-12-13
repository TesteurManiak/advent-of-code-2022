import 'dart:convert';

import '../utils/index.dart';

class Day13 extends GenericDay {
  Day13() : super(13);

  CustomListInt recursiveParse(List myList) {
    final completedList = <CustomListInt>[];
    for (final e in myList) {
      if (e is List) {
        completedList.add(recursiveParse(e));
      } else {
        completedList.add(CustomListInt.int(e as int));
      }
    }
    return CustomListInt.list(completedList);
  }

  @override
  Iterable<CustomListInt> parseInput() sync* {
    final inputLines = input.getPerLine()..removeWhere((e) => e.isEmpty);

    final groupedList = <List<dynamic>>[];
    for (final line in inputLines) {
      final parsedLine = jsonDecode(line) as List;
      yield recursiveParse(parsedLine);
      groupedList.add(parsedLine);
    }
  }

  Iterable<SignalPair> parsePart1() sync* {
    final inputs = parseInput();
    final groupedList = <CustomListInt>[];

    for (final input in inputs) {
      groupedList.add(input);
      if (groupedList.length == 2) {
        yield SignalPair(
          groupedList[0],
          groupedList[1],
        );
        groupedList.clear();
      }
    }
  }

  @override
  int solvePart1() {
    final result = parsePart1().toList();
    final indexesOrdered = <int>[];

    for (int i = 0; i < result.length; i++) {
      final pair = result[i];
      final ordered = areOrdered(pair.left, pair.right) > 0;

      if (ordered) indexesOrdered.add(i + 1);
    }
    return indexesOrdered.sum;
  }

  @override
  int solvePart2() {
    const startKey = CustomListInt.list([CustomListInt.int(2)]);
    const endKey = CustomListInt.list([CustomListInt.int(6)]);

    List<CustomListInt> result = parseInput().toList();
    result.addAll([startKey, endKey]);
    result.sort(areOrdered);
    result = result.reversed.toList();

    return (result.indexOf(startKey) + 1) * (result.indexOf(endKey) + 1);
  }

  int areOrdered(CustomListInt left, CustomListInt right) {
    if (left.isInt && right.isInt) {
      return right.requireValue.compareTo(left.requireValue);
    } else if (left.isList && right.isList) {
      for (int i = 0; i < left.requireEntries.length; i++) {
        if (i >= right.requireEntries.length) return -1;

        final result = areOrdered(
          left.requireEntries[i],
          right.requireEntries[i],
        );

        if (result != 0) return result;
      }
      if (left.requireEntries.length < right.requireEntries.length) return 1;
      return 0;
    } else if (left.isInt && right.isList) {
      return areOrdered(
        CustomListInt.list(left.convertToList()),
        right,
      );
    } else if (left.isList && right.isInt) {
      return areOrdered(
        left,
        CustomListInt.list(right.convertToList()),
      );
    }
    return -1;
  }
}

class SignalPair extends Tuple2<CustomListInt, CustomListInt> {
  SignalPair(CustomListInt left, CustomListInt right) : super(left, right);

  CustomListInt get left => item1;
  CustomListInt get right => item2;
}

class CustomListInt {
  const CustomListInt.int(int this.value) : entries = null;
  const CustomListInt.list(List<CustomListInt> this.entries) : value = null;

  final List<CustomListInt>? entries;
  final int? value;

  bool get isInt => value != null;
  bool get isList => entries != null;

  List<CustomListInt> convertToList() {
    if (isInt) {
      return [this];
    } else {
      return entries!;
    }
  }

  int get requireValue {
    assert(isInt);
    return value!;
  }

  List<CustomListInt> get requireEntries {
    assert(isList);
    return entries!;
  }
}
