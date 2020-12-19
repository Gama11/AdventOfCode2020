package days;

class Day19 {
	static function parse(input:String):Input {
		function ints(s:String):Array<Int> {
			return s.split(" ").map(Std.parseInt);
		}
		final sections = input.split("\n\n");
		final indexPattern = ~/^(\d+): /;
		final rules = [];
		for (line in sections[0].split("\n")) {
			indexPattern.match(line);
			final index = indexPattern.int(1);
			line = line.substr(indexPattern.matched(0).length);
			rules[index] = if (line.contains("\"")) {
				Character(line.charAt(line.indexOf("\"") + 1));
			} else if (line.contains("|")) {
				final parts = line.split(" | ");
				Or(ints(parts[0]), ints(parts[1]));
			} else {
				All(ints(line));
			}
		}
		return {
			rules: rules,
			messages: sections[1].split("\n")
		}
	}

	static function compileRegex(rules:Array<Rule>):EReg {
		function loop(index:RuleIndex):String {
			return switch rules[index] {
				case All(list): list.map(loop).join("");
				case Or(a, b): "(?:" + a.map(loop).join("") + "|" + b.map(loop).join("") + ")";
				case Character(c): c;
			}
		}
		return new EReg("^" + loop(0) + "$", "");
	}

	public static function countMatchingMessages(input:String):Int {
		final input = parse(input);
		final regex = compileRegex(input.rules);
		return input.messages.count(message -> regex.match(message));
	}
}

private typedef Input = {
	final rules:Array<Rule>;
	final messages:Array<String>;
}

private enum Rule {
	All(list:Rules);
	Or(a:Rules, b:Rules);
	Character(c:String);
}

private typedef Rules = Array<RuleIndex>;
private typedef RuleIndex = Int;
