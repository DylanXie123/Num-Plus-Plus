import 'package:flutter_test/flutter_test.dart';
import 'package:math_expressions/math_expressions.dart';

import 'package:num_plus_plus/src/backend/latex.dart';

void main() {
  test('Unit Test', () {
    final lp = LaTexParser('\\sin\\left(45-\\frac{\\log_3\\left(45+\\frac{\\sin\\left(2\\right)}{\\sqrt{2}}\\right)}{x\\pi}\\right)+e^{-1}');
    // print(lp.stream);
    // print(lp.outputstack);
    print(lp.parse());
  });

  test('General Expression Benchmark', () {
    final lp = LaTexParser('\\sin\\left(45-\\frac{\\log_3\\left(45+\\frac{\\sin\\left(2\\right)}{\\sqrt{2}}\\right)}{4\\pi}\\right)+e^{-1}');
    Expression exp = lp.parse();
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    print(eval);
    expect(eval.toStringAsFixed(7), '1.0428622');
  });

}
