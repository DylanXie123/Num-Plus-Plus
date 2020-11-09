import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'package:num_plus_plus/src/widgets/mathbox.dart';
import 'package:num_plus_plus/src/pages/settingpage.dart';
import 'package:num_plus_plus/src/backend/mathmodel.dart';

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
        fontFamily: "TimesNewRoman",
      ),
      child: InkResponse(
        splashFactory: InkRipple.splashFactory,
        highlightColor: Colors.transparent,
        onTap: onPressed,
        onLongPress: onLongPress,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

const AspectRatio = 1.2;

class MathKeyBoard extends StatelessWidget {
  List<Widget> _buildLowButton(MathLiveController mathController) {
    List<Widget> button = [];

    for (var i = 7; i <= 9; i++) {
      button.add(MyButton(
        child: Text('$i'),
        onPressed: () {
          mathController.insert('$i');
        },
      ));
    }

    button.add(MyButton(
      child: Icon(
        // frac
        IconData(0xe907, fontFamily: 'Keyboard'),
        size: 60.0,
      ),
      onPressed: () {
        mathController.insert('/');
      },
    ));

    button.add(MyButton(
      child: Icon(MaterialCommunityIcons.getIconData("backspace-outline")),
      onPressed: mathController.backspace,
      onLongPress: mathController.deleteAll,
      // onLongPress: () async {
      //   mathController.deleteAllExpression();
      //   await mathController.clearAnimationController?.forward();
      //   mathController.clearAnimationController?.reset();
      // },
    ));

    for (var i = 4; i <= 6; i++) {
      button.add(MyButton(
        child: Text('$i'),
        onPressed: () {
          mathController.insert('$i');
        },
      ));
    }

    button.add(MyButton(
      child: Text('+'),
      onPressed: () {
        mathController.insert('+');
      },
    ));

    button.add(MyButton(
      child: Text('-'),
      onPressed: () {
        mathController.insert('-');
      },
    ));

    for (var i = 1; i <= 3; i++) {
      button.add(MyButton(
        child: Text('$i'),
        onPressed: () {
          mathController.insert('$i');
        },
      ));
    }

    button.add(MyButton(
      child: Text('×'),
      onPressed: () {
        mathController.insert('\\\\times');
      },
    ));

    button.add(MyButton(
      child: Text('÷'),
      onPressed: () {
        mathController.insert('\\div');
      },
    ));

    button.add(MyButton(
      child: Text('0'),
      onPressed: () {
        mathController.insert('0');
      },
    ));

    button.add(MyButton(
      child: Text('.'),
      onPressed: () {
        mathController.insert('.');
      },
    ));

    button.add(Consumer<CalculationMode>(
      builder: (context, mode, _) => MyButton(
        child: mode.value != Mode.Matrix
            ? Text('=')
            : Icon(
                MaterialCommunityIcons.getIconData("matrix"),
                size: 40.0,
              ),
        onPressed: () {
          // mode.value == Mode.Basic
          //     ? mathController.equal()
          //     : mathController.insert('\\\\bmatrix');
        },
      ),
    ));

    button.add(MyButton(
      child: Text('π'),
      onPressed: () {
        mathController.insert('\\pi');
      },
    ));

    button.add(MyButton(
      child: Text('e'),
      onPressed: () {
        mathController.insert('e');
      },
    ));

    return button;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final mathController =
        Provider.of<MathLiveController>(context, listen: false);
    return Container(
      height: width / 5 * 4 / AspectRatio,
      child: Material(
        color: Colors.grey[300],
        elevation: 15.0,
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          childAspectRatio: AspectRatio,
          children: _buildLowButton(mathController),
        ),
      ),
    );
  }
}

const AnimationConstant = 8.0;

class AtanCurve extends Curve {
  @override
  double transform(double t) =>
      atan(AnimationConstant * 2 * t - AnimationConstant) /
          (2 * atan(AnimationConstant)) +
      0.5;
}

class ExpandKeyBoard extends StatefulWidget {
  @override
  _ExpandKeyBoardState createState() => _ExpandKeyBoardState();
}

