import days.*;
import sys.io.File;
import utest.ITest;
import utest.UTest;

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
		969024 == Day01.find2020Product(data("day01/part1"), 2);

		241861950 == Day01.find2020Product(data("day01/example"), 3);
		230057040 == Day01.find2020Product(data("day01/part1"), 3);
	}
}
