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
    animationController = AnimationController(duration: const Duration(milliseconds: 400),vsync: this);
    mathModel.equalAnimation = animationController;
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

class SingleMatrixButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const SingleMatrixButton({Key key, @required this.child, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: child,
      onPressed: onPressed,
      color: Colors.blueAccent[400],
      textColor: Colors.white,
    );
  }
}

class MatrixButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mathBoxController = Provider.of<MathBoxController>(context, listen: false);
    return SizedBox(
      height: 40.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Consumer<MatrixModel>(
            builder: (_, model, child) => model.single?
              SizedBox(height: 0.0,):
              SingleMatrixButton(
                child: child,
                onPressed: () {
                  model.calc();
                  mathBoxController.deleteAllExpression();
                  mathBoxController.addString(model.display());
                },
              ),
            child: Text('Calculate'),
          ),
          Consumer<MatrixModel>(
            builder: (_, model, child) => model.single?
              SingleMatrixButton(
                child: child,
                onPressed: () {
                  model.invert();
                  mathBoxController.deleteAllExpression();
                  mathBoxController.addString(model.display());
                },
              ):
              SizedBox(height: 0.0,),
            child: Text('Invert'),
          ),
          Consumer<MatrixModel>(
            builder: (_, model, child) => model.single?
              SingleMatrixButton(
                child: child,
                onPressed: () {
                  model.transpose();
                  mathBoxController.deleteAllExpression();
                  mathBoxController.addString(model.display());
                },
              ):
              SizedBox(height: 0.0,),
            child: Text('Transpose'),
          ),
          Consumer<MatrixModel>(
            builder: (_, model, child) => model.single?
              SingleMatrixButton(
                child: child,
                onPressed: () {
                  model.norm();
                  mathBoxController.deleteAllExpression();
                  mathBoxController.addString(model.display());
                },
              ):
              SizedBox(height: 0.0,),
            child: Text('Norm'),
          ),
          SingleMatrixButton(
            child: Text('Add Row'),
            onPressed: () {
              mathBoxController.addKey('Shift-Spacebar');
            },
          ),
          SingleMatrixButton(
            child: Text('Add Column'),
            onPressed: () {
              mathBoxController.addKey('Shift-Enter');
            },
          ),
        ],
      ),
    );
  }
}