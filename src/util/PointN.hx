package util;

import polygonal.ds.Hashable;

@:forward(dimensions)
@:forward.new
abstract PointN(PointNImpl) from PointNImpl to Hashable {
	public static function neighbors(dimensions:Int):Array<PointN> {
		function recurse(dimensions:Int):Array<Array<Int>> {
			if (dimensions == 0) {
				return [[]];
			}
			final neighbors = [];
			for (i in -1...2) {
				final lowerDimensionsNeighbors = recurse(dimensions - 1);
				for (lower in lowerDimensionsNeighbors) {
					lower.push(i);
					neighbors.push(lower);
				}
			}
			return neighbors;
		}
		return recurse(dimensions).filter(a -> a.exists(i -> i != 0)).map(a -> new PointN(a));
	}

	@:op(A + B) function add(point:PointN):PointN {
		return new PointN([for (i in 0...this.dimensions) (this : PointN) [i] + point[i]]);
	}

	@:arrayAccess inline function get(i:Int):Int {
		return this.coordinates[i];
	}
}

private class PointNImpl implements Hashable {
	public final coordinates:Array<Int>;

	public var dimensions(get, never):Int;

	inline function get_dimensions()
		return coordinates.length;

	public var key(default, null):Int;

	public function new(coordinates) {
		this.coordinates = coordinates;
		key = hashCode();
	}

	function hashCode():Int {
		var result = 17;
		for (coordinate in coordinates) {
			result = 31 * result + coordinate;
		}
		return result;
	}

	public function toString():String {
		return '(${coordinates.join(", ")})';
	}

	public function equals(other:PointNImpl):Bool {
		return coordinates.equals(other.coordinates);
	}
}