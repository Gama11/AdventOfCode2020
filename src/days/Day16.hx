package days;

class Day16 {
	static function parse(input:String):Notes {
		final sections = input.split("\n").filter(l -> !l.endsWith(":")).join("\n").split("\n\n");
		final rulePattern = ~/(\w+): (\d+)-(\d+) or (\d+)-(\d+)/;
		final rules:Rules = [
			for (line in sections[0].split("\n")) {
				if (!rulePattern.match(line)) {
					throw 'not match for $line';
				}
				rulePattern.matched(1) => {
					first: {min: rulePattern.int(2), max: rulePattern.int(3)},
					second: {min: rulePattern.int(4), max: rulePattern.int(5)}
				};
			}
		];
		function parseTicket(line:String):Ticket {
			return line.split(",").map(Std.parseInt);
		}
		return {
			rules: rules,
			ownTicket: parseTicket(sections[1]),
			nearbyTickets: sections[2].split("\n").map(parseTicket)
		};
	}

	public static function calculateTicketScanningErrorRate(input:String):Int {
		final notes = parse(input);
		function isInRange(value:Int, range:Range) {
			return value >= range.min && value <= range.max;
		}
		function violatesAllRules(value:Int):Bool {
			return notes.rules.foreach(rule -> !isInRange(value, rule.first) && !isInRange(value, rule.second));
		}
		return notes.nearbyTickets.flatten().filter(violatesAllRules).sum();
	}
}

private typedef Notes = {
	final rules:Rules;
	final ownTicket:Ticket;
	final nearbyTickets:Array<Ticket>;
}

private typedef Rules = Map<String, {first:Range, second:Range}>;

private typedef Range = {
	final min:Int;
	final max:Int;
}

private typedef Ticket = Array<Int>;
