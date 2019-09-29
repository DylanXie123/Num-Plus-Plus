import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'latex_parser.dart';

class MathModel with ChangeNotifier {
  String _latexExp = '';
  String result = '';
  List<String> history = [''];

  WebViewController webViewController;
  bool isClearable = false;

  AnimationController animationController;

  set latexExp(String latex) {
    _latexExp = latex;
    calc();
    notifyListeners();
  }

  void keep() {
    if (result.isNotEmpty) {
      history.add(result);
    }
    notifyListeners();
    print(history);
  }

  void calc() {
    try {
      print('Latex: ' + _latexExp);
      LatexParser lp = LatexParser();
      lp.parse(_latexExp);
      Expression exp = Parser().parse(lp.result.value);
      num val = exp.evaluate(EvaluationType.REAL, ContextModel());
      val = num.parse(val.toStringAsFixed(10));
      // set calc precision to 10
      val = intCheck(val);
      if (val.abs() < 1e-10) {
        val = 0;
      }
      result = val.toString();
      // TODO: live calc to transfer decimal to fraction
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

num intCheck(num a) {
  if (a.ceil() == a.floor()) {
    return a.toInt();
  } else {
    return a;
  }
}

List<int> deci2frac(num a) {
  double esp = 1e-15;
  List<int> res = [];
  for (var i = 0; i < 50; i++) {
    int t = a.truncate();
    res.add(t);
    a = a - t;
    while(t > 0) {
      t = t~/10;
      esp *= 10;
    }
    if (a.abs() < esp) {
      return _contfrac2frac(res);
    } else if ((1-a).abs() < esp) {
      res.last += 1;
      return _contfrac2frac(res);
    } else {
      a = 1 / a;
    }
  }
  throw 'Unable to tranfer decimal to frac';
}

List<int> _contfrac2frac(List<int> cont){
  List<int> res = [1, 1];
  res.first = cont.last;
  cont.removeLast();
  for (var i = cont.length; i > 0; i--) {
    res = res.reversed.toList();
    res.first = res.first + res.last * cont.last;
    cont.removeLast();
  }
  return res;
}
