import 'package:calculator/src/latexmodel.dart';
import 'package:flutter/material.dart';

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
        fontFamily: 'Symbola',
        fontWeight: FontWeight.w600,
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
          onLongPress: onLongPress,
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

class MathKeyBoard extends StatelessWidget {

  final LatexModel latexModel;

  const MathKeyBoard({Key key, @required this.latexModel}) : super(key: key);

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
    '\\² ' : Text('x²'),
    '\\³ ' : Text('x³'),
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
                latexModel.addExpression(cmd);
                break;
              case 2:
                latexModel.addExpression(cmd, isOperator: true);
                break;
              case 3:
                latexModel.addExpression(cmd);
                latexModel.addExpression('(');
                break;
              case 4:
                latexModel.addExpression(cmd);
                latexModel.addExpression('_');
                break;
              case 5:
                latexModel.addKey(cmd);
                break;
            }
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
      onPressed: () {latexModel.addExpression('7');},
    ));

    button.add(MyButton(
      child: Text('8'),
      onPressed: () {latexModel.addExpression('8');},
    ));

    button.add(MyButton(
      child: Text('9'),
      onPressed: () {latexModel.addExpression('9');},
    ));

    button.add(MyButton(
      child: Text('x/y'),
      onPressed: () {latexModel.addExpression('/', isOperator: true);},
    ));

    button.add(MyButton(
      child: Icon(Icons.backspace),
      onPressed: () {latexModel.delExpression();},
      onLongPress: () async{
        await latexModel.animationController.forward();
        latexModel.delAllExpression();
        latexModel.animationController.reset();
      },
    ));

    button.add(MyButton(
      child: Text('4'),
      onPressed: () {latexModel.addExpression('4');},
    ));

    button.add(MyButton(
      child: Text('5'),
      onPressed: () {latexModel.addExpression('5');},
    ));

    button.add(MyButton(
      child: Text('6'),
      onPressed: () {latexModel.addExpression('6');},
    ));

    button.add(MyButton(
      child: Text('+'),
      onPressed: () {latexModel.addExpression('+', isOperator: true);},
    ));

    button.add(MyButton(
      child: Text('-'),
      onPressed: () {latexModel.addExpression('-', isOperator: true);},
    ));

    button.add(MyButton(
      child: Text('1'),
      onPressed: () {latexModel.addExpression('1');},
    ));

    button.add(MyButton(
      child: Text('2'),
      onPressed: () {latexModel.addExpression('2');},
    ));

    button.add(MyButton(
      child: Text('3'),
      onPressed: () {latexModel.addExpression('3');},
    ));

    button.add(MyButton(
      child: Text('×'),
      onPressed: () {latexModel.addExpression('\\\\times', isOperator: true);},
    ));

    button.add(MyButton(
      child: Text('÷'),
      onPressed: () {latexModel.addExpression('\\div', isOperator: true);},
    ));

    button.add(MyButton(
      child: Text('0'),
      onPressed: () {latexModel.addExpression('0');},
    ));

    button.add(MyButton(
      child: Text('.'),
      onPressed: () {latexModel.addExpression('.');},
    ));

    button.add(MyButton(
      child: Text('='),
      onPressed: () {
        latexModel.keep();
        latexModel.isClearable = true;
      },
    ));

    button.add(MyButton(
      child: Text('π'),
      onPressed: () {latexModel.addExpression('\\pi');},
    ));

    button.add(MyButton(
      child: Text('e'),
      onPressed: () {latexModel.addExpression('e');},
    ));

    return button;
  }

  List<Widget> _buildUpButton() {
    List<Widget> button = [];

    button.addAll(_buildButtonGroup(functionA, 3));
    button.addAll(_buildButtonGroup(functionB, 4));
    button.addAll(_buildButtonGroup(function, 1));
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