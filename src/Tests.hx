import days.*;
import sys.io.File;
import utest.ITest;
import utest.UTest;
import haxe.Int64.parseString as int64;

class Tests implements ITest {
	static function main() {
		UTest.run([new Tests()]);
	}

	function new() {}

	function data(name:String):String {
		return File.getContent('data/$name.txt').replace("\r", "");
	}

	#if !only_current_day
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
		int64("4723283400") == Day03.findTreeCountProduct(data("day03/input"));
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

	function specDay08() {
		final example = Day08.parseProgram(data("day08/example"));
		final input = Day08.parseProgram(data("day08/input"));

		5 == Day08.runFirstLoop(example).accumulator;
		1548 == Day08.runFirstLoop(input).accumulator;

		8 == Day08.runRepairedProgram(example);
		1375 == Day08.runRepairedProgram(input);
	}

	function specDay09() {
		final exampleTarget = Day09.findWeaknessPart1(data("day09/example"), 5);
		final realTarget = Day09.findWeaknessPart1(data("day09/input"), 25);

		127 == exampleTarget;
		31161678 == realTarget;

		62 == Day09.findWeaknessPart2(data("day09/example"), exampleTarget);
		5453868 == Day09.findWeaknessPart2(data("day09/input"), realTarget);
	}

	function specDay10() {
		7 * 5 == Day10.calculateDistributionProduct(data("day10/example1"));
		22 * 10 == Day10.calculateDistributionProduct(data("day10/example2"));
		1984 == Day10.calculateDistributionProduct(data("day10/input"));

		8 == Day10.calculateDistinctArrangements(data("day10/example1"));
		19208 == Day10.calculateDistinctArrangements(data("day10/example2"));
		int64("3543369523456") == Day10.calculateDistinctArrangements(data("day10/input"));
	}

	function specDay11() {
		37 == Day11.countFinalOccupiedSeatsDirectlyAdjacent(data("day11/example"));
		2468 == Day11.countFinalOccupiedSeatsDirectlyAdjacent(data("day11/input"));

		26 == Day11.countFinalOccupiedSeatsVisible(data("day11/example"));
		2214 == Day11.countFinalOccupiedSeatsVisible(data("day11/input"));
	}

	function specDay12() {
		25 == Day12.calculateTraveledDistance(data("day12/example"));
		441 == Day12.calculateTraveledDistance(data("day12/input"));

		286 == Day12.calculateTraveledDistanceWithWaypoint(data("day12/example"));
		40014 == Day12.calculateTraveledDistanceWithWaypoint(data("day12/input"));
	}

	function specDay13() {
		59 * 5 == Day13.findBusIdAndWaitTime(data("day13/example1"));
		3882 == Day13.findBusIdAndWaitTime(data("day13/input"));

		1068781 == Day13.findTimestampWithConsecutiveDepartures(data("day13/example1"));
		3417 == Day13.findTimestampWithConsecutiveDepartures(data("day13/example2"));
		754018 == Day13.findTimestampWithConsecutiveDepartures(data("day13/example3"));
		779210 == Day13.findTimestampWithConsecutiveDepartures(data("day13/example4"));
		1261476 == Day13.findTimestampWithConsecutiveDepartures(data("day13/example5"));
		1202161486 == Day13.findTimestampWithConsecutiveDepartures(data("day13/example6"));
		int64("867295486378319") == Day13.findTimestampWithConsecutiveDepartures(data("day13/input"));
	}

	function specDay14() {
		165 == Day14.sumMemoryWithMaskedValues(data("day14/example1"));
		int64("11884151942312") == Day14.sumMemoryWithMaskedValues(data("day14/input"));

		208 == Day14.sumMemoryWithMaskedAddresses(data("day14/example2"));
		int64("2625449018811") == Day14.sumMemoryWithMaskedAddresses(data("day14/input"));
	}

