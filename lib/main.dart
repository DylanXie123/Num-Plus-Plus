import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';

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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      title: 'Num++',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(builder: (_) => SettingModel(),),
          ChangeNotifierProvider(builder: (_) => MathModel(),),
          Provider(builder: (context) => MathBoxController(),),
        ],
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  TabController tabController;
  List tabs = ["Basic", "Matrix"];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(MaterialCommunityIcons.getIconData("settings-outline"), color: Colors.grey,),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingPage()),
            );
          },
        ),
        title: TabBar(
          controller: tabController,
          labelColor: Colors.black,
          tabs: <Widget>[
            Tab(text: 'Basic',),
            Tab(text: 'Matrix',),
          ],
          onTap: null,
          // TODO: Display a matrix when tap matrix button
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: MathBox(),),
            Result(tabController: tabController,),
            MathKeyBoard(),
          ],
        ),
      ),
    );
  }
}
