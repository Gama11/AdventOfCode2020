package days;

class Day06 {
	public static function findSumOfYesAnswers(input:String) {
		final groups = input.split("\n\n").map(group -> group.split("\n").flatMap(member -> member.split("")));
		return groups.map(group -> group.unique().length).sum();
	}
}
