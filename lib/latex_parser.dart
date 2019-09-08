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

    builder.group()
      ..primitive(number()|constant()|variable())
      ..wrapper(char('{'), char('}'), (l, a, r) => '(' + a.toString() + ')')
      ..wrapper(string('\\left|'), string('\\right|'), (l, a, r) => 'abs($a)')
      ..wrapper(string('\\left('), string('\\right)'), (l, a, r) => '(' + a.toString() + ')');

    // prefix group
    builder.group()
      ..prefix(char('-'), (op, a) => '-($a)')
      ..prefix(string('\\log_').seq(digit()|constant()|variable()), (op ,a) => '${op[1]} log $a')
      ..prefix(string('\\log_{').seq(number()|constant()|variable()).seq(char('}')), (op ,a) => '${op[1]} log $a')
      ..prefix(string('\\sqrt'), (op, a) => 'sqrt$a')
      ..prefix(string('\\ln'), (op, a) => 'ln$a')
      ..prefix(string('\\sin'), (op, a) => 'sin$a')
      ..prefix(string('\\arcsin'), (op, a) => 'arcsin$a');
    
    //postfix group
    builder.group()
      ..postfix(number()|constant()|variable(), (a, b) => '$a * $b')
      ..postfix(char('!'), (a, op) => factorial(a).toString());

    // left-associative group
    builder.group()
      ..left(string('\\times'), (a, op, b) => '$a * $b')
      ..left(string('\\frac'), (a, op, b) => '$a / $b')
      ..left(char('+'), (a, op, b) => '$a + $b')
      ..left(char('-'), (a, op, b) => '$a - $b');
    
    builder.group() // make \times default operator
      ..left(char('{').and(), (a, op, b) => '$a * $b')
      ..left(string('\\sin'), (a, op, b) => '$a * sin$b');

    // right-associative group
    builder.group()
      ..right(char('^'), (a, op, b) => '$a ^ $b');


    final parser = builder.build().end();
    // // for debug
    // final parser = builder.build();

    id1 = parser.parse(binary2unary(latexmath));
  }

  String binary2unary (String latexmath) {
    Map p = Map();
    Map l = Map();
    List result = [];

    for (var i = 0; i < latexmath.length; i++) {
      if(latexmath.startsWith('\\frac{', i)) {
        p[i] = '\\frac{';
        i += 5;
        continue;
      }
      switch (latexmath[i]) {
        case '{':
          p[i] = '{';
          break;
        case '}':
          p[i] = '}';
          break;
      }
    }
    print(p);

    for (var i = 0; i < p.values.length; i++) {
      if(p.values.elementAt(i).contains('{')) {
        l[p.keys.elementAt(i)] = p.values.elementAt(i);
        continue;
      }
      if (p.values.elementAt(i) == '}') {
        if (l.values.elementAt(l.values.length-1) == '{') {
          l.remove(l.keys.elementAt(l.keys.length-1));
        } else {
          result.add(l.keys.elementAt(l.keys.length-1));
          result.add(p.keys.elementAt(i));
          l.remove(l.keys.elementAt(l.keys.length-1));
        }
      }
    }
    print(result);

    for (var i = 0; i < result.length; i+=2) {
      latexmath =  latexmath.substring(0,result[i]) + latexmath.substring(result[i]+5,result[i+1]+1) + '\\frac' + latexmath.substring(result[i+1]+1);
    }
    print('bi2un: ' + latexmath.replaceAll(' ', ''));
    return latexmath.replaceAll(' ', '');
  }

  get result => id1;
}

num intCheck(num a) {
  if (a.ceil() == a.floor()) {
    return a.toInt();
  } else {
    return a;
  }
}
