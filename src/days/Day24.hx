package days;

class Day24 {
	static function parse(input:String):Array<Array<Direction>> {
		return input.split("\n").map(function(line) {
			final directions = [];
			function consume(direction:Direction) {
				if (line.startsWith(direction)) {
					line = line.substr(direction.length);
					directions.push(direction);
				}
			}
			while (line.length > 0) {
				consume(SouthEast);
				consume(SouthWest);
				consume(NorthWest);
				consume(NorthEast);
				consume(East);
				consume(West);
			}
			return directions;
		});
	}

	public static function countBlackTiles(input:String):Int {
		final directions = parse(input);
		final coordinates = directions.map(tile -> tile.map(function(direction) {
			return switch direction {
				case East: new Point(2, 0);
				case West: new Point(-2, 0);

				case SouthEast: new Point(1, -1);
				case NorthWest: new Point(-1, 1);

				case SouthWest: new Point(-1, -1);
				case NorthEast: new Point(1, 1);
			}
		}).fold((a, b) -> a + b, new Point(0, 0)));
		
		final map = new HashMap();
		for (coordinate in coordinates) {
			map[coordinate] = map.getOrDefault(coordinate, White).flip();
		}
		return map.count(color -> color == Black);
	}
}

@:forward(length)
private enum abstract Direction(String) to String {
	final East = "e";
	final SouthEast = "se";
	final SouthWest = "sw";
	final West = "w";
	final NorthWest = "nw";
	final NorthEast = "ne";
}

private enum abstract Color(Bool) {
	final Black = true;
	final White = false;

	public function flip():Color {
		return (cast !this : Color);
	}
}
