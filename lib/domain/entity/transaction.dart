import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime createdDate;

  @HiveField(2)
  bool isExpense = true;

  @HiveField(3)
  double amount;
  @HiveField(4)
  String nameUser;
  @HiveField(5)
  String nameCategory;
  Transaction({
    required this.name,
    required this.createdDate,
    required this.isExpense,
    required this.amount,
    required this.nameUser,
    required this.nameCategory,
  });
}
