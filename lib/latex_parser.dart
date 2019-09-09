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
      ..prefix(string('\\arcsin'), (op, a) => 'arcsin$a');
    
    //postfix group
    builder.group()
      ..postfix(number()|constant()|variable(), (a, b) => '$a * $b')
      ..postfix(char('!'), (a, op) => factorial(a).toString());

    // left-associative group
    builder.group()
      ..left(string('\\log'), (a, op, b) => '$a log $b')
      ..left(string('\\times'), (a, op, b) => '$a * $b')
      ..left(string('\\frac'), (a, op, b) => '$a / $b')
      ..left(char('+'), (a, op, b) => '$a + $b')
      ..left(char('-'), (a, op, b) => '$a - $b');
    
    builder.group() // make \times default operator
      ..left(char('{').and(), (a, op, b) => '$a * $b')
      ..left(string('\\left(').and(), (a, op, b) => '$a * $b')
      ..left(string('\\left|').and(), (a, op, b) => '$a * $b')
      // ..left(string('\\log_{'), (a, op, b) => '$a * sin$b')
      // ..left(string('\\log_'), (a, op, b) => '$a * sin$b')
      ..left(string('\\sin'), (a, op, b) => '$a * sin$b')
      ..left(string('\\ln'), (a, op, b) => '$a * ln$b')
      ..left(string('\\arcsin'), (a, op, b) => '$a * arcsin$b')
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
    Map _parenthesisInfo = Map();
    Map _temp = Map();
    List _parenthesisLoc = [];

    // get parenthesisInfo in Map form
    for (var i = 0; i < latexmath.length; i++) {
      if(latexmath.startsWith('\\frac{', i)) {
        _parenthesisInfo[i] = '\\frac{';
        i += 5;
        continue;
      }
      if (latexmath.startsWith('\\log_{', i)) {
        _parenthesisInfo[i] = '\\log_{';
        i += 5;
        continue;
      }
      switch (latexmath[i]) {
        case '{':
          _parenthesisInfo[i] = '{';
          break;
        case '}':
          _parenthesisInfo[i] = '}';
          break;
      }
    }
    print(_parenthesisInfo);

    // remove unnecessary parenthesis
    for (var i = 0; i < _parenthesisInfo.values.length; i++) {
      if(_parenthesisInfo.values.elementAt(i).contains('{')) {
        _temp[_parenthesisInfo.keys.elementAt(i)] = _parenthesisInfo.values.elementAt(i);
        continue;
      } else {
        if (_temp.values.elementAt(_temp.values.length-1) == '{') {
          _temp.remove(_temp.keys.elementAt(_temp.keys.length-1));
        } else {
          _parenthesisLoc.add(_temp.keys.elementAt(_temp.keys.length-1));
          _parenthesisLoc.add(_parenthesisInfo.keys.elementAt(i));
          _temp.remove(_temp.keys.elementAt(_temp.keys.length-1));
        }
      }
    }
    print(_parenthesisLoc);

    // refactor the string
    for (var i = 0; i < _parenthesisLoc.length; i+=2) {
      String msg = '';
      if (_parenthesisInfo[_parenthesisLoc[i]] == '\\frac{') {
        msg = '\\frac';
      } else {
        msg = '\\log ';
      }
      latexmath =  latexmath.substring(0,_parenthesisLoc[i]) + latexmath.substring(_parenthesisLoc[i]+5,_parenthesisLoc[i+1]+1) + msg + latexmath.substring(_parenthesisLoc[i+1]+1);
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
