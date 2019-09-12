import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double _width = 40.0; //40.0 is better

  const MyButton({
    @required this.child,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: _width / 1.3,
        color: Colors.black,
        fontFamily: 'RobotoMono',
      ),
      child: Container(
        height: _width * 2,
        width: _width * 2,
        alignment: Alignment.center,
        child: InkResponse(
          radius: _width * 1.2,
          splashFactory: InkRipple.splashFactory,
          highlightColor: Colors.transparent,
          onTap: onPressed,
          child: Container(
            height: _width * 2,
            width: _width * 2,
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}
