package days;

import util.Util.Grid;
import polygonal.ds.Hashable;

private inline final TileSize = 10;
private inline final MaxIndex = TileSize - 1;

class Day20 {
	static function parsePuzzle(input:String):Puzzle {
		final tiles = input.split("\n\n");
		final idPattern = ~/Tile (\d+):\n/;
		return [
			for (tile in tiles) {
				idPattern.match(tile);
				final id = new TileId(idPattern.int(1));
				final grid = Util.parseGrid(tile.substr(idPattern.matched(0).length), s -> s);
				id => grid;
			}
		];
	}

	static function parseMonster(input:String):Monster {
		final image = Util.parseGrid(input, s -> s).map;
		final monster = new Monster();
		for (pos => pixel in image) {
			if (pixel == "#") {
				monster[pos] = true;
			}
		}
		return monster;
	}

	static function transformPoint(tile:TransformedTile, pos:Point):Point {
		for (transformation in tile.transformations) {
			pos = switch transformation {
				case FlipX: new Point(tile.tile.width - 1 - pos.x, pos.y);
				case FlipY: new Point(pos.x, tile.tile.height - 1 - pos.y);
				case Rotate: new Point(pos.y, pos.x);
			}
		}
		return pos;
	}

	static function transformTile(tile:TransformedTile):Tile {
		final transformedTile = new HashMap();
		for (pos in tile.tile.map.keys()) {
			transformedTile[pos] = tile.tile.map[transformPoint(tile, pos)];
		}
		return {
			width: tile.tile.width,
			height: tile.tile.height,
			map: transformedTile
		};
	}

	static function fits(a:TransformedTile, b:TransformedTile, edge:Edge):Bool {
		function readPixel(tile:TransformedTile, x:Int, y:Int) {
			return tile.tile.map[transformPoint(tile, new Point(x, y))];
		}
		for (i in 0...TileSize) {
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

	static function solvePuzzle(puzzle:Puzzle):Solution {
		final startingId = puzzle.keys().next();
		final startingTile = {tile: puzzle[startingId], transformations: []};
		final connections = [for (tileId in puzzle.keys()) tileId => new Map<Edge, TileId>()];
		final lockedTransformations = new Map<TileId, Array<Transformation>>();
		lockedTransformations[startingId] = [];
		function connect(tileId:TileId, edge:Edge, neighborId:TileId) {
			final tileNeighbors = connections.getOrDefault(tileId, []);
			tileNeighbors[edge] = neighborId;
			connections[tileId] = tileNeighbors;
		}
		function solve(tileId:TileId, tile:TransformedTile) {
			for (edge in Edge.all) {
				final oppositeEdge = edge.opposite();
				for (neighborId => neighborTile in puzzle) {
					if (connections[tileId][edge] != null) {
						break;
					}
					if (neighborId == tileId || connections[neighborId][oppositeEdge] != null) {
						continue;
					}
					var transformationsToCheck = Transformation.combinations;
					if (lockedTransformations.exists(neighborId)) {
						transformationsToCheck = [lockedTransformations[neighborId]];
					}
					for (transformations in transformationsToCheck) {
						final transformedNeighbor = {tile: neighborTile, transformations: transformations};
						if (fits(tile, transformedNeighbor, edge)) {
							connect(tileId, edge, neighborId);
							connect(neighborId, oppositeEdge, tileId);
							lockedTransformations[neighborId] = transformations;
							solve(neighborId, transformedNeighbor);
						}
					}
				}
			}
		}
		solve(startingId, startingTile);
		return {
			connections: connections,
			transformations: lockedTransformations
		}
	}

	public static function calculateCornerProduct(input:String):Int64 {
		final solution = solvePuzzle(parsePuzzle(input));
		return [
			for (tileId => edges in solution.connections) {
				if (edges.count() == 2) {
					(tileId.toInt() : Int64);
				}
			}
		].product();
	}

	static function constructImage(puzzle:Puzzle, solution:Solution):Tile {
		var rowId = puzzle.keys().iterable().find(function(tileId) {
			final edges = solution.connections[tileId];
			return edges.exists(Right) && edges.exists(Bottom) && !edges.exists(Left) && !edges.exists(Top);
		});
		var columnId = rowId;
		var tileOffset = new Point(0, 0);
		var edgeSize = new Point(1, 1);
		var gapSize = new Point(0, 0);
		var image = new HashMap();
		while (columnId != null) {
			final tile = transformTile({
				tile: puzzle[columnId],
				transformations: solution.transformations[columnId]
			});
			for (pos => pixel in tile.map) {
				if (pos.x >= edgeSize.x && pos.y >= edgeSize.y && pos.x < TileSize - edgeSize.x && pos.y < TileSize - edgeSize.y) {
					image[pos - edgeSize + tileOffset] = pixel;
				}
			}
			final rightId = solution.connections[columnId][Right];
			if (rightId != null) {
				columnId = rightId;
				tileOffset += new Point(TileSize - edgeSize.x * 2 + gapSize.x, 0);
			} else {
				final bottomId = solution.connections[rowId][Bottom];
				rowId = bottomId;
				columnId = bottomId;
				tileOffset = new Point(0, tileOffset.y + TileSize - edgeSize.y * 2 + gapSize.y);
			}
		}
		final bounds = Util.findBounds(image.keys().iterable());
		return {
			width: bounds.max.x,
			height: bounds.max.y,
			map: image
		};
	}

	static function countMonsterPixels(image:Tile, monster:Monster):Int {
		final monsterPixels = new HashMap<Point, Bool>();
		for (pos in image.map.keys()) {
			final isMonster = monster.keys().iterable().foreach(function(offset) {
				final offsetPos = pos + offset;
				return !monsterPixels.exists(offsetPos) && image.map[offsetPos] == "#";
			});
			if (isMonster) {
				for (offset in monster.keys()) {
					monsterPixels[pos + offset] = true;
				}
			}
		}
		return monsterPixels.count();
	}

	public static function calculateWaterRoughness(puzzle:String, monster:String):Int {
		final puzzle = parsePuzzle(puzzle);
		final solution = solvePuzzle(puzzle);
		final image = constructImage(puzzle, solution);
		final monster = parseMonster(monster);
		final pixels = image.map.count(pixel -> pixel == "#");
		for (transformations in Transformation.combinations) {
			final transformedImage = transformTile({tile: image, transformations: transformations});
			final monsterPixels = countMonsterPixels(transformedImage, monster);
			if (monsterPixels > 0) {
				return pixels - monsterPixels;
			}
		}
		throw 'no monsters found';
	}
}

private typedef Puzzle = Map<TileId, Tile>;

private typedef Solution = {
	final connections:Map<TileId, Map<Edge, TileId>>;
	final transformations:Map<TileId, Array<Transformation>>;
}

private typedef Monster = HashMap<Point, Bool>;

private abstract TileId(Int) to Int {
	public function new(id) {
		this = id;
	}

	public function toInt():Int {
		return this;
	}
}

private typedef Tile = Grid<String>;

private typedef TransformedTile = {
	var tile:Tile;
	var transformations:Array<Transformation>;
}

private enum abstract Transformation(Int) {
	public static final combinations = [
		[],
		[FlipX],
		[FlipY],
		[Rotate],
		[FlipX, FlipY],
		[FlipX, Rotate],
		[FlipY, Rotate],
		[FlipX, FlipY, Rotate],
	];
	final FlipX;
	final FlipY;
	final Rotate;
}

private enum abstract Edge(Int) to Int {
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
