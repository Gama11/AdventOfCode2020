package days;

class Day07 {
	static function parseLuggageRules(input:String):LuggageRules {
		final contentPattern = ~/(\d) (\w+ \w+) bags?/;
		final rules = new Map<BagColor, BagContent>();
		for (rule in input.split("\n")) {
			final parts = ~/( bags contain |, )/g.split(rule);
			final color = parts.shift();
			final content = [
				for (part in parts) {
					if (!contentPattern.match(part)) {
						continue;
					}
					final amount = contentPattern.int(1);
					final contentColor = contentPattern.matched(2);
					contentColor => amount;
				}
			];
			rules[color] = content;
		}
		return rules;
	}

	static function invertRules(rules:LuggageRules):Map<BagColor, Array<BagColor>> {
		final inverted = new Map<BagColor, Array<BagColor>>();
		for (color => content in rules) {
			for (contentColor => _ in content) {
				final containers = inverted.getOrDefault(contentColor, []);
				containers.push(color);
				inverted[contentColor] = containers;
			}
		}
		return inverted;
	}

	public static function countColorsContainingGold(input:String):Int {
		final rules = invertRules(parseLuggageRules(input));
		final hasShinyGold = new Map<BagColor, Bool>();
		function walkChildren(color:BagColor) {
			final children = rules[color];
			if (children != null) {
				for (child in children) {
					hasShinyGold[child] = true;
					walkChildren(child);
				}
			}
		}
		walkChildren("shiny gold");
		return hasShinyGold.count();
	}

	public static function countBagsInGold(input:String):Int {
		final rules = parseLuggageRules(input);
		final cache = new Map<BagColor, Int>();
		function countChildren(color:BagColor):Int {
			if (cache.exists(color)) {
				return cache[color];
			}
			final children = rules.getOrDefault(color, []);
			final result = if (children.count() == 0) {
				1;
			} else {
				1 + [for (color => count in children) countChildren(color) * count].sum();
			}
			cache[color] = result;
			return result;
		}
		return countChildren("shiny gold") - 1;
	}
}

typedef LuggageRules = Map<BagColor, BagContent>;
typedef BagContent = Map<BagColor, Int>;
typedef BagColor = String;
