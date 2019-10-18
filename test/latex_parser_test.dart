import 'package:flutter_test/flutter_test.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:num_plus_plus/src/latex.dart';

void main() {
  test('Unit Test', () {
    final lp = LaTexParser('{2+6}\\sin{3}');
    // print(lp.stream);
    // print(lp.outputstack);
    print(lp.parse());
  });

  test('General Expression Benchmark', () {
    final lp = LaTexParser('\\sin\\left(45-\\frac{\\frac{\\log_3\\left(45+\\frac{\\sin\\left(2\\right)}{\\sqrt{2}}\\right)}{\\left|45-\\frac{.23}{8E4}\\right|}}{4\\pi}\\right)+e');
    Expression exp = lp.parse();
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    print(eval);
    expect(eval.toStringAsFixed(6), '2.715996');
  });

}
