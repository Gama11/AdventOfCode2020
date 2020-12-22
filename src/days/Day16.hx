package days;

class Day16 {
	static function parse(input:String):Notes {
		final sections = input.split("\n").filter(l -> !l.endsWith(":")).join("\n").split("\n\n");
		final rulePattern = ~/([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)/;
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
			return line.splitToInt(",");
		}
		return {
			rules: rules,
			ownTicket: parseTicket(sections[1]),
			nearbyTickets: sections[2].split("\n").map(parseTicket)
		};
	}

	static function matchesRule(rule:Rule, value:Int) {
		function isInRange(value:Int, range:Range) {
			return value >= range.min && value <= range.max;
		}
		return isInRange(value, rule.first) || isInRange(value, rule.second);
	}

	static function violatesAllRules(rules:Rules, value:Int):Bool {
		return rules.foreach(rule -> !matchesRule(rule, value));
	}

	public static function calculateTicketScanningErrorRate(input:String):Int {
		final notes = parse(input);
		return notes.nearbyTickets.flatten().filter(violatesAllRules.bind(notes.rules)).sum();
	}

	public static function calculateDepartureProduct(input:String):Int64 {
		final notes = parse(input);
		function isValid(ticket:Ticket):Bool {
			return ticket.foreach(value -> !violatesAllRules(notes.rules, value));
		}
		final nearbyTickets = notes.nearbyTickets.filter(isValid);
		final fieldCount = nearbyTickets[0].length;
		final potentialMatches = [
			for (i in 0...fieldCount) {
				final fields = [for (ticket in nearbyTickets) ticket[i]];
				i => [
					for (field => rule in notes.rules) {
						if (fields.foreach(value -> matchesRule(rule, value))) {
							field;
						} else {
							continue;
						}
					}
				];
			}
		];
		final assignedFields = new Map<Int, String>();
		while (potentialMatches.count() > 0) {
			for (index => fields in potentialMatches) {
				if (fields.length == 1) {
					assignedFields[index] = fields[0];
					potentialMatches.remove(index);
					for (v in potentialMatches) {
						v.remove(fields[0]);
					}
					break;
				}
			}
		}
		return [
			for (assignedIndex => field in assignedFields) {
				if (field.startsWith("departure ")) {
					(notes.ownTicket[assignedIndex] : Int64);
				}
			}
		].product();
	}
}

private typedef Notes = {
	final rules:Rules;
	final ownTicket:Ticket;
	final nearbyTickets:Array<Ticket>;
}

private typedef Rules = Map<String, Rule>;
private typedef Rule = {first:Range, second:Range};

private typedef Range = {
	final min:Int;
	final max:Int;
}

private typedef Ticket = Array<Int>;
