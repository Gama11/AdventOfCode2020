import haxe.ds.ReadOnlyArray;
import haxe.ds.HashMap;
import polygonal.ds.Prioritizable;
import haxe.Int64;
import polygonal.ds.Hashable;

class Util {
	public static function mod(a:Int, b:Int) {
		var r = a % b;
		return r < 0 ? r + b : r;
	}

	public static function mod64(a:Int64, b:Int64) {
		var r = a % b;
		return r < 0 ? r + b : r;
	}

	public static function bitCount(x:Int):Int {
		x = x - ((x >> 1) & 0x55555555);
		x = (x & 0x33333333) + ((x >> 2) & 0x33333333);
		x = (x + (x >> 4)) & 0x0F0F0F0F;
		x = x + (x >> 8);
		x = x + (x >> 16);
		return x & 0x0000003F;
	}

	public static function findBounds(points:Array<Point>) {
		final n = 9999999;
		var maxX = -n;
		var maxY = -n;
		var minX = n;
		var minY = n;
		for (pos in points) {
			maxX = Std.int(Math.max(maxX, pos.x));
			maxY = Std.int(Math.max(maxY, pos.y));
			minX = Std.int(Math.min(minX, pos.x));
			minY = Std.int(Math.min(minY, pos.y));
		}
		return {
			min: new Point(minX, minY),
			max: new Point(maxX, maxY)
		};
	}

	public static function renderPointGrid(points:Array<Point>, render:Point->String, empty = " "):String {
		var bounds = findBounds(points);
		var min = bounds.min;
		var max = bounds.max;

		var grid = [for (_ in 0...max.y - min.y + 1) [for (_ in 0...max.x - min.x + 1) empty]];
		for (pos in points) {
			grid[pos.y - min.y][pos.x - min.x] = render(pos);
		}
		return grid.map(row -> row.join("")).join("\n") + "\n";
	}

	public static function renderPointHash<T>(map:HashMap<Point, T>, render:T->String, empty = " "):String {
		return renderPointGrid([for (p in map.keys()) p], p -> render(map[p]), empty);
	}

	public static function parseGrid(input:String) {
		var grid = input.split("\n").map(line -> line.split(""));
		var result = new HashMap();
		for (y in 0...grid.length) {
			for (x in 0...grid[y].length) {
				result[new Point(x, y)] = grid[y][x];
			}
		}
		return {
			map: result,
			width: grid[0].length,
			height: grid.length
		};
	}
}

class StaticExtensions {
	public static function int(reg:EReg, n:Int):Null<Int> {
		return Std.parseInt(reg.matched(n));
	}

	public static function sum(a:Array<Int>):Int {
		return a.fold((a, b) -> a + b, 0);
	}

	public static function product(a:Array<Int>):Int {
		return a.fold((a, b) -> a * b, 1);
	}

	public static function max<T>(a:Array<T>, f:T->Int) {
		var maxValue:Null<Int> = null;
		var list = [];
		for (e in a) {
			var value = f(e);
			if (maxValue == null || value > maxValue) {
				maxValue = value;
				list = [e];
			} else if (value == maxValue) {
				list.push(e);
			}
		}
		return {list: list, value: maxValue};
	}

	public static function min<T>(a:Array<T>, f:T->Int) {
		var minValue:Null<Int> = null;
		var list = [];
		for (e in a) {
			var value = f(e);
			if (minValue == null || value < minValue) {
				minValue = value;
				list = [e];
			} else if (value == minValue) {
				list.push(e);
			}
		}
		return {list: list, value: minValue};
	}

	public static function count<T>(a:Array<T>, f:T->Bool):Int {
		var count = 0;
		for (e in a) {
			if (f(e)) {
				count++;
			}
		}
		return count;
	}

	public static function tuples<T>(a:Array<T>):Array<{a:T, b:T}> {
		var result = [];
		for (e1 in a) {
			for (e2 in a) {
				if (e1 != e2) {
					result.push({a: e1, b: e2});
				}
			}
		}
		return result;
	}

