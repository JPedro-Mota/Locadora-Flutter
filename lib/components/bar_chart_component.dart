import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartComponent extends StatelessWidget {
  final List<int> data;

  BarChartComponent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Ensure that the data list is valid and contains non-null, non-NaN values
    List<int> validatedData = data.map((value) {
      return value.isFinite ? value : 0; // Replace invalid values with 0
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(
                toY: validatedData[0].toDouble(), color: Color.fromRGBO(34, 1, 39, 1))
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: validatedData[1].toDouble(), color: Colors.red)
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: validatedData[2].toDouble(), color: Colors.blue)
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(toY: validatedData[3].toDouble(), color: Colors.red),
          ]),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                List<String> labels = [
                  "Aluguados",
                  "Atrasados",
                  "No Prazo",
                  "Fora do prazo"
                ];

                return SideTitleWidget(
                  space: 10,
                  meta: meta,
                  child: Text(
                    labels[value.toInt()],
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              reservedSize: 60,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
