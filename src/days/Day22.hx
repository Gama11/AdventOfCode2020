package days;

class Day22 {
	static function parse(input:String) {
		input = input.split("\n").filter(l -> !l.endsWith(":")).join("\n");
		final players = input.split("\n\n");
		return {
			player1: players[0].splitToInt("\n"),
			player2: players[1].splitToInt("\n")
		};
	}

	static function calculateWinningScore(winner:Deck):Int {
		return [for (i in 0...winner.length) (i + 1) * winner[winner.length - 1 - i]].sum();
	}

	public static function playCrabCombat(input:String):Int {
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
		return calculateWinningScore(winner);
	}

	public static function playRecursiveCrabCombat(input:String):Int {
		function playGame(player1:Deck, player2:Deck):Bool {
			final seen = new Map();
			while (player1.length > 0 && player2.length > 0) {
				final key = Util.hashCode(player1) + Util.hashCode(player2);
				if (seen[key]) {
					return true;
				}
				seen[key] = true;

				final card1 = player1.shift();
				final card2 = player2.shift();
				final player1Win = if (player1.length >= card1 && player2.length >= card2) {
					playGame(player1.slice(0, card1), player2.slice(0, card2));
				} else {
					card1 > card2;
				}
				if (player1Win) {
					player1.push(card1);
					player1.push(card2);
				} else {
					player2.push(card2);
					player2.push(card1);
				}
			}
			return player2.length == 0;
		}
		final decks = parse(input);
		final player1 = decks.player1;
		final player2 = decks.player2;
		playGame(player1, player2);

		final winner = if (playGame(player1, player2)) player1 else player2;
		return calculateWinningScore(winner);
	}
}

private typedef StartingDecks = {
	final player1:Deck;
	final player2:Deck;
}

private typedef Deck = Array<Card>;
private typedef Card = Int;
