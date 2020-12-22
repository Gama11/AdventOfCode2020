package days;

class Day22 {
	static function parse(input:String) {
		input = input.split("\n").filter(l -> !l.endsWith(":")).join("\n");
		final players = input.split("\n\n");
		return {
			player1: players[0].split("\n").map(Std.parseInt),
			player2: players[1].split("\n").map(Std.parseInt)
		};
	}

	public static function findWinningScore(input:String):Int {
		final decks = parse(input);
		final player1 = decks.player1;
		final player2 = decks.player2;
		while (player1.length > 0 && player2.length > 0) {
			final card1 = player1.shift();
			final card2 = player2.shift();
			if (card1 > card2) {
				player1.push(card1);
				player1.push(card2);
			} else {
				player2.push(card2);
				player2.push(card1);
			}
		}
		final winner = if (player1.length == 0) player2 else player1;
		return [for (i in 0...winner.length) (i + 1) * winner[winner.length - 1 - i]].sum();
	}
}

private typedef StartingDecks = {
	final player1:Deck;
	final player2:Deck;
}

private typedef Deck = Array<Card>;
private typedef Card = Int;
