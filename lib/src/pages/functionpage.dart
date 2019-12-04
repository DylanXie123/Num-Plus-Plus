import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:num_plus_plus/src/backend/mathmodel.dart';

class FunctionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Function'),),
      body: ListView(
        children: <Widget>[
          Consumer<FunctionModel>(
            builder: (context, model, _) => LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _plotData(model.calc),
                    isCurved: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<FlSpot> _plotData(Function calc, {double start = -5.0, double end = 5.0}) {
  const interval = 50;
  double step = (end - start) / interval;
  return List<FlSpot>.generate(interval, (index) {
    return FlSpot(index.toDouble(), calc(start+step*index));
  });
}