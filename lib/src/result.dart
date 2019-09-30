import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mathmodel.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: Row(
        children: <Widget>[
          Consumer<MathModel>(
            builder: (context, model, _) => model.isFunction ? 
            RaisedButton(
              child: Text('Calc'),
              onPressed: () {
                model.calcFunction();
              },
            ) : Container(color: Colors.red,),
          ),
          Consumer<MathModel>(
            builder: (context, result, _) => Text(result.result),
          ),
        ],
      ),
    );
  }
}