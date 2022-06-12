import 'package:family_budget/domain/entity/cilcle_diagramm.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class IndicatorFamalyBudget extends StatelessWidget {
  const IndicatorFamalyBudget({
    Key? key,
    this.userName,
    this.dateTimeRange,
  }) : super(key: key);
  final DateTimeRange? dateTimeRange;
  final String? userName;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Transaction>>(
        valueListenable:
            Hive.box<Transaction>(HiveDbName.transactionBox).listenable(),
        builder: (context, box, _) {
          final tr = Hive.box<Transaction>(HiveDbName.transactionBox)
              .values
              .where((e) => dateTimeRange?.start != null
                  ? e.createdDate.isAfter(dateTimeRange!.start)
                  : true)
              .where((e) => dateTimeRange?.end != null
                  ? e.createdDate
                      .isBefore(dateTimeRange!.end.add(const Duration(days: 1)))
                  : true)
              .where((element) =>
                  userName != null ? element.nameUser == userName : true);

          final List<String> types = [
            TypeTransaction.expense,
            TypeTransaction.income
          ];
          final summ = tr.fold<double>(
              0, (previousValue, element) => previousValue + element.amount);

          List<ChartData> chartData = [];
          for (var type in types) {
            final items =
                tr.where((transaction) => type == transaction.typeTransaction);
            final summItems = items.fold<double>(
                0, (previousValue, element) => previousValue + element.amount);
            chartData.add(ChartData(
                '$type ${(summItems / (summ == 0 ? 1 : summ) * 100).toStringAsFixed(1)}%',
                summItems));
          }
          return CircleDiagramm(chartData: chartData);
        });
  }
}
