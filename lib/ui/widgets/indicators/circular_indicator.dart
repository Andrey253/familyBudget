import 'package:family_budget/domain/entity/cilcle_diagramm.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class IndicatorFamalyBudget extends StatelessWidget {
  const IndicatorFamalyBudget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Transaction>>(
        valueListenable:
            Hive.box<Transaction>(HiveDbName.transactionBox)
                .listenable(),
        builder: (context, box, _) {
          final tr =
              Hive.box<Transaction>(HiveDbName.transactionBox).values;
          final expense =
              tr.where((element) => element.isExpense == true);
          final out = tr.where((element) => element.isExpense == false);
          final summExp = expense.fold<double>(
              0,
              (previousValue, element) =>
                  previousValue + element.amount);
          final summEOut = out.fold<double>(
              0,
              (previousValue, element) =>
                  previousValue + element.amount);

          final List<ChartData> chartData = [
            ChartData('Расходы', summEOut, Colors.yellow),
            ChartData('Доходы', summExp),
          ];
          return CircleDiagramm(chartData: chartData);
        });
  }
}