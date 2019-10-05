import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        // fontFamilyFallback: ['RobotoMono'], // don't work ??
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
      child: Icon(Icons.backspace),
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
    var width;
    if (MediaQuery.of(context).size.aspectRatio > 1) {
      width = MediaQuery.of(context).size.height;
    } else {
      width = MediaQuery.of(context).size.width;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ExpandKeyBoard(mathModel: mathModel, width: width,),
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
  final double width;

  const ExpandKeyBoard({Key key, @required this.mathModel, @required this.width, }) : super(key: key);

  @override
  _ExpandKeyBoardState createState() => _ExpandKeyBoardState();
}

class _ExpandKeyBoardState extends State<ExpandKeyBoard> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  Animation buttonAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 300),vsync: this);
    final curve = CurvedAnimation(parent: animationController, curve: Curves.easeInCubic);
    animation = Tween<double>(begin: (widget.width-10) / 7 * 3, end: 0).animate(curve);
    buttonAnimation = Tween<double>(begin: 15.0, end: 30.0).animate(curve);
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
    final setting = Provider.of<SettingModel>(context, listen: false);
    print('Mode: '+setting.isProMode.toString());
    if (setting.isProMode == false) {
      animationController.forward();
    }
    return GestureDetector(
      onVerticalDragUpdate: (detail) {
        if (detail.delta.dy>0) {// move down
          animationController.forward();
          setting.changeMode(false);
        } else {
          animationController.reverse();
          setting.changeMode(true);
        }
      },
      child: Container(
        height: buttonAnimation.value + animation.value,
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
                height: buttonAnimation.value,
                width: double.infinity,
                color: Colors.blueAccent[400],
                child: FlatButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    if (animationController.status == AnimationStatus.dismissed) {
                      animationController.forward();
                      setting.changeMode(false);
                    } else {
                      animationController.reverse();
                      setting.changeMode(true);
                    }
                  },
                  child: Icon(
                    (animation.value > 20.0)?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 7,
                  children: _buildUpButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            widget.mathModel.addExpression(cmd);
            if (par) {widget.mathModel.addExpression('(');}
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
        widget.mathModel.addExpression('log');
        widget.mathModel.addExpression('_');
        widget.mathModel.addKey('Right');
        widget.mathModel.addExpression('(');
        widget.mathModel.addKey('Left Left');
      },
    ));

    button.add(MyButton(
      child: Text('x▘'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        widget.mathModel.addExpression(')');
        widget.mathModel.addExpression('^');
        // widget.mathModel.addExpression('(');
      },
    ));

    button.add(MyButton(
      child: Text('x²'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        widget.mathModel.addExpression('^');
        widget.mathModel.addExpression('2');
        widget.mathModel.addKey('Right');
      },
    ));

    button.add(MyButton(
      child: Text('e▘'),
      fontSize: fontSize,
      fontColor: fontColor,
      onPressed: () {
        widget.mathModel.addExpression('e');
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
          print('No History Yet');
        }
      },
    ));

    return button;
  }

}
