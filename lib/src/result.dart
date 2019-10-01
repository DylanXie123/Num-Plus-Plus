import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mathmodel.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Container(
          //   height: 60.0,
          //   alignment: Alignment.center,
          //   child: Consumer<MathModel>(
          //     builder: (context, model, _) => model.isFunction ?
          //     ToggleButtons(
          //       children: <Widget>[
          //         Text('Solve'),
          //         Text('Integral'),
          //         Text('Plot'),
          //       ],
          //       isSelected: [true, true, true],
          //       onPressed: (int index) {
          //         switch (index) {
          //           case 0:
          //             model.nSolveFunction();
          //             break;
          //           case 1:
          //             model.result = '';
          //             break;
          //           case 2:
          //             model.result = '';
          //             break;
          //         }
          //       },
          //     ) : Container(color: Colors.transparent,),
          //   ),
          // ),
          Consumer<MathModel>(
            builder: (context, result, _) => Text(result.result),
          ),
        ],
      ),
    );
  }
}