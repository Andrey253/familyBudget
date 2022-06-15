import 'package:family_budget/ui/widgets/general_widgets/select_period.dart';
import 'package:family_budget/ui/widgets/reports/category/category.dart';
import 'package:family_budget/ui/widgets/reports/report_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryReportWidget extends StatelessWidget {
  const CategoryReportWidget({
    Key? key,
    this.userName,
  }) : super(key: key);

  final String? userName;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ReportModel>();
    final listData = model.getListChartDataOnCategory();
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Column(children: [
        SelectPeriod(
            setDateTimeRange: model.setDateTimeRange,
            start: model.start,
            end: model.end),
        ...listData
            .map((e) =>
                SizedBox(height: 400, child: CategoryWidget(series: e)))
            .toList()
      ]),
    )));
  }
}
