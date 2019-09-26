import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'src/mathbox.dart';
import 'src/mybutton.dart';
import 'src/mathmodel.dart';

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final mathModel = MathModel();

  @override
  void initState() {
    super.initState();
    mathModel.animationController = AnimationController(duration: const Duration(milliseconds: 500),vsync: this);
    mathModel.animation = Tween<double>(begin: 0, end: 1000).animate(mathModel.animationController);
  }

  @override
  void dispose() {
    mathModel.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Rebuit');
    return Scaffold(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Consumer<MathModel>(
                    builder: (context, result, _) => Text(result.history.last),
                  ),
                  // VerticalDivider(width: 15.0, thickness: 15.0,color: Colors.red,),
                  // TODO: Make result display part an individual widget(to let user choose eval behaviour)
                  Consumer<MathModel>(
                    builder: (context, result, _) => Text(result.result),
                  ),
                ],
              ),
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

