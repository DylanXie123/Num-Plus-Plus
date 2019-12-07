import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:num_plus_plus/src/backend/mathmodel.dart';
import 'package:num_plus_plus/src/widgets/mathbox.dart';

class SingleMatrixButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const SingleMatrixButton({Key key, @required this.child, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: OutlineButton(
        child: child,
        onPressed: onPressed,
        highlightedBorderColor: Colors.blue,
        highlightColor: Colors.blue[200],
        splashColor: Colors.blueAccent,
        borderSide: BorderSide(
          color: Colors.blue,
          width: 2.0,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    );
  }
}

class MatrixButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mathBoxController = Provider.of<MathBoxController>(context, listen: false);
    return Container(
      height: 40.0,
      color: Colors.white,
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
            builder: (_, model, child) => model.square?
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
            builder: (_, model, child) => model.square?
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