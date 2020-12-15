package days;

class Day15 {
	public static function find2020thSpokenNumber(input:String):Int {
		final startingNubmers = input.split(",").map(Std.parseInt);
		final numberUtterances = [for (turn => number in startingNubmers) number => [turn]];
		var lastSpoken = startingNubmers.last();
		var turn = startingNubmers.length;
		while (turn < 2020) {
			final lastUtterances = numberUtterances[lastSpoken];
			final number = if (lastUtterances.length < 2) 0 else lastUtterances[0] - lastUtterances[1];
			numberUtterances[number] = [turn].concat(numberUtterances.getOrDefault(number, []));
			lastSpoken = number;
			turn++;
		}
		return lastSpoken;
	}
}
