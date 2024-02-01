import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomChart4LinesWithLabel extends StatelessWidget {
  CustomChart4LinesWithLabel({super.key, required this.data}) {
    List dataTemp = [
      {
        'label': '',
        'value1': 0,
        'value2': 0,
        'value3': 0,
        'value4': 0,
      },
    ];
    for (var element in data) {
      dataTemp.add({
        'label': element['created_at'].toString().substring(10, 16),
        'value1': int.parse(element['dt_1']),
        'value2': int.parse(element['dt_2']),
        'value3': int.parse(element['dt_3']),
        'value4': int.parse(element['dt_4']),
      });
    }
    data = dataTemp;
  }
  List data;

  double datamax() {
    double maks = 0;
    for (var element in data) {
      if (element['value1'] > maks) {
        maks = element['value1'].toDouble();
      }
      if (element['value2'] > maks) {
        maks = element['value2'].toDouble();
      }
      if (element['value3'] > maks) {
        maks = element['value3'].toDouble();
      }
      if (element['value4'] > maks) {
        maks = element['value4'].toDouble();
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

  List thirdpoints() {
    int i = 0;
    List temp = [];
    for (var element in data) {
      temp.add({
        'x': i.toDouble(),
        'y': element['value3'].toDouble(),
      });
      i++;
    }
    return temp;
  }

  List fourthpoints() {
    int i = 0;
    List temp = [];
    for (var element in data) {
      temp.add({
        'x': i.toDouble(),
        'y': element['value4'].toDouble(),
      });
      i++;
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
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
                  interval: data.length.toDouble() / 10,
                  reservedSize: 60,
                  getTitlesWidget: (value, meta) {
                    if (value >= data.length) {
                      return const SizedBox();
                    }
                    return Transform.translate(
                      offset: const Offset(-30.0, 50.0),
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
                  },
                ),
              ),
            ),
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
              LineChartBarData(
                spots: thirdpoints().map((e) => FlSpot(e['x'], e['y'])).toList(),
                // isCurved: true,
                dotData: const FlDotData(show: false),
                color: Colors.red,
                // belowBarData: BarAreaData(show: true, color: Color(0xff159600)),
              ),
              LineChartBarData(
                spots: fourthpoints().map((e) => FlSpot(e['x'], e['y'])).toList(),
                // isCurved: true,
                dotData: const FlDotData(show: false),
                color: Colors.amber,
                // belowBarData: BarAreaData(show: true, color: Color(0xff159600)),
              ),
            ]),
      ),
    );
  }
}
