import 'package:flutter/material.dart';
import 'package:num_plus_plus/src/mathbox.dart';
import 'package:provider/provider.dart';

import 'mathmodel.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> with TickerProviderStateMixin {

  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();
    final mathModel = Provider.of<MathModel>(context, listen: false);
    mathModel.addListener(() {
      mathModel.isClearable?animationController.forward():animationController.reset();
    });
    animationController = AnimationController(duration: const Duration(milliseconds: 400),vsync: this);
    final curve = CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack);
    animation = Tween<double>(begin: 30.0, end: 60.0).animate(curve)
      ..addListener(() {setState(() {});});
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: animation.value,
      width: double.infinity,
      alignment: Alignment.centerRight,
      child: Consumer<MathModel>(
        builder: (_, model, __) {
          final _textController = TextEditingController();
          if (model.result!='' && animationController.status == AnimationStatus.dismissed) {
            _textController.text = '= ' + model.result;
          } else {
            _textController.text = model.result;
          }
          return TextField(
            controller: _textController,
            readOnly: true,
            textAlign: TextAlign.right,
            autofocus: true,
            decoration: null,
            style: TextStyle(
              fontFamily: 'Minion-Pro',
              fontSize: animation.value - 5,
            ),
          );
        },
      ),
    );
  }
}

class MatrixButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MatrixModel>(
      builder:(_, model, child) {
        final mathBoxController = Provider.of<MathBoxController>(context, listen: false);
        return SizedBox(
          height: 40.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              ToggleButtons(
                children: <Widget>[
                  Text('Invert'),
                  Text('Calculate'),
                  Text('Transpose'),
                  Text('Norm'),
                  Text('Add Row'),
                  Text('Add Column'),
                ],
                isSelected: List.filled(6, false),
                onPressed: (index) {
                  switch (index) {
                    case 0:
                      model.invert();
                      mathBoxController.deleteAllExpression();
                      mathBoxController.addString(model.display());
                      break;
                    case 1:
                      model.calc();
                      mathBoxController.deleteAllExpression();
                      mathBoxController.addString(model.display());
                      break;
                    case 2:
                      model.transpose();
                      mathBoxController.deleteAllExpression();
                      mathBoxController.addString(model.display());
                      break;
                    case 3:
                      model.norm();
                      mathBoxController.deleteAllExpression();
                      mathBoxController.addString(model.display());
                      break;
                    case 4:
                      mathBoxController.addKey('Shift-Enter');
                      break;
                    case 5:
                      mathBoxController.addKey('Shift-Spacebar');
                      break;
                    default:
                      throw 'Unknown type';
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}