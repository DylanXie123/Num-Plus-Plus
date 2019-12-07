import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:num_plus_plus/src/backend/mathmodel.dart';

class FunctionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plot'),),
      body: Container(
        padding: EdgeInsets.all(5.0),
        width: double.infinity,
        height: double.infinity,
        child: FunctionChart(),
      ),
    );
  }
}

typedef CalculationFunction = num Function(num x);

class FunctionChart extends StatefulWidget {
  @override
  _FunctionChartState createState() => _FunctionChartState();
}

class _FunctionChartState extends State<FunctionChart> {
  List<double> xCoordinate = <double>[];
  List<FlSpot> _spots = <FlSpot>[];
  double start = -6.0;
  double end = 6.0;

  @override
  void initState() {
    super.initState();
    _spots = _plotData(Provider.of<FunctionModel>(context, listen: false).calc, start, end);
  }

  List<FlSpot> _plotData(CalculationFunction calc, double start, double end) {
    const interval = 500;
    double step = (end - start) / interval;
    List<FlSpot> spots = [];
    for (var i = 0; i < interval; i++) {
      var result = calc(start+step*i);
      if (result.isFinite) {
        spots.add(FlSpot(start+step*i, result));
      }
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    // onTap: () {
    //   print('tap');
    // },
    onScaleStart: (detail) {
      print('object');
    },
    child: LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: _spots,
            isCurved: true,
            dotData: FlDotData(
              show: false,
            ),
          ),
          LineChartBarData(
            spots: [
              FlSpot(start, 0),
              FlSpot(end, 0),
            ],
            colors: [Colors.black],
            dotData: FlDotData(
              show: false,
            ),
          ),
          LineChartBarData(
            spots: [
              FlSpot(0, -5.0),
              FlSpot(0, 5.0),
            ],
            colors: [Colors.black],
            dotData: FlDotData(
              show: false,
            ),
          ),
        ],
        gridData: FlGridData(
          show: false,
          getDrawingHorizontalGridLine: (value) {
            return FlLine();
          }
        ),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: false,
            getTitles: (value) {
              if(value.remainder(5) == 0) {
                return value.toInt().toString();
              } else {
                return null;
              }
            }
          ),
          leftTitles: SideTitles(
            showTitles: false,
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
          enabled: false,
          enableNormalTouch: false,
          handleBuiltInTouches: false,
          // touchCallback: (response) {
          //   if (response.touchInput.getOffset().dx != 0.0) {
          //     if (xCoordinate.length < 2) {
          //       xCoordinate.add(response.touchInput.getOffset().dx);
          //     } else {
          //       xCoordinate.removeAt(0);
          //       xCoordinate.add(response.touchInput.getOffset().dx);
          //       setState(() {
          //         start += xCoordinate[1] - xCoordinate[0];
          //         end += xCoordinate[1] - xCoordinate[0];
          //         _spots = _plotData(Provider.of<FunctionModel>(context, listen: false).calc, start, end);
          //       });
          //     }
          //   }
          // },
        ),
      ),
      swapAnimationDuration: Duration(milliseconds: 10),
    ),
  );
}