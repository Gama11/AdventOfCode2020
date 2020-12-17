package days;

class Day10 {
	static function calculateJoltageDifferences(input:String):Array<Int> {
		final joltages = input.split("\n").map(Std.parseInt);
		joltages.sort(Reflect.compare);
		joltages.push(joltages.last() + 3);
		final differences = [];
		var prev = 0;
		for (joltage in joltages) {
			differences.push(joltage - prev);
			prev = joltage;
		}
		return differences;
	}

	public static function calculateDistributionProduct(input:String):Int {
		final differences = calculateJoltageDifferences(input);
		return differences.count(i -> i == 1) * differences.count(i -> i == 3);
	}

	public static function calculateDistinctArrangements(input:String):Int64 {
		final differences = calculateJoltageDifferences(input);
		final sectionLengths = [];
		var length = 0;
		for (difference in differences) {
			if (difference == 3) {
				sectionLengths.push(length);
				length = 0;
			} else {
				length++;
			}
		}
		return sectionLengths.map(length -> (switch length {
			case 0, 1: 1;
			case 2: 2;
			case 3: 4;
			case 4: 7;
			case _: throw 'unsupported';
		} : Int64)).product();
	}
}
