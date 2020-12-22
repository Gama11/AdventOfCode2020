package days;

class Day09 {
	public static function findWeaknessPart1(input:String, preambleLength:Int):Int {
		final numbers = input.splitToInt("\n");
		final preamble = numbers.slice(0, preambleLength);
		final sums = numbers.slice(preambleLength);
		for (sum in sums) {
			final hasWeakness = preamble.tuples().foreach(t -> t.a + t.b != sum);
			if (hasWeakness) {
				return sum;
			}
			preamble.shift();
			preamble.push(sum);
		}
		throw 'not found';
	}

	public static function findWeaknessPart2(input:String, target:Int):Int {
		final numbers = input.splitToInt("\n");
		for (i in 0...numbers.length) {
			final start = numbers[i];
			var sum = start;
			for (j in (i + 1)...numbers.length) {
				sum += numbers[j];
				if (sum == target) {
					final set = numbers.slice(i, j + 1);
					set.sort(Reflect.compare);
					return set[0] + set.last();
				} else if (sum > target) {
					break;
				}
			}
		}
		throw 'not found';
	}
}
