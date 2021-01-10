import 'package:flutter/material.dart';
import 'package:num_plus_plus/src/widgets/mathbox.dart';
import 'package:provider/provider.dart';

class DynamicButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mathLiveCtl = Provider.of<MathLiveController>(context, listen: false);
    return Consumer<ValueNotifier<MathMode>>(builder: (context, mathModel, _) {
      if (mathModel.value == MathMode.Var) {
        return Row(
          children: [
            OutlineButton(
              child: Text('Int'),
              onPressed: mathLiveCtl.doIntegrate,
            ),
            OutlineButton(
              child: Text('Diff'),
              onPressed: mathLiveCtl.doDiff,
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }
}
