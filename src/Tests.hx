import days.*;
import sys.io.File;
import utest.ITest;
import utest.UTest;
import Util;

class Tests implements ITest {
	static function main() {
		UTest.run([new Tests()]);
	}

	function new() {}

	function data(name:String):String {
		return File.getContent('data/$name.txt').replace("\r", "");
	}

	function specDay01() {
		514579 == Day01.find2020Product(data("day01/example"), 2);
		969024 == Day01.find2020Product(data("day01/input"), 2);

		241861950 == Day01.find2020Product(data("day01/example"), 3);
		230057040 == Day01.find2020Product(data("day01/input"), 3);
	}

	function specDay02() {
		2 == Day02.countValidPasswords(data("day02/example"), Day02.part1Policy);
		614 == Day02.countValidPasswords(data("day02/input"), Day02.part1Policy);

		1 == Day02.countValidPasswords(data("day02/example"), Day02.part2Policy);
		354 == Day02.countValidPasswords(data("day02/input"), Day02.part2Policy);
	}

	function specDay03() {
		7 == Day03.countTreesOnTraversal(data("day03/example"), new Point(3, 1));
		187 == Day03.countTreesOnTraversal(data("day03/input"), new Point(3, 1));

		336 == Day03.findTreeCountProduct(data("day03/example"));
		Int64.parseString("4723283400") == Day03.findTreeCountProduct(data("day03/input"));
	}

	function specDay04() {
		2 == Day04.countValidPassports(data("day04/example"), Day04.isValidPart1);
		222 == Day04.countValidPassports(data("day04/input"), Day04.isValidPart1);

		0 == Day04.countValidPassports(data("day04/example2"), Day04.isValidPart2);
		4 == Day04.countValidPassports(data("day04/example3"), Day04.isValidPart2);
		140 == Day04.countValidPassports(data("day04/input"), Day04.isValidPart2);
	}

	function specDay05() {
		357 == Day05.calculateSeatId("FBFBBFFRLR");
		567 == Day05.calculateSeatId("BFFFBBFRRR");
		119 == Day05.calculateSeatId("FFFBBBFRRR");
		820 == Day05.calculateSeatId("BBFFBBFRLL");
		978 == Day05.findHighestSeatId(data("day05/input"));

		727 == Day05.findMySeatId(data("day05/input"));
	}

	function specDay06() {
		11 == Day06.countQuestionsAnyoneAnsweredWithYes(data("day06/example"));
		6947 == Day06.countQuestionsAnyoneAnsweredWithYes(data("day06/input"));

		6 == Day06.countQuestionsEveryoneAnsweredWithYes(data("day06/example"));
		3398 == Day06.countQuestionsEveryoneAnsweredWithYes(data("day06/input"));
	}

	function specDay07() {
		4 == Day07.countColorsContainingGold(data("day07/example"));
		252 == Day07.countColorsContainingGold(data("day07/input"));

		32 == Day07.countBagsInGold(data("day07/example"));
		126 == Day07.countBagsInGold(data("day07/example2"));
		35487 == Day07.countBagsInGold(data("day07/input"));
	}
}
