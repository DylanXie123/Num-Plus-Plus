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

class WebMathController {
  WebViewController webViewController;

  void addExpression(String msg) {
    webViewController.evaluateJavascript("addCmd('$msg')");
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
  bool isClearable = false;
  final webMathController = WebMathController();
  Map keyboard = {
    '1' : Text('1'),
    '2' : Text('2'),
    '3' : Text('3'),
    '4' : Text('4'),
    '5' : Text('5'),
    '6' : Text('6'),
    '7' : Text('7'),
    '8' : Text('8'),
    '9' : Text('9'),
    '0' : Text('0'),
    '+' : Text('+'),
    '-' : Text('-'),
    '\\\\times' : Text('×'),
    '\\div' : Text('÷'),
    '/' : Text('frac'),
    '^' : Text('^'),
    '.' : Text('.'),
    '(' : Text('('),
    ')' : Text(')'),
    '%' : Text('%'),
    'e' : Text('e'),
    '\\pi' : Text('pi'),
    '\\sqrt' : Text('sqrt'),
    '\\\\nthroot' : Text('nroot'),
    '\\sin' : Text('sin'),
    '\\cos' : Text('cos'),
    '\\tan' : Text('tan'),
    '\\arcsin' : Text('asin'),
    '\\arccos' : Text('acos'),
    '\\arctan' : Text('atan'),
    '\\log' : Text('log'),
    '\\ln' : Text('ln'),
    '\\|' : Text('abs'),
    'x' : Text('x'),
    'Left' : Icon(Icons.arrow_back),
    'Right' : Icon(Icons.arrow_forward),
    'Up' : Icon(Icons.arrow_upward),
    'Down' : Icon(Icons.arrow_downward),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 50.0,
            child: WebView(
              onWebViewCreated: (controller) {
                webMathController.webViewController = controller;
                webMathController.webViewController.loadUrl("$baseUrl");
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
          Text(
            resultText,
            style: TextStyle(
              color: Colors.blue,
              fontFamily: 'RobotoMono',
              fontSize: 24,
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
                  if (isClearable) {
                    webMathController.delAllExpression();
                    setState(() {
                      mathExpression = '';
                      resultText = '';
                    });
                    isClearable = false;
                  }
                  var cmd = keyboard.keys.elementAt(index);
                  switch (cmd) {
                    case '\\sin':
                      continue trigonometric;
                    case '\\cos':
                      continue trigonometric;
                    case '\\tan':
                      continue trigonometric;
                    case '\\arcsin':
                      continue trigonometric;
                    case '\\arccos':
                      continue trigonometric;
                    trigonometric:
                    case '\\arctan':
                      webMathController.addExpression(cmd);
                      webMathController.addExpression('(');
                      break;
                    case '\\log':
                      webMathController.addExpression(cmd);
                      webMathController.addExpression('_');
                      break;
                    case 'Up':
                      continue movecursor;
                    case 'Down':
                      continue movecursor;
                    case 'Left':
                      continue movecursor;
                    movecursor:
                    case 'Right':
                      webMathController.addKey(cmd);
                      break;
                    case 'AC':
                      webMathController.delAllExpression();
                      setState(() {
                        mathExpression = '';
                        resultText = '';
                      });
                      break;
                    case 'BackSpace':
                      webMathController.delExpression();
                      break;
                    case '=':
                      setState(() {
                        LatexParser lp = LatexParser();
                        lp.parse(latexExpression);
                        print(lp.result);
                        if (lp.result.isSuccess) {
                          // isClearable = true;
                          mathExpression = lp.result.toString();
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
                        }
                      });
                      break;
                    default: 
                      webMathController.addExpression(cmd);
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

