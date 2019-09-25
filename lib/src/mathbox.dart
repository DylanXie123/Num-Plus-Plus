import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';

import 'latexmodel.dart';

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

  final LatexModel latexModel;
  final _server = Server();
  final double height;

  MathBox({@required this.latexModel, this.height = 100.0,}) {
    _server.start();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: WebView(
        onWebViewCreated: (controller) {
          latexModel.webViewController = controller;
          latexModel.webViewController.loadUrl("http://localhost:8080/assets/html/homepage.html");
        },
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: Set.from([
          JavascriptChannel(
            name: 'latexString',
            onMessageReceived: (JavascriptMessage message) { latexModel.latexExp = message.message;}
          ),
        ]),
      ),
    );
  }
}
