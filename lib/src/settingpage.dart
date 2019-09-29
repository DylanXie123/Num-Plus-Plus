import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Slider(
        value: 0.5,
        onChanged: (val) {},
      ),
    );
  }
}