import 'package:hive_flutter/hive_flutter.dart';

part 'category_transaction.g.dart';

@HiveType(typeId: 3)
class NameCategory extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String type;

  @HiveField(2)
  double? fix;

  NameCategory({
    required this.name,
    required this.type,
  });

  // void addTask(Box<Task> box, Task task) {
  //   tasks ??= HiveList(box);
  //   tasks?.add(task);
  //   save();
  // }

  @override
  String toString() => 'CategoryTransaction(name: $name, type: $type)';
}
