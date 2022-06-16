import 'package:family_budget/domain/model/char_data.dart';
import 'package:family_budget/ui/widgets/reports/report_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback(
    //     (_) => {context.read<ReportModel>().setDateTimeAllRange()});
  }

  @override
  Widget build(BuildContext context) {
    return _buildIndexedCategoryAxisChart();
  }

  /// Returns the column chart with arranged index.
  SfCartesianChart _buildIndexedCategoryAxisChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: true, position: LegendPosition.top),
      primaryXAxis: CategoryAxis(
          arrangeByIndex: true,
          majorGridLines: const MajorGridLines(width: 0),
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}',
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
          dataLabelMapper: (ChartIncomeExpenses data, _) =>
              data.summa != 0 ? '    ${data.summa.toInt().toString()}' : '',
          name: 'Доходы',
          dataLabelSettings: const DataLabelSettings(
              angle: -90, isVisible: true, textStyle: TextStyle(fontSize: 10))),
      ColumnSeries<ChartIncomeExpenses, String>(
          dataSource: widget.chartData1,
          xValueMapper: (ChartIncomeExpenses data, _) => '',
          yValueMapper: (ChartIncomeExpenses data, _) => data.summa,
          dataLabelMapper: (ChartIncomeExpenses data, _) =>
              data.summa != 0 ? '    ${data.summa.toInt().toString()}' : '',
          name: 'Расходы',
          dataLabelSettings: const DataLabelSettings(
              angle: -90, isVisible: true, textStyle: TextStyle(fontSize: 10)))
    ];
  }
}
