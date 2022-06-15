import 'package:family_budget/domain/model/char_data.dart';

import 'package:family_budget/ui/widgets/reports/income_expenses/income_expenses.dart';
import 'package:family_budget/ui/widgets/general_widgets/select_period.dart';
import 'package:family_budget/ui/widgets/reports/report_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeExpensesReportWidget extends StatelessWidget {
  const IncomeExpensesReportWidget({
    Key? key,
    this.userName,
  }) : super(key: key);

  final String? userName;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ReportModel>();

    List<ChartIncomeExpenses> chartData = <ChartIncomeExpenses>[
      ChartIncomeExpenses(
          summa: 3,
          createDate: DateTime.now().add(const Duration(days: 1)),
          count: '1'),
      ChartIncomeExpenses(
          summa: 4,
          createDate: DateTime.now().add(const Duration(days: 2)),
          count: '2'),
      ChartIncomeExpenses(
          summa: 7,
          createDate: DateTime.now().add(const Duration(days: 3)),
          count: '3'),
    ];
    List<ChartIncomeExpenses> chartData1 = <ChartIncomeExpenses>[
      ChartIncomeExpenses(
          summa: 2,
          createDate: DateTime.now().add(const Duration(days: 1)),
          count: '1'),
      ChartIncomeExpenses(
          summa: 1,
          createDate: DateTime.now().add(const Duration(days: 2)),
          count: '2'),
      ChartIncomeExpenses(
          summa: 6,
          createDate: DateTime.now().add(const Duration(days: 3)),
          count: '3'),
    ];
    // final listData = model.getListChartDataOnCategory();
    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      SelectPeriod(
          setDateTimeRange: model.setDateTimeRange,
          start: model.start,
          end: model.end),
      Expanded(
          child: IncomExp(
        chartData: chartData,
        chartData1: chartData1,
      ))
    ])));
  }
}
