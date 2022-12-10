import '../utils/index.dart';

class Day10 extends GenericDay {
  Day10() : super(10);

  @override
  List<Instruction> parseInput() {
    final lines = input.getPerLine();
    return lines.map(Instruction.fromString).toList();
  }

  @override
  int solvePart1() {
    final instructions = parseInput();
    final signalStrenghtList = <int>[];

    int cycles = 0;
    int registerX = 1;
    for (final instruction in instructions) {
      for (int i = 0; i < instruction.cyclesToComplete; i++) {
        cycles++;
        if ((cycles - 20) % 40 == 0) {
          signalStrenghtList.add(cycles * registerX);
        }
      }
      registerX += instruction.argument;
    }
    return signalStrenghtList.sum;
  }

  @override
  solvePart2() {
    final instructions = parseInput();

    int cycles = 0;
    int registerX = 1;
    int crtPos = 0;
    final sb = StringBuffer();
    for (final instruction in instructions) {
      for (int i = 0; i < instruction.cyclesToComplete; i++) {
        final spritePosition = <int>{
          registerX - 1,
          registerX,
          registerX + 1,
        };

        cycles++;
        sb.write(spritePosition.contains(crtPos) ? '#' : '.');
        crtPos++;

        if (cycles % 40 == 0) {
          print(sb.toString());
          sb.clear();
          crtPos = 0;
        }
      }
      registerX += instruction.argument;
    }
    return null;
  }
}

enum InstructionType { noop, addX }

class Instruction {
  const Instruction.noop()
      : type = InstructionType.noop,
        argument = 0,
        cyclesToComplete = 1;

  const Instruction.addX(this.argument)
      : type = InstructionType.addX,
        cyclesToComplete = 2;

  factory Instruction.fromString(String str) {
    final parts = str.split(' ');
    if (parts.length < 2) {
      return const Instruction.noop();
    }
    return Instruction.addX(int.parse(parts[1]));
  }

  final InstructionType type;
  final int argument;
  final int cyclesToComplete;
}
