package days;

class Day21 {
	static function parse(input:String):Array<Food> {
		input = ~/[,()]/g.replace(input, "");
		return input.split("\n").map(function(line) {
			final parts = line.split(" contains ");
			return {
				ingredients: parts[0].split(" "),
				knownAllergens: parts[1].split(" "),
			}
		});
	}

	static function findDangerousIngredients(foods:Array<Food>):Map<Ingredient, Allergen> {
		final allergenAppearances = new Map<Allergen, Array<Array<Ingredient>>>();
		for (food in foods) {
			for (allergen in food.knownAllergens) {
				final ingredients = allergenAppearances.getOrDefault(allergen, []);
				ingredients.push(food.ingredients);
				allergenAppearances[allergen] = ingredients;
			}
		}
		final allergenCandidates = [
			for (allergen => ingredients in allergenAppearances) {
				allergen => ingredients.slice(1).fold(Extensions.intersection, ingredients[0]);
			}
		];
		final dangerousIngredients = new Map<Ingredient, Allergen>();
		while (allergenCandidates.count() > 0) {
			for (allergen => ingredients in allergenCandidates) {
				if (ingredients.length != 1) {
					continue;
				}
				final ingredient = ingredients[0];
				allergenCandidates.remove(allergen);
				dangerousIngredients[ingredient] = allergen;
				for (otherIngredients in allergenCandidates) {
					otherIngredients.remove(ingredient);
				}
			}
		}
		return dangerousIngredients;
	}

	public static function countIngredientsWithoutAllergens(input:String):Int {
		final foods = parse(input);
		final dangerousIngredients = findDangerousIngredients(foods);
		return foods.map(food -> food.ingredients.count(i -> !dangerousIngredients.exists(i))).sum();
	}

	public static function getCanonicalDangerousIngredientsList(input:String):String {
		final foods = parse(input);
		final dangerousIngredients = findDangerousIngredients(foods);
		final canonicalList = dangerousIngredients.keys().array();
		canonicalList.sort((a, b) -> Reflect.compare(dangerousIngredients[a], dangerousIngredients[b]));
		return canonicalList.join(",");
	}
}

private typedef Food = {
	final ingredients:Array<Ingredient>;
	final knownAllergens:Array<Allergen>;
}

private typedef Ingredient = String;
private typedef Allergen = String;
