import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

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
      ),
      child: InkResponse(
        splashFactory: InkRipple.splashFactory,
        highlightColor: Colors.transparent,
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
      child: Icon(MaterialCommunityIcons.getIconData("backspace-outline")),
      onPressed: () {
        mathModel.isClearable = false;
        mathModel.webViewController.evaluateJavascript("delString()");
      },
      onLongPress: () async {
        if (mathModel.latexExp != '') {
          mathModel.webViewController.evaluateJavascript("delAll()");
          await mathModel.animationController?.forward();
          mathModel.animationController?.reset();
        } 
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ExpandKeyBoard(mathModel: mathModel,),
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
    );
  }

}

class ExpandKeyBoard extends StatefulWidget {
  final MathModel mathModel;

  const ExpandKeyBoard({Key key, @required this.mathModel,}) : super(key: key);

  @override
  _ExpandKeyBoardState createState() => _ExpandKeyBoardState();
}

class _ExpandKeyBoardState extends State<ExpandKeyBoard> with TickerProviderStateMixin {
  AnimationController animationController;
  CurvedAnimation curve;
  Animation keyboardAnimation;
  Animation arrowAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 300),vsync: this);
    curve = CurvedAnimation(parent: animationController, curve: Curves.easeInBack);
    arrowAnimation = Tween<double>(begin: 15.0, end: 35.0).animate(curve);
    animationController.addListener((){
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const crossAxisCount = 7;
    keyboardAnimation = Tween<double>(begin: (width-10) / crossAxisCount * 3, end: 0).animate(curve);
    return GestureDetector(
      onVerticalDragUpdate: (detail) {
        if (detail.delta.dy>0) {// move down
          animationController.forward();
        } else {
          animationController.reverse();
        }
      },
      child: Container(
        height: arrowAnimation.value + keyboardAnimation.value,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child: Material(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0)),
          elevation: 8.0,
          color: Colors.blueAccent[400],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: arrowAnimation.value,
                width: double.infinity,
                color: Colors.blueAccent[400],
                child: FlatButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    if (animationController.status == AnimationStatus.dismissed) {
                      animationController.forward();
                    } else {
                      animationController.reverse();
                    }
                  },
                  child: Icon(
                    (keyboardAnimation.value > 20.0)?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  children: _buildUpButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildUpButton() {
    List<Widget> button = [];
    const fontSize = 25.0;
    const iconSize = 45.0;
    var fontColor = Colors.grey[200];

    button.add(MyButton(
      child: Text('sin'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        widget.mathModel.addExpression('\\sin');
        widget.mathModel.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Text('cos'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        widget.mathModel.addExpression('\\cos');
        widget.mathModel.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Text('tan'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        widget.mathModel.addExpression('\\tan');
        widget.mathModel.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Icon(// sqrt
        IconData(0xe908, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        widget.mathModel.addExpression('\\sqrt');
      },
    ));

    button.add(MyButton(
      child: Icon(// exp
        IconData(0xe904, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        widget.mathModel.addExpression('e');
        widget.mathModel.addExpression('^');
      },
    ));

    button.add(MyButton(
      child: Icon(// pow2
        IconData(0xe907, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        widget.mathModel.addExpression(')');
        widget.mathModel.addExpression('^');
        widget.mathModel.addExpression('2');
      },
    ));

    button.add(MyButton(
      child: Text('ln'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        widget.mathModel.addExpression('\\ln');
        widget.mathModel.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Icon(// arcsin
        IconData(0xe902, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        widget.mathModel.addExpression('\\arcsin');
        widget.mathModel.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Icon(// arccos
        IconData(0xe901, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        widget.mathModel.addExpression('\\arccos');
        widget.mathModel.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Icon(// arctan
        IconData(0xe903, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        widget.mathModel.addExpression('\\arctan');
        widget.mathModel.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Icon(// nrt
        IconData(0xe906, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        widget.mathModel.addExpression('\\\\nthroot');
      },
    ));

    button.add(MyButton(
      child: Icon(// abs
        IconData(0xe900, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        widget.mathModel.addExpression('\\|');
      },
    ));

    button.add(MyButton(
      child: Text('('),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        widget.mathModel.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Text(')'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        widget.mathModel.addExpression(')');
      },
    ));

    button.add(MyButton(
      child: Text('!'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        widget.mathModel.addExpression('!');
      },
    ));

    button.add(MyButton(
      child: Text('%'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        widget.mathModel.addExpression('%');
      },
    ));

    button.add(MyButton(
      child: Text('log'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        widget.mathModel.addExpression('log');
        widget.mathModel.addExpression('_');
        widget.mathModel.addKey('Right');
        widget.mathModel.addExpression('(');
        widget.mathModel.addKey('Left Left');
      },
    ));

    button.add(MyButton(
      child: Icon(// expo
        IconData(0xe905, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        widget.mathModel.addExpression(')');
        widget.mathModel.addExpression('^');
      },
    ));

    button.add(MyButton(
      child: Icon(Icons.arrow_back, color: fontColor,),
      onPressed: () {
        widget.mathModel.isClearable = false;
        widget.mathModel.addKey('Left');
      },
    ));

    button.add(MyButton(
      child: Icon(Icons.arrow_forward, color: fontColor,),
      onPressed: () {
        widget.mathModel.isClearable = false;
        widget.mathModel.addKey('Right');
      },
    ));

    button.add(MyButton(
      child: Text('Ans'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        if (widget.mathModel.history.last != '') {
          widget.mathModel.addExpression('Ans');
        } else {
          final snackBar = SnackBar(
            content: Text('No History Yet'),
            duration: Duration(milliseconds: 500,),
            action: SnackBarAction(
              label: 'OK',
              onPressed: (){},
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
    ));

    return button;
  }

}
