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
  List<String> _matrixExpHistory = [];
  String _matrixExression;
  Matrix _matrix;
  int _precision;
  bool _single = true;
  bool _square = true;

  bool get single => _single;
  bool get square => _square;

  void updateExpression(String expression) {
    _matrixExression = expression;
    final mp = MatrixParser(_matrixExression, precision: _precision);
    _matrix = mp.parse();
    _single = mp.single;
    _square = mp.square;
    notifyListeners();
  }

  void calc() {
    _matrixExpHistory.add(_matrixExression);
    updateExpression(matrix2String(_matrix));
  }

  void norm() {
    _matrixExpHistory.add(_matrixExression);
    _matrixExression = _matrix.det().toString();
    _single = false;
    _square = false;
    notifyListeners();
  }

  void transpose() {
    _matrixExpHistory.add(_matrixExression);
    updateExpression(matrix2String(_matrix.transpose()));
  }

  void invert() {
    _matrixExpHistory.add(_matrixExression);
    updateExpression(matrix2String(_matrix.inverse()));
  }

  String display() {
    List<int> uniCode = _matrixExression.runes.toList();
    for (var i = 0; i < uniCode.length; i++) {
      if (uniCode[i] == 92) {
        uniCode.insert(i, 92);
        i++;
      }
    }
    return String.fromCharCodes(uniCode);
  }

  String matrix2String(Matrix matrix) {
    List<String> matrixRows = [];
    for (var i = 0; i < matrix.m; i++) {
      matrixRows.add(matrix[i].join('&'));
    }
    String matrixString = matrixRows.join(r'\\');
    matrixString = r'\begin{bmatrix}' + matrixString + r'\end{bmatrix}';
    return matrixString;
  }

  void changeSetting({int precision}) {
    this._precision = precision;
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
