import 'package:flutter_test/flutter_test.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:num_plus_plus/src/latex.dart';

void main() {
  test('Unit Test', () {
    final lp = LaTexParser('2\\log_{4.2}{7}');
    // print(lp.stream);
    print(lp.outputstack);
    // print(lp.parse());
  });

  // test('Primative Unit Test', () {
  //   final lp = LatexParser();
  //   print(lp.parse('23').value);
  //   print(lp.parse('-43.324324E-20').value);
  //   print(lp.parse('.1234E+20').value);
  //   print(lp.parse('-.1234E2').value);
  //   print(lp.parse('45.78').value);
  //   print(lp.parse('\\pi').value);
  //   print(lp.parse('x').value);
  //   print(lp.parse('\\left(78\\right)').value);
  // });

  // test('Postfix Test', () {
  //   final lp = LatexParser();
  //   print(lp.parse('3!').value);
  //   print(lp.parse('\\left(3+6\\right)!').value);
  //   print(lp.parse('562\\%').value);
  // });

  // test('Function Test', () {
  //   final lp = LatexParser();
  //   print(lp.parse('\\sin\\left(.23\\right)').value);
  //   print(lp.parse('\\arcsin\\left(53.6\\right)').value);
  //   print(lp.parse('\\log_3\\left(34\\right)').value);
  //   print(lp.parse('\\log_{1+2}\\left(34\\right)').value);
  //   print(lp.parse('\\sqrt{78.6}').value);
  //   print(lp.parse('\\sqrt[2+6]{45}').value);
  // });

  // test('Terms Test', () {
  //   final lp = LatexParser();
  //   print(lp.parse('45.36*2').value);
  //   print(lp.parse('\\frac{1}{45}+1').value);
  //   print(lp.parse('45\\frac{\\frac{56*21+5}{2}}{45}').value);
  //   print(lp.parse('45.36*25.12\\div2').value);
  //   print(lp.parse('45.36^25.12\\div2').value);
  //   print(lp.parse('45.36^{25.12+1}').value);
  // });

  // test('Binary Operator Test', () {
  //   final lp = LatexParser();
  //   print(lp.parse('25.12-2').value);
  //   print(lp.parse('45.36+25.12+2').value);
  //   print(lp.parse('7\\times\\sin\\left(90\\right)').value);
  //   print(lp.parse('\\left(45-45.36\\right)*25.12+2').value);
  // });

  test('General Expression Benchmark', () {
    final lp = LaTexParser('\\sin\\left(45-\\frac{\\frac{\\log_3\\left(45+\\frac{\\sin\\left(2\\right)}{\\sqrt{2}}\\right)}{\\left|45-\\frac{.23}{8E4}\\right|}}{4\\times\\pi}\\right)+e');
    Expression exp = lp.parse();
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    print(eval);

    // print(lp.parse('45\\frac{\\sqrt[2+6]{45}}{\\log_3\\left(45\\right)}+6').value);
    // print(lp.parse('\\sin\\left(45-\\frac{\\frac{\\log_3\\left(45+\\frac{\\sin\\left(2\\right)}{\\sqrt{2}}\\right)}{\\left|45-\\frac{.23}{8E4}\\right|}}{4\\pi}\\right)+e').value);
  });

}
