import 'package:flutter/material.dart';

class SingleMatrixButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const SingleMatrixButton(
      {Key key, @required this.child, @required this.onPressed})
      : super(key: key);

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
