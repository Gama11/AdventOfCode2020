package days;

class Day02 {
	static function parsePasswordInfo(input:String):PasswordInfo {
		final parts = ~/[ :-]+/g.split(input);
		return {
			policy: {
				n1: Std.parseInt(parts[0]),
				n2: Std.parseInt(parts[1]),
				character: parts[2]
			},
			password: parts[3]
		}
	}

	public static function part1Policy(info:PasswordInfo):Bool {
		final count = new EReg('[^${info.policy.character}]', "g").replace(info.password, "").length;
		return count >= info.policy.n1 && count <= info.policy.n2;
	}

	public static function part2Policy(info:PasswordInfo):Bool {
		function matches(i:Int):Bool {
			return info.password.charAt(i - 1) == info.policy.character;
		}
		final match1 = matches(info.policy.n1);
		final match2 = matches(info.policy.n2);
		return (match1 && !match2) || (!match1 && match2);
	}

	public static function countValidPasswords(input:String, policy:PasswordInfo->Bool):Int {
		return input.split("\n").map(parsePasswordInfo).count(policy);
	}
}

private typedef PasswordInfo = {
	final policy:{
		final character:String;
		final n1:Int;
		final n2:Int;
	};
	final password:String;
}
