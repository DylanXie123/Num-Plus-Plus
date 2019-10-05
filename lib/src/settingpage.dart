import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mathmodel.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<SettingModel>(context, listen: false);
    final mathModel = Provider.of<MathModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blueAccent,),
          onPressed: () {
            mathModel.precision = setting.precision.toInt();
            mathModel.calcNumber();
            Navigator.pop(context);
          },
        ),
        title: Text('Setting', style: TextStyle(color: Colors.blueAccent),),
      ),
      body: Consumer<SettingModel>(
        builder: (context, setmodel, _) => ListView(
          children: <Widget>[
            SwitchListTile(
              title: Text('ProMode'),
              value: setmodel.isProMode,
              onChanged: (mode) {
                setmodel.changeMode(mode);
              },
            ),
            ListTile(
              leading: Text('Precision:'),
              title: Slider(
                value: setmodel.precision,
                min: 0,
                max: 10,
                label: "${setmodel.precision.toInt()}",
                divisions: 10,
                onChanged: (val) {
                  setmodel.changeSlider(val);
                },
              ),
              trailing: Text('${setmodel.precision.toInt()}'),
            ),
          ],
        ),
      ),
    );
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
    print('Set Mode: ' + isProMode.toString());
    notifyListeners();
  }

  Future initVal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    precision = (prefs.getDouble('precision') ?? 0);
    isProMode = (prefs.getBool('isProMode') ?? true);
    notifyListeners();
  }

}
