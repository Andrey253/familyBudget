import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';
import 'package:family_budget/ui/widgets/type_transaction/transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';

class UserProfileModel extends ChangeNotifier {
  int userKey;
  late final Box<User> _userBox;

  String? typeTransaction = TypeTransaction.all;
  List<NameCategory> listTypes = [];

  User? _user;
  User? get user => _user;
  DateTimeRange? dateTimeRange;

  UserProfileModel({required this.userKey}) {
    _setup();
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

  void resetTypeTransaction(BuildContext context, String type) async {
    typeTransaction = null;
    listTypes = Hive.box<NameCategory>(HiveDbName.categoryName).values.toList();
    notifyListeners();
  }

  void addTransaction(BuildContext context, NameCategory categoryTransaction) {
    final transaction = Transaction(
        name: '',
        createdDate: DateTime.now(),
        isExpense:
            categoryTransaction.type == TypeTransaction.income ? false : true,
        nameUser: _user?.name ?? '',
        nameCategory: categoryTransaction.name,
        typeTransaction: categoryTransaction.type,
        amount: 0);
    Navigator.of(context).pushNamed(MainNavigationRouteNames.transactioDialog,
        arguments: transaction);
  }

  void _setup() {
    listTypes = Hive.box<NameCategory>(HiveDbName.categoryName).values.toList();
    _userBox = Hive.box<User>(HiveDbName.userBox);
    _user = _userBox.get(userKey);
    notifyListeners();
  }

  void setState() => notifyListeners();
}
