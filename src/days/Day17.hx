package days;

class Day17 {
	public static function countActiveCubesAfterBoot(input:String, dimensions:Int):Int {
		final neighbors = PointN.neighbors(dimensions);
		function expandAround(grid:Grid, pos:PointN) {
			for (dir in neighbors) {
				final neighbor = pos + dir;
				if (!grid.exists(neighbor)) {
					grid[neighbor] = Inactive;
				}
			}
		}
		final inputGrid = Util.parseGrid(input, t -> (cast t : Cube));
		var grid = new Grid();
		for (pos => cube in inputGrid.map) {
			final posN = new PointN([pos.x, pos.y].concat([for (_ in 0...dimensions - 2) 0]));
			grid[posN] = cube;
			if (cube == Active) {
				expandAround(grid, posN);
			}
		}

		for (_ in 0...6) {
			final nextGrid = new Grid();
			for (pos => cube in grid) {
				final activeNeighbors = neighbors.count(dir -> grid[pos + dir] == Active);
				nextGrid[pos] = switch cube {
					case Active if (activeNeighbors != 2 && activeNeighbors != 3):
						Inactive;

					case Inactive if (activeNeighbors == 3):
						expandAround(nextGrid, pos);
						Active;

					case _: cube;
				}
			}
			grid = nextGrid;
		}
		return grid.count(cube -> cube == Active);
	}
}

private enum abstract Cube(String) {
	final Active = "#";
	final Inactive = ".";
}

private typedef Grid = HashMap<PointN, Cube>;
