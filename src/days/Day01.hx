package days;

class Day01 {
	public static function find2020Product(input:String, parts:Int):Int {
		final numbers = input.splitToInt("\n");
		final set = [for (n in numbers) n => true];
		function findProduct(target:Int, parts:Int):Null<Int> {
			for (number in set.keys()) {
				final summand = target - number;
				if (parts > 2) {
					final result = findProduct(summand, parts - 1);
					if (result != null) {
						return result * number;
					}
				} else if (set.exists(summand)) {
					return summand * number;
				}
			}
			return null;
		}
		return findProduct(2020, parts);
	}
}
