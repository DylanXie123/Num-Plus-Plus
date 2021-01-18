import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

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

class ClearAnimation extends StatefulWidget {
  @override
  _ClearAnimationState createState() => _ClearAnimationState();
}

class _ClearAnimationState extends State<ClearAnimation>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final curve = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutCubic);
    animation = Tween<double>(begin: 0, end: 2000).animate(curve);
    // Provider.of<MathBoxController>(context, listen: false)
    //     .clearAnimationController = animationController;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Positioned(
      top: 10 - animation.value / 2,
      right: -animation.value / 2,
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

class MathLiveController {
  WebViewController _controller;

  set controller(WebViewController newController) {
    this._controller = newController;
  }

  Future<String> add(String latex) =>
      _controller.evaluateJavascript("add('$latex')");

  Future<String> backspace() => _controller.evaluateJavascript("backspace()");

  Future<String> clear() => _controller.evaluateJavascript("clear()");

  Future<String> doIntegrate() =>
      _controller.evaluateJavascript("doIntegrate()");

  Future<String> doDiff() => _controller.evaluateJavascript("doDiff()");

  Future<String> doPlot() => _controller.evaluateJavascript("doPlot()");

  Future<String> invertMatrix() =>
      _controller.evaluateJavascript("invertMatrix()");
}

enum MathMode {
  Eval,
  Var,
  Defint,
  Limit,
  Matrix,
}

class MathLiveBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mathLiveController =
        Provider.of<MathLiveController>(context, listen: false);
    final mathModel =
        Provider.of<ValueNotifier<MathMode>>(context, listen: false);
    return WebView(
      onWebViewCreated: (controller) {
        controller.loadUrl("http://localhost:8080/assets/html/index.html");
        mathLiveController.controller = controller;
      },
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: Set.from([
        JavascriptChannel(
          name: 'variable',
          onMessageReceived: (msg) {
            final modeCode = int.tryParse(msg.message);
            mathModel.value = MathMode.values[modeCode];
          },
        )
      ]),
    );
  }
}
