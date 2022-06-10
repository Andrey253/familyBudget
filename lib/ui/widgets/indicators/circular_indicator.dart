import 'package:family_budget/domain/entity/cilcle_diagramm.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class IndicatorFamalyBudget extends StatelessWidget {
   IndicatorFamalyBudget({
    Key? key,
  }) : super(key: key);
  final DateTimeRange dateTimeRange =
      DateTimeRange(start: DateTime(2022), end: DateTime(2025));
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Transaction>>(
        valueListenable:
            Hive.box<Transaction>(HiveDbName.transactionBox).listenable(),
        builder: (context, box, _) {
          final tr = Hive.box<Transaction>(HiveDbName.transactionBox).values;
          final expense = tr.where((element) => element.isExpense == true);
          final out = tr.where((element) => element.isExpense == false);
          final summExp = expense.fold<double>(
              0, (previousValue, element) => previousValue + element.amount);
          final summEOut = out.fold<double>(
              0, (previousValue, element) => previousValue + element.amount);

          final List<ChartData> chartData = [
            ChartData('Расходы', summEOut, Colors.yellow),
            ChartData('Доходы', summExp),
          ];
          return Column(
            children: [
              TextButton(
                  onPressed: () async {
                    final dr = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2025));
                    print('teg dr ${dr?.start}');
                    print('teg dr ${dr?.end}');
                  },
                  child: Text('Выбрать период')),
              CircleDiagramm(chartData: chartData),
            ],
          );
        });
  }
}
