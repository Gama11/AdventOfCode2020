package days;

class Day08 {
	static function parseProgram(input:String):Program {
		return input.split("\n").map(function(line):Instruction {
			final parts = line.split(" ");
			return {
				op: parts[0],
				argument: Std.parseInt(parts[1])
			}
		});
	}

	static function runProgram(program:Program, stop:(nextInstructionIndex:Int) -> Bool):Int {
		var accumulator = 0;
		var i = 0;
		while (i >= 0 && i < program.length && !stop(i)) {
			final op = program[i].op;
			final argument = program[i].argument;
			switch op {
				case Acc:
					accumulator += argument;
					i++;

				case Jmp:
					i += argument;

				case Nop:
					i++;
			}
		}
		return accumulator;
	}

	public static function findAccumulatorAfterFirstLoop(input:String):Int {
		final executedInstructions = new Map<Int, Bool>();
		return runProgram(parseProgram(input), function(nextInstructionIndex:Int) {
			if (executedInstructions.exists(nextInstructionIndex)) {
				return true;
			}
			executedInstructions[nextInstructionIndex] = true;
			return false;
		});
	}
}

private typedef Program = Array<Instruction>;

private typedef Instruction = {
	final op:Operation;
	final argument:Int;
}

private enum abstract Operation(String) from String {
	final Acc = "acc";
	final Jmp = "jmp";
	final Nop = "nop";
}
