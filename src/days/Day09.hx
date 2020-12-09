package days;

class Day09 {
	public static function findWeakness(input:String, preambleLength:Int):Int {
		final numbers = input.split("\n").map(Std.parseInt);
		final preamble = numbers.slice(0, preambleLength);
		final sums = numbers.slice(preambleLength);
		for (sum in sums) {
			var foundWeakness = true;
			for (tuple in preamble.tuples()) {
				if (tuple.a + tuple.b == sum) {
					foundWeakness = false;
					break;
				}
			}
			if (foundWeakness) {
				return sum;
			}
			preamble.shift();
			preamble.push(sum);
		}
		throw 'no weakness found';
	}
}
