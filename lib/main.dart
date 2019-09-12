import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:math_expressions/math_expressions.dart';

import 'server.dart';
import 'mybutton.dart';
import 'latex_parser.dart';
import 'function.dart';

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

WebViewController webViewController;

void addExpression(String msg) {
  webViewController.evaluateJavascript("addCmd('$msg')");
  print("addCmd('$msg')");
}

void delExpression() {
  webViewController.evaluateJavascript("delString()");
}

void delAllExpression() {
  webViewController.evaluateJavascript("delAll()");
}

void addKey(String key) {
  webViewController.evaluateJavascript("simulateKey('$key')");
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Server _server;
  String baseUrl;

  String latexExpression = '';
  String mathExpression = '';
  String resultText = '';
  Map keyboard = {
    '1' : Text('1'),
    '3' : Text('3'),
    '7' : Text('7'),
    '0' : Text('0'),
    '+' : Text('+'),
    '-' : Text('-'),
    '/' : Text('÷'),
    '^' : Text('^'),
    '.' : Text('.'),
    '(' : Text('('),
    ')' : Text(')'),
    'e' : Text('e'),
    '\\pi' : Text('pi'),
    '\\\\times' : Text('×'),
    '\\sqrt' : Text('sqrt'),
    '\\sin' : Text('sin'),
    '\\arcsin' : Text('asin'),
    '\\log' : Text('log'),
    '\\|' : Text('abs'),
    'x' : Text('x'),
    'Left' : Icon(Icons.arrow_back),
    'Right' : Icon(Icons.arrow_forward),
    'AC' : Icon(Icons.delete),
    'BackSpace' : Icon(Icons.backspace),
    '=' : Text('='),
  };

  @override
  void initState() {
    _server = Server();
    baseUrl = "http://localhost:8080/assets/html/homepage.html";
    super.initState();
    _server.start();
  }

  @override
  Widget build(BuildContext context) {
    // print('Rebuit');
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 50.0,
            child: WebView(
              onWebViewCreated: (controller) {
                webViewController = controller;
                webViewController.loadUrl("$baseUrl");
              },
              onPageFinished: (url) {},
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: Set.from([
                JavascriptChannel(
                  name: 'latexString',
                  onMessageReceived: (JavascriptMessage message) {
                    setState(() {
                      latexExpression = message.message;  
                    });
                  }
                ),
              ]),
            ),
          ),
          Text('Latex: ' + latexExpression),
          Text('Math: ' + mathExpression),
          Text('Output: ' + resultText),
          Expanded(
            child: GridView.builder(
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
                    trigonometric:
                    case '\\arcsin':
                      addExpression(cmd);
                      addExpression('(');
                      break;
                    case '\\log':
                      addExpression(cmd);
                      addExpression('_');
                      break;
                    case 'Right':
                      continue movecursor;
                    movecursor:
                    case 'Left':
                      addKey(cmd);
                      break;
                    case 'AC':
                      delAllExpression();
                      setState(() {
                        mathExpression = '';
                        resultText = '';
                      });
                      break;
                    case 'BackSpace':
                      delExpression();
                      break;
                    case '=':
                      setState(() {
                        LatexParser lp = LatexParser();
                        lp.parse(latexExpression);
                        mathExpression = lp.result.toString();
                        if (lp.result.isSuccess) {
                          print(lp.result.value is String);
                        }
                        if (mathExpression.contains('x')) {
                          MyFunction f = MyFunction(lp.result.value);
                          resultText = f.calc(1).toString();
                        } else {
                          Parser p = new Parser();
                          Expression exp = p.parse(lp.result.value);
                          ContextModel cm = new ContextModel();
                          double eval = exp.evaluate(EvaluationType.REAL, cm);
                          resultText = intCheck(eval).toString();
                          print(eval);
                        }
                      });
                      break;
                    default: 
                      addExpression(cmd);
                      break;
                  }
                },
                child: keyboard.values.elementAt(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _server.close();
    super.dispose();
  }

}

