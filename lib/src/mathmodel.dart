import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:linalg/linalg.dart';

// import 'function.dart';
import 'latex.dart';

class MathModel with ChangeNotifier {
  List<String> _latexExp = [''];
  List<String> _result = [''];
  int _precision;
  bool _isRadMode;
  bool _isClearable = false;
  int _resultIndex = 0;

  AnimationController equalAnimation;

  String get result => _result.last;
  int get resultLength => _result.length;
  
  void changeClearable(bool b) {
    _isClearable = b;
    if (_isClearable && _latexExp.last.isNotEmpty) {
      _latexExp.add('');
      _result.add(_result.last);
      _resultIndex = _latexExp.length - 1;
      equalAnimation.forward();
    } else {
      equalAnimation.reset();
    }
  }

  void changeSetting({int precision, bool isRadMode}) {
    this._precision = precision;
    this._isRadMode = isRadMode;
  }

  void updateExpression(String expression) {
    _latexExp.last = expression;
  }

  void calcNumber() {
    print('exp: ' + _latexExp.toString());
    if (_latexExp.last.isEmpty) {
      _result.last = '';
    } else {
      try {
        LaTexParser lp;
        if (_result.length <= 1) {
          lp = LaTexParser(_latexExp.last, isRadMode: _isRadMode);
        } else {
          lp = LaTexParser(_latexExp.last.replaceAll('Ans', '{'+_result[_result.length-2].toString()+'}'), isRadMode: _isRadMode);
        }
        Expression mathexp = lp.parse();
        print('Parsed: ' + mathexp.toString());
        _result.last = calc(mathexp, _precision).toString();
      } catch (e) {
        _result.last = '';
        print('Error: '+ e.toString());
      }
    }
    notifyListeners();
  }

  String checkHistory({@required toPrevious}) {
    // TODO: Have index problem
    if (toPrevious) {
      if (_resultIndex>0) {
        _resultIndex--;
      } else {
        throw 'Out of Range';
      }
    } else {
      if (_resultIndex+2<_result.length) {
        _resultIndex++;
      } else {
        throw 'Out of Range';
      }
    }
    List<int> uniCode = _latexExp[_resultIndex].runes.toList();
    for (var i = 0; i < uniCode.length; i++) {
      if (uniCode[i] == 92) {
        uniCode.insert(i, 92);
        i++;
      }
    }
    _latexExp.last = String.fromCharCodes(uniCode);
    _result.last = _result[_resultIndex];
    notifyListeners();
    return _latexExp.last;
  }

}

class MatrixModel with ChangeNotifier {
  List<String> _matrixExpression = [''];
  List _result = [''];
  int _precision;
  bool _isRadMode;
  bool single = true;

  get result => _result.last;

  void updateExpression(String expression) {
    _matrixExpression.last = expression;
    final mp = MatrixParser(_matrixExpression.last)..tokenize();
    single = mp.length>1?false:true;
    notifyListeners();
  }

  void calc() {
    final mp = MatrixParser(_matrixExpression.last, precision: _precision);
    Matrix matrix = mp.parse();
    _result.last = matrix;
    _matrixExpression.add(_matrixExpression.last);
    _result.add(_result.last);
  }

  void norm() {
    final mp = MatrixParser(_matrixExpression.last, precision: _precision);
    Matrix matrix = mp.parse();
    _result.last = matrix.det();
    _matrixExpression.add(_matrixExpression.last);
    _result.add(_result.last);
  }

  void transpose() {
    final mp = MatrixParser(_matrixExpression.last, precision: _precision);
    Matrix matrix = mp.parse();
    _result.last = matrix.transpose();
    _matrixExpression.add(_matrixExpression.last);
    _result.add(_result.last);
  }

  void invert() {
    final mp = MatrixParser(_matrixExpression.last, precision: _precision);
    Matrix matrix = mp.parse();
    _result.last = matrix.inverse();
    _matrixExpression.add(_matrixExpression.last);
    _result.add(_result.last);
  }

  String display() {
    List<String> matrixRows = [];
    for (var i = 0; i < _result.last.m; i++) {
      matrixRows.add(_result.last[i].join('&'));
    }
    String matrixString = matrixRows.join(r'\\\\');
    matrixString = r'\\begin{bmatrix}' + matrixString + r'\\end{bmatrix}';
    return matrixString;
  }

  void changeSetting({int precision, bool isRadMode}) {
    this._precision = precision;
    this._isRadMode = isRadMode;
  }

}

class CalculationMode extends ValueNotifier<Mode> {
  CalculationMode(Mode value) : super(value);
}

enum Mode {
  Basic,
  Matrix,
}

num calc(Expression mathexp, int precision) {  
  num val = mathexp.evaluate(EvaluationType.REAL, ContextModel());
  if (val.abs()>16331239353195369) {
    return val.sign*(1.0/0.0);
  }
  val = num.parse(val.toStringAsFixed(precision));
  val = intCheck(val);
  return val;
}

num intCheck(num a) {
  if (a.ceil() == a.floor()) {
    return a.toInt();
  } else {
    return a;
  }
}

// TODO: calc to transfer decimal to fraction
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
