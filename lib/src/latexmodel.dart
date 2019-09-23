import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import 'latex_parser.dart';

class LatexModel with ChangeNotifier {
  String _latexExp = '';
  String result = '';

  set latexExp(String latex) {
    _latexExp = latex;
    calc();
    notifyListeners();
  }

  void calc() {
    try {
      print('Latex: ' + _latexExp);
      LatexParser lp = LatexParser();
      lp.parse(_latexExp);
      Expression exp = Parser().parse(lp.result.value);
      result = exp.evaluate(EvaluationType.REAL, ContextModel()).toString();
      print('Calc Result: ' + result);
    } catch (e) {
      result = '';
      print('Error In calc: ' + e.toString());
    }
  }
}