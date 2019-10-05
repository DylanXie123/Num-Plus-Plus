import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mathmodel.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: double.infinity,
      alignment: Alignment.centerRight,
      child: Consumer<MathModel>(
        builder: (context, model, _) => Text(
          (model.result=='')?'':'= ' + model.result,
          style: TextStyle(
            fontFamily: 'Minion-Pro',
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
