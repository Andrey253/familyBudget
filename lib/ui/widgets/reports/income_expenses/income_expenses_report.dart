import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:family_budget/ui/widgets/reports/income_expenses/income_expenses.dart';
import 'package:family_budget/ui/widgets/reports/transaction/ltransaction_list.dart';
import 'package:family_budget/ui/widgets/type_transaction/select_period_main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class IncomeExpensesReportWidget extends StatelessWidget {
  const IncomeExpensesReportWidget({
    Key? key,
    this.userName,
  }) : super(key: key);

  final String? userName;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainModel>();
    final listData = model.getListChartDataIncomeExpenses();
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Column(children: [
        const SelectPeriodMain(),
        ...listData
            .map((e) =>
                SizedBox(height: 400, child: IncomeExpensesWidget(series: e)))
            .toList()
      ]),
    )));
  }
}
