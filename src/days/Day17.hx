package days;

import haxe.ds.HashMap;

class Day17 {
	public static function countActiveCubesAfterBoot(input:String):Int {
		final grid = Util.parseGrid(input, t -> (cast t : CubeState));

		var maxX = 1;
		var maxY = 1;
		var maxZ = 1;

		var dimensions = new Map<Int, Dimension>();
		dimensions[0] = grid.map;

		function newSlice() {
			final slice = new Dimension();
			for (pos => _ in dimensions[0]) {
				slice[pos] = Inactive;
			}
			return slice;
		}
		dimensions[-1] = newSlice();
		dimensions[1] = newSlice();

		for (_ in 0...6) {
			for (dimension in dimensions) {
				function expand(x, y) {
					final pos = new Point(x, y);
					if (!dimension.exists(pos)) {
						dimension[pos] = Inactive;
					}
				}
				for (x in -maxX...maxX + grid.width) {
					expand(x, -maxY);
					expand(x, grid.height + maxY - 1);
				}
				for (y in -maxY...grid.height + maxY) {
					expand(-maxX, y);
					expand(grid.width + maxX - 1, y);
				}
			}

			dimensions[-maxZ - 1] = newSlice();
			dimensions[maxZ + 1] = newSlice();

			final nextDimensions = new Map();
			for (z => slice in dimensions) {
				if (Math.abs(z) > maxZ) {
					nextDimensions[z] = slice;
					continue;
				}
				final nextSlice = new Dimension();
				for (pos => state in slice) {
					var activeNeighbours = Direction.all.map(function(dir) {
						final neighbour = pos + dir;
						return [-1, 0, 1].count(offset -> dimensions[z + offset][neighbour] == Active);
					}).sum();
					if (dimensions[z - 1][pos] == Active) {
						activeNeighbours++;
					}
					if (dimensions[z + 1][pos] == Active) {
						activeNeighbours++;
					}
					nextSlice[pos] = switch state {
						case Active if (activeNeighbours != 2 && activeNeighbours != 3): Inactive;
						case Inactive if (activeNeighbours == 3): Active;
						case _: state;
					}
				}
				nextDimensions[z] = nextSlice;
			}

			dimensions = nextDimensions;
			maxX++;
			maxY++;
			maxZ++;
		}

		var count = 0;
		for (dimension in dimensions) {
			for (slice in dimension) {
				if (slice == Active) {
					count++;
				}
			}
		}
		return count;
	}
}

private enum abstract CubeState(String) {
	final Active = "#";
	final Inactive = ".";
}

private typedef Dimension = HashMap<Point, CubeState>;
