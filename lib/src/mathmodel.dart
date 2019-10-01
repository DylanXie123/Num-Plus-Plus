import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'latex_parser.dart';
import 'function.dart';

class MathModel with ChangeNotifier {
  String latexExp = '';
  String result = '';
  List<String> history = [''];

  WebViewController webViewController;
  bool isClearable = false;
  bool isFunction = false;
  int precision = 10;
  bool degree = true; // false is rad
  // TODO: Rewrire parser to support rad/degree

  AnimationController animationController;

  void calcNumber() {
    LatexParser lp = LatexParser();
    lp.parse(latexExp);
    if (lp.result.isSuccess) {
      print('Parsed: ' + lp.result.value);
      String mathString = lp.result.value.replaceFirst('Ans', history.last.toString());
      try {
        result = calc(mathString, precision).toString();
      } catch (e) {
        result = '';
        print('Error in calc: '+ e.toString());
      }
    } else {
      isFunction = false;
      result = '';
    }
    notifyListeners();
  }

  void toFunction() {
    isFunction = true;
    result = '';
    notifyListeners();
  }

  void nSolveFunction() {
    LatexParser lp = LatexParser();
    lp.parse(latexExp);
    if (lp.result.isSuccess) {
      print('Parsed: ' + lp.result.value);
      var f = MyFunction(lp.result.value);
      result = f.nsolve().toString();
      print(result);
    } else {
      print('Fail');
      result = '';
    }
    notifyListeners();
  }

  void keep() {
    if (result.isNotEmpty) {
      history.add(result);
    }
    notifyListeners();
    print(history);
  }

  void addExpression(String msg, {bool isOperator = false}) {
    if (isClearable) {
      webViewController.evaluateJavascript("delAll()");
      isClearable = false;
      if (isOperator) {
        webViewController.evaluateJavascript("addCmd('Ans')");
      }
    }
    webViewController.evaluateJavascript("addCmd('$msg')");
  }

  void addKey(String key) {
    webViewController.evaluateJavascript("simulateKey('$key')");
  }

}

num calc(String mathString, int precision) {  
  Expression exp = Parser().parse(mathString);
  num val = exp.evaluate(EvaluationType.REAL, ContextModel());
  val = num.parse(val.toStringAsFixed(precision));
  val = intCheck(val);
  if (val.abs() < 1e-10) {
    val = 0;
  }
  print('Calc Result: ' + val.toString());
  return val;
}

num intCheck(num a) {
  if (a.ceil() == a.floor()) {
    return a.toInt();
  } else {
    return a;
  }
}

// TODO: live calc to transfer decimal to fraction
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
