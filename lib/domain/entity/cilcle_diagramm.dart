import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}

class CircleDiagramm extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const CircleDiagramm({Key? key, required this.chartData}) : super(key: key);
  final List<ChartData> chartData;
  @override
  _CircleDiagrammState createState() => _CircleDiagrammState();
}

class _CircleDiagrammState extends State<CircleDiagramm> {
  @override
  Widget build(BuildContext context) {
   
    return SfCircularChart(
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CircularSeries>[
          // Render pie chart
          PieSeries<ChartData, String>(
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            dataSource: widget.chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            //pointColorMapper: (ChartData data, _) => data.color
          )
        ]);
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
