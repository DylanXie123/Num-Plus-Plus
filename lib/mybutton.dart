import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{
  
  final String text;
  final VoidCallback onPressed;
  final double _width = 40.0; //40.0 is better
  
  const MyButton({
    @required this.text,
    @required this.onPressed,
  });

  @override
  Widget build (BuildContext context){
    return Container(
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
          child: Text(
            text,
            style: TextStyle(
              fontSize: _width / 1.3,
              color: Colors.black,
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
      ),
    );
  }
}
