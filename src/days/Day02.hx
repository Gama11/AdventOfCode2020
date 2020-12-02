package days;

class Day02 {
	static function parsePasswordInfo(input:String):PasswordInfo {
		final parts = ~/[ :-]+/g.split(input);
		return {
			policy: {
				min: Std.parseInt(parts[0]),
				max: Std.parseInt(parts[1]),
				character: parts[2]
			},
			password: parts[3]
		}
	}

	static function isValidPassword(info: PasswordInfo):Bool {
		final count = new EReg('[^${info.policy.character}]', "g").replace(info.password, "").length;
		return count >= info.policy.min && count <= info.policy.max;
	}

	public static function countValidPasswords(input:String):Int {
		return input.split("\n").map(parsePasswordInfo).count(isValidPassword);
	}
}

typedef PasswordInfo = {
	final policy:{
		final character:String;
		final min:Int;
		final max:Int;
	};
	final password:String;
}
