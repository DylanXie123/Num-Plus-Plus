import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:num_plus_plus/src/backend/mathmodel.dart';

class FunctionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Function'),),
      body: Center(
        child: Consumer<FunctionModel>(
          builder: (context, model, _) => LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: _plotData(model.calc),
                  isCurved: true,
                  show: true,
                  dotData: FlDotData(
                    show: false,
                  ),
                ),
              ],
              gridData: FlGridData(
                drawVerticalGrid: true,
                show: false,
              ),
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTitles: (value) {
                    if(value.remainder(5) == 0) {
                      return value.toInt().toString();
                    } else {
                      return null;
                    }
                  }
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTitles: (value) {
                    if(value.remainder(5) == 0) {
                      return value.toInt().toString();
                    } else {
                      return null;
                    }
                  }
                ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef FunctionCalc = num Function(num x);

List<FlSpot> _plotData(FunctionCalc calc, {double start = -5.0, double end = 5.0}) {
  const interval = 50;
  double step = (end - start) / interval;
  List<FlSpot> spots = [];
  for (var i = 0; i < interval; i++) {
    var result = calc(start+step*i);
    if (result.isFinite) {
      spots.add(FlSpot(start+step*i, result));
    } else {
      // spots.add(FlSpot(i.toDouble(), 0));
    }
  }
  // var temp = List<FlSpot>.generate(interval, (index) {
  //   var result = calc(start+step*index);
  //   if (result.isFinite) {
  //     return FlSpot(index.toDouble(), result);
  //   } else {
  //     return FlSpot(index.toDouble(), 0.0);
  //   }
  // });
  // temp.removeAt(5);
  return spots;
}