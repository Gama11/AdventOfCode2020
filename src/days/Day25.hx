package days;

class Day25 {
	public static function reverseEngineerEncryptionKey(cardPublicKey:Int, doorPublicKey:Int):Int {
		function transform(value:Int, subject:Int):Int {
			return value = (value * subject) % 20201227;
		}
		var value = 1;
		var cardLoopSize = 0;
		while (value != cardPublicKey) {
			value = transform(value, 7);
			cardLoopSize++;
		}
		var encryptionKey = 1;
		for (_ in 0...cardLoopSize) {
			encryptionKey = transform(encryptionKey, doorPublicKey);
		}
		return encryptionKey;
	}
}
