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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            mathModel.precision = setting.precision.toInt();
            mathModel.calcNumber();
            Navigator.pop(context);
          },
        ),
        title: Text('Setting'),
      ),
      body: Consumer<SettingModel>(
        builder: (context, setmodel, _) => Row(
          children: <Widget>[
            Text("${setmodel.precision.toInt()}:"),
            Expanded(
              child: Slider(
                value: setmodel.precision,
                min: 0,
                max: 10,
                label: "${setmodel.precision.toInt()}",
                divisions: 10,
                onChanged: (val) {
                  setmodel.changeSlider(val);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingModel with ChangeNotifier {
  num precision;

  Future changeSlider(double val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    precision = val;
    prefs.setDouble('precision', precision);
    notifyListeners();
  }

  Future initVal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    precision = (prefs.getDouble('precision') ?? 0);
    notifyListeners();
  }

}
