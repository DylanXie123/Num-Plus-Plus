import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

final mycontroller = new CalcController();

class CalcController extends TextEditingController {
  var _temp = 0;

  void addString(String text) {
    _temp = super.selection.baseOffset;
    _temp = _temp > 0 ? _temp : 0;

    super.text = super.text.substring(0, _temp) + text + super.text.substring(_temp);

    super.selection = TextSelection.collapsed(
      offset: _temp + text.length,
    );
  }

  void deleteString() {
    _temp = super.selection.baseOffset;
    
    if(_temp > 0) {
      super.text = super.text.substring(0, _temp-1) +  super.text.substring(_temp);

      super.selection = TextSelection.collapsed(
      offset: _temp - 1,
    );
    }
    
  }

}

class MyButton extends StatelessWidget{
  final String _text;
  final double _width = 20.0; //40.0 is better
  
  MyButton(this._text);

  @override
  Widget build (BuildContext context){
    return Container(
      height: _width * 2,
      width: _width * 2,
      alignment: Alignment.center,
      child: InkResponse(
        radius: _width * 1.2,
        splashFactory: InkRipple.splashFactory,
        highlightColor: Colors.transparent,
        onTap: () {
          mycontroller.addString(_text);
        },
        child: Container(
          height: _width * 2,
          width: _width * 2,
          alignment: Alignment.center,
          child: Text(
            _text,
            style: TextStyle(
              fontSize: _width / 1.3,
              color: Colors.black,
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  
  final TextEditingController _resultcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            readOnly: true,
            showCursor: true,
            autofocus: true,
            controller: mycontroller,
          ),
          TextField(
            readOnly: true,
            controller: _resultcontroller,
            autofocus: false,
          ),
          MyButton('3'),
          MyButton('7'),
          MyButton('sin('),
          MyButton(')'),
          MyButton('nrt'),
          MyButton('*'),
          MyButton('.'),
          MyButton(math.pi.toString()),
          RaisedButton(
            onPressed: () {
              mycontroller.deleteString();
            },
            child: Icon(Icons.backspace),
          ),
          RaisedButton(
            onPressed: () {
              mycontroller.clear();
              _resultcontroller.clear();
            },
            child: Text('Clear'),
          ),
          RaisedButton(
            onPressed: () {
              Parser p = new Parser();
              Expression exp = p.parse(mycontroller.text);
              ContextModel cm = new ContextModel();
              double eval = exp.evaluate(EvaluationType.REAL, cm);
              _resultcontroller.clear();
              _resultcontroller.text += eval.toString();
            },
            child: Text('='),
          )
        ],
      ),
    );
  }
}
