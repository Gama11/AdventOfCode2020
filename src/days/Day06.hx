package days;

class Day06 {
	static function parseGroups(input:String):Array<Group> {
		return input.split("\n\n").map(group -> group.split("\n").map(member -> member.split("")));
	}

	public static function countQuestionsAnyoneAnsweredWithYes(input:String):Int {
		return parseGroups(input).map(group -> group.flatten().unique().length).sum();
	}

	public static function countQuestionsEveryoneAnsweredWithYes(input:String):Int {
		return parseGroups(input).map(function(group) {
			return group.flatten().unique().count(question -> group.foreach(member -> member.contains(question)));
		}).sum();
	}
}

private typedef Group = Array<Member>;
private typedef Member = Array<Question>;
private typedef Question = String;
