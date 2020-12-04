package days;

class Day04 {
	static function parsePassport(input:String):Passport {
		return [
			for (pair in ~/\s+/g.split(input).map(pair -> pair.split(":"))) {
				pair[0] => pair[1];
			}
		];
	}

	public static function isValidPart1(passport:Passport):Bool {
		return Field.RequiredFields.foreach(field -> passport.exists(field));
	}

	public static function isValidPart2(passport:Passport):Bool {
		for (field => isValid in Field.ValidationRules) {
			final value = passport[field];
			if (value == null || !isValid(value)) {
				return false;
			}
		}
		return true;
	}

	public static function countValidPassports(input:String, isValid:Passport->Bool):Int {
		return input.split("\n\n").map(parsePassport).count(isValid);
	}
}

private typedef Passport = Map<Field, String>;

private enum abstract Field(String) from String {
	final BirthYear = "byr";
	final IssueYear = "iyr";
	final ExpirationYear = "eyr";
	final Height = "hgt";
	final HairColor = "hcl";
	final EyeColor = "ecl";
	final PassportId = "pid";
	final CountryId = "cid";

	public static final RequiredFields = [
		BirthYear,
		IssueYear,
		ExpirationYear,
		Height,
		HairColor,
		EyeColor,
		PassportId
	];

	public static final ValidationRules:Map<Field, ValidationRule> = {
		function range(from:Int, to:Int, value:String) {
			final int = Std.parseInt(value);
			return int != null && int >= from && int <= to;
		}
		function regex(regex:EReg, value:String) {
			return regex.match(value);
		}
		[
			BirthYear => range.bind(1920, 2002),
			IssueYear => range.bind(2010, 2020),
			ExpirationYear => range.bind(2020, 2030),
			Height => function(value:String) {
				return if (value.endsWith("cm")) {
					range(150, 193, value.replace("cm", "")); 
				} else if (value.endsWith("in")) {
					range(59, 76, value.replace("in", ""));
				} else {
					false;
				}
			},
			HairColor => regex.bind(~/^#[0-9a-f]{6,6}$/),
			EyeColor => regex.bind(~/^(amb|blu|brn|gry|grn|hzl|oth)$/),
			PassportId => regex.bind(~/^\d{9,9}$/)
		];
	}
}

private typedef ValidationRule = (value:String) -> Bool;
