import 'dart:async';
import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/domain/entity/cilcle_diagramm.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/domain/model/type_transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/type_transaction/transaction_detail.dart';
import 'package:family_budget/ui/widgets/type_transaction/transaction_type_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';
import 'package:provider/provider.dart';

class MainModel extends ChangeNotifier {
  var _groups = <User>[];
  var groupName = '';
  List<NameCategory> listCategory = [];
  List<Transaction> listTransaction = [];

  List<User> get users => _groups.toList();
  String typeTransaction = TypeTransaction.all;

  List<ChartData> chartDataTypeTransaction = [];
  List<ChartData> chartDataNameTransaction = [];

  DateTime dateNow = DateTime.now();
  DateTime? _start;
  DateTime? get start => _start;
  DateTime? _end;
  DateTime? get end => _end;

  MainModel() {
    _setup();
  }

  void saveUser(BuildContext context) async {
    if (groupName.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    final box = Hive.box<User>(HiveDbName.userBox);
    final group = User(name: groupName, isSelected: false);
    await box.add(group);
    Navigator.of(context).pop();
  }

  void selectTypeTransaction(BuildContext context, TypeTrans typeTrans) async {
    if (typeTrans.name == TypeTransaction.addExpense) {
      typeTransaction = TypeTransaction.expense;
      addCategory(context, TypeTransaction.expense);
      return;
    }
    if (typeTrans.name == TypeTransaction.addIncome) {
      typeTransaction = TypeTransaction.income;
      addCategory(context, TypeTransaction.income);
      return;
    }
    typeTransaction = typeTrans.name;
    listCategory = Hive.box<NameCategory>(HiveDbName.categoryName)
        .values
        .where((element) => typeTrans.name == TypeTransaction.all
            ? true
            : element.type == typeTransaction)
        .toList();
    notifyListeners();
  }

  void resetTypeTransaction(BuildContext context) async {
    typeTransaction = TypeTransaction.all;
    listCategory =
        Hive.box<NameCategory>(HiveDbName.categoryName).values.toList();
    notifyListeners();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.userAdd);
  }

