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

	public static function countIngredientsWithoutAllergens(input:String):Int {
		final foods = parse(input);
		final allergens = new Map<Allergen, Array<Array<Ingredient>>>();
		for (food in foods) {
			for (allergen in food.knownAllergens) {
				final ingredients = allergens.getOrDefault(allergen, []);
				ingredients.push(food.ingredients);
				allergens[allergen] = ingredients;
			}
		}
		final allergenCandidates = [
			for (allergen => ingredients in allergens) {
				allergen => ingredients.slice(1).fold(Extensions.intersection, ingredients[0]);
			}
		];
		final knownAllergens = new Map<Ingredient, Allergen>();
		while (allergenCandidates.count() > 0) {
			for (allergen => ingredients in allergenCandidates) {
				if (ingredients.length != 1) {
					continue;
				}
				final ingredient = ingredients[0];
				allergenCandidates.remove(allergen);
				knownAllergens[ingredient] = allergen;
				for (otherIngredients in allergenCandidates) {
					otherIngredients.remove(ingredient);
				}
			}
		}
		return foods.map(food -> food.ingredients.count(i -> !knownAllergens.exists(i))).sum();
	}
}

private typedef Food = {
	final ingredients:Array<Ingredient>;
	final knownAllergens:Array<Allergen>;
}

private typedef Ingredient = String;
private typedef Allergen = String;