	public static function permutations<T>(a:Array<T>):Array<Array<T>> {
		if (a.length == 2) {
			return [a, [a[1], a[0]]];
		} else {
			var list = [];
			for (item in a) {
				var copy = a.copy();
				copy.remove(item);
				for (permutation in permutations(copy)) {
					permutation.unshift(item);
					list.push(permutation);
				}
			}
			return list;
		}
	}

	public static function size<K:{function hashCode():Int;}, V>(map:HashMap<K, V>):Int {
		return [for (_ in map) _].length;
	}
}

@:forward
abstract Point(PointImpl) from PointImpl to {function hashCode():Int;} {
	public inline function new(x, y) {
		this = new PointImpl(x, y);
	}

	@:op(A + B) inline function add(point:Point):Point {
		return new Point(this.x + point.x, this.y + point.y);
	}

	@:op(A - B) inline function subtract(point:Point):Point {
		return new Point(this.x - point.x, this.y - point.y);
	}

	@:op(A * B) inline function scale(n:Int):Point {
		return new Point(this.x * n, this.y * n);
	}

	@:op(A == B) inline function equals(point:Point):Bool {
		return this.x == point.x && this.y == point.y;
	}

	@:op(A != B) inline function notEquals(point:Point):Bool {
		return !equals(point);
	}

	public inline function invert():Point {
		return new Point(-this.x, -this.y);
	}
}

private class PointImpl implements Hashable {
	public final x:Int;
	public final y:Int;

	public var key(default, null):Int;

	public inline function new(x, y) {
		this.x = x;
		this.y = y;
		key = hashCode();
	}

	public function hashCode():Int {
		return x + 10000 * y;
	}

	public function distanceTo(point:Point):Int {
		return Std.int(Math.abs(x - point.x) + Math.abs(y - point.y));
	}

	public function angleBetween(point:Point):Float {
		// from FlxPoint
		var x:Float = point.x - x;
		var y:Float = point.y - y;
		var angle:Float = 0;
		if (x != 0 || y != 0) {
			var c1:Float = Math.PI * 0.25;
			var c2:Float = 3 * c1;
			var ay:Float = (y < 0) ? -y : y;

			if (x >= 0) {
				angle = c1 - c1 * ((x - ay) / (x + ay));
			} else {
				angle = c2 - c1 * ((x + ay) / (ay - x));
			}
			angle = ((y < 0) ? -angle : angle) * (180 / Math.PI);

			if (angle > 90) {
				angle = angle - 270;
			} else {
				angle += 90;
			}
		}
		return angle;
	}

	public function shortString():String {
		return '$x,$y';
	}

	public function toString():String {
		return '($x, $y)';
	}
}

@:forward(x, y)
abstract Direction(Point) to Point {
	public static final Left = new Direction(-1, 0);
	public static final Up = new Direction(0, -1);
	public static final Down = new Direction(0, 1);
	public static final Right = new Direction(1, 0);

	public static final horizonals = [Left, Up, Right, Down];
	public static final diagonals = [Left + Up, Right + Up, Left + Down, Right + Down];
	public static final all = horizonals.concat(diagonals);

	private inline function new(x:Int, y:Int) {
		this = new Point(x, y);
	}

	public function rotate(by:Int):Direction {
		var i = horizonals.indexOf((cast this : Direction)) + by;
		return horizonals[Util.mod(i, horizonals.length)];
	}

	public function toString() {
		return switch (this) {
			case Left: "Left";
			case Up: "Up";
			case Down: "Down";
			case Right: "Right";
			case _: "unknown direction";
		}
	}

	@:op(A + B) function add(dir:Direction):Direction {
		return new Direction(this.x + dir.x, this.y + dir.y);
	}
}

class PrioritizedItem<T> implements Prioritizable {
	public final item:T;
	public var priority(default, null):Float = 0;
	public var position(default, null):Int;

	public function new(item:T, priority:Float) {
		this.item = item;
		this.priority = priority;
	}
}
