package days;

import polygonal.ds.Hashable;

private final MaxIndex = 9;

class Day20 {
	static function parse(input:String):Map<TileId, Tile> {
		final tiles = input.split("\n\n");
		final idPattern = ~/Tile (\d+):\n/;
		return [
			for (tile in tiles) {
				idPattern.match(tile);
				final id = new TileId(idPattern.int(1));
				final grid = Util.parseGrid(tile.substr(idPattern.matched(0).length), s -> s);
				id => grid.map;
			}
		];
	}

	static function readPixel(tile:TransformedTile, x:Int, y:Int):String {
		var pos = new Point(x, y);
		for (transformation in tile.transformations) {
			pos = transformation.apply(pos);
		}
		return tile.tile[pos];
	}

	static function fits(a:TransformedTile, b:TransformedTile, edge:Edge):Bool {
		for (i in 0...MaxIndex + 1) {
			final match = switch edge {
				case Top:
					readPixel(a, i, 0) == readPixel(b, i, MaxIndex);
				case Bottom:
					readPixel(a, i, MaxIndex) == readPixel(b, i, 0);
				case Left:
					readPixel(a, 0, i) == readPixel(b, MaxIndex, i);
				case Right:
					readPixel(a, MaxIndex, i) == readPixel(b, 0, i);
			}
			if (!match) {
				return false;
			}
		}
		return true;
	}

	public static function solveJigsaw(input:String):Int64 {
		final tiles = parse(input);
		final startingId = tiles.keys().next();
		final startingTile = {tile: tiles[startingId], transformations: []};
		final neighbors = new Map<TileId, Array<TileId>>();
		final assigned = new HashMap<TileEdge, Bool>();
		final lockedTransformations = new Map<TileId, Array<Transformation>>();
		lockedTransformations[startingId] = [];
		final possibleTransformations = [
			[],
			[FlipX],
			[FlipY],
			[Rotate],
			[FlipX, FlipY],
			[FlipX, Rotate],
			[FlipY, Rotate],
			[FlipX, FlipY, Rotate],
		];
		function addNeighbor(tileId:TileId, neighborId:TileId) {
			final tileNeighbors = neighbors.getOrDefault(tileId, []);
			tileNeighbors.push(neighborId);
			neighbors[tileId] = tileNeighbors;
		}
		function solve(tileId:TileId, tile:TransformedTile) {
			for (edge in Edge.all) {
				final oppositeEdge = edge.opposite();
				for (neighborId => neighborTile in tiles) {
					if (assigned.exists(new TileEdge(tileId, edge))) {
						break;
					}
					if (neighborId == tileId || assigned.exists(new TileEdge(neighborId, oppositeEdge))) {
						continue;
					}
					var transformationsToCheck = possibleTransformations;
					if (lockedTransformations.exists(neighborId)) {
						transformationsToCheck = [lockedTransformations[neighborId]];
					}
					for (transformations in transformationsToCheck) {
						final transformedNeighbor = {tile: neighborTile, transformations: transformations};
						if (fits(tile, transformedNeighbor, edge)) {
							addNeighbor(tileId, neighborId);
							addNeighbor(neighborId, tileId);
							assigned[new TileEdge(tileId, edge)] = true;
							assigned[new TileEdge(neighborId, oppositeEdge)] = true;
							lockedTransformations[neighborId] = transformations;
							solve(neighborId, transformedNeighbor);
						}
					}
				}
			}
		}
		solve(startingId, startingTile);
		return [
			for (tileId => tileNeighbors in neighbors) {
				if (tileNeighbors.length == 2) {
					(tileId.toInt() : Int64);
				}
			}
		].product();
	}
}

private abstract TileId(Int) {
	public function new(id) {
		this = id;
	}

	public function toInt():Int {
		return this;
	}
}

private typedef Tile = HashMap<Point, String>;

private typedef TransformedTile = {
	var tile:Tile;
	var transformations:Array<Transformation>;
}

private enum abstract Transformation(Int) {
	final FlipX;
	final FlipY;
	final Rotate;

	public function apply(pos:Point):Point {
		return switch (cast this : Transformation) {
			case FlipX: new Point(MaxIndex - pos.x, pos.y);
			case FlipY: new Point(pos.x, MaxIndex - pos.y);
			case Rotate: new Point(pos.y, pos.x);
		}
	}
}

private enum abstract Edge(Int) {
	public static final all = [Top, Bottom, Left, Right];
	final Top;
	final Bottom;
	final Left;
	final Right;

	public function opposite():Edge {
		return switch (cast this : Edge) {
			case Top: Bottom;
			case Bottom: Top;
			case Left: Right;
			case Right: Left;
		}
	}
}

private abstract TileEdge(Point) to Hashable {
	public function new(tileId:TileId, edge:Edge) {
		this = new Point(tileId.toInt(), cast edge);
	}
}
