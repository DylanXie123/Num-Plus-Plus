import 'package:flutter/material.dart';
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
    final mathModel = Provider.of<MathModel>(context, listen: false);
    mathModel.equalAnimationController = animationController;
    return Container(
      height: animation.value,
      width: double.infinity,
      alignment: Alignment.centerRight,
      child: Consumer<MathModel>(
        builder: (context, model, _) {
          final _textController = TextEditingController();
          _textController.text = (model.result.last=='')?'':'= ' + model.result.last;
          return TextField(
            controller: _textController,
            readOnly: true,
            textAlign: TextAlign.right,
            autofocus: true,
            style: TextStyle(
              fontFamily: 'Minion-Pro',
              fontSize: animation.value - 5,
            ),
            decoration: null,
          );
        }
      ),
    );
  }
}
