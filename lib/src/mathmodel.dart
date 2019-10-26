import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'function.dart';
import 'latex.dart';

class MathModel with ChangeNotifier {
  List<String> latexExp = [''];
  List<String> result = [''];
  int _resultIndex = 0;
  bool _isClearable = false;
  int precision;
  bool isRadMode;
  
  WebViewController webViewController;
  AnimationController clearAnimationController;
  AnimationController equalAnimationController;

  void calcNumber() {
    print('exp: ' + latexExp.toString());
    if (latexExp.last.isEmpty) {
      result.last = '';
    } else {
      try {
        LaTexParser lp;
        if (result.length <= 1) {
          lp = LaTexParser(latexExp.last, isRadMode: isRadMode);
        } else {
          lp = LaTexParser(latexExp.last.replaceAll('Ans', '{'+result[result.length-2].toString()+'}'), isRadMode: isRadMode);
        }
        Expression mathexp = lp.parse();
        print('Parsed: ' + mathexp.toString());
        result.last = calc(mathexp, precision).toString();
      } catch (e) {
        result.last = '';
        print('Error: '+ e.toString());
      }
    }
    notifyListeners();
  }

  void pressEqual() {
    if (result.last.isNotEmpty) {
      result.add(result.last);
      latexExp.add(latexExp.last);
      _isClearable = true;
      _resultIndex = result.length - 1;
      equalAnimationController.forward();
      notifyListeners();
    }
    print(result);
  }

  void checkHistory({@required toPrevious}) {
    if (toPrevious) {
      if (_resultIndex>0) {
        _resultIndex--;
      } else {
        throw 'Out of Range';
      }
    } else {
      if (_resultIndex<result.length-1) {
        _resultIndex++;
      } else {
        throw 'Out of Range';
      }
    }
    webViewController.evaluateJavascript("delAll()");
    List<int> uniCode = latexExp[_resultIndex].runes.toList();
    for (var i = 0; i < uniCode.length; i++) {
      if (uniCode[i] == 92) {
        uniCode.insert(i, 92);
        i++;
      }
    }
    String history = String.fromCharCodes(uniCode);
    equalAnimationController.reset();
    webViewController.evaluateJavascript("addString('$history')");
    result.last = result[_resultIndex];
  }

  void toNotClearable() {
    _isClearable = false;
    equalAnimationController.reset();
  }

  void addExpression(String msg, {bool isOperator = false}) {
    if (_isClearable) {
      webViewController.evaluateJavascript("delAll()");
      toNotClearable();
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
