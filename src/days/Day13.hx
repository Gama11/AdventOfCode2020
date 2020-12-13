package days;

class Day13 {
	static function parse(input:String):Notes {
		final parts = input.split("\n");
		return {
			earliestDepature: Std.parseInt(parts[0]),
			bussesInService: parts[1].split(",").filter(id -> id != "x").map(Std.parseInt)
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
}

private typedef Notes = {
	final earliestDepature:Int;
	final bussesInService:Array<Int>;
}
