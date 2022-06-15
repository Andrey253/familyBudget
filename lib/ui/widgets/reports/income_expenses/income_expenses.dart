import 'package:family_budget/domain/model/char_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IncomExp extends StatefulWidget {
  const IncomExp({Key? key, required this.chartData, required this.chartData1})
      : super(key: key);
  final List<ChartIncomeExpenses> chartData;
  final List<ChartIncomeExpenses> chartData1;
  @override
  State<IncomExp> createState() => _IncomExpState();
}

class _IncomExpState extends State<IncomExp> {
  bool? isIndexed;

  @override
  void initState() {
    isIndexed = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildIndexedCategoryAxisChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
        children: <Widget>[
          const Text('Arrange by index',
              style: TextStyle(
                // color: model.textColor,
                fontSize: 16,
              )),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: SizedBox(
                width: 90,
                child: CheckboxListTile(
                    // activeColor: model.backgroundColor,
                    value: isIndexed,
                    onChanged: (bool? value) {
                      setState(() {
                        isIndexed = value;
                        stateSetter(() {});
                      });
                    })),
          )
        ],
      );
    });
  }

  /// Returns the column chart with arranged index.
  SfCartesianChart _buildIndexedCategoryAxisChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: true, position: LegendPosition.top),
      primaryXAxis: CategoryAxis(
          arrangeByIndex: isIndexed ?? true,
          majorGridLines: const MajorGridLines(width: 0),
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}%',
          // interval: isCardView ? 2 : 1,
          title: AxisTitle(text: 'GDP growth rate'),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getIndexedCategoryAxisSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the column chart.
  List<ColumnSeries<ChartIncomeExpenses, String>>
      _getIndexedCategoryAxisSeries() {
    return <ColumnSeries<ChartIncomeExpenses, String>>[
      ColumnSeries<ChartIncomeExpenses, String>(
          dataSource: widget.chartData,
          xValueMapper: (ChartIncomeExpenses data, _) => data.count,
          yValueMapper: (ChartIncomeExpenses data, _) => data.summa,
          name: 'Доходы'),
      ColumnSeries<ChartIncomeExpenses, String>(
          dataSource: widget.chartData1,
          xValueMapper: (ChartIncomeExpenses data, _) => data.count,
          yValueMapper: (ChartIncomeExpenses data, _) => data.summa,
          name: 'Расходы')
    ];
  }
}
