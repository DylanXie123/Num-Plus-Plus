import 'package:petitparser/petitparser.dart';

/// six cacl levels:
/// primative: numbers variable constant parethesis
/// postfix: ! %
/// function: sin... ln sqrt abs
/// exponential: ^
/// terms: * / frac
/// binary: + -

class LatexGrammarDefinition extends GrammarDefinition {
  const LatexGrammarDefinition();
  start() => ref(binary).end();

  basic() => ref(number) | ref(pi) | ref(e) | ref(variable);
  prim() => (string('\\left(') & ref(binary) & string('\\right)')).pick(1) | ref(basic);
  postfix() => (ref(factorial) | ref(percent)) | ref(prim);
  function() => 
    (ref(sin) | ref(cos) | ref(tan) |
    ref(asin) | ref(acos) | ref(atan) |
    ref(abs) | ref(ln) | ref(log) |
    ref(nlog) | ref(sqrt) | ref(nrt)) | ref(postfix);
  expo() => ref(exponential) | ref(function);
  terms() => (ref(defaulttimes) | ref(times) | ref(frac) | ref(divide)) | ref(expo); //defaulttimes must be the first
  binary() => (ref(plus) | ref(minus)) | ref(terms);

  integer() => digit().plus().flatten();
  number() =>
    (ref(integer) | char('.').and()) &
    (char('.') & ref(integer)).optional() &
    (char('E') & pattern('+-').optional() & ref(integer)).optional();
  pi() => string('\\pi');
  e() => char('e');
  variable() => pattern('xy');

  factorial() => ref(prim) & char('!');
  percent() => ref(prim) & char('%');

  sin() => string('\\sin\\left(') & ref(binary) & string('\\right)');
  cos() => string('\\cos\\left(') & ref(binary) & string('\\right)');
  tan() => string('\\tan\\left(') & ref(binary) & string('\\right)');
  asin() => string('\\arcsin\\left(') & ref(binary) & string('\\right)');
  acos() => string('\\arccos\\left(') & ref(binary) & string('\\right)');
  atan() => string('\\arctan\\left(') & ref(binary) & string('\\right)');
  abs() => string('\\left|') & ref(binary) & string('\\right|');
  ln() => string('\\ln\\left(') & ref(binary) & string('\\right)');
  log() => string('\\log_') & digit() & string('\\left(') & ref(binary) & string('\\right)');
  nlog() => string('\\log_{') & ref(binary) & string('}\\left(') & ref(binary) & string('\\right)');
  sqrt() => string('\\sqrt{') & ref(binary) & char('}');
  nrt() => string('\\sqrt[') & ref(binary) & string(']{') & ref(binary) & char('}');
  
  exponential() => ref(function) & char('^') & (ref(expo) | (char('{') & ref(binary) & char('}')));

  defaulttimes() => ref(expo) & ref(terms);
  times() => ref(expo) & char('*') & ref(terms); 
  /// why function * terms?? not terms * terms
  /// Ans: calling ref(terms) at the begining will become a dead loop
  divide() => ref(expo) & string('\\div') & ref(terms);
  frac() => string('\\frac{') & ref(binary) & string('}{') & ref(binary) & char('}');
  
  plus() => ref(terms) & char('+') & ref(binary);
  minus() => ref(terms) & char('-') & ref(binary);
}
