import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/mathbox.dart';
import 'src/result.dart';
import 'src/mybutton.dart';
import 'src/mathmodel.dart';

void main() {
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

class HomePage extends StatelessWidget {
  final mathModel = MathModel();

  @override
  Widget build(BuildContext context) {
    print('Rebuit');
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.blue,),
            onPressed: () {},
          ),
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: mathModel,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: MathBox(
                  mathModel: mathModel,
                ),
              ),
              Result(),
              Expanded(
                flex: 4,
                child: MathKeyBoard(
                  mathModel: mathModel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

