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

  @HiveField(6)
   String typeTransaction;
  Transaction({
    required this.name,
    required this.createdDate,
    required this.isExpense,
    required this.amount,
    required this.nameUser,
    required this.nameCategory,
    required this.typeTransaction,
  });

  @override
  String toString() {
    return 'Transaction(name: $name, createdDate: $createdDate, isExpense: $isExpense, amount: $amount, nameUser: $nameUser, nameCategory: $nameCategory, typeTransaction: $typeTransaction)';
  }


}
