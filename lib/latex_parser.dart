import 'package:petitparser/petitparser.dart';
import 'dart:math' as math;

class LatexParser {
  Result id1;
  
  LatexParser();

  num factorial(num a) {
    if (a < 0 || !(a is int)) {
      throw "Can't do factorial! Input isn't interger or smaller than 0";
    }
    num result = 1;
    while (a > 1) {
      result *= a;
      a--;
    }
    return result;
  }

  void parse(String latexmath) {

    final builder = new ExpressionBuilder();    

    Parser number() => digit().plus().seq(char('.').seq(digit().plus()).optional()).flatten().trim().map((a) => num.tryParse(a));

    Parser constant() =>
      char('\\').or(letter()).seq(letter().star()).trim().flatten().map((val) {
        switch (val) {
          case '\\pi':
            return math.pi;
          case 'e':
            return math.e;
          default:
            throw 'unknow constant';
        }
      });

    Parser binary(String element, ActionCallback callback,) => string('$element').seq(char('{')).seq(number()).seq(char('}')).seq(char('{')).seq(number()).seq(char('}')).trim().map(callback);

    builder.group()
      ..primitive(number())
      ..primitive(binary('\\frac', (val) => val[2]/val[5] ))
      ..primitive(constant())
      ..wrapper(char('{').trim(), char('}').trim(), (l, a, r) => a)
      ..wrapper(char('(').trim(), char(')').trim(), (l, a, r) => a)
      ..wrapper(string('\\left(').trim(), string('\\right)').trim(), (l, a, r) => a);

    builder.group()
      ..prefix(char('-').trim(), (op, a) => -a)
      ..prefix(string('\\sqrt').trim(), (op, a) => math.sqrt(a))
      ..prefix(string('\\ln').trim(), (op, a) => math.log(a))
      ..prefix(string('\\sin').trim(), (op, a) => math.sin(a));

    builder.group()
      ..right(char('^').trim(), (a, op, b) => math.pow(a, b));

    builder.group()
      ..left(string('\\times').trim(), (a, op, b) => a * b)
      ..left(char('/').trim(), (a, op, b) => a / b);
    builder.group()
      ..left(char('+').trim(), (a, op, b) => a + b)
      ..left(char('-').trim(), (a, op, b) => a - b);

    // builder.group()
    //   ..postfix(char('!').trim(), (a, op) => factorial(a));
    
    final parser = builder.build().end();
    // // for debug
    // final parser = builder.build();

    id1 = parser.parse(latexmath);
  }

  get result => id1;
}