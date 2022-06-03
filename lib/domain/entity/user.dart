import 'package:hive/hive.dart';

import 'package:family_budget/domain/entity/task.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  HiveList<Task>? tasks;
    @HiveField(2)
  bool isSelected;

  User({
    required this.name,
    this.tasks,
    required this.isSelected,
  });

  void addTask(Box<Task> box, Task task) {
    tasks ??= HiveList(box);
    tasks?.add(task);
    save();
  }
}
