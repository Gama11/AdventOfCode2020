package days;

import sys.io.File;
import haxe.macro.Context;
import haxe.macro.Expr;

class Day18 {
	public static macro function calculateSumOfExpressions(file:String, part2:Bool):Expr {
		var input = File.getContent('data/day18/$file.txt').replace("\r", "");
		input = input.replace("*", "-");
		if (part2) {
			input = input.replace("+", "*");
			input = input.replace("-", "+");
		}
		input = "[" + input.split("\n").join(",") + "]";
		final expr = Context.parse(input, (macro 0).pos);
		function eval(expr:Expr):Int64 {
			return switch expr.expr {
				case EBinop(OpAdd, a, b) if (!part2): eval(a) + eval(b);
				case EBinop(OpSub, a, b) if (!part2): eval(a) * eval(b);

				case EBinop(OpAdd, a, b) if (part2): eval(a) * eval(b);
				case EBinop(OpMult, a, b) if (part2): eval(a) + eval(b);

				case EConst(CInt(i)): Int64.parseString(i);
				case EParenthesis(a): eval(a);
				case EArrayDecl(values): values.map(eval).sum();
				case _: throw 'unenxpected ' + expr;
			}
		}
		return macro haxe.Int64.parseString($v{Std.string(eval(expr))});
	}
}
