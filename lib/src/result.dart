import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mathmodel.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          child: Consumer<MathModel>(
            builder: (context, result, _) => Text(result.history.last),
          ),
        ),
        VerticalDivider(),
        Container(
          child: Consumer<MathModel>(
            builder: (context, result, _) => Text(result.result),
          ),
        ),
      ],
    );
  }
}