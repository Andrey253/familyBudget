import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/type_transaction/transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';

class UserProfileModel extends ChangeNotifier {
  int userKey;
  late final Box<User> _userBox;

  String? typeTransaction  = TypeTransaction.all;
  List<CategoryTransaction> listTypes = [];

  User? _user;
  User? get user => _user;

  UserProfileModel({required this.userKey}) {
    _setup();
  }
  void selectTypeTransaction(BuildContext context, String type) async {
    typeTransaction = type;
    listTypes = Hive.box<CategoryTransaction>(HiveDbName.categoryTransaction)
        .values
        .where((element) => type == TypeTransaction.all ? true : element.type == typeTransaction)
        .toList();
    notifyListeners();
  }

  void resetTypeTransaction(BuildContext context, String type) async {
    typeTransaction = null;
    listTypes = Hive.box<CategoryTransaction>(HiveDbName.categoryTransaction).values.toList();
    notifyListeners();
  }

  void addTransaction(BuildContext context, CategoryTransaction categoryTransaction) {
    final transaction = Transaction()
      ..name = ''
      ..createdDate = DateTime.now()
      ..isExpense =categoryTransaction.type == TypeTransaction.income? false : true
      ..nameUser = _user?.name ?? ''
      ..nameCategory = categoryTransaction.nameCategory
      ..typeTransaction = categoryTransaction.type
      ..amount = 0;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransactionDialog(transaction: transaction)));
  }

  void _loadUser() {
    final box = _userBox;
    _user = box.get(userKey);
    notifyListeners();
  }

  void _setup() {
    listTypes = Hive.box<CategoryTransaction>(HiveDbName.categoryTransaction).values.toList();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAdapter());
    }
    _userBox = Hive.box<User>(HiveDbName.userBox);

    _loadUser();
    notifyListeners();
    // _setupListenTasks();
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
