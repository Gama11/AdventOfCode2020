package days;

class Day10 {
	public static function calculateJoltageDifferences(input:String):Int {
		final joltages = input.split("\n").map(Std.parseInt);
		joltages.sort(Reflect.compare);
		joltages.push(joltages.last() + 3);
		final distribution = new Map<Int, Int>();
		var prev = 0;
		for (joltage in joltages) {
			final difference = joltage - prev;
			distribution[difference] = distribution.getOrDefault(difference, 0) + 1;
			prev = joltage;
		}
		return distribution[1] * distribution[3];
	}
}
