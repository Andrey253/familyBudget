import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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
        margin: EdgeInsets.zero,
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CircularSeries>[
          // Render pie chart
          PieSeries<ChartData, String>(
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            dataSource: widget.chartData,
            xValueMapper: (ChartData data, _) => data.type,
            yValueMapper: (ChartData data, _) => data.summa,
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

class ChartData {
  ChartData(this.type, this.summa, [this.color]);
  final String type;
  final double summa;
  final Color? color;

  @override
  String toString() => 'ChartData(type: $type, summa: $summa, color: $color)';
}
