import 'package:flutter/material.dart';

import 'mathmodel.dart';

class MyButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final double _width = 40.0; //40.0 is better
  final double fontSize;

  const MyButton({
    @required this.child,
    @required this.onPressed, 
    this.onLongPress,
    this.fontSize = 35,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        fontFamily: 'Minion-Pro',
        // fontFamilyFallback: ['RobotoMono'], // don't work ??
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

  // a stupid way to insert another font text
  // TODO: update in the future
  static const TextSpan upminus = TextSpan(
    text: '⁻',
    style: TextStyle(
      fontFamily: 'Roboto',
    ),
  );

  static const TextSpan upx = TextSpan(
    text: 'ˣ',
    style: TextStyle(
      fontFamily: 'Roboto',
    ),
  );

  static const TextSpan upy = TextSpan(
    text: '⁻',
    style: TextStyle(
      fontFamily: 'Roboto',
    ),
  );

  static const Map pfunction = {
    '\\sin' : Text('sin'),
    '\\cos' : Text('cos'),
    '\\\\tan' : Text('tan'),
    '\\arcsin' : Text.rich(
      TextSpan(
        text: 'sin',
        children: <TextSpan>[
          upminus,
          TextSpan(
            text: '¹'
          ),
        ],
      ),
    ),
    '\\arccos' : Text.rich(
      TextSpan(
        text: 'cos',
        children: <TextSpan>[
          upminus,
          TextSpan(
            text: '¹'
          ),
        ],
      ),
    ),
    '\\arctan' : Text.rich(
      TextSpan(
        text: 'tan',
        children: <TextSpan>[
          upminus,
          TextSpan(
            text: '¹'
          ),
        ],
      ),
    ),
    '\\ln' : Text('ln'),
  };

  static const Map function = {
    '\\sqrt' : Text('√￣'),
    '\\\\nthroot' : Text('▝√￣'),
    '\\|' : Text('|  |'),
    '\\int' : Text('∫'),
    '!' : Text('!'),
    'x' : Text('x'),
    '%' : Text('%'),
    '(' : Text('('),
    ')' : Text(')'),
  };

  List<Widget> _buildButtonGroup(Map key, {bool par = false, double fontsize = 35.0}) {
    List<Widget> button = [];
    for (var i = 0; i < key.length; i++) {
      button.add(
        MyButton(
          child: key.values.elementAt(i),
          fontSize: fontsize,
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
      onPressed: () {
        mathModel.isClearable = false;
        mathModel.delExpression();
      },
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
    const fontSize = 20.0;

    button.addAll(_buildButtonGroup(pfunction, par: true, fontsize: fontSize));
    button.addAll(_buildButtonGroup(function, fontsize: fontSize));

    button.add(MyButton(
      child: Text('log'),
      fontSize: fontSize,
      onPressed: () {
        mathModel.addExpression('log');
        mathModel.addExpression('_');
        mathModel.addKey('Right');
        mathModel.addExpression('(');
        mathModel.addKey('Left Left');
      },
    ));

    button.add(MyButton(
      child: Text('x▘'),
      fontSize: fontSize,
      onPressed: () {
        mathModel.addExpression(')');
        mathModel.addExpression('^');
        mathModel.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Text('x²'),
      fontSize: fontSize,
      onPressed: () {
        mathModel.addExpression('^');
        mathModel.addExpression('2');
        mathModel.addKey('Left Left');
      },
    ));

    button.add(MyButton(
      child: Icon(Icons.arrow_back),
      onPressed: () {
        mathModel.isClearable = false;
        mathModel.addKey('Left');
      },
    ));

    button.add(MyButton(
      child: Icon(Icons.arrow_forward),
      onPressed: () {
        mathModel.isClearable = false;
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
                physics: ScrollPhysics(),
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
              physics: ScrollPhysics(),
              crossAxisCount: 5,
              children: _buildLowButton(),
            ),
          ),
        ),
      ],
    );
  }

}