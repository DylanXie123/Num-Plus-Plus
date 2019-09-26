import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'src/mathbox.dart';
import 'src/mybutton.dart';
import 'src/latexmodel.dart';

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
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: MathBox(
                  latexModel: latexModel,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Consumer<LatexModel>(
                    builder: (context, result, _) => Text(result.history.last),
                  ),
                  // VerticalDivider(width: 15.0, thickness: 15.0,color: Colors.red,),
                  Consumer<LatexModel>(
                    builder: (context, result, _) => Text(result.result),
                  ),
                ],
              ),
              Expanded(
                flex: 4,
                child: MathKeyBoard(
                  latexModel: latexModel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

