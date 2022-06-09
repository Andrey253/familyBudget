import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late DateTime createdDate;

  @HiveField(2)
  late bool isExpense = true;

  @HiveField(3)
  late double amount;

  @HiveField(4)
  late String nameUser;

  @HiveField(5)
  late String nameCategory;

  @HiveField(6)
  late String typeTransaction;

  @override
  String toString() {
    return 'Transaction(name: $name, createdDate: $createdDate, isExpense: $isExpense, amount: $amount, nameUser: $nameUser, nameCategory: $nameCategory, typeTransaction: $typeTransaction)';
  }

  Transaction copyWith({
    String? name,
    DateTime? createdDate,
    bool? isExpense,
    double? amount,
    String? nameUser,
    String? nameCategory,
    String? typeTransaction,
  }) {
    return Transaction()
      ..name = name ?? this.name
      ..createdDate = createdDate ?? this.createdDate
      ..isExpense = isExpense ?? this.isExpense
      ..amount = amount ?? this.amount
      ..nameUser = nameUser ?? this.nameUser
      ..nameCategory = nameCategory ?? this.nameCategory
      ..typeTransaction = typeTransaction ?? this.typeTransaction;
  }
}
