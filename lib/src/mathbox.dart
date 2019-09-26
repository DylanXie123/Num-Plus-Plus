import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';

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

  final MathModel mathModel;
  final _server = Server();

  MathBox({@required this.mathModel,}) {
    _server.start();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        WebView(
          onWebViewCreated: (controller) {
            mathModel.webViewController = controller;
            mathModel.webViewController.loadUrl("http://localhost:8080/assets/html/homepage.html");
          },
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: Set.from([
            JavascriptChannel(
              name: 'latexString',
              onMessageReceived: (JavascriptMessage message) { mathModel.latexExp = message.message;}
            ),
          ]),
        ),
        ClearAnimation(animation: mathModel.animation,),
      ],
    );
  }
}

class ClearAnimation extends StatefulWidget {
  final Animation animation;

  const ClearAnimation({Key key, @required this.animation}) : super(key: key);

  @override
  _ClearAnimationState createState() => _ClearAnimationState();
}

class _ClearAnimationState extends State<ClearAnimation> with TickerProviderStateMixin {

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Positioned(
      bottom: -widget.animation.value/2,
      right: 50-widget.animation.value/2,
      child: ClipOval(
        child: Container(
          height: widget.animation.value,
          width: widget.animation.value,
          color: Colors.blue[100],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: widget.animation,
    );
  }
}
