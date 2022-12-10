import '../utils/index.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  List<List<String>> parseInput() {
    final inputLines = input.getPerLine();
    final results = <List<String>>[];
    for (final line in inputLines) {
      final battle = line.split(' ');
      results.add(battle);
    }
    return results;
  }

  @override
  int solvePart1() {
    final inputLines = parseInput();
    int total = 0;
    for (final line in inputLines) {
      final opponent = RPSValues.fromLetter(line[0]);
      final you = RPSValues.fromLetter(line[1]);

      if (you.isWin(opponent)) {
        total += ResultValues.win.score;
      } else if (you.isDraw(opponent)) {
        total += ResultValues.draw.score;
      }

      total += you.score;
    }
    return total;
  }

  @override
  int solvePart2() {
    final inputLines = parseInput();
    int total = 0;
    for (final line in inputLines) {
      final opponent = RPSValues.fromLetter(line[0]);
      final result = ResultValues.fromLetter(line[1]);

      switch (result) {
        case ResultValues.win:
          total += ResultValues.win.score;
          total += counterFor(opponent).score;
          break;
        case ResultValues.draw:
          total += ResultValues.draw.score;
          total += opponent.score;
          break;
        case ResultValues.loss:
          total += lossFor(opponent).score;
          break;
      }
    }
    return total;
  }
}

enum RPSValues {
  rock('A', 'X', 'Y', 1),
  paper('B', 'Y', 'Z', 2),
  scissors('C', 'Z', 'X', 3);

  final String opponentPlay;
  final String yourPlay;
  final String counter;
  final int score;

  const RPSValues(
    this.opponentPlay,
    this.yourPlay,
    this.counter,
    this.score,
  );

  static RPSValues fromLetter(String letter) {
    switch (letter) {
      case 'A':
      case 'X':
        return RPSValues.rock;
      case 'B':
      case 'Y':
        return RPSValues.paper;
      case 'C':
      case 'Z':
        return RPSValues.scissors;
      default:
        throw Exception('Invalid letter');
    }
  }
}

extension on RPSValues {
  bool isWin(RPSValues other) {
    return yourPlay == other.counter;
  }

  bool isDraw(RPSValues other) {
    return yourPlay == other.yourPlay;
  }
}

RPSValues counterFor(RPSValues value) {
  return RPSValues.values.firstWhere((e) => e.yourPlay == value.counter);
}

RPSValues lossFor(RPSValues value) {
  return RPSValues.values.firstWhere(
    (e) => e.yourPlay != value.counter && e.yourPlay != value.yourPlay,
  );
}

enum ResultValues {
  win('Z', 6),
  draw('Y', 3),
  loss('X', 0);

  final String letter;
  final int score;
  const ResultValues(this.letter, this.score);

  static ResultValues fromLetter(String letter) {
    switch (letter) {
      case 'Z':
        return ResultValues.win;
      case 'Y':
        return ResultValues.draw;
      case 'X':
        return ResultValues.loss;
      default:
        throw Exception('Invalid letter');
    }
  }
}
