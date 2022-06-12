import 'dart:async';
import 'package:family_budget/domain/entity/category_transaction.dart';
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
  List<NameCategory> listTypes = [];

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

  void selectTypeTransaction(BuildContext context, String type) async {
    typeTransaction = type;
    listTypes = Hive.box<NameCategory>(HiveDbName.categoryName)
        .values
        .where((element) => type == TypeTransaction.all
            ? true
            : element.type == typeTransaction)
        .toList();
    notifyListeners();
  }

  void resetTypeTransaction(BuildContext context) async {
    typeTransaction = TypeTransaction.all;
    listTypes = Hive.box<NameCategory>(HiveDbName.categoryName).values.toList();
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
    listTypes = Hive.box<NameCategory>(HiveDbName.categoryName).values.toList();
  }

  void addCategory(BuildContext context) async {
    // final type = context.read<MainModel>().typeTransaction;

    final transactionCategory =
        await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return TransactionTypeDialog(type: typeTransaction);
      },
    )) as NameCategory?;
    print('teg transactionCategory $transactionCategory');
    if (transactionCategory == null) return;
    final box = Hive.box<NameCategory>(HiveDbName.categoryName);
    final index = await box.add(transactionCategory);
    // final key = await box.keyAt(index);
    // transactionCategory.keyAt = key;
    // await transactionCategory.save();
    listTypes = Hive.box<NameCategory>(HiveDbName.categoryName)
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
      NameCategory categoryTransaction, BuildContext context) async {
    categoryTransaction.delete();
    final box = Hive.box<NameCategory>(HiveDbName.categoryName);
    listTypes = box.values.toList();
    Navigator.pop(context);
    notifyListeners();
    // box.deleteFromDisk();
  }

  void saveCategoryTransaction(
      NameCategory categoryTransaction, BuildContext context) async {
    categoryTransaction.save();
    final box = Hive.box<NameCategory>(HiveDbName.categoryName);
    listTypes = box.values.toList();
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
