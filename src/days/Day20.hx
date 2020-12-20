package days;

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
				id => new Tile(grid.width, grid.map, []);
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

	static function solvePuzzle(puzzle:Puzzle):Solution {
		final startingId = puzzle.keys().next();
		final startingTile = puzzle[startingId];
		final connections = [for (tileId in puzzle.keys()) tileId => new Map<Edge, TileId>()];
		final lockedTransformations = new Map<TileId, Array<Transformation>>();
		lockedTransformations[startingId] = [];
		function connect(tileId:TileId, edge:Edge, neighborId:TileId) {
			final tileNeighbors = connections.getOrDefault(tileId, []);
			tileNeighbors[edge] = neighborId;
			connections[tileId] = tileNeighbors;
		}
		function solve(tileId:TileId, tile:Tile) {
			for (edge in Edge.all) {
				final oppositeEdge = edge.opposite();
				for (neighborId => neighborTile in puzzle) {
					if (connections[tileId].exists(edge)) {
						break;
					}
					if (neighborId == tileId || connections[neighborId].exists(oppositeEdge)) {
						continue;
					}
					var transformationsToCheck = Transformation.combinations;
					if (lockedTransformations.exists(neighborId)) {
						transformationsToCheck = [lockedTransformations[neighborId]];
					}
					for (transformations in transformationsToCheck) {
						final transformedNeighbor = neighborTile.withTransformations(transformations);
						if (tile.fits(transformedNeighbor, edge)) {
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
			final tile = puzzle[columnId].withTransformations(solution.transformations[columnId]);
			for (pos in tile.pixels.keys()) {
				if (pos.x >= edgeSize.x && pos.y >= edgeSize.y && pos.x < TileSize - edgeSize.x && pos.y < TileSize - edgeSize.y) {
					image[pos - edgeSize + tileOffset] = tile.readPixel(pos);
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
		return new Tile(bounds.max.x + 1, image, []);
	}

	static function countMonsterPixels(image:Tile, monster:Monster):Int {
		final monsterPixels = new HashMap<Point, Bool>();
		for (pos in image.pixels.keys()) {
			final isMonster = monster.keys().iterable().foreach(function(offset) {
				final offsetPos = pos + offset;
				return !monsterPixels.exists(offsetPos) && image.readPixel(offsetPos) == "#";
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
		final pixels = image.pixels.count(pixel -> pixel == "#");
		for (transformations in Transformation.combinations) {
			final transformedImage = image.withTransformations(transformations);
			final monsterPixels = countMonsterPixels(transformedImage, monster);
			if (monsterPixels > 0) {
				return pixels - monsterPixels;
			}
		}
		throw 'no monsters found';
	}
}

class Tile {
	final size:Int;
	public final pixels:HashMap<Point, String>;
	final transformations:Array<Transformation>;

	public function new(size, pixels, transformations) {
		this.size = size;
		this.pixels = pixels;
		this.transformations = transformations;
	}

	public function withTransformations(transformations:Array<Transformation>) {
		return new Tile(size, pixels, transformations);
	}

	public function readPixel(pos:Point):String {
		return pixels[transformPoint(pos)];
	}

	public inline function readPixelXY(x:Int, y:Int):String {
		return readPixel(new Point(x, y));
	}

	function transformPoint(pos:Point):Point {
		for (transformation in transformations) {
			pos = switch transformation {
				case FlipX: new Point(size - 1 - pos.x, pos.y);
				case FlipY: new Point(pos.x, size - 1 - pos.y);
				case Rotate: new Point(pos.y, pos.x);
			}
		}
		return pos;
	}

	public function fits(tile:Tile, edge:Edge):Bool {
		for (i in 0...TileSize) {
			final match = switch edge {
				case Top:
					readPixelXY(i, 0) == tile.readPixelXY(i, MaxIndex);
				case Bottom:
					readPixelXY(i, MaxIndex) == tile.readPixelXY(i, 0);
				case Left:
					readPixelXY(0, i) == tile.readPixelXY(MaxIndex, i);
				case Right:
					readPixelXY(MaxIndex, i) == tile.readPixelXY(0, i);
			}
			if (!match) {
				return false;
			}
		}
		return true;
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
