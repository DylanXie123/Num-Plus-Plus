import 'package:petitparser/petitparser.dart';
import 'dart:math' as math;

class LatexParser {
  Result id1;
  
  LatexParser();

  int factorial(int a) {
    if (a < 0) {
      throw "Can't do factorial! Input is smaller than 0";
    }
    num result = 1;
    while (a > 1) {
      result *= a;
      a--;
      if (result < 0) {
        throw "Out of range";
      }
    }
    return result;
  }

  //TODO: Add log_ function support
  void parse(String latexmath) {

    final builder = new ExpressionBuilder();    

    Parser number() => digit().plus().seq(char('.').seq(digit().plus()).optional()).flatten().map((a) => num.tryParse(a));

    // Constant
    Parser pi() => string('\\pi').map((v) => math.pi);
    Parser e() => char('e').map((v) => math.e);

    Parser constant() =>
      pi() |
      e();

    // Binary Operators
    Parser binary(String element) => string('$element'+'{').seq(number().or(constant())).seq(char('}'));

    List<num> divide(num a, num b) {
      if (intCheck(a) is int && intCheck(b) is int) {
        int t = a.toInt();
        int divisor = t.gcd(b);
        return [intCheck(a/divisor),intCheck(b/divisor)];
      } else {
        return [a/b];
      }
    }

    // Unary Operators
    // Parser func() =>
    //   string('\\sin') |
    //   string('\\ln') |
    //   string('\\sqrt');
    
    builder.group()
      ..primitive(number())
      ..primitive(constant())
      ..wrapper(char('{'), char('}'), (l, a, r) => a)
      ..wrapper(char('('), char(')'), (l, a, r) => a)
      ..wrapper(string('\\left('), string('\\right)'), (l, a, r) => a);

    // prefix group
    builder.group()
      ..prefix(char('-'), (op, a) => -a)
      ..prefix(binary('\\frac'), (op, a) => divide(op[1],a))
      ..prefix(string('\\sqrt'), (op, a) => math.sqrt(a))
      ..prefix(string('\\ln'), (op, a) => math.log(a))
      ..prefix(string('\\sin'), (op, a) => math.sin(a));
    
    //postfix group
    builder.group()
      ..postfix(char('!'), (a, op) => factorial(a));

    // left-associative group
    builder.group() // make \times default operator
      ..left(binary('\\frac'), (a, op, b) => a * divide(op[1],a))
      ..left(string('\\sin'), (a, op, b) => a * math.sin(b));

    builder.group()
      ..left(string('\\times'), (a, op, b) => a * b)
      ..left(char('/'), (a, op, b) => a / b)
      ..left(char('+'), (a, op, b) => a + b)
      ..left(char('-'), (a, op, b) => a - b);

    // right-associative group
    builder.group()
      ..right(char('^'), (a, op, b) => math.pow(a, b));


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
