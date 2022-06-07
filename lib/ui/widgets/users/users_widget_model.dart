import 'dart:async';
import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/type_transaction/transaction_detail.dart';
import 'package:family_budget/ui/widgets/type_transaction/transaction_type_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';
import 'package:family_budget/domain/entity/task.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';
import 'package:provider/provider.dart';

class UsersWidgetModel extends ChangeNotifier {
  var _groups = <User>[];
  var groupName = '';
  List<CategoryTransaction> listTypes = [];

  List<User> get groups => _groups.toList();
  String typeTransaction = '';
  UsersWidgetModel() {
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
    listTypes = Hive.box<CategoryTransaction>(HiveDbName.categoryTransaction)
        .values
        .where((element) => element.type == typeTransaction)
        .toList();
    print('teg $typeTransaction');
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

  void deleteGroup(int groupIndex, BuildContext context) async {
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
                      await box.getAt(groupIndex)?.tasks?.deleteAllFromHive();
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
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAdapter());
    }
    final box = Hive.box<User>(HiveDbName.userBox);
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }

    _readGroupsFromHive(box);
    box.listenable().addListener(() => _readGroupsFromHive(box));
  }

  void addCategory(BuildContext context) async {
    final type = context.read<UsersWidgetModel>().typeTransaction;

    final transactionCategory = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return TransactionTypeDialog(type: type);
      },
    )) as CategoryTransaction?;
    if (transactionCategory == null) return;
    final box = Hive.box<CategoryTransaction>(HiveDbName.categoryTransaction);
    final index = await box.put(transactionCategory.keyAt, transactionCategory);
    // final key = await box.keyAt(index);
    // transactionCategory.keyAt = key;
    // await transactionCategory.save();
    listTypes = Hive.box<CategoryTransaction>(HiveDbName.categoryTransaction)
        .values
        .where((element) => element.type == typeTransaction)
        .toList();
    notifyListeners();
    // Navigator.of(context).pop();
  }

  openTransElement(BuildContext context, CategoryTransaction categoryTransaction) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return TransactionDetail(categoryTransaction: categoryTransaction);
      },
    ));
  }

  deleteTypeTransaction(int index) async {
    final box = Hive.box<CategoryTransaction>(HiveDbName.categoryTransaction);
    final key = listTypes[index].keyAt;
    await box.delete(key);
    listTypes = box.values.where((element) => element.type == typeTransaction).toList();
    notifyListeners();
    // box.deleteFromDisk();
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
