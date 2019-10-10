import 'package:math_expressions/math_expressions.dart';
import 'package:petitparser/petitparser.dart';

import 'dart:math' as math;
import 'latex_grammar.dart';

class LatexParserDefinition extends LatexGrammarDefinition{
  final bool isRadMode;
  const LatexParserDefinition(this.isRadMode);

  number() => super.number().flatten().map((n)=>Number(num.tryParse(n)));
  pi() => super.pi().map((n)=>Number(math.pi));
  e() => super.e().map((n)=>Number(math.e));
  variable() => super.variable().map((v)=>Variable(v));

  // factorial() => super.factorial().map((n) {
  //   print(n[0]);
  //   return n;
  // });
  // may need custom function
  percent() => super.percent().map((n)=>n[0]/Number(100));

  sin() => super.sin().map((n)=>Sin((isRadMode)?n[1]:n[1]*Number(math.pi/180)));
  cos() => super.cos().map((n)=>Cos((isRadMode)?n[1]:n[1]*Number(math.pi/180)));
  tan() => super.tan().map((n)=>Tan((isRadMode)?n[1]:n[1]*Number(math.pi/180)));
  asin() => super.asin().map((n)=>((isRadMode)?Number(1):Number(180/math.pi))*Asin(n[1]));
  acos() => super.acos().map((n)=>((isRadMode)?Number(1):Number(180/math.pi))*Acos(n[1]));
  atan() => super.atan().map((n)=>((isRadMode)?Number(1):Number(180/math.pi))*Atan(n[1]));

  abs() => super.abs().map((n)=>Abs(n[1]));
  ln() => super.ln().map((n)=>Ln(n[1]));
  log() => super.log().map((n)=>Log(Number(num.tryParse(n[1])), n[3]));
  nlog() => super.nlog().map((n)=>Log(n[1], n[3]));
  sqrt() => super.sqrt().map((n)=>Root.sqrt(n[1]));
  nrt() => super.nrt().map((n)=>Power(n[3], Number(1)/n[1]));

  exponential() => super.exponential().map((n) {
    if (n[2] is List) {
      return Power(n[0], n[2][1]);
    } else {
      return Power(n[0], n[2]);
    }
  });

  defaulttimes() => super.defaulttimes().map((n)=>n[0]*n[1]);
  times() => super.times().map((n)=>n[0] * n[2]);
  divide() => super.divide().map((n)=>n[0] / n[2]);
  frac() => super.frac().map((n)=>n[1]/n[3]);

  plus() => super.plus().map((n)=>n[0]+n[2]);
  minus() => super.minus().map((n)=>n[0]-n[2]);
}

class LatexParser extends GrammarParser {
  final bool isRadMode;
  LatexParser({this.isRadMode = true}) : super(LatexParserDefinition(isRadMode));
}