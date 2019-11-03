import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'mathbox.dart';
import 'mathmodel.dart';
import 'settingpage.dart';

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

  List<Widget> _buildLowButton(MathBoxController mathBoxController) {
    List<Widget> button = [];

    for (var i = 7; i <= 9; i++) {
      button.add(MyButton(
        child: Text('$i'),
        onPressed: () {mathBoxController.addExpression('$i');},
      ));
    }

    button.add(MyButton(
      child: Icon(// frac
        IconData(0xe909, fontFamily: 'Keyboard'),
        size: 60.0,
      ),
      onPressed: () {mathBoxController.addExpression('/', isOperator: true);},
    ));

    button.add(MyButton(
      child: Icon(MaterialCommunityIcons.getIconData("backspace-outline")),
      onPressed: mathBoxController.deleteExpression,
      onLongPress: () async {
        mathBoxController.deleteAllExpression();
        await mathBoxController.clearAnimationController?.forward();
        mathBoxController.clearAnimationController?.reset();
      },
    ));

    button.add(MyButton(
      child: Text('sin'),
      onPressed: () {
        mathBoxController.addExpression('\\sin');
        mathBoxController.addExpression('(');
      },
      onLongPress: () {
        mathBoxController.addExpression('\\arcsin');
        mathBoxController.addExpression('(');
      },
    ));

    for (var i = 4; i <= 6; i++) {
      button.add(MyButton(
        child: Text('$i'),
        onPressed: () {mathBoxController.addExpression('$i');},
      ));
    }

    button.add(MyButton(
      child: Text('+'),
      onPressed: () {mathBoxController.addExpression('+', isOperator: true);},
    ));

    button.add(MyButton(
      child: Text('-'),
      onPressed: () {mathBoxController.addExpression('-', isOperator: true);},
    ));

    button.add(MyButton(
      child: Text('cos'),
      onPressed: () {
        mathBoxController.addExpression('\\cos');
        mathBoxController.addExpression('(');
      },
      onLongPress: () {
        mathBoxController.addExpression('\\arccos');
        mathBoxController.addExpression('(');
      },
    ));

    for (var i = 1; i <= 3; i++) {
      button.add(MyButton(
        child: Text('$i'),
        onPressed: () {mathBoxController.addExpression('$i');},
      ));
    }

    button.add(MyButton(
      child: Text('×'),
      onPressed: () {mathBoxController.addExpression('\\\\times', isOperator: true);},
    ));

    button.add(MyButton(
      child: Text('÷'),
      onPressed: () {mathBoxController.addExpression('\\div', isOperator: true);},
    ));

    button.add(MyButton(
      child: Icon(// expo
        IconData(0xe905, fontFamily: 'Keyboard'),
        size: 60.0,
      ),
      onPressed: () {
        mathBoxController.addExpression(')');
        mathBoxController.addExpression('^');
      },
    ));

    button.add(MyButton(
      child: Text('0'),
      onPressed: () {mathBoxController.addExpression('0');},
    ));

    button.add(MyButton(
      child: Text('.'),
      onPressed: () {mathBoxController.addExpression('.');},
    ));

    button.add(MyButton(
      child: Text('='),
      onPressed: mathBoxController.equal,
    ));

    button.add(MyButton(
      child: Text('π'),
      onPressed: () {mathBoxController.addExpression('\\pi');},
    ));

    button.add(MyButton(
      child: Text('e'),
      onPressed: () {mathBoxController.addExpression('e');},
    ));

    button.add(MyButton(
      child: Icon(// sqrt
        IconData(0xe908, fontFamily: 'Keyboard'),
        size: 60.0,
      ),
      onPressed: () {
        mathBoxController.addExpression('\\sqrt');
      },
    ));

    return button;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final mathBoxController = Provider.of<MathBoxController>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ExpandKeyBoard(),
        Container(
          height: width / 6 * 4,
          child: Material(
            color: Colors.grey[300],
            elevation: 15.0,
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 6,
              children: _buildLowButton(mathBoxController),
            ),
          ),
        ),
      ],
    );
  }

}

class ExpandKeyBoard extends StatefulWidget {
  @override
  _ExpandKeyBoardState createState() => _ExpandKeyBoardState();
}

