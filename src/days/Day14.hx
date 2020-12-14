package days;

class Day14 {
	static function parse(input:String):Program {
		return input.split("\n").map(function(line) {
			final maskPrefix = "mask = ";
			if (line.startsWith(maskPrefix)) {
				final mask = line.substr(maskPrefix.length);
				final chars = mask.split("");
				return SetMask([
					for (i in 0...chars.length) {
						35 - i => switch chars[i] {
							case "0": false;
							case "1": true;
							case _: continue;
						}
					}
				]);
			}
			final writePattern = ~/mem\[(\d+)\] = (\d+)/;
			if (!writePattern.match(line)) {
				throw 'invalid instruction $line';
			}
			return Write(writePattern.int(1), writePattern.int(2));
		});
	}

	public static function calculateSumOfMemoryValues(input:String):Int64 {
		final program = parse(input);
		var mask = null;
		final memory:Map<Int, Int64> = [];
		for (instruction in program) {
			switch instruction {
				case SetMask(newMask):
					mask = newMask;

				case Write(address, value):
					for (offset => bit in mask) {
						if (bit) {
							value |= (1 : Int64) << offset;
						} else {
							value &= ~((1 : Int64) << offset);
						}
					}
					memory[address] = value;
			}
		}
		return memory.array().sum64();
	}
}

private typedef Program = Array<Instruction>;

private enum Instruction {
	SetMask(mask:Map<Int, Bool>);
	Write(address:Int, value:Int64);
}
