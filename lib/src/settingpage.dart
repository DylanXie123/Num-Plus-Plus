import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'mathmodel.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<SettingModel>(context, listen: false);
    final mathModel = Provider.of<MathModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,),
          onPressed: () {
            mathModel.precision = setting.precision.toInt();
            mathModel.calcNumber();
            Navigator.pop(context);
          },
        ),
        title: Text('Setting',),
      ),
      body: ListView(
        itemExtent: 60.0,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: <Widget>[
          ListTile(
            leading: Text(
              'Calc Setting',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Consumer<SettingModel>(
            builder: (context, setmodel, _) => SwitchListTile(
              title: Text('Advance Keyboard'),
              value: setmodel.isProMode,
              onChanged: (mode) {
                setmodel.changeMode(mode);
              },
            ),
          ),
          Consumer<SettingModel>(
            builder: (context, setmodel, _) => ListTile(
              title: Text('Calc Precision'),
              subtitle: Slider(
                value: setmodel.precision.toDouble(),
                min: 0.0,
                max: 10.0,
                label: "${setmodel.precision.toInt()}",
                divisions: 10,
                onChanged: (val) {
                  setmodel.changeSlider(val);
                },
              ),
              trailing: Text('${setmodel.precision.toInt()}'),
            ),
          ),
          Divider(),
          ListTile(
            leading: Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ListTile(
            leading: Icon(MaterialCommunityIcons.getIconData("github-circle")),
            title: Text('Github'),
            onTap: () {
              _launchURL('https://github.com/DXie123/calculator/');
            },
          ),
          ListTile(
            leading: Icon(MaterialCommunityIcons.getIconData("email-edit-outline"),),
            title: Text('Email'),
            onTap: () {
              _launchURL('mailto:dylanxie123@outlook.com?subject=Flutter%20Calculator');
            },
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}

class SettingModel with ChangeNotifier {
  num precision;
  bool isProMode;

  Future changeSlider(double val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    precision = val;
    prefs.setDouble('precision', precision);
    notifyListeners();
  }

  Future changeMode(bool mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isProMode = mode;
    prefs.setBool('isProMode', isProMode);
    notifyListeners();
  }

  Future initVal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    precision = (prefs.getDouble('precision') ?? 10);
    isProMode = (prefs.getBool('isProMode') ?? true);
    notifyListeners();
  }

}
