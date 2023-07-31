import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomChart2LinesWithLabel extends StatelessWidget {
  CustomChart2LinesWithLabel({super.key, required this.data}) {
    List<Map<dynamic, dynamic>> dataTemp = [
      {
        'label': '',
        'value1': 0,
        'value2': 0,
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
      if (element['value1'] > maks) {
        maks = element['value1'].toDouble();
      }
      if (element['value2'] > maks) {
        maks = element['value2'].toDouble();
      }
    }
    return maks;
  }

  List firstpoints() {
    int i = 0;
    List temp = [];
    for (var element in data) {
      temp.add({
        'x': i.toDouble(),
        'y': element['value1'].toDouble(),
      });
      i++;
    }
    return temp;
  }

  List secondpoints() {
    int i = 0;
    List temp = [];
    for (var element in data) {
      temp.add({
        'x': i.toDouble(),
        'y': element['value2'].toDouble(),
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
            // gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 9)))),
                rightTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 90,
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
                                width: 110,
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
                  spots: firstpoints().map((e) => FlSpot(e['x'], e['y'])).toList(),
                  // isCurved: true,
                  dotData: const FlDotData(show: false),
                  color: Theme.of(context).primaryColor
                  // belowBarData: BarAreaData(show: true, color: Theme.of(context).primaryColor),
                  ),
              LineChartBarData(
                spots: secondpoints().map((e) => FlSpot(e['x'], e['y'])).toList(),
                // isCurved: true,
                dotData: const FlDotData(show: false),
                color: const Color(0xff159600),
                // belowBarData: BarAreaData(show: true, color: Color(0xff159600)),
              ),
            ]),
      ),
    );
  }
}
