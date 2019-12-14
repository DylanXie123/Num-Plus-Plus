import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:num_plus_plus/src/backend/mathmodel.dart';

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
    animationController = AnimationController(duration: const Duration(milliseconds: 400),vsync: this);
    mathModel.equalAnimation = animationController;
    final curve = CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack);
    animation = Tween<double>(begin: 30.0, end: 60.0).animate(curve);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      height: animation.value,
      width: double.infinity,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      child: Consumer<MathModel>(
        builder: (_, model, __) {
          String text;
          if (model.result!='' && animationController.status == AnimationStatus.dismissed) {
            text = '= ' + model.result;
          } else {
            text = model.result;
          }
          return SelectableText(
            text,
            style: TextStyle(
              fontFamily: "TimesNewRoman",
              fontSize: animation.value - 5,
            ),
            maxLines: 1,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: _buildAnimation,
    );
  }
}
