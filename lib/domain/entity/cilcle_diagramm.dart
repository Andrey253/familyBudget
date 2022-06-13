import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
            xValueMapper: (ChartData data, _) => data.name,
            yValueMapper: (ChartData data, _) => data.summa,
            //pointColorMapper: (ChartData data, _) => data.color
          )
        ]);
  }
}



class ChartData {
  ChartData(this.name, this.summa, [this.color]);
  String name;
  final double summa;
  final Color? color;

  @override
  String toString() => 'ChartData(name: $name, summa: $summa, color: $color)';
}
