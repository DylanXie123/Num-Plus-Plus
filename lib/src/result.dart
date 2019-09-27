import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mathmodel.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Consumer<MathModel>(
          builder: (context, result, _) => Text(result.history.last),
        ),
        // VerticalDivider(thickness: 10.0, color: Colors.red,),
        Consumer<MathModel>(
          builder: (context, result, _) => Text(result.result),
        ),
      ],
    );
  }
}