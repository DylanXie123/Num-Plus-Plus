import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:num_plus_plus/src/backend/mathmodel.dart';

class FunctionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Function'),),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Text('Solve'),
            title: Consumer<FunctionModel>(
              builder: (context, model, _) => Text(model.solve().toString()),
            ),
          ),
        ],
      ),
    );
  }
}