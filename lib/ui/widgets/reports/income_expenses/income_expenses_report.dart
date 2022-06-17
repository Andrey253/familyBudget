
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

    final data = model.getListChartDataOnIncomeExp();
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
        chartData: data[0],
        chartData1: data[1],
      ))
    ])));
  }
}
