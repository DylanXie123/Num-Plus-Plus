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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            MathBox(
              latexModel: latexModel,
            ),
            Consumer<LatexModel>(
              builder: (context, result, _) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    result.history.last,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    result.result,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 48,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MathKeyBoard(
                latexModel: latexModel,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

