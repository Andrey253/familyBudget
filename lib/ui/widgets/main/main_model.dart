import 'dart:async';
import 'package:family_budget/domain/entity/category_transaction.dart';
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

  List<User> get groups => _groups.toList();
  String typeTransaction = TypeTransaction.all;
  DateTimeRange? dateTimeRange;
  MainModel() {
    _setup();
  }

  void saveGroup(BuildContext context) async {
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
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAdapter());
    }
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

  void _readGroupsFromHive(Box<User> box) {
    _groups = box.values.toList();
    notifyListeners();
  }

  void _setup() {
    listCategory =
        Hive.box<NameCategory>(HiveDbName.categoryName).values.toList();
  }

  void addCategory(BuildContext context, String typeTrans) async {
    // final type = context.read<MainModel>().typeTransaction;

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
    // Navigator.of(context).pop();
  }

  openTransElement(BuildContext ctx, NameCategory categoryTransaction) {
    Navigator.of(ctx).pushNamed(MainNavigationRouteNames.transactionDetail,
        arguments: [categoryTransaction, ctx.read<MainModel>()]);
  }

  void deleteCategoryTransaction(
      NameCategory nameCategory, BuildContext context) async {
    final summ = Hive.box<Transaction>(HiveDbName.transactionBox)
        .values.where((element) => element.nameCategory==nameCategory.name)
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

  void saveCategoryTransaction (
      NameCategory categoryTransaction, BuildContext context) async {
  await  categoryTransaction.save();
    final box = Hive.box<NameCategory>(HiveDbName.categoryName);
    listCategory = box.values.toList();
    Navigator.pop(context);
    notifyListeners();
    // box.deleteFromDisk();
  }

  void setState() {
    notifyListeners();
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
