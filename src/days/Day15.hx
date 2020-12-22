package days;

class Day15 {
	public static function findNthSpokenNumber(input:String, n:Int):Int {
		final startingNumbers = input.splitToInt(",");
		var lastSpoken = startingNumbers.pop();
		final numberUtterances = [for (turn => number in startingNumbers) number => turn];
		var lastTurn = startingNumbers.length;
		while (lastTurn + 1 < n) {
			final lastUtterance = numberUtterances.getOrDefault(lastSpoken, lastTurn);
			final number = lastTurn - lastUtterance;
			numberUtterances[lastSpoken] = lastTurn;
			lastSpoken = number;
			lastTurn++;
		}
		return lastSpoken;
	}
}
