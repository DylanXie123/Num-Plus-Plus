import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

import 'mathmodel.dart';

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
  final _server = Server();

  MathBox() {
    _server.start();
  }
  
  @override
  Widget build(BuildContext context) {
    final mathBoxController = Provider.of<MathBoxController>(context, listen: false);
    final mathModel = Provider.of<MathModel>(context, listen: false);
    final matrixModel = Provider.of<MatrixModel>(context, listen: false);
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        WebView(
          onWebViewCreated: (controller) {
            controller.loadUrl("http://localhost:8080/assets/html/homepage.html");
            mathBoxController.webViewController = controller;
          },
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: Set.from([
            JavascriptChannel(
              name: 'latexString',
              onMessageReceived: (JavascriptMessage message) {
                if (message.message.contains('matrix')) {
                  matrixModel.updateExpression(message.message);
                } else if (message.message.isNotEmpty) {
                  mathModel.updateExpression(message.message);
                  mathModel.calcNumber();
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
        // Consumer<MathBoxController>(
        //   builder: (context, mathBoxController, _) => Container(
        //     color: Colors.grey[50],
        //     height: (mathBoxController.webViewController == null)?double.infinity:0,
        //   ),
        // ), // cover initial white when creating webview
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    animationController = AnimationController(duration: const Duration(milliseconds: 400),vsync: this);
    final curve = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animation = Tween<double>(begin: 0, end: size.aspectRatio<1?size.height:size.width).animate(curve);
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
