package days;

import Util.Point;

class Day03 {
	public static function countTreesOnTraversal(input:String, slope:Point):Int64 {
		final grid = Util.parseGrid(input, s -> (cast s : Tile));
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

	public static function findTreeCountProduct(input:String):Int64 {
		return [
			new Point(1, 1),
			new Point(3, 1),
			new Point(5, 1),
			new Point(7, 1),
			new Point(1, 2)
		].map(countTreesOnTraversal.bind(input)).product64();
	}
}

private enum abstract Tile(String) from String {
	final Open = ".";
	final Tree = "#";
}
