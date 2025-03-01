import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(value: 40, title: "40%", color: Color.fromRGBO(34, 1, 39, 1)),
          PieChartSectionData(value: 30, color: Colors.red, title: "30%"),
          PieChartSectionData(value: 20, color: Colors.blue, title: "20%"),
          
        ],
      ),
    );
  }
}
