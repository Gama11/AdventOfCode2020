package days;

import util.Util.Grid;
import haxe.ds.HashMap;

class Day11 {
	static function parse(input:String) {
		return Util.parseGrid(input, s -> (cast s : Tile));
	}

	static function countFinalOccupiedSeats(grid:Grid<Tile>, tolerance:Int, look:(pos:Point, dir:Direction) -> Null<Point>):Int {
		var map = grid.map;
		function countOccupiedAdjacent(pos:Point):Int {
			return Direction.all.count(function(dir) {
				final seat = look(pos, dir);
				return if (seat == null) false else map[seat] == OccupiedSeat;
			});
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

					case OccupiedSeat if (occupiedAdjacent >= tolerance):
						anyChanges = true;
						EmptySeat;

					case tile: tile;
				}
			}
			map = nextMap;
		}
		return [for (tile in map) tile].count(tile -> tile == OccupiedSeat);
	}

	public static function countFinalOccupiedSeatsDirectlyAdjacent(input:String):Int {
		return countFinalOccupiedSeats(parse(input), 4, (pos, dir) -> pos + dir);
	}

	public static function countFinalOccupiedSeatsVisible(input:String):Int {
		final grid = parse(input);
		final visibleSeats = new HashMap<Point, HashMap<Direction, Point>>();
		for (pos => tile in grid.map) {
			if (tile == Floor) {
				continue;
			}
			final seatPerDirection = new HashMap<Direction, Point>();
			for (dir in Direction.all) {
				var p = pos + dir;
				while (true) {
					if (!grid.map.exists(p)) {
						break;
					}
					if (grid.map[p] == EmptySeat) {
						seatPerDirection[dir] = p;
						break;
					}
					p += dir;
				}
			}
			visibleSeats[pos] = seatPerDirection;
		}
		return countFinalOccupiedSeats(grid, 5, (pos, dir) -> visibleSeats[pos][dir]);
	}
}

private enum abstract Tile(String) {
	final Floor = ".";
	final EmptySeat = "L";
	final OccupiedSeat = "#";
}
