import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:num_plus_plus/src/widgets/mathbox.dart';
import 'package:num_plus_plus/src/widgets/result.dart';
import 'package:num_plus_plus/src/widgets/matrixbutton.dart';
import 'package:num_plus_plus/src/widgets/keyboard.dart';
import 'package:num_plus_plus/src/backend/mathmodel.dart';
import 'package:num_plus_plus/src/pages/settingpage.dart';
import 'package:num_plus_plus/src/pages/functionpage.dart';

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
          initialBuilder: (context) => MathModel(),
          builder: (context, settings, model) =>
            model..changeSetting(
              precision: settings.precision.toInt(),
              isRadMode: settings.isRadMode
            ),
        ),
        ChangeNotifierProxyProvider<SettingModel, MatrixModel>(
          initialBuilder: (context) => MatrixModel(),
          builder: (context, settings, model) =>
            model..changeSetting(
              precision: settings.precision.toInt(),
            ),
        ),
        Provider(builder: (context) => FunctionModel(),),
        ListenableProvider<CalculationMode>(
          builder: (context) => CalculationMode(Mode.Basic),
          dispose: (context, value) => value.dispose(),
        ),
        Provider(builder: (context) => MathBoxController(),),
      ],
      child: MaterialApp(
        title: 'num++',
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<CalculationMode>(context, listen: false);
    final mathBoxController = Provider.of<MathBoxController>(context, listen: false);
    final setting = Provider.of<SettingModel>(context);
    tabController.index = setting.initPage;
    switch (tabController.index) {
      case 0:
        if (mode.value == Mode.Matrix) {
          mode.value = Mode.Basic;
        }
        break;
      case 1:
        mode.value = Mode.Matrix;
        break;
      default:
        throw 'Unknown type';
    }
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
          indicatorColor: Colors.blueAccent[400],
          controller: tabController,
          labelColor: Colors.black,
          tabs: <Widget>[
            Tab(text: 'Basic',),
            Tab(text: 'Matrix',),
          ],
          onTap: (index) {
            setting.changeInitpage(index);
            mathBoxController.deleteAllExpression();
            switch (index) {
              case 0:
                mode.value = Mode.Basic;
                break;
              case 1:
                mode.value = Mode.Matrix;
                mathBoxController.addExpression('\\\\bmatrix');
                break;
              default:
                throw 'Unknown type';
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(child: MathBox(),),
            Consumer<CalculationMode>(
              builder: (context, mathMode, _) {
                switch (mathMode.value) {
                  case Mode.Basic:
                    return Result();
                    break;
                  case Mode.Matrix:
                    return MatrixButton();
                    break;
                  case Mode.Function:
                    return OutlineButton(
                      child: Text('Analyze'),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FunctionPage()),
                        );
                      },
                    );
                    break;
                  default:
                    throw 'Error';
                }
              },
            ),
            Consumer<CalculationMode>(
              builder: (context, mathMode, _) => mathMode.value!=Mode.Matrix?ExpandKeyBoard():SizedBox(height: 0.0,),
            ),
            MathKeyBoard(),
          ],
        ),
      ),
    );
  }
}
