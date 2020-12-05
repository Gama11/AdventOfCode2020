package days;

class Day05 {
	static function partition(min:Int, max:Int, lower:Partitioner, upper:Partitioner, instructions:Array<Partitioner>):Int {
		for (partitioner in instructions) {
			final half = Std.int((max + 1 - min) / 2);
			if (partitioner == lower) {
				max -= half;
			} else if (partitioner == upper) {
				min += half;
			} else {
				throw 'invalid partitioner $partitioner';
			}
		}
		if (min != max) {
			throw '$min != $max';
		}
		return min;
	}

	public static function calculateSeatId(input:String):Int {
		final boardingPass = input.split("");
		final row = partition(0, 127, Front, Back, boardingPass.slice(0, 7));
		final column = partition(0, 7, Left, Right, boardingPass.slice(7));
		return row * 8 + column;
	}

	public static function findHighestSeatId(input:String):Int {
		return input.split("\n").max(calculateSeatId).value;
	}
}

private enum abstract Partitioner(String) from String {
	final Front = "F";
	final Back = "B";
	final Left = "L";
	final Right = "R";
}
