import 'package:flutter/material.dart';
import 'package:num_plus_plus/src/widgets/mathbox.dart';
import 'package:provider/provider.dart';

class SymCalcButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mathLiveCtl = Provider.of<MathLiveController>(context, listen: false);
    return OutlineButton(
      child: Text('Sym Calc'),
      onPressed: mathLiveCtl.doSymCalc,
    );
  }
}
