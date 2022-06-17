import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/domain/model/char_data.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/ui/widgets/indicators/cilcle_diagramm.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportModel extends ChangeNotifier {
  String nameUser = '';
  List<NameCategory> listCategory = [];
  List<Transaction> listTransaction = [];

  List<ChartData> chartDataTypeTransaction = [];
  List<ChartData> chartDataNameTransaction = [];

  DateTime dateNow = DateTime.now();
  DateTime? _start;
  DateTime? get start => _start;
  DateTime? _end;
  DateTime? get end => _end;

  ReportModel({required this.nameUser}) {
    _setup();
  }

  void _setup() {
    listCategory =
        Hive.box<NameCategory>(HiveDbName.categoryName).values.toList();
    _start = DateTime(dateNow.year, dateNow.month);
    _end = DateTime(dateNow.year, dateNow.month + 1)
        .add(const Duration(microseconds: -1));
  }

  void setDateTimeRange(DateTime? startL, DateTime? endL) {
    _start = startL ?? _start ?? DateTime(2022);
    _end = endL ?? _end ?? DateTime(2210);
    notifyListeners();
  }

  Iterable<Transaction> getTransaction() {
    return Hive.box<Transaction>(HiveDbName.transactionBox)
        .values
        .where((e) => start != null ? e.createdDate.isAfter(start!) : true)
        .where((e) => end != null
            ? e.createdDate.isBefore(end!.add(const Duration(days: 1)))
            : true)
        .where((e) => nameUser == '' ? true : e.nameUser == nameUser);
  }

  List<List<ColumnSeries<ChartIncomeExpenses, String>>>
      getListChartDataOnCategory() {
    List<List<ColumnSeries<ChartIncomeExpenses, String>>> result = [];
    final transactions = getTransaction();
    final catName = Hive.box<NameCategory>(HiveDbName.categoryName).values;

    for (var e in catName) {
      List<ChartIExp> listChartIExp = [];
      final category = transactions.where((el) => el.nameCategory == e.name);

      for (DateTime dTime = start!;
          dTime.compareTo(end!) <= 0;
          dTime = dTime.add(const Duration(days: 1))) {
        final trtansactionOnDate = category.where((el) =>
            el.createdDate.toString().split(' ').first ==
            dTime.toString().split(' ').first);
        final summ = trtansactionOnDate.fold<double>(
            0, (prV, element) => prV + element.amount);
        listChartIExp.add(ChartIExp(
            summa: summ,
            createDate: dTime,
            count: '${dTime.month}.${dTime.day}'));
      }

      final chartDataIncomeExpenses = listChartIExp.map((elem) =>
          ChartIncomeExpenses(
              summa: elem.summa,
              createDate: elem.createDate,
              count: elem.count));
      final categoryChartIncomeExpenses =
          getChartDataOnCategory(chartDataIncomeExpenses, e.name);
      result.add(categoryChartIncomeExpenses);
    }

    return result;
  }

  List<ColumnSeries<ChartIncomeExpenses, String>> getChartDataOnCategory(
      Iterable<ChartIncomeExpenses> chartDataIncomeExpenses, String name) {
    return <ColumnSeries<ChartIncomeExpenses, String>>[
      ColumnSeries<ChartIncomeExpenses, String>(
          name: name,
          dataSource: chartDataIncomeExpenses.toList(),
          xValueMapper: (ChartIncomeExpenses data, _) => data.count,
          yValueMapper: (ChartIncomeExpenses data, _) => data.summa,
          dataLabelMapper: (ChartIncomeExpenses data, _) =>
              data.summa != 0 ? '    ${data.summa.toInt().toString()}' : '',
          dataLabelSettings: const DataLabelSettings(
              angle: -90, isVisible: true, textStyle: TextStyle(fontSize: 10)))
    ];
  }

  List<List<ChartIncomeExpenses>> getListChartDataOnIncomeExp() {
    List<List<ChartIncomeExpenses>> result = [];
    final transactions = getTransaction();

    final List<String> incomExp = [
      TypeTransaction.income,
      TypeTransaction.expense
    ];
    for (var e in incomExp) {
      List<ChartIExp> listChartIExp = [];
      final type = transactions.where((el) => el.typeTransaction == e);

      for (DateTime dTime = start!;
          dTime.compareTo(end!) <= 0;
          dTime = DateTime(dTime.year, dTime.month + 1)) {
        final trtansactionOnDate = type.where((el) =>
            el.createdDate.month == dTime.month &&
            el.createdDate.year == dTime.year);
        final summ = trtansactionOnDate.fold<double>(
            0, (prV, element) => prV + element.amount);
        listChartIExp.add(ChartIExp(
            summa: summ,
            createDate: dTime,
            count: '${dTime.year}.${dTime.month}'));
      }

      final chartDataIncomeExpenses = listChartIExp.map((elem) =>
          ChartIncomeExpenses(
              summa: elem.summa,
              createDate: elem.createDate,
              count: elem.count));
      result.add(chartDataIncomeExpenses.toList());
    }

    return result;
  }
}
