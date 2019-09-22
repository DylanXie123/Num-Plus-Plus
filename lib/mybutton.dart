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

Map keyboard = {
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
  '+' : Text('+'),
  '-' : Text('-'),
  '\\\\times' : Text('×'),
  '\\div' : Text('÷'),
  '/' : Text('frac'),
  '^' : Text('^'),
  '.' : Text('.'),
  '(' : Text('('),
  ')' : Text(')'),
  '%' : Text('%'),
  'e' : Text('e'),
  '\\pi' : Text('pi'),
  '\\sqrt' : Text('sqrt'),
  '\\\\nthroot' : Text('nroot'),
  '\\sin' : Text('sin'),
  '\\cos' : Text('cos'),
  '\\tan' : Text('tan'),
  '\\arcsin' : Text('asin'),
  '\\arccos' : Text('acos'),
  '\\arctan' : Text('atan'),
  '\\log' : Text('log'),
  '\\ln' : Text('ln'),
  '\\|' : Text('abs'),
  'x' : Text('x'),
  'Left' : Icon(Icons.arrow_back),
  'Right' : Icon(Icons.arrow_forward),
  'Up' : Icon(Icons.arrow_upward),
  'Down' : Icon(Icons.arrow_downward),
  'AC' : Icon(Icons.delete),
  'BackSpace' : Icon(Icons.backspace),
  '=' : Text('='),
};

class MathKeyBoard extends StatelessWidget {

  final MathController mathController;

  const MathKeyBoard({Key key, @required this.mathController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      itemCount: keyboard.length,
      itemBuilder: (context, index) => MyButton(
        onPressed: () {
          var cmd = keyboard.keys.elementAt(index);
          switch (cmd) {
            case '\\sin':
              continue trigonometric;
            case '\\cos':
              continue trigonometric;
            case '\\tan':
              continue trigonometric;
            case '\\arcsin':
              continue trigonometric;
            case '\\arccos':
              continue trigonometric;
            trigonometric:
            case '\\arctan':
              mathController.addExpression(cmd);
              mathController.addExpression('(');
              break;
            case '\\log':
              mathController.addExpression(cmd);
              mathController.addExpression('_');
              break;
            case 'Up':
              continue movecursor;
            case 'Down':
              continue movecursor;
            case 'Left':
              continue movecursor;
            movecursor:
            case 'Right':
              mathController.addKey(cmd);
              break;
            case 'AC':
              mathController.delAllExpression();
              break;
            case 'BackSpace':
              mathController.delExpression();
              break;
            case '=':
              break;
            default: 
              mathController.addExpression(cmd);
              break;
          }
        },
        child: keyboard.values.elementAt(index),
      ),
    );
  }
}
