import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomChartWithLabel extends StatelessWidget {
  CustomChartWithLabel({super.key, required this.data}) {
    List<Map<dynamic, dynamic>> dataTemp = [
      {
        'label': '',
        'value': 0,
      },
    ];
    for (var element in data) {
      dataTemp.add(element);
    }
    data = dataTemp;
  }
  List<Map> data;

  double datamax() {
    double maks = 0;
    for (var element in data) {
      if (element['value'] > maks) {
        maks = element['value'].toDouble();
      }
    }
    return maks;
  }

  double bottomHeight() {
    double maks = 0;
    for (var element in data) {
      if (element['label'].length > maks) {
        maks = element['label'].length.toDouble();
      }
    }
    return maks * 5;
  }

  List points() {
    int i = 0;
    List temp = [];
    for (var element in data) {
      temp.add({
        'x': i.toDouble(),
        'y': element['value'].toDouble(),
      });
      i++;
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
            minX: 0.0,
            maxX: data.length.toDouble(),
            minY: 0,
            maxY: datamax(),
            borderData: FlBorderData(border: const Border(left: BorderSide(), bottom: BorderSide())),
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 9)))),
                rightTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: bottomHeight(),
                        getTitlesWidget: (value, meta) {
                          if (value >= data.length) {
                            return const SizedBox();
                          }
                          return Transform.translate(
                            offset: const Offset(5.0, 25.0),
                            child: Transform.rotate(
                              // alignment: Alignment.topLeft,
                              angle: -3.14 / 3,
                              child: SizedBox(
                                width: bottomHeight() + 10,
                                // color: Colors.red,
                                child: Text(
                                  data[value.toInt()]['label'].toString(),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(fontSize: 9),
                                ),
                              ),
                            ),
                          );
                        }))),
            lineBarsData: [
              LineChartBarData(
                spots: points().map((e) => FlSpot(e['x'], e['y'])).toList(),
                // isCurved: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: true, gradient: const LinearGradient(colors: [Colors.blue, Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              ),
            ]),
      ),
    );
  }
}
