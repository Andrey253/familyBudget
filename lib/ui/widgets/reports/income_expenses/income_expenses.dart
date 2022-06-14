import 'package:family_budget/domain/model/char_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IncomeExpensesWidget extends StatelessWidget {
  const IncomeExpensesWidget(
      {Key? key, required this.series})
      : super(key: key);
  final List<ColumnSeries<ChartIncomeExpenses, num>> series;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 400,
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          legend: Legend(
            position: LegendPosition.top,
            isVisible: true,
            toggleSeriesVisibility: true,
            legendItemBuilder:
                (String name, dynamic series, dynamic point, int index) {
              return Text(name);
            },
          ),
          primaryXAxis:
              CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
          primaryYAxis: NumericAxis(
              labelFormat: '{value}',
              majorTickLines: const MajorTickLines(color: Colors.transparent),
              axisLine: const AxisLine(width: 0),
              minimum: 0,
              maximum: 100),
          series: series,
          tooltipBehavior:
              TooltipBehavior(enable: true, header: '', canShowMarker: true),
        ),
      ),
    );
  }

  /// Method to get the images for customizing the legends of line chart series.
  // Image _getImage(int index) {
  //   final List<Image> images = <Image>[
  //     Image.asset('images/truck_legend.png'),
  //     Image.asset('images/car_legend.png'),
  //     Image.asset('images/bike_legend.png'),
  //     Image.asset('images/cycle_legend.png')
  //   ];
  //   return images[index];
  // }
}
