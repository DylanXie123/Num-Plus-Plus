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
      ..prefix(string('\\sqrt'), (op, a) => 'sqrt$a')
      ..prefix(string('\\ln'), (op, a) => 'ln$a')
      ..prefix(string('\\sin'), (op, a) => 'sin$a')
      ..prefix(string('\\cos'), (op, a) => 'cos$a')
      ..prefix(string('\\tan'), (op, a) => 'tan$a')
      ..prefix(string('\\arcsin'), (op, a) => 'arcsin$a')
      ..prefix(string('\\arccos'), (op, a) => 'arccos$a')
      ..prefix(string('\\arctan'), (op, a) => 'arctan$a');
    
    //postfix group
    builder.group()
      ..postfix(number()|constant()|variable(), (a, b) => '$a * $b')
      ..postfix(string('\\%'), (a, op) => '$a/100')
      ..postfix(char('!'), (a, op) => factorial(a).toString());

    // left-associative group
    builder.group()
      ..left(string('\\log'), (a, op, b) => '$a log $b')
      ..left(string('\\nrt'), (a, op, b) => '$b ^ (1/$a)')
      ..left(string('\\times'), (a, op, b) => '$a * $b')
      ..left(string('\\frac'), (a, op, b) => '$a / $b')
      ..left(string('\\div'), (a, op, b) => '$a / $b')
      ..left(char('+'), (a, op, b) => '$a + $b')
      ..left(char('-'), (a, op, b) => '$a - $b');
    
    builder.group() // make \times default operator
      ..left(char('{').and(), (a, op, b) => '$a * $b')
      ..left(string('\\left(').and(), (a, op, b) => '$a * $b')
      ..left(string('\\left|').and(), (a, op, b) => '$a * $b')
      ..left(string('\\log_').seq(digit()|constant()|variable()), (a, op, b) => '$a * ${op[1]} log $b')
      ..left(string('\\ln'), (a, op, b) => '$a * ln$b')
      ..left(string('\\sin'), (a, op, b) => '$a * sin$b')
      ..left(string('\\cos'), (a, op, b) => '$a * cos$b')
      ..left(string('\\tan'), (a, op, b) => '$a * tan$b')
      ..left(string('\\arcsin'), (a, op, b) => '$a * arcsin$b')
      ..left(string('\\arccos'), (a, op, b) => '$a * arccos$b')
      ..left(string('\\arctan'), (a, op, b) => '$a * arctan$b')
      ..left(string('\\sqrt'), (a, op, b) => '$a * sqrt$b');

    // right-associative group
    builder.group()
      ..right(char('^'), (a, op, b) => '$a ^ $b');


    final parser = builder.build().end();
    // // for debug
    // final parser = builder.build();

    id1 = parser.parse(binary2unary(latexmath));
  }

  String binary2unary (String latexmath) {
    Map pInfo = Map();
    Map pLoc = Map();

    // get parenthesisInfo in Map form
    for (var i = 0; i < latexmath.length; i++) {
      if (i<latexmath.length-5) {
        String t = latexmath.substring(i,i+6);
        switch (t) {
          case '\\frac{':
            continue fbracket;
          case '\\log_{':
            continue fbracket;
          fbracket:
          case '\\sqrt[':
            pInfo[i] = t;
            i += 5;
            continue;
        }
      }
      
      switch (latexmath[i]) {
        case '{':
          pInfo[i] = '{';
          break;
        case ']':
          continue rbracket;
        rbracket:
        case '}':
          if (pInfo.values.elementAt(pInfo.length-1) != '{') {
            pLoc[pInfo.keys.elementAt(pInfo.length-1)] = pInfo.values.elementAt(pInfo.length-1);
            pLoc[i] = '}';
          }
          pInfo.remove(pInfo.keys.elementAt(pInfo.length-1));
          break;
      }
    }
    print(pLoc);

    // refactor the string
    List plist = pLoc.keys.toList();
    for (var i = 0; i < pLoc.length; i+=2) {
      String msg = '';
      switch (pLoc.values.elementAt(i)) {
        case '\\frac{':
          msg = '\\frac';
          break;
        case '\\log_{':
          msg = '\\log ';
          break;
        case '\\sqrt[':
          msg = '\\nrt ';
          break;
      }
      latexmath =  latexmath.substring(0,plist[i]) + '{' + latexmath.substring(plist[i]+6,plist[i+1]) + '}' + msg + latexmath.substring(plist[i+1]+1);
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
