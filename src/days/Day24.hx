package days;

import days.Day24.HexDirection.*;

class Day24 {
	static function parse(input:String):Array<Array<Direction>> {
		return input.split("\n").map(function(line) {
			final directions = [];
			function consume(string:String, direction:Direction) {
				if (line.startsWith(string)) {
					line = line.substr(string.length);
					directions.push(direction);
				}
			}
			while (line.length > 0) {
				consume("se", SouthEast);
				consume("sw", SouthWest);
				consume("nw", NorthWest);
				consume("ne", NorthEast);
				consume("e", East);
				consume("w", West);
			}
			return directions;
		});
	}

	static function getInitialTiling(input:String):Tiles {
		final directions = parse(input);
		final coordinates = directions.map(line -> line.fold((a, b) -> a + b, Direction.None));
		final tiles = new HashMap();
		for (coordinate in coordinates) {
			tiles[coordinate] = tiles.getOrDefault(coordinate, White).flip();
		}
		return tiles;
	}

	public static function countBlackTiles(input:String):Int {
		return getInitialTiling(input).count(tile -> tile == Black);
	}

	public static function simulateArtExhibit(input:String, days:Int):Int {
		function expandNeighbors(tiles:Tiles, pos:Point) {
			for (dir in HexDirection.all) {
				final neighborPos = pos + dir;
				if (!tiles.exists(neighborPos)) {
					tiles[neighborPos] = White;
				}
			}
		}
		var tiles = getInitialTiling(input);
		for (pos => tile in tiles) {
			if (tile == Black) {
				expandNeighbors(tiles, pos);
			}
		}
		for (_ in 0...days) {
			final nextTiles = new HashMap();
			for (pos => tile in tiles) {
				final blackNeighbors = HexDirection.all.count(dir -> tiles.getOrDefault(pos + dir, White) == Black);
				nextTiles[pos] = switch tile {
					case Black if (blackNeighbors == 0 || blackNeighbors > 2):
						White;

					case White if (blackNeighbors == 2):
						expandNeighbors(nextTiles, pos);
						Black;

					case _: tile;
				}
			}
			tiles = nextTiles;
		}
		return tiles.count(tile -> tile == Black);
	}
}

private typedef Tiles = HashMap<Point, Tile>;

@:publicFields
@:access(util.Direction)
private class HexDirection {
	static final East = new Direction(2, 0);
	static final SouthEast = new Direction(1, -1);
	static final SouthWest = new Direction(-1, -1);
	static final West = new Direction(-2, 0);
	static final NorthWest = new Direction(-1, 1);
	static final NorthEast = new Direction(1, 1);
	static final all = [East, SouthEast, SouthWest, West, NorthWest, NorthEast];
}

private enum abstract Tile(Bool) {
	final Black = true;
	final White = false;

	public function flip():Tile {
		return (cast !this : Tile);
	}
}
