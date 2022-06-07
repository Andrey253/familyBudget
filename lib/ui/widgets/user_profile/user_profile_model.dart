import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/type_transaction/transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';
import 'package:family_budget/domain/entity/task.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';

class UserProfileModel extends ChangeNotifier {
  int userKey;
  late final Box<User> _userBox;
  // var _tasks = <Task>[];
  String typeTransaction = '';
  List<CategoryTransaction> listTypes = [];
  // List<Task> get tasks => _tasks.toList();

  User? _user;
  User? get user => _user;

  UserProfileModel({required this.userKey}) {
    _setup();
  }
  void selectTypeTransaction(BuildContext context, String type) async {
    typeTransaction = type;
    listTypes = Hive.box<CategoryTransaction>(HiveDbName.categoryTransaction)
        .values
        .where((element) => element.type == typeTransaction)
        .toList();
    notifyListeners();
  }

  void addTransaction(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TransactionDialog(
            onClickedDone: onClickedDone, nameUser: _user?.name ?? '', nameCategory: typeTransaction)));
  }

  void _loadUser() {
    final box = _userBox;
    _user = box.get(userKey);
    notifyListeners();
  }

  dynamic onClickedDone(String name, double amount, bool isExpense, String nameUser, String nameCategory) async {
    final transaction = Transaction()
      ..name = name
      ..createdDate = DateTime.now()
      ..amount = amount
      ..isExpense = isExpense
      ..nameUser = nameUser
      ..nameCategory = nameCategory;

    final box = Hive.box<Transaction>(HiveDbName.transactionBox);
    await box.put(transaction.createdDate.toString(), transaction);
  }

  void _setup() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAdapter());
    }
    _userBox = Hive.box<User>(HiveDbName.userBox);

    _loadUser();
    notifyListeners();
    // _setupListenTasks();
  }

  void deleteTransaction(String key) async {
    final box = Hive.box<Transaction>(HiveDbName.transactionBox);
    await box.delete(key);
    // box.clear();
  }
}

// class TasksWidgetModelProvider extends InheritedNotifier {
//   final TasksWidgetModel model;
//   const TasksWidgetModelProvider({
//     Key? key,
//     required this.model,
//     required Widget child,
//   }) : super(
//           key: key,
//           notifier: model,
//           child: child,
//         );

//   static TasksWidgetModelProvider? watch(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
//   }

//   static TasksWidgetModelProvider? read(BuildContext context) {
//     final widget = context.getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()?.widget;
//     return widget is TasksWidgetModelProvider ? widget : null;
//   }
// }
