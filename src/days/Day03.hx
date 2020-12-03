package days;

import Util.Point;

class Day03 {
	public static function countTreesOnTraversal(input:String):Int {
		final grid = Util.parseGrid(input);
		final slope = new Point(3, 1);
		var position = new Point(0, 0);
		var trees = 0;
		while (position.y < grid.height) {
			position += slope;
			if (position.x >= grid.width) {
				position = new Point(position.x % grid.width, position.y);
			}
			if (grid.map[position] == Tree) {
				trees++;
			}
		}
		return trees;
	}
}

private enum abstract Square(String) from String {
	final Open = ".";
	final Tree = "#";
}
