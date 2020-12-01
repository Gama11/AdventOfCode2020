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
		514579 == Day01.find2020Checksum(data("day01/example"));
		969024 == Day01.find2020Checksum(data("day01/part1"));
	}
}
