import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'src/mathbox.dart';
import 'src/result.dart';
import 'src/mybutton.dart';
import 'src/mathmodel.dart';
import 'src/settingpage.dart';

void main() async {
  final mathModel = MathModel();
  final settings = SettingModel();
  await settings.initVal();
  mathModel.precision = settings.precision.toInt();
  print('Init Mode: ' + settings.isProMode.toString());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settings,),
        ChangeNotifierProvider.value(value: mathModel,),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // static final mathModel = MathModel();
  // static final settings = SettingModel();

  // void init() async {
  //   await settings.initVal();
  //   print('Init Mode ' + settings.isProMode.toString());
  //   mathModel.precision = settings.precision.toInt();
  // }// TODO: Have problem to load initial setting

  @override
  Widget build(BuildContext context) {
    // init();
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
  @override
  Widget build(BuildContext context) {
    final mathModel = Provider.of<MathModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(MaterialCommunityIcons.getIconData("settings-outline"), color: Colors.grey,),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingPage()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: MathBox(),
            ),
            Result(),
            MathKeyBoard(
              mathModel: mathModel,
            ),
          ],
        ),
      ),
    );
  }
}

