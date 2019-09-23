import 'package:calculator/src/latexmodel.dart';
import 'package:flutter/material.dart';
import 'mathbox.dart';

class MyButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double _width = 40.0; //40.0 is better

  const MyButton({
    @required this.child,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: _width / 1.3,
        color: Colors.black,
        fontFamily: 'RobotoMono',
      ),
      child: Container(
        height: _width * 2,
        width: _width * 2,
        alignment: Alignment.center,
        child: InkResponse(
          radius: _width * 1.2,
          splashFactory: InkRipple.splashFactory,
          highlightColor: Colors.transparent,
          onTap: onPressed,
          child: Container(
            height: _width * 2,
            width: _width * 2,
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}

// TODO: Adjust keyboard layout
class MathKeyBoard extends StatelessWidget {

  final MathController mathController;
  final LatexModel latexModel;

  const MathKeyBoard({Key key, @required this.mathController, @required this.latexModel}) : super(key: key);
  
  static const Map basic = {
    '1' : Text('1'),
    '2' : Text('2'),
    '3' : Text('3'),
    '4' : Text('4'),
    '5' : Text('5'),
    '6' : Text('6'),
    '7' : Text('7'),
    '8' : Text('8'),
    '9' : Text('9'),
    '0' : Text('0'),
    '^' : Text('^'),
    '.' : Text('.'),
    '(' : Text('('),
    ')' : Text(')'),
    '%' : Text('%'),
    'e' : Text('e'),
    '\\pi' : Text('pi'),
    'x' : Text('x'),
  };

  static const Map mathoperator = {
    '+' : Text('+'),
    '-' : Text('-'),
    '\\\\times' : Text('×'),
    '\\div' : Text('÷'),
    '/' : Text('frac'),
  };

  static const Map functionA = {
    '\\sin' : Text('sin'),
    '\\cos' : Text('cos'),
    '\\tan' : Text('tan'),
    '\\arcsin' : Text('asn'),
    '\\arccos' : Text('acs'),
    '\\arctan' : Text('atn'),
  };

  static const Map functionB = {
    '\\log' : Text('log'),
    '\\ln' : Text('ln'),
  };

  static const Map function = {
    '\\sqrt' : Text('sqrt'),
    '\\\\nthroot' : Text('nrt'),
    '\\|' : Text('abs'),
  };

  static const Map cursor = {
    'Left' : Icon(Icons.arrow_back),
    'Right' : Icon(Icons.arrow_forward),
    'Up' : Icon(Icons.arrow_upward),
    'Down' : Icon(Icons.arrow_downward),
  };

  List<Widget> _buildButtonGroup(Map key, int type) {
    List<Widget> button = [];
    for (var i = 0; i < key.length; i++) {
      button.add(
        MyButton(
          child: key.values.elementAt(i),
          onPressed: () {
            var cmd = key.keys.elementAt(i);
            switch (type) {
              case 1: // basic type
                mathController.addExpression(cmd);
                break;
              case 2:
                mathController.addExpression(cmd, isOperator: true);
                break;
              case 3:
                mathController.addExpression(cmd);
                mathController.addExpression('(');
                break;
              case 4:
                mathController.addExpression(cmd);
                mathController.addExpression('_');
                break;
              case 5:
                mathController.addKey(cmd);
                break;
            }
          },
        ),
      );
    }
    return button;
  }

  List<Widget> _buildButton() {
    List<Widget> button = [];
    
    final equal = MyButton(
      child: Text('='),
      onPressed: () {
        latexModel.keep();
        mathController.isClearable = true;
      },
    );
    final backspace = MyButton(
      child: Icon(Icons.backspace),
      onPressed: () {
        mathController.delExpression();
      },
    );
    final ac = MyButton(
      child: Icon(Icons.delete),
      onPressed: () {
        mathController.delAllExpression();
      },
    );

    button.addAll(_buildButtonGroup(basic, 1));
    button.addAll(_buildButtonGroup(mathoperator, 2));
    button.addAll(_buildButtonGroup(functionA, 3));
    button.addAll(_buildButtonGroup(functionB, 4));
    button.addAll(_buildButtonGroup(function, 1));
    button.addAll(_buildButtonGroup(cursor, 5));
    button.add(equal);
    button.add(backspace);
    button.add(ac);
    return button;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 5,
      children: _buildButton(),
    );
  }

}