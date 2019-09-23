import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'latex_parser.dart';

class LatexModel with ChangeNotifier {
  String _latexExp = '';
  String result = '';
  List<String> history = [''];

  WebViewController webViewController;
  bool isClearable = false;
  // TODO: Implement isClearable function here

  set latexExp(String latex) {
    _latexExp = latex;
    calc();
    notifyListeners();
  }

  void keep() {
    history.add(result);
    result = '';
    notifyListeners();
    print(history);
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

  void addExpression(String msg, {bool isOperator = false}) {
    if (isClearable) {
      delAllExpression();
      isClearable = false;
      if (isOperator) {
        String ans = history.last;
        webViewController.evaluateJavascript("addCmd('$ans')");
      }
    }
    webViewController.evaluateJavascript("addCmd('$msg')");
  }

  void delExpression() {
    webViewController.evaluateJavascript("delString()");
  }

  void delAllExpression() {
    webViewController.evaluateJavascript("delAll()");
  }

  void addKey(String key) {
    webViewController.evaluateJavascript("simulateKey('$key')");
  }

}