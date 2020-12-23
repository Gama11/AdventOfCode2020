package days;

import polygonal.ds.Dll;

class Day23 {
	public static function playCrabCups(input:String, moves:Int):String {
		final input = input.splitToInt("");
		final highest = input.max(n -> n).value;
		final cups = new Dll(0, input).close();
		var current = cups.getNodeAt(0);
		function getNodeWithValue(value:Int) {
			final index = [for (i in 0...cups.size) i].find(i -> cups.get(i) == value);
			return cups.getNodeAt(index);
		}
		for (_ in 0...moves) {
			final nextThree = [
				for (_ in 0...3) {
					cups.removeAt((cups.indexOf(current.val) + 1) % cups.size);
				}
			];

			function nextDestination(destination:Int):Int {
				destination--;
				if (destination < 1) {
					destination = highest;
				}
				return destination;
			}
			var destination = nextDestination(current.val);
			while (nextThree.contains(destination)) {
				destination = nextDestination(destination);
			}

			final destinationNode = getNodeWithValue(destination);
			while (nextThree.length > 0) {
				cups.insertAfter(destinationNode, nextThree.pop());
			}

			current = current.next;
		}
		var labels = "";
		var node = getNodeWithValue(1).next;
		while (node.val != 1) {
			labels += node.val;
			node = node.next;
		}
		return labels;
	}
}