class _ExpandKeyBoardState extends State<ExpandKeyBoard>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation keyboardAnimation;
  Animation arrowAnimation;
  double _height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _height = (MediaQuery.of(context).size.width - 10) / 7 * 3 / AspectRatio;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    final curve =
        CurvedAnimation(parent: animationController, curve: AtanCurve());
    keyboardAnimation = Tween<double>(begin: _height, end: 0).animate(curve);
    arrowAnimation = Tween<double>(begin: 15.0, end: 35.0).animate(curve);
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Material(
        color: Colors.blueAccent[400],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: arrowAnimation.value,
              width: double.infinity,
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  final setting =
                      Provider.of<SettingModel>(context, listen: false);
                  if (animationController.status == AnimationStatus.dismissed) {
                    animationController.forward();
                    setting.changeKeyboardMode(true);
                  } else {
                    animationController.reverse();
                    setting.changeKeyboardMode(false);
                  }
                },
                child: Icon(
                  (keyboardAnimation.value > _height * 0.8)
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: Colors.grey[200],
                ),
              ),
            ),
            SizedBox(
              height: keyboardAnimation.value,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 7,
                children: _buildUpButton(),
                childAspectRatio: AspectRatio,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<SettingModel>(context, listen: false);
    return FutureBuilder(
        future: setting.loading.future,
        builder: (context, snapshot) {
          if (setting.loading.isCompleted && setting.hideKeyboard) {
            animationController.value = 1;
          }
          return GestureDetector(
            onVerticalDragUpdate: (detail) {
              if (keyboardAnimation.value - detail.delta.dy > 0 &&
                  keyboardAnimation.value - detail.delta.dy < _height) {
                double y = keyboardAnimation.value - detail.delta.dy;
                animationController.value = (tan(atan(AnimationConstant) -
                            y * atan(AnimationConstant) * 2 / _height) +
                        AnimationConstant) /
                    AnimationConstant /
                    2;
              }
            },
            onVerticalDragEnd: (detail) {
              if (detail.primaryVelocity > 0.0) {
                animationController.animateTo(1.0,
                    duration: const Duration(milliseconds: 200));
                setting.changeKeyboardMode(true);
              } else if (detail.primaryVelocity < 0.0) {
                animationController.animateBack(0.0,
                    duration: const Duration(milliseconds: 200));
                setting.changeKeyboardMode(false);
              } else if (keyboardAnimation.value > _height * 0.8) {
                animationController.reverse();
                setting.changeKeyboardMode(false);
              } else {
                animationController.forward();
                setting.changeKeyboardMode(true);
              }
            },
            child: AnimatedBuilder(
              builder: _buildAnimation,
              animation: animationController,
            ),
          );
        });
  }

  List<Widget> _buildUpButton() {
    final mathController =
        Provider.of<MathLiveController>(context, listen: false);
    List<Widget> button = [];
    const fontSize = 25.0;
    const iconSize = 45.0;
    var fontColor = Colors.grey[200];

    button.add(MyButton(
      child: Text('sin'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathController.insert('\\sin');
        mathController.insert('(');
      },
    ));

    button.add(MyButton(
      child: Text('cos'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathController.insert('\\cos');
        mathController.insert('(');
      },
    ));

    button.add(MyButton(
      child: Text('tan'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathController.insert('\\\\tan');
        mathController.insert('(');
      },
    ));

    button.add(MyButton(
      child: Icon(
        // sqrt
        IconData(0xe90a, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        mathController.insert('\\sqrt');
      },
    ));

    button.add(MyButton(
      child: Icon(
        // exp
        IconData(0xe905, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        mathController.insert('e');
        mathController.insert('^');
      },
    ));

    button.add(MyButton(
      child: Icon(
        // pow2
        IconData(0xe909, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        mathController.insert(')');
        mathController.insert('^');
        mathController.insert('2');
      },
    ));

    button.add(MyButton(
      child: Text('ln'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathController.insert('\\ln');
        mathController.insert('(');
      },
    ));

    button.add(MyButton(
      child: Icon(
        // arcsin
        IconData(0xe903, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        mathController.insert('\\arcsin');
        mathController.insert('(');
      },
    ));

    button.add(MyButton(
      child: Icon(
        // arccos
        IconData(0xe902, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        mathController.insert('\\arccos');
        mathController.insert('(');
      },
    ));

    button.add(MyButton(
      child: Icon(
        // arctan
        IconData(0xe904, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        mathController.insert('\\arctan');
        mathController.insert('(');
      },
    ));

    button.add(MyButton(
      child: Icon(
        // nrt
        IconData(0xe908, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        mathController.insert('\\\\nthroot');
      },
    ));

    button.add(MyButton(
      child: Icon(
        // abs
        IconData(0xe901, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        mathController.insert('\\|');
      },
    ));

    button.add(MyButton(
      child: Text('('),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathController.insert('(');
      },
    ));

    button.add(MyButton(
      child: Text(')'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathController.insert(')');
      },
    ));

    button.add(MyButton(
      child: Text('!'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathController.insert('!');
      },
    ));

    button.add(MyButton(
      child: Icon(
        // *10^n
        IconData(0xe900, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        mathController.insert('E');
      },
    ));

    button.add(MyButton(
      child: Text('log'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        // mathController.insert('log');
        // mathController.insert('_');
        // mathController.addKey('Right');
        // mathController.insert('(');
        // mathController.addKey('Left Left');
      },
    ));

    button.add(MyButton(
      child: Icon(
        // expo
        IconData(0xe906, fontFamily: 'Keyboard'),
        color: fontColor,
        size: iconSize,
      ),
      onPressed: () {
        mathController.insert(')');
        mathController.insert('^');
      },
    ));

    // button.add(MyButton(
    //   child: Icon(
    //     MaterialCommunityIcons.getIconData("function-variant"),
    //     color: fontColor,
    //   ),
    //   onPressed: () {
    //     mathBoxController.insert('x');
    //   },
    // ));

    button.add(MyButton(
      child: Icon(
        Icons.arrow_back,
        color: fontColor,
      ),
      onPressed: () {
        // mathController.addKey('Left');
      },
      onLongPress: () {
        try {
          final expression = Provider.of<MathModel>(context, listen: false)
              .checkHistory(toPrevious: true);
          // mathController.deleteAllExpression();
          // mathController.addString(expression);
        } catch (e) {
          final snackBar = SnackBar(
            content: Text('This is the first result'),
            duration: Duration(
              milliseconds: 700,
            ),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
    ));

    button.add(MyButton(
      child: Icon(
        Icons.arrow_forward,
        color: fontColor,
      ),
      onPressed: () {
        // mathController.addKey('Right');
      },
      onLongPress: () {
        try {
          final expression = Provider.of<MathModel>(context, listen: false)
              .checkHistory(toPrevious: false);
          // mathController.deleteAllExpression();
          // mathController.addString(expression);
        } catch (e) {
          final snackBar = SnackBar(
            content: Text('This is the last result'),
            duration: Duration(
              milliseconds: 700,
            ),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
    ));

    button.add(MyButton(
      child: Text('Ans'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        if (Provider.of<MathModel>(context, listen: false).hasHistory) {
          mathController.insert('Ans');
        } else {
          final snackBar = SnackBar(
            content: Text('Unable to input Ans now'),
            duration: Duration(
              milliseconds: 500,
            ),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
    ));

    return button;
  }
}
