import 'package:flutter/material.dart';

import 'mathmodel.dart';

class MyButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final double fontSize;
  final Color fontColor;

  const MyButton({
    @required this.child,
    @required this.onPressed, 
    this.onLongPress,
    this.fontSize = 35,
    this.fontColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontFamily: 'Minion-Pro',
        // fontFamilyFallback: ['RobotoMono'], // don't work ??
      ),
      child: InkResponse(
        splashFactory: InkRipple.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.green[50],
        onTap: onPressed,
        onLongPress: onLongPress,
        child: Center(child: child,),
      ),
    );
  }
}

class MathKeyBoard extends StatelessWidget {

  final MathModel mathModel;

  const MathKeyBoard({Key key, @required this.mathModel}) : super(key: key);

  // TODO: a stupid way to insert another font text
  // update in the future
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
    '\\|' : Text('|  |'),
    '!' : Text('!'),
    // 'x' : Text('x'),
    '%' : Text('%'),
    '(' : Text('('),
    ')' : Text(')'),
    '\\\\nthroot' : Text('▝√￣'),
  };

  List<Widget> _buildLowButton() {
    List<Widget> button = [];

    for (var i = 7; i <= 9; i++) {
      button.add(MyButton(
        child: Text('$i'),
        onPressed: () {mathModel.addExpression('$i');},
      ));
    }

    button.add(MyButton(
      child: Text('x/y'),
      onPressed: () {mathModel.addExpression('/', isOperator: true);},
    ));

    button.add(MyButton(
      child: Icon(Icons.backspace),
      onPressed: () {
        mathModel.isClearable = false;
        mathModel.webViewController.evaluateJavascript("delString()");
      },
      onLongPress: () async {
        mathModel.webViewController.evaluateJavascript("delAll()");
        await mathModel.animationController?.forward();
        mathModel.animationController?.reset();
      },
    ));

    for (var i = 4; i <= 6; i++) {
      button.add(MyButton(
        child: Text('$i'),
        onPressed: () {mathModel.addExpression('$i');},
      ));
    }

    button.add(MyButton(
      child: Text('+'),
      onPressed: () {mathModel.addExpression('+', isOperator: true);},
    ));

    button.add(MyButton(
      child: Text('-'),
      onPressed: () {mathModel.addExpression('-', isOperator: true);},
    ));

    for (var i = 1; i <= 3; i++) {
      button.add(MyButton(
        child: Text('$i'),
        onPressed: () {mathModel.addExpression('$i');},
      ));
    }

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

  List<Widget> _buildButtonGroup(Map key, {bool par = false, double fontSize, Color fontColor}) {
    List<Widget> button = [];
    for (var i = 0; i < key.length; i++) {
      button.add(
        MyButton(
          child: key.values.elementAt(i),
          fontSize: fontSize,
          fontColor: fontColor,
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

  List<Widget> _buildUpButton() {
    List<Widget> button = [];
    const fontSize = 20.0;
    var fontColor = Colors.grey[200];

    button.addAll(_buildButtonGroup(pfunction, par: true, fontSize: fontSize, fontColor: fontColor));
    button.addAll(_buildButtonGroup(function, fontSize: fontSize, fontColor: fontColor));

    button.add(MyButton(
      child: Text('log'),
      fontSize: fontSize,
      fontColor: fontColor,
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
      fontColor: fontColor,
      onPressed: () {
        mathModel.addExpression(')');
        mathModel.addExpression('^');
        // mathModel.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Text('x²'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathModel.addExpression('^');
        mathModel.addExpression('2');
        mathModel.addKey('Right');
      },
    ));

    button.add(MyButton(
      child: Text('e▘'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathModel.addExpression('e');
        mathModel.addExpression('^');
      },
    ));

    button.add(MyButton(
      child: Icon(Icons.arrow_back, color: fontColor,),
      onPressed: () {
        mathModel.isClearable = false;
        mathModel.addKey('Left');
      },
    ));

    button.add(MyButton(
      child: Icon(Icons.arrow_forward, color: fontColor,),
      onPressed: () {
        mathModel.isClearable = false;
        mathModel.addKey('Right');
      },
    ));

    button.add(MyButton(
      child: Text('Ans'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        if (mathModel.history.last != '') {
          mathModel.addExpression('Ans');
        } else {
          print('No History Yet');
        }
      },
    ));

    return button;
  }

  @override
  Widget build(BuildContext context) {
    var width;
    if (MediaQuery.of(context).size.aspectRatio > 1) {
      width = MediaQuery.of(context).size.height;
    } else {
      width = MediaQuery.of(context).size.width;
    }
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: (width-10) / 7 * 3,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Material(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0)),
                elevation: 8.0,
                color: Colors.blueAccent[400],
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 7,
                  children: _buildUpButton(),
                ),
              ),
            ),
          ),
          Container(
            height: width / 5 * 4,
            child: Material(
              color: Colors.grey[300],
              elevation: 15.0,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 5,
                children: _buildLowButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
