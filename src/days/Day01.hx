package days;

class Day01 {
	public static function find2020Checksum(input:String):Int {
		final numbers = input.split("\n").map(Std.parseInt);
		final set = [for (n in numbers) n => true];
		for (number in set.keys()) {
			final summand = 2020 - number;
			if (set.exists(summand)) {
				return summand * number;
			}
		}
		throw "not found";
	}
}
