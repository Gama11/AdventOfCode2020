package days;

class Day14 {
	static function parse(input:String):Program {
		return input.split("\n").map(function(line) {
			final maskPrefix = "mask = ";
			if (line.startsWith(maskPrefix)) {
				final mask = line.substr(maskPrefix.length).split("");
				mask.reverse();
				return SetMask(mask);
			}
			final writePattern = ~/mem\[(\d+)\] = (\d+)/;
			if (!writePattern.match(line)) {
				throw 'invalid instruction $line';
			}
			return Write(writePattern.int(1), writePattern.int(2));
		});
	}

	static function applyMask(value:Int64) {}

	public static function sumMemoryWithMaskedValues(input:String):Int64 {
		final program = parse(input);
		var mask = null;
		final memory:Map<Int, Int64> = [];
		for (instruction in program) {
			switch instruction {
				case SetMask(newMask):
					mask = newMask;

				case Write(address, value):
					for (offset => bit in mask) {
						switch bit {
							case One: value = value.setBit(offset);
							case Zero: value = value.clearBit(offset);
							case X:
						}
					}
					memory[address] = value;
			}
		}
		return memory.array().sum();
	}

	public static function sumMemoryWithMaskedAddresses(input:String):Int64 {
		final program = parse(input);
		var mask = null;
		var floatingBits = 0;
		var maskRange = 0;
		final memory:Map<String, Int64> = [];
		for (instruction in program) {
			switch instruction {
				case SetMask(newMask):
					mask = newMask;
					floatingBits = mask.count(v -> v == X);
					maskRange = Std.int(Math.pow(2, floatingBits));

				case Write(address, value):
					for (n in 0...maskRange) {
						var maskedAddress:Int64 = address;
						var floatingIndex = 0;
						for (offset => bit in mask) {
							switch bit {
								case One:
									maskedAddress = maskedAddress.setBit(offset);
								case X:
									maskedAddress = if (n.isBitSet(floatingIndex++)) {
										maskedAddress.setBit(offset);
									} else {
										maskedAddress.clearBit(offset);
									}
								case Zero:
							}
						}
						memory[Std.string(maskedAddress)] = value;
					}
			}
		}
		return memory.array().sum();
	}
}

private typedef Program = Array<Instruction>;

private enum Instruction {
	SetMask(mask:Mask);
	Write(address:Int, value:Int64);
}

private typedef Mask = Array<MaskValue>;

private enum abstract MaskValue(String) from String {
	final Zero = "0";
	final One = "1";
	final X = "X";
}
