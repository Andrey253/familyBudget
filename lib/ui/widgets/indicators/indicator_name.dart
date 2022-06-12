import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/domain/entity/cilcle_diagramm.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class IndicatorPerson extends StatelessWidget {
  const IndicatorPerson({
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
          final catName =
              Hive.box<NameCategory>(HiveDbName.categoryName).values;
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
          final summ = tr.fold<double>(
              0, (previousValue, element) => previousValue + element.amount);

          final List<ChartData> chartData = [];

          for (var category in catName) {
            final items = tr.where(
                (transaction) => category.name == transaction.nameCategory);

            final summItems = items.fold<double>(
                0, (previousValue, element) => previousValue + element.amount);

            chartData.add(ChartData(
                '${category.name} ${(summItems / (summ == 0 ? 1 : summ) * 100).toStringAsFixed(1)}%',
                summItems));
          }
          // print('teg chartData $chartData');

          return CircleDiagramm(chartData: chartData);
        });
  }
}