  void showTasks(BuildContext context, int userIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAdapter());
    }

    final box = Hive.box<User>(HiveDbName.userBox);
    final groupKey = box.keyAt(userIndex) as int;

    unawaited(
      Navigator.of(context).pushNamed(
        MainNavigationRouteNames.userProfile,
        arguments: groupKey,
      ),
    );
  }

  void deleteUser(int groupIndex, BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () async {
                      final box = await Hive.openBox<User>(HiveDbName.userBox);

                      await box.deleteAt(groupIndex);
                      Navigator.pop(context);
                    },
                    child: const Text('Удалить пользователя')),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: const Text('Отмена'))
              ],
            ));
  }

  void _setup() {
    listCategory =
        Hive.box<NameCategory>(HiveDbName.categoryName).values.toList();
    _start = DateTime(dateNow.year, dateNow.month);
    _end = DateTime(dateNow.year, dateNow.month + 1)
        .add(const Duration(microseconds: -1));
  }

  void addCategory(BuildContext context, String typeTrans) async {
    final transactionCategory =
        await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return TransactionTypeDialog(type: typeTrans);
      },
    )) as NameCategory?;
    if (transactionCategory == null) return;
    final box = Hive.box<NameCategory>(HiveDbName.categoryName);
    await box.add(transactionCategory);
    listCategory = Hive.box<NameCategory>(HiveDbName.categoryName)
        .values
        .where((element) => element.type == typeTransaction)
        .toList();
    notifyListeners();
  }

  openTransElement(BuildContext ctx, NameCategory categoryTransaction) {
    Navigator.of(ctx).pushNamed(MainNavigationRouteNames.transactionDetail,
        arguments: [categoryTransaction, ctx.read<MainModel>()]);
  }

  void deleteCategoryTransaction(
      NameCategory nameCategory, BuildContext context) async {
    final summ = Hive.box<Transaction>(HiveDbName.transactionBox)
        .values
        .where((element) => element.nameCategory == nameCategory.name)
        .fold<double>(
            0, (previousValue, element) => previousValue + element.amount);
    if (summ > 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'В данной категории есть транзакции. Необходимо сначала удалить транзакции из категории')));
      return;
    }
    nameCategory.delete();
    final box = Hive.box<NameCategory>(HiveDbName.categoryName);
    listCategory = box.values.toList();
    Navigator.pop(context);
    notifyListeners();
    // box.deleteFromDisk();
  }

  void saveCategoryTransaction(
      NameCategory categoryTransaction, BuildContext context) async {
    await categoryTransaction.save();
    final box = Hive.box<NameCategory>(HiveDbName.categoryName);
    listCategory = box.values.toList();
    Navigator.pop(context);
    notifyListeners();
    // box.deleteFromDisk();
  }

  void setState() {
    notifyListeners();
  }

  void setDateTimeRange(DateTime? start, DateTime? end) {
    _start = start ?? _start ?? DateTime(2022);
    _end = end ?? _end ?? DateTime(2220);
    notifyListeners();
  }

  Iterable<Transaction> getTransaction(String? userName) {
    return Hive.box<Transaction>(HiveDbName.transactionBox)
        .values
        .where((e) => start != null ? e.createdDate.isAfter(start!) : true)
        .where((e) => end != null
            ? e.createdDate.isBefore(end!.add(const Duration(days: 1)))
            : true)
        .where((e) => userName == null ? true : e.nameUser == userName);
  }

  void getDataNameTransactions(String? userName) {
    final catName = Hive.box<NameCategory>(HiveDbName.categoryName).values;
    final tr = getTransaction(userName);

    chartDataNameTransaction = [];
    for (var category in catName) {
      final items =
          tr.where((transaction) => category.name == transaction.nameCategory);

      final summItems = items.fold<double>(
          0, (previousValue, element) => previousValue + element.amount);

      chartDataNameTransaction.add(ChartData(category.name, summItems));
    }
    final s =
        chartDataNameTransaction.fold<double>(0, (prV, e) => prV + e.summa);
    for (var e in chartDataNameTransaction) {
      e.type =
          '${e.type} ${(e.summa / (s == 0 ? 1 : s) * 100).toStringAsFixed(1)}%';
    }
  }

  void getDataTypeTransactions(String? userName) {
    final tr = getTransaction(userName);

    final List<String> types = [
      TypeTransaction.expense,
      TypeTransaction.income
    ];
    chartDataTypeTransaction = [];
    for (var type in types) {
      final items =
          tr.where((transaction) => type == transaction.typeTransaction);
      final summItems = items.fold<double>(
          0, (previousValue, element) => previousValue + element.amount);
      chartDataTypeTransaction.add(ChartData(type, summItems));
    }
    final s =
        chartDataTypeTransaction.fold<double>(0, (prV, e) => prV + e.summa);
    for (var e in chartDataTypeTransaction) {
      e.type =
          '${e.type} ${(e.summa / (s == 0 ? 1 : s) * 100).toStringAsFixed(1)}%';
    }
  }

  void setListTransaction(String? userName) {
    // listTransaction = [];
    listTransaction = getTransaction(userName).toList();
    listTransaction.sort(((a, b) => a.createdDate.compareTo(b.createdDate)));
  }
}

// class GroupsWidgetModelProvider extends InheritedNotifier {
//   final UsersWidgetModel model;
//   const GroupsWidgetModelProvider({
//     Key? key,
//     required this.model,
//     required Widget child,
//   }) : super(
//           key: key,
//           notifier: model,
//           child: child,
//         );

//   static GroupsWidgetModelProvider? watch(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
//   }

//   static GroupsWidgetModelProvider? read(BuildContext context) {
//     final widget = context.getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()?.widget;
//     return widget is GroupsWidgetModelProvider ? widget : null;
//   }
// }
