package days;

class Day13 {
	static function parse(input:String):Notes {
		final parts = input.split("\n");
		return {
			earliestDepature: Std.parseInt(parts[0]),
			bussesInService: parts[1].split(",").map(id -> if (id == "x") 0 else Std.parseInt(id))
		}
	}

	public static function findBusIdAndWaitTime(input:String):Int {
		final notes = parse(input);
		final result = notes.bussesInService.map(id -> {
			id: id,
			waitTime: id - (notes.earliestDepature % id)
		}).min(tuple -> tuple.waitTime);
		return result.value * result.list[0].id;
	}

	public static function findTimestampWithConsecutiveDepartures(input:String):Int64 {
		final busses = parse(input).bussesInService;
		var count = 2;
		var timestamp:Int64 = 0;
		var increment:Int64 = 1;
		var cycleStart:Null<Int64> = null;
		while (true) {
			while (busses[count] == 0) {
				count++;
			}
			var match = true;
			for (i in 0...count) {
				final id = busses[i];
				if (id != 0 && (timestamp + i) % id != 0) {
					match = false;
					break;
				}
			}
			if (match) {
				if (count == busses.length) {
					return timestamp;
				} else if (cycleStart == null) {
					cycleStart = timestamp;
				} else {
					increment = timestamp - cycleStart;
					cycleStart = null;
					count++;
				}
			}
			timestamp += increment;
		}
	}
}

private typedef Notes = {
	final earliestDepature:Int;
	final bussesInService:Array<Int>;
}
