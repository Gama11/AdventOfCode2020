package days;

class Day04 {
	static function parsePassport(input:String):Passport {
		return [
			for (pair in ~/\s+/g.split(input).map(pair -> pair.split(":"))) {
				pair[0] => pair[1];
			}
		];
	}

	static function isPassportValid(passport:Passport):Bool {
		return Field.RequiredFields.foreach(field -> passport.exists(field));
	}

	public static function countValidPassports(input:String):Int {
		return input.split("\n\n").map(parsePassport).count(isPassportValid);
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
}