class _ExpandKeyBoardState extends State<ExpandKeyBoard> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation keyboardAnimation;
  Animation arrowAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.of(context).size.width;
    animationController = AnimationController(duration: const Duration(milliseconds: 300),vsync: this);
    final curve = CurvedAnimation(parent: animationController, curve: Curves.easeInBack);
    keyboardAnimation = Tween<double>(begin: (width-10) / 7 * 2, end: 0).animate(curve);
    arrowAnimation = Tween<double>(begin: 15.0, end: 35.0).animate(curve);
    animationController.addListener((){
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<SettingModel>(context, listen: false);
    final mathBoxController = Provider.of<MathBoxController>(context, listen:false);
    if (setting.hideKeyboard == true) {
      animationController.value = 1;
    }
    return GestureDetector(
      onVerticalDragUpdate: (detail) {
        if (detail.delta.dy>0) {// move down
          animationController.forward();
          setting.changeKeyboardMode(true);
        } else {
          animationController.reverse();
          setting.changeKeyboardMode(false);
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
                      setting.changeKeyboardMode(true);
                    } else {
                      animationController.reverse();
                      setting.changeKeyboardMode(false);
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
                  crossAxisCount: 7,
                  children: _buildUpButton(mathBoxController),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildUpButton(MathBoxController mathBoxController) {
    List<Widget> button = [];
    const fontSize = 25.0;
    const iconSize = 45.0;
    var fontColor = Colors.grey[200];

    button.add(MyButton(
      child: Text('ln'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathBoxController.addExpression('\\ln');
        mathBoxController.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Icon(// nrt
        IconData(0xe906, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        mathBoxController.addExpression('\\\\nthroot');
      },
    ));

    button.add(MyButton(
      child: Icon(// abs
        IconData(0xe900, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        mathBoxController.addExpression('\\|');
      },
    ));

    button.add(MyButton(
      child: Text('('),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathBoxController.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Text(')'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathBoxController.addExpression(')');
      },
    ));

    button.add(MyButton(
      child: Text('!'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathBoxController.addExpression('!');
      },
    ));

    button.add(MyButton(
      child: Icon(// *10^n
        IconData(0xe90a, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathBoxController.addExpression('E');
      },
    ));

    button.add(MyButton(
      child: Text('log'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathBoxController.addExpression('log');
        mathBoxController.addExpression('_');
        mathBoxController.addKey('Right');
        mathBoxController.addExpression('(');
        mathBoxController.addKey('Left Left');
      },
    ));

    button.add(MyButton(
      child: Text('tan'),
      fontColor: fontColor,
      fontSize: fontSize,
      onPressed: () {
        mathBoxController.addExpression('\\\\tan');
        mathBoxController.addExpression('(');
      },
      onLongPress: () {
        mathBoxController.addExpression('\\arctan');
        mathBoxController.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Text('M'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathBoxController.addExpression('\\\\bmatrix');
      },
    ));

    button.add(MyButton(
      child: Text('C+'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathBoxController.addKey('Shift-Spacebar');
      },
    ));

    button.add(MyButton(
      child: Text('R+'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathBoxController.addKey('Shift-Enter');
      },
    ));   

    button.add(MyButton(
      child: Icon(Icons.arrow_back, color: fontColor,),
      onPressed: () {
        mathBoxController.addKey('Left');
      },
      onLongPress: () {
        try {
          final expression = Provider.of<MathModel>(context, listen: false).checkHistory(toPrevious: true);
          mathBoxController.deleteAllExpression();
          mathBoxController.addString(expression);
        } catch (e) {
          final snackBar = SnackBar(
            content: Text('This is the first result'),
            duration: Duration(milliseconds: 700,),
            action: SnackBarAction(
              label: 'OK',
              onPressed: (){},
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
    ));

    button.add(MyButton(
      child: Icon(Icons.arrow_forward, color: fontColor,),
      onPressed: () {
        mathBoxController.addKey('Right');
      },
      onLongPress: () {
        try {
          final expression = Provider.of<MathModel>(context, listen: false).checkHistory(toPrevious: false);
          mathBoxController.deleteAllExpression();
          mathBoxController.addString(expression);
        } catch (e) {
          final snackBar = SnackBar(
            content: Text('This is the last result'),
            duration: Duration(milliseconds: 700,),
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
