import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/mathbox.dart';
import 'src/result.dart';
import 'src/mybutton.dart';
import 'src/mathmodel.dart';
import 'src/settingpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MathModel(),),
        ChangeNotifierProvider.value(value: SettingModel(),)
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<SettingModel>(context, listen: false);
    final mathModel = Provider.of<MathModel>(context, listen: false);

    void init() async {
      await setting.initVal();
      mathModel.precision = setting.precision.toInt();
    }

    init();
    
    print('Rebuilt');
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.grey,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
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
              flex: 6,
              child: MathKeyBoard(
                mathModel: mathModel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

