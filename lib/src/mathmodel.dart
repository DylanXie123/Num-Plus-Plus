import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:ml_linalg/matrix.dart';

// import 'function.dart';
import 'latex.dart';

class MathModel with ChangeNotifier {
  List<String> _latexExp = [''];
  List<String> _result = [''];
  int _precision;
  bool _isRadMode;
  bool _isClearable = false;

  int _resultIndex = 0;

  String get result => _result.last;
  bool get isClearable => _isClearable;
  int get resultLength => _result.length;
  
  void changeClearable(bool b) {
    _isClearable = b;
    if (_isClearable && _latexExp.last.isNotEmpty) {
      _latexExp.add('');
      _result.add(_result.last);
      _resultIndex = _latexExp.length - 1;
    }
    notifyListeners();
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

class MatrixModel {
  List<String> _matrixExp = [''];
  List _resultExp = [''];

  void updateExpression(String expression) {
    _matrixExp.last = expression;
  }

  void calc() {
    final mp = MatrixParser(_matrixExp.last);
    Matrix matrix = mp.parse();
    _resultExp.last = matrix;
  }

  void norm() {
    final mp = MatrixParser(_matrixExp.last);
    if (mp.outputstack.length > 1) {
      throw 'Unable to do norm';
    }
    Matrix matrix = mp.parse();
    _resultExp.last = matrix.norm();
  }

  void transpose() {
    final mp = MatrixParser(_matrixExp.last);
    if (mp.outputstack.length > 1) {
      throw 'Unable to do transpose';
    }
    Matrix matrix = mp.parse();
    _resultExp.last = matrix.transpose();
  }

  void invert() {
    final mp = MatrixParser(_matrixExp.last);
    if (mp.outputstack.length > 1) {
      throw 'Unable to do invert';
    }
    Matrix matrix = mp.parse();
    if (matrix.rowsNum == matrix.columnsNum) {
      List<List<double>> temp = List.filled(matrix.rowsNum, List.filled(matrix.rowsNum, 0.0));
      for (var i = 0; i < temp.length; i++) {
        temp[i][i] = 1;
      }
      Matrix identity = Matrix.fromList(temp);
      _resultExp.last = identity / matrix;
    } else {
      throw 'Not a square matrix';
    }
  }

  String display() {
    var matrixList = _resultExp.last.toList();
    List rows = List(matrixList.length);
    for (var i = 0; i < matrixList.length; i++) {
      rows[i] = matrixList[i].join('&');
    }
    String matrixString = rows.join(r'\\\\');
    matrixString = r'\\begin{bmatrix}' + matrixString + r'\\end{bmatrix}';
    return matrixString;
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
