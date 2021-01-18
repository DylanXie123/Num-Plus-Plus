import 'package:flutter/material.dart';
import 'package:num_plus_plus/src/widgets/mathbox.dart';
import 'package:provider/provider.dart';

class DynamicButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mathLiveCtl = Provider.of<MathLiveController>(context, listen: false);
    return Consumer<ValueNotifier<MathMode>>(builder: (context, mathModel, _) {
      switch (mathModel.value) {
        case MathMode.Var:
          return VariableButtons(mathLiveController: mathLiveCtl);
        case MathMode.Matrix:
          return OutlineButton(
            child: Text('Invert'),
            onPressed: mathLiveCtl.invertMatrix,
          );
        default:
          return Container();
      }
    });
  }
}

class VariableButtons extends StatelessWidget {
  final MathLiveController mathLiveController;

  const VariableButtons({Key key, this.mathLiveController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlineButton(
          child: Text('Int'),
          onPressed: mathLiveController.doIntegrate,
        ),
        OutlineButton(
          child: Text('Diff'),
          onPressed: mathLiveController.doDiff,
        ),
        OutlineButton(
          child: Text('Plot'),
          onPressed: mathLiveController.doPlot,
        ),
      ],
    );
  }
}
