import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/ui/widgets/indicators/cilcle_diagramm.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';

class UserProfileModel extends ChangeNotifier {
  int userKey;
  late final Box<User> _userBox;

  String? typeTransaction = TypeTransaction.all;
  List<NameCategory> listCategory = [];

  User? _user;

  double summaOfUser = 0;

  List<ChartData> chartDataTypeTransaction = [];

  List<ChartData> chartDataNameTransaction = [];
  User? get user => _user;
  DateTimeRange? dateTimeRange;

  DateTime dateNow = DateTime.now();
  DateTime? _start;
  DateTime? get start => _start;
  DateTime? _end;
  DateTime? get end => _end;

  UserProfileModel({required this.userKey}) {
    _setup();
  }
  void selectTypeTransaction(BuildContext context, String type) async {
    typeTransaction = type;
    listCategory = Hive.box<NameCategory>(HiveDbName.categoryName)
        .values
        .where((element) => type == TypeTransaction.all
            ? true
            : element.type == typeTransaction)
        .toList();
    notifyListeners();
  }

  void resetTypeTransaction(BuildContext context, String type) async {
    typeTransaction = null;
    listCategory =
        Hive.box<NameCategory>(HiveDbName.categoryName).values.toList();
    notifyListeners();
  }

  void addTransaction(BuildContext context, NameCategory nameCategory) async {
    final transaction = Transaction(
        name: '',
        createdDate: DateTime.now(),
        isExpense: nameCategory.type == TypeTransaction.income ? false : true,
        nameUser: _user?.name ?? '',
        nameCategory: nameCategory.name,
        typeTransaction: nameCategory.type,
        amount: 0);
    await Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.transactioDialog, arguments: [
      transaction,
      nameCategory.users?[_user?.name ?? ''],
      getSummOfUser(nameCategory)
    ]);
    getSummOfUser(nameCategory);
    notifyListeners();
  }

  void _setup() {
    listCategory =
        Hive.box<NameCategory>(HiveDbName.categoryName).values.toList();
    _userBox = Hive.box<User>(HiveDbName.userBox);
    _user = _userBox.get(userKey);
    _start = DateTime(dateNow.year, dateNow.month);
    _end = DateTime(dateNow.year, dateNow.month + 1)
        .add(const Duration(microseconds: -1));
    notifyListeners();
  }

  void setDateTimeRange(DateTime? start, DateTime? end) {
    _start = start ?? _start ?? DateTime(2022);
    _end = end ?? _end ?? DateTime(2220);
    notifyListeners();
  }
  // void setState() => notifyListeners();

  void saveLimit(NameCategory nameCategory, BuildContext context,
      TextEditingController textEditingController) async {
    nameCategory.users ??= <String, double>{};

    if (textEditingController.text == '' || textEditingController.text == '0') {
      nameCategory.users?.remove(user?.name);
    } else {
      nameCategory.users![user!.name] =
          double.parse(textEditingController.text);
    }
    await nameCategory.save();
    Navigator.pop(context);
    notifyListeners();
  }

  double getSummOfUser(NameCategory nameCategory) {
    final dateStart = DateTime(dateNow.year, dateNow.month);
    final dateEnd = DateTime(dateNow.year, dateNow.month + 1);
    final trans = Hive.box<Transaction>(HiveDbName.transactionBox)
        .values
        .where((e) => e.createdDate.isAfter(dateStart))
        .where((e) => e.createdDate.isBefore(dateEnd))
        .where((element) => element.nameCategory == nameCategory.name)
        .where((element) => element.nameUser == user?.name);
    summaOfUser = trans.fold<double>(
        0, (previousValue, element) => previousValue + element.amount);
    return summaOfUser;
  }
  double getSummOfCcategory(NameCategory nameCategory) {
    final dateStart = DateTime(dateNow.year, dateNow.month);
    final dateEnd = DateTime(dateNow.year, dateNow.month + 1);
    final trans = Hive.box<Transaction>(HiveDbName.transactionBox)
        .values
        .where((e) => e.createdDate.isAfter(dateStart))
        .where((e) => e.createdDate.isBefore(dateEnd))
        .where((element) => element.nameCategory == nameCategory.name)
;
    final summa = trans.fold<double>(
        0, (previousValue, element) => previousValue + element.amount);
    return summa;
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

  List<ChartData> getDataNameTransactions(String? userName) {
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
      e.name =
          '${e.name} ${(e.summa / (s == 0 ? 1 : s) * 100).toStringAsFixed(1)}%';
    }
    return chartDataNameTransaction;
  }

  List<ChartData> getDataTypeTransactions(String? userName) {
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
      e.name =
          '${e.name} ${(e.summa / (s == 0 ? 1 : s) * 100).toStringAsFixed(1)}%';
    }
    return chartDataTypeTransaction;
  }
}
