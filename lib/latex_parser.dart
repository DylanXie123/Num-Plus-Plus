import 'package:petitparser/petitparser.dart';
import 'dart:math' as math;

class LatexParser {
  Result id1;
  
  LatexParser();

  int factorial(String a) {
    int v = int.tryParse(a);
    if (v < 0) {
      throw "Can't do factorial! Input is smaller than 0";
    }
    num result = 1;
    while (v > 1) {
      result *= v;
      v--;
      if (result < 0) {
        throw "Out of range";
      }
    }
    return result;
  }

  // (experimental)
  List<num> divide(num a, num b) {
    if (intCheck(a) is int && intCheck(b) is int) {
      int t = a.toInt();
      int divisor = t.gcd(b);
      return [intCheck(a/divisor),intCheck(b/divisor)];
    } else {
      return [a/b];
    }
  }
  
  //TODO: Add log_ function support
  void parse(String latexmath) {

    final builder = new ExpressionBuilder();    

    // Numbers
    Parser number() => digit().plus().seq(char('.').seq(digit().plus()).optional()).flatten();

    // Constant
    Parser pi() => string('\\pi').map((v) => math.pi.toString());
    Parser e() => char('e').map((v) => math.e.toString());

    Parser constant() =>
      pi() |
      e();

    // Variable (experimental)
    Parser variable() => char('x').flatten();

    // Binary Operators
    Parser binary(String element) => string('$element'+'{').seq((number()|constant()|variable())).seq(char('}'));

    builder.group()
      ..primitive(number()|constant()|variable())
      ..wrapper(char('{'), char('}'), (l, a, r) => a.toString())
      ..wrapper(char('('), char(')'), (l, a, r) => a.toString())
      ..wrapper(string('\\left('), string('\\right)'), (l, a, r) => a.toString());

    // prefix group
    builder.group()
      ..prefix(char('-'), (op, a) => '-($a)')
      // TODO: frac goes wrong when numerator is a expression
      ..prefix(binary('\\frac'), (op, a) => '(${op[1]}) / ($a)')
      ..prefix(string('\\sqrt'), (op, a) => 'sqrt($a)')
      ..prefix(string('\\ln'), (op, a) => 'ln($a)')
      ..prefix(string('\\sin'), (op, a) => 'sin($a)');
    
    //postfix group
    builder.group()
      ..postfix(char('!'), (a, op) => factorial(a).toString());

    // left-associative group
    builder.group()
      ..left(string('\\times'), (a, op, b) => '($a) * ($b)')
      ..left(char('/'), (a, op, b) => '($a) / ($b)')
      ..left(char('+'), (a, op, b) => '($a) + ($b)')
      ..left(char('-'), (a, op, b) => '($a) - ($b)');
    
    builder.group() // make \times default operator
          ..left(binary('\\frac'), (a, op, b) => '($a) * (${op[1]}) / ($a)')
          ..left(string('\\sin'), (a, op, b) => '($a) * sin($b)');

    // right-associative group
    builder.group()
      ..right(char('^'), (a, op, b) => '($a) ^ ($b)');


    final parser = builder.build().end();
    // // for debug
    // final parser = builder.build();

    id1 = parser.parse(latexmath);
  }

  get result => id1;
}

// TODO: Make it possible for List input
num intCheck(num a) {
  if (a.ceil() == a.floor()) {
    return a.toInt();
  } else {
    return a;
  }
}
