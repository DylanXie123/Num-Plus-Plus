import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'mathbox.dart';
import 'mybutton.dart';

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

class HomePage extends StatelessWidget {

  final mathController = MathController();
  final latexModel = LatexModel();

  @override
  Widget build(BuildContext context) {
    print('Rebuit');
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: ChangeNotifierProvider.value(
        value: latexModel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            MathBox(
              mathController: mathController,
              latexModel: latexModel,
            ),
            Consumer<LatexModel>(
              builder: (context, result, _) => Text(
                result.result,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 48,
                ),
              ),
            ),
            Expanded(
              child: MathKeyBoard(mathController: mathController,),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('='),
        onPressed: () {
          latexModel.calc();
        },
      ),
    );
  }

}

