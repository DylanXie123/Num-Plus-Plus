import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:math_expressions/math_expressions.dart';

import 'server.dart';
import 'mybutton.dart';
import 'latex_parser.dart';

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
            height: 150.0,
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
            child: GridView.count(
              crossAxisCount: 4,
              children: <Widget>[
                MyButton(
                  onPressed: () {
                    addExpression('/');
                  },
                  text: 'frac',
                ),
                MyButton(
                  onPressed: () {
                    delExpression();
                  },
                  text: 'Del',
                ),
                MyButton(
                  onPressed: () {
                    addExpression('2');
                  },
                  text: '2',
                ),
                MyButton(
                  onPressed: () {
                    addExpression('4');
                  },
                  text: '4',
                ),
                MyButton(
                  onPressed: () {
                    addExpression('.');
                  },
                  text: '.',
                ),
                MyButton(
                  onPressed: () {
                    addExpression('^');
                  },
                  text: '^',
                ),
                MyButton(
                  onPressed: () {
                    addExpression('e');
                  },
                  text: 'e',
                ),
                MyButton(
                  onPressed: () {
                    addExpression('\\\\times');
                  },
                  text: '*',
                ),
                MyButton(
                  onPressed: () {
                    addExpression('+');
                  },
                  text: '+',
                ),
                MyButton(
                  onPressed: () {
                    addExpression('\\sqrt');
                  },
                  text: 'sqrt',
                ),
                MyButton(
                  onPressed: () {
                    addExpression('\\sin');
                    addExpression('\\(');
                  },
                  text: 'sin',
                ),
                MyButton(
                  onPressed: () {
                    addExpression('\\(');
                  },
                  text: '(',
                ),
                MyButton(
                  onPressed: () {
                    addExpression('\\)');
                  },
                  text: ')',
                ),
                MyButton(
                  onPressed: () {
                    addExpression('\\int');
                  },
                  text: 'int',
                ),
                MyButton(
                  onPressed: () {
                    delAllExpression();
                    setState(() {
                      mathExpression = '';
                      resultText = '';
                    });
                  },
                  text: 'AC',
                ),
                MyButton(
                  onPressed: () {
                    setState(() {
                      LatexParser lp = LatexParser();
                      lp.parse(latexExpression);
                      mathExpression = lp.result.toString();
                      if (lp.result.isSuccess) {
                        print(lp.result.value);
                      }
                      // Parser p = new Parser();
                      // Expression exp = p.parse(lp.result.value);
                      // ContextModel cm = new ContextModel();
                      // double eval = exp.evaluate(EvaluationType.REAL, cm);
                      // resultText = eval.toString();
                      // print(eval);
                    });
                  },
                  text: '=',
                ),
              ],
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

