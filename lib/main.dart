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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => SettingModel(),),
        ChangeNotifierProxyProvider<SettingModel, MathModel>(
          initialBuilder: (_) => MathModel(),
          builder: (_, settings, model) {
            model.changeSetting(
              precision: settings.precision.toInt(), 
              isRadMode: settings.isRadMode
            );
            return model;
          },
        ),
        Provider(builder: (context) => MatrixModel(),),
        Provider(builder: (context) => MathBoxController(),),
      ],
      child: MaterialApp(
        title: 'Num++',
        theme: ThemeData(
          primarySwatch: Colors.blue,
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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  TabController tabController;
  List tabs = ["Basic", "Matrix"];
  ValueNotifier<int> tabIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
    final mathBoxController = Provider.of<MathBoxController>(context, listen: false);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
      // TODO: Throw Exception here: AnimationController.stop() called after AnimationController.dispose()
      mathBoxController.deleteAllExpression();
      if (tabController.index == 1) {
        mathBoxController.addExpression('\\\\bmatrix');
      }
    });
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
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(child: MathBox(),),
            ValueListenableBuilder(
              valueListenable: tabIndex,
              builder: (context, index, _) => index==0?Result():MatrixButton(),
            ),
            ExpandKeyBoard(),
            ValueListenableBuilder(
              valueListenable: tabIndex,
              builder: (context, index, _) => MathKeyBoard(mode: index,),
            ),
          ],
        ),
      ),
    );
  }
}
