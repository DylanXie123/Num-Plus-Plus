import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:num_plus_plus/src/widgets/sym_calc_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:num_plus_plus/src/widgets/mathbox.dart';
import 'package:num_plus_plus/src/widgets/keyboard.dart';
import 'package:num_plus_plus/src/pages/settingpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //   ),
    // );
    return MultiProvider(
      providers: [
        Provider(create: (context) => MathLiveController()),
        ChangeNotifierProvider(create: (_) => SettingModel()),
      ],
      child: MaterialApp(
        title: 'num++',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: Colors.white,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Server _server = Server();

  @override
  void initState() {
    super.initState();
    _server.start();
  }

  @override
  void dispose() {
    _server.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(
            MaterialCommunityIcons.getIconData("settings-outline"),
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingPage()),
            );
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                MathLiveBox(),
                SlidComponent(),
              ],
            ),
          ),
          MathKeyBoard(),
        ],
      ),
    );
  }
}

class SlidComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SymCalcButton(),
        ExpandKeyBoard(),
      ],
    );
  }
}