	function specDay15() {
		436 == Day15.findNthSpokenNumber("0,3,6", 2020);
		1 == Day15.findNthSpokenNumber("1,3,2", 2020);
		10 == Day15.findNthSpokenNumber("2,1,3", 2020);
		27 == Day15.findNthSpokenNumber("1,2,3", 2020);
		78 == Day15.findNthSpokenNumber("2,3,1", 2020);
		438 == Day15.findNthSpokenNumber("3,2,1", 2020);
		1836 == Day15.findNthSpokenNumber("3,1,2", 2020);
		1085 == Day15.findNthSpokenNumber("1,20,11,6,12,0", 2020);

		// 10652 == Day15.findNthSpokenNumber("1,20,11,6,12,0", 30000000);
	}

	function specDay16() {
		71 == Day16.calculateTicketScanningErrorRate(data("day16/example1"));
		27850 == Day16.calculateTicketScanningErrorRate(data("day16/input"));

		1 == Day16.calculateDepartureProduct(data("day16/example2"));
		int64("491924517533") == Day16.calculateDepartureProduct(data("day16/input"));
	}

	function specDay17() {
		112 == Day17.countActiveCubesAfterBoot(data("day17/example"), 3);
		384 == Day17.countActiveCubesAfterBoot(data("day17/input"), 3);

		848 == Day17.countActiveCubesAfterBoot(data("day17/example"), 4);
		2012 == Day17.countActiveCubesAfterBoot(data("day17/input"), 4);
	}

	function specDay18() {
		71 == Day18.calculateSumOfExpressions("example1", false);
		51 == Day18.calculateSumOfExpressions("example2", false);
		26 == Day18.calculateSumOfExpressions("example3", false);
		437 == Day18.calculateSumOfExpressions("example4", false);
		12240 == Day18.calculateSumOfExpressions("example5", false);
		13632 == Day18.calculateSumOfExpressions("example6", false);
		int64("14208061823964") == Day18.calculateSumOfExpressions("input", false);

		231 == Day18.calculateSumOfExpressions("example1", true);
		51 == Day18.calculateSumOfExpressions("example2", true);
		46 == Day18.calculateSumOfExpressions("example3", true);
		1445 == Day18.calculateSumOfExpressions("example4", true);
		669060 == Day18.calculateSumOfExpressions("example5", true);
		23340 == Day18.calculateSumOfExpressions("example6", true);
		int64("320536571743074") == Day18.calculateSumOfExpressions("input", true);
	}

	function specDay19() {
		2 == Day19.countMatchingMessages(data("day19/example1"));
		2 == Day19.countMatchingMessages(data("day19/example2"));
		115 == Day19.countMatchingMessages(data("day19/input"));

		3 == Day19.countMatchingMessages(data("day19/example3"));
		12 == Day19.countMatchingMessagesWithLoops(data("day19/example3"));
		237 == Day19.countMatchingMessagesWithLoops(data("day19/input"));
	}

	function specDay20() {
		int64("20899048083289") == Day20.calculateCornerProduct(data("day20/example"));
		int64("51214443014783") == Day20.calculateCornerProduct(data("day20/input"));

		273 == Day20.calculateWaterRoughness(data("day20/example"), data("day20/monster"));
		2065 == Day20.calculateWaterRoughness(data("day20/input"), data("day20/monster"));
	}

	function specDay21() {
		5 == Day21.countIngredientsWithoutAllergens(data("day21/example"));
		2573 == Day21.countIngredientsWithoutAllergens(data("day21/input"));

		"mxmxvkd,sqjhc,fvjkl" == Day21.getCanonicalDangerousIngredientsList(data("day21/example"));
		"bjpkhx,nsnqf,snhph,zmfqpn,qrbnjtj,dbhfd,thn,sthnsg" == Day21.getCanonicalDangerousIngredientsList(data("day21/input"));
	}
	#end

	function specDay22() {
		306 == Day22.playCrabCombat(data("day22/example1"));
		35397 == Day22.playCrabCombat(data("day22/input"));

		291 == Day22.playRecursiveCrabCombat(data("day22/example1"));
		105 == Day22.playRecursiveCrabCombat(data("day22/example2"));
		31120 == Day22.playRecursiveCrabCombat(data("day22/input"));
	}
}
