import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomChart extends StatelessWidget {
  const CustomChart({super.key, required this.data});
  final List data;

  double datamax() {
    double maks = 0;
    for (var element in data) {
      if (element > maks) {
        maks = element.toDouble();
      }
    }
    return maks;
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
            titlesData: const FlTitlesData(topTitles: AxisTitles(), rightTitles: AxisTitles(axisNameWidget: SizedBox())),
            lineBarsData: [
              LineChartBarData(
                spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList(),
                // isCurved: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: true, gradient: const LinearGradient(colors: [Colors.blue, Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              ),
            ]),
      ),
    );
  }
}
