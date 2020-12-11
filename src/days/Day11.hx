package days;

import Util.Direction;
import Util.Point;
import haxe.ds.HashMap;

class Day11 {
	public static function countOccupiedSeatsInStableState(input:String):Int {
		final grid = Util.parseGrid(input, s -> (cast s : Tile));
		var map = grid.map;
		function countOccupiedAdjacent(pos:Point):Int {
			return Direction.all.count(dir -> map[pos + dir] == OccupiedSeat);
		}
		var anyChanges = true;
		while (anyChanges) {
			anyChanges = false;
			final nextMap = new HashMap();
			for (pos => tile in map) {
				if (tile == Floor) {
					continue;
				}
				final occupiedAdjacent = countOccupiedAdjacent(pos);
				nextMap[pos] = switch tile {
					case EmptySeat if (occupiedAdjacent == 0):
						anyChanges = true;
						OccupiedSeat;

					case OccupiedSeat if (occupiedAdjacent >= 4):
						anyChanges = true;
						EmptySeat;

					case tile: tile;
				}
			}
			map = nextMap;
		}
		return [for (tile in map) tile].count(tile -> tile == OccupiedSeat);
	}
}

private enum abstract Tile(String) {
	final Floor = ".";
	final EmptySeat = "L";
	final OccupiedSeat = "#";
}
