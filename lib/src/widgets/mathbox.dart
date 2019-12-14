import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

import 'package:num_plus_plus/src/backend/mathmodel.dart';
import 'package:num_plus_plus/src/pages/settingpage.dart';

class Server {
  // class from inAppBrowser

  HttpServer _server;

  int _port = 8080;

  Server({int port = 8080}) {
    this._port = port;
  }

  ///Closes the server.
  Future<void> close() async {
    if (this._server != null) {
      await this._server.close(force: true);
      print('Server running on http://localhost:$_port closed');
      this._server = null;
    }
  }

  Future<void> start() async {
    if (this._server != null) {
      throw Exception('Server already started on http://localhost:$_port');
    }

    var completer = new Completer();
    runZoned(() {
      HttpServer.bind('127.0.0.1', _port, shared: true).then((server) {
        print('Server running on http://localhost:' + _port.toString());

        this._server = server;

        server.listen((HttpRequest request) async {
          var body = List<int>();
          var path = request.requestedUri.path;
          path = (path.startsWith('/')) ? path.substring(1) : path;
          path += (path.endsWith('/')) ? 'index.html' : '';

          try {
            body = (await rootBundle.load(path)).buffer.asUint8List();
          } catch (e) {
            print(e.toString());
            request.response.close();
            return;
          }

          var contentType = ['text', 'html'];
          if (!request.requestedUri.path.endsWith('/') &&
              request.requestedUri.pathSegments.isNotEmpty) {
            var mimeType =
                lookupMimeType(request.requestedUri.path, headerBytes: body);
            if (mimeType != null) {
              contentType = mimeType.split('/');
            }
          }

          request.response.headers.contentType =
              new ContentType(contentType[0], contentType[1], charset: 'utf-8');
          request.response.add(body);
          request.response.close();
        });

        completer.complete();
      });
    }, onError: (e, stackTrace) => print('Error: $e $stackTrace'));

    return completer.future;
  }
}

class MathBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mathBoxController = Provider.of<MathBoxController>(context, listen: false);
    final mathModel = Provider.of<MathModel>(context, listen: false);
    final matrixModel = Provider.of<MatrixModel>(context, listen: false);
    final functionModel = Provider.of<FunctionModel>(context, listen: false);
    final mode = Provider.of<CalculationMode>(context, listen: false);
    return Stack(
      children: <Widget>[
        WebView(
          onWebViewCreated: (controller) {
            controller.loadUrl("http://localhost:8080/assets/html/homepage.html");
            mathBoxController.webViewController = controller;
          },
          onPageFinished: (s) {
            final setting = Provider.of<SettingModel>(context, listen: false);
            if (setting.initPage == 1) {
              mathBoxController.addExpression('\\\\bmatrix');
            }
          },
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: Set.from([
            JavascriptChannel(
              name: 'latexString',
              onMessageReceived: (JavascriptMessage message) {
                if (mode.value == Mode.Matrix) {
                  matrixModel.updateExpression(message.message);
                } else {
                  if (message.message.contains(RegExp('x|y'))) {
                    mode.changeMode(Mode.Function);
                    functionModel.updateExpression(message.message);
                  } else {
                    mode.changeMode(Mode.Basic);
                    mathModel.updateExpression(message.message);
                    mathModel.calcNumber();
                  }
                }
              }
            ),
            JavascriptChannel(
              name: 'clearable',
              onMessageReceived: (JavascriptMessage message) {
                mathModel.changeClearable(message.message == 'false'?false:true);
              }
            ),
          ]),
        ),
        ClearAnimation(),
      ],
    );
  }
}

class ClearAnimation extends StatefulWidget {
  @override
  _ClearAnimationState createState() => _ClearAnimationState();
}

class _ClearAnimationState extends State<ClearAnimation> with TickerProviderStateMixin {

  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 500),vsync: this);
    final curve = CurvedAnimation(parent: animationController, curve: Curves.easeInOutCubic);
    animation = Tween<double>(begin: 0, end: 2000).animate(curve);
    Provider.of<MathBoxController>(context, listen: false).clearAnimationController = animationController;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Positioned(
      top: 10-animation.value/2,
      right: -animation.value/2,
      child: ClipOval(
        child: Container(
          height: animation.value,
          width: animation.value,
          color: Colors.blue[100],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: animation,
    );
  }
}

class MathBoxController {

  WebViewController _webViewController;
  AnimationController clearAnimationController;

  set webViewController(WebViewController controller) {
    this._webViewController = controller;
  }

  void addExpression(String msg, {bool isOperator = false}) {
    assert(_webViewController != null);
    _webViewController.evaluateJavascript("addCmd('$msg', {isOperator: ${isOperator.toString()}})");
  }

  void addString(String msg) {
    assert(_webViewController != null);
    _webViewController.evaluateJavascript("addString('$msg')");
  }

  void equal() {
    assert(_webViewController != null);
    _webViewController.evaluateJavascript("equal()");
  }

  void addKey(String key) {
    assert(_webViewController != null);
    _webViewController.evaluateJavascript("simulateKey('$key')");
  }

  void deleteExpression() {
    assert(_webViewController != null);
    _webViewController.evaluateJavascript("delString()");
  }

  void deleteAllExpression() {
    assert(_webViewController != null);
    _webViewController.evaluateJavascript("delAll()");
  }
  
}
