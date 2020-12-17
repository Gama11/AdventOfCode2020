package days;

class Day12 {
	static function parseInstructions(input:String):Array<Instruction> {
		return input.split("\n").map(function(line) {
			return {
				action: (line.charAt(0) : Action),
				units: Std.parseInt(line.substr(1))
			};
		});
	}

	public static function calculateTraveledDistance(input:String):Int {
		final instructions = parseInstructions(input);
		var pos = new Point(0, 0);
		var dir = Direction.Right;
		for (instruction in instructions) {
			final units = instruction.units;
			switch instruction.action {
				case North:
					pos += Direction.Up * units;
				case South:
					pos += Direction.Down * units;
				case East:
					pos += Direction.Right * units;
				case West:
					pos += Direction.Left * units;
				case Left:
					dir = dir.rotate(-Std.int(units / 90));
				case Right:
					dir = dir.rotate(Std.int(units / 90));
				case Forward:
					pos += dir * units;
			}
		}
		return pos.distanceTo(new Point(0, 0));
	}

	public static function calculateTraveledDistanceWithWaypoint(input:String):Int {
		final instructions = parseInstructions(input);
		var ship = new Point(0, 0);
		var waypoint = new Point(10, -1);
		for (instruction in instructions) {
			final units = instruction.units;
			switch instruction.action {
				case North:
					waypoint += Direction.Up * units;
				case South:
					waypoint += Direction.Down * units;
				case East:
					waypoint += Direction.Right * units;
				case West:
					waypoint += Direction.Left * units;
				case Left:
					for (_ in 0...Std.int(units / 90)) {
						waypoint = new Point(waypoint.y, -waypoint.x);
					}
				case Right:
					for (_ in 0...Std.int(units / 90)) {
						waypoint = new Point(-waypoint.y, waypoint.x);
					}
				case Forward:
					ship += waypoint * units;
			}
		}
		return ship.distanceTo(new Point(0, 0));
	}
}

private typedef Instruction = {
	final action:Action;
	final units:Int;
}

private enum abstract Action(String) from String {
	final North = "N";
	final South = "S";
	final East = "E";
	final West = "W";
	final Left = "L";
	final Right = "R";
	final Forward = "F";
}
