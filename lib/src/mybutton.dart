import 'package:flutter/material.dart';

import 'mathmodel.dart';

class MyButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final double _width = 40.0; //40.0 is better

  const MyButton({
    @required this.child,
    @required this.onPressed, 
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: _width / 1.3,
        color: Colors.black,
        fontFamily: 'Minion-Pro',
      ),
      child: InkResponse(
        radius: _width * 1.2,
        splashFactory: InkRipple.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.green[50],
        onTap: onPressed,
        onLongPress: onLongPress,
        child: Container(
          height: _width * 2,
          width: _width * 2,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

class MathKeyBoard extends StatelessWidget {

  final MathModel mathModel;

  const MathKeyBoard({Key key, @required this.mathModel}) : super(key: key);

  static const Map pfunction = {
    '\\sin' : Text('Sin'),
    '\\cos' : Text('Cos'),
    '\\\\tan' : Text('Tan'),
    '\\arcsin' : Text('asin'),
    '\\arccos' : Text('acos'),
    '\\arctan' : Text('atan'),
    '\\ln' : Text('Ln'),
  };

  static const Map function = {
    '\\sqrt' : Text('√'),
    '\\\\nthroot' : Text('nrt'),
    '\\|' : Text('| |'),
    '\\int' : Text('∫'),
    '!' : Text('!'),
    'x' : Text('x'),
    '^' : Text('x^y'),
    '%' : Text('%'),
    '(' : Text('('),
    ')' : Text(')'),
  };

  List<Widget> _buildButtonGroup(Map key, {bool par = false}) {
    List<Widget> button = [];
    for (var i = 0; i < key.length; i++) {
      button.add(
        MyButton(
          child: key.values.elementAt(i),
          onPressed: () {
            var cmd = key.keys.elementAt(i);
            mathModel.addExpression(cmd);
            if (par) {mathModel.addExpression('(');}
          },
        ),
      );
    }
    return button;
  }

  List<Widget> _buildLowButton() {
    List<Widget> button = [];

    button.add(MyButton(
      child: Text('7'),
      onPressed: () {mathModel.addExpression('7');},
    ));

    button.add(MyButton(
      child: Text('8'),
      onPressed: () {mathModel.addExpression('8');},
    ));

    button.add(MyButton(
      child: Text('9'),
      onPressed: () {mathModel.addExpression('9');},
    ));

    button.add(MyButton(
      child: Text('x/y'),
      onPressed: () {mathModel.addExpression('/', isOperator: true);},
    ));

    button.add(MyButton(
      child: Icon(Icons.backspace),
      onPressed: () {mathModel.delExpression();},
      onLongPress: () async {
        mathModel.delAllExpression();
        await mathModel.animationController.forward();
        mathModel.animationController.reset();
      },
    ));

    button.add(MyButton(
      child: Text('4'),
      onPressed: () {mathModel.addExpression('4');},
    ));

    button.add(MyButton(
      child: Text('5'),
      onPressed: () {mathModel.addExpression('5');},
    ));

    button.add(MyButton(
      child: Text('6'),
      onPressed: () {mathModel.addExpression('6');},
    ));

    button.add(MyButton(
      child: Text('+'),
      onPressed: () {mathModel.addExpression('+', isOperator: true);},
    ));

    button.add(MyButton(
      child: Text('-'),
      onPressed: () {mathModel.addExpression('-', isOperator: true);},
    ));

    button.add(MyButton(
      child: Text('1'),
      onPressed: () {mathModel.addExpression('1');},
    ));

    button.add(MyButton(
      child: Text('2'),
      onPressed: () {mathModel.addExpression('2');},
    ));

    button.add(MyButton(
      child: Text('3'),
      onPressed: () {mathModel.addExpression('3');},
    ));

    button.add(MyButton(
      child: Text('×'),
      onPressed: () {mathModel.addExpression('\\\\times', isOperator: true);},
    ));

    button.add(MyButton(
      child: Text('÷'),
      onPressed: () {mathModel.addExpression('\\div', isOperator: true);},
    ));

    button.add(MyButton(
      child: Text('0'),
      onPressed: () {mathModel.addExpression('0');},
    ));

    button.add(MyButton(
      child: Text('.'),
      onPressed: () {mathModel.addExpression('.');},
    ));

    button.add(MyButton(
      child: Text('='),
      onPressed: () {
        mathModel.keep();
        mathModel.isClearable = true;
      },
    ));

    button.add(MyButton(
      child: Text('π'),
      onPressed: () {mathModel.addExpression('\\pi');},
    ));

    button.add(MyButton(
      child: Text('e'),
      onPressed: () {mathModel.addExpression('e');},
    ));

    return button;
  }

  List<Widget> _buildUpButton() {
    List<Widget> button = [];

    button.addAll(_buildButtonGroup(pfunction, par: true));
    button.addAll(_buildButtonGroup(function));
    
    button.add(MyButton(
      child: Text('log'),
      onPressed: () {
        mathModel.addExpression('log');
        mathModel.addExpression('_');
        mathModel.addKey('Right');
        mathModel.addExpression('(');
        mathModel.addKey('Left Left');
      },
    ));

    button.add(MyButton(
      child: Text('x²'),
      onPressed: () {
        mathModel.addExpression('(');
        mathModel.addExpression(')');
        mathModel.addExpression('^');
        mathModel.addExpression('2');
        mathModel.addKey('Left Left Left');
      },
    ));

    button.add(MyButton(
      child: Icon(Icons.arrow_back),
      onPressed: () {
        mathModel.addKey('Left');
      },
    ));

    button.add(MyButton(
      child: Icon(Icons.arrow_forward),
      onPressed: () {
        mathModel.addKey('Right');
      },
    ));

    return button;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            child: Material(
              borderRadius: BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0)),
              elevation: 8.0,
              color: Colors.green[200],
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 7,
                children: _buildUpButton(),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Material(
            color: Colors.yellow[200],
            elevation: 15.0,
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 5,
              children: _buildLowButton(),
            ),
          ),
        ),
      ],
    );
  }

}