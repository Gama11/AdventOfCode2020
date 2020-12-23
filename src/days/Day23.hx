package days;

import haxe.ds.Vector;

class Day23 {
	static function playCrabCups(input:String, moves:Int, size:Int):Vector<Cup> {
		final input = input.splitToInt("");

		var current = new Cup(input[0]);
		final cups = new Vector(size + 1);
		cups[current.label] = current;

		var it = current;
		for (i in 1...size) {
			final label = if (i >= input.length) i + 1 else input[i];
			final next = new Cup(label);
			cups[next.label] = next;
			it.next = next;
			it = next;
		}
		it.next = current;

		for (_ in 0...moves) {
			final next1 = current.next;
			final next2 = next1.next;
			final next3 = next2.next;

			function nextDestination(destination:Int):Int {
				destination--;
				if (destination < 1) {
					destination = size;
				}
				return destination;
			}
			var destination = nextDestination(current.label);
			while (next1.label == destination || next2.label == destination || next3.label == destination) {
				destination = nextDestination(destination);
			}

			final destinationCup = cups[destination];
			final afterDestination = destinationCup.next;
			current.next = next3.next;
			destinationCup.next = next1;
			next3.next = afterDestination;

			current = current.next;
		}
		return cups;
	}

	public static function getLabelsAfterOne(input:String, moves:Int):String {
		final cups = playCrabCups(input, moves, input.length);
		return cups[1].toString("").replace("1", "");
	}

	public static function findProductOfLabelsAfterOne(input:String, moves:Int, size:Int):Int64 {
		final cups = playCrabCups(input, moves, size);
		final cupAfterOne = cups[1].next;
		return (cupAfterOne.label : Int64) * cupAfterOne.next.label;
	}
}

private class Cup {
	public final label:Int;
	public var next:Cup;

	public function new(label:Int) {
		this.label = label;
	}

	public function toString(separator = " "):String {
		var result = "";
		var it = this;
		do {
			result += it.label + separator;
			it = it.next;
		} while (it != this);
		return result;
	}
}
