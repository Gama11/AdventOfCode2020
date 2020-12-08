package days;

class Day08 {
	public static function parseProgram(input:String):Program {
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
			switch program[i] {
				case {op: Acc, argument: value}:
					accumulator += value;
					i++;

				case {op: Jmp, argument: offset}:
					i += offset;

				case {op: Nop}:
					i++;
			}
		}
		return accumulator;
	}

	public static function runFirstLoop(program:Program):{accumulator:Int, stoppedNormally:Bool} {
		final executedInstructions = new Map<Int, Bool>();
		var stoppedNormally = true;
		final accumulator = runProgram(program, function(nextInstructionIndex:Int) {
			if (executedInstructions.exists(nextInstructionIndex)) {
				stoppedNormally = false;
				return true;
			}
			executedInstructions[nextInstructionIndex] = true;
			return false;
		});
		return {
			accumulator: accumulator,
			stoppedNormally: stoppedNormally
		}
	}

	public static function runRepairedProgram(program:Program):Int {
		function swap(i:Int) {
			final instruction = program[i];
			program[i] = {
				op: if (instruction.op == Nop) Jmp else Nop,
				argument: instruction.argument
			};
		}
		for (i in 0...program.length) {
			if (program[i].op != Acc) {
				swap(i);
				final result = runFirstLoop(program);
				if (result.stoppedNormally) {
					return result.accumulator;
				}
				swap(i);
			}
		}
		throw 'no correct program found';
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
