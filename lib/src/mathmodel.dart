import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'function.dart';
import 'latex.dart';

class MathModel with ChangeNotifier {
  String latexExp = '';
  String result = '';
  List<String> history = [];

  WebViewController webViewController;
  bool isClearable = false;
  bool isFunction = false;
  int precision = 10;
  bool isRadMode = true;

  AnimationController clearAnimationController;
  AnimationController equalAnimationController;

  void calcNumber() {
    print('exp: ' + latexExp.toString());
    if (latexExp.isEmpty) {
      result = '';
    } else {
      try {
        LaTexParser lp;
        if (history.isEmpty) {
          lp = LaTexParser(latexExp, isRadMode: isRadMode);
        } else {
          lp = LaTexParser(latexExp.replaceFirst('Ans', '{'+history.last.toString()+'}'), isRadMode: isRadMode);
        }
        Expression mathexp = lp.parse();
        print('Parsed: ' + mathexp.toString());
        result = calc(mathexp, precision).toString();
      } catch (e) {
        result = '';
        print('Error: '+ e.toString());
      }
    }
    notifyListeners();
  }

  void toFunction() {
    isFunction = true;
    result = '';
    notifyListeners();
  }

  // void nSolveFunction() {
  //   LatexParser lp = LatexParser();
  //   lp.parse(latexExp);
  //   if (lp.result.isSuccess) {
  //     print('Parsed: ' + lp.result.value);
  //     var f = MyFunction(lp.result.value);
  //     result = f.nsolve().toString();
  //     print(result);
  //   } else {
  //     print('Fail');
  //     result = '';
  //   }
  //   notifyListeners();
  // }

  void pressEqual() {
    if (result.isNotEmpty) {
      history.add(result);
      isClearable = true;
    }
    equalAnimationController.forward();
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
    equalAnimationController.reset();
    webViewController.evaluateJavascript("addCmd('$msg')");
  }

  void addKey(String key) {
    webViewController.evaluateJavascript("simulateKey('$key')");
  }

}

num calc(Expression mathexp, int precision) {  
  num val = mathexp.evaluate(EvaluationType.REAL, ContextModel());
  if (val.abs()>16331239353195369) {
    return val.sign*(1.0/0.0);
  }
  val = num.parse(val.toStringAsFixed(precision));
  val = intCheck(val);
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
