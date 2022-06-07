import 'package:hive_flutter/hive_flutter.dart';

part 'category_transaction.g.dart';

@HiveType(typeId: 3)
class CategoryTransaction extends HiveObject {
  @HiveField(0)
  String nameCategory;

  @HiveField(1)
  String type;

  @HiveField(2)
  String? keyAt;

  CategoryTransaction({
    required this.nameCategory,
    required this.type,
    required this.keyAt,
  });

  // void addTask(Box<Task> box, Task task) {
  //   tasks ??= HiveList(box);
  //   tasks?.add(task);
  //   save();
  // }

  @override
  String toString() => 'CategoryTransaction(name: $nameCategory, type: $type, keyAt: $keyAt)';
}
