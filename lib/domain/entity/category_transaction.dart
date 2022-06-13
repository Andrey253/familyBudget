import 'package:hive_flutter/hive_flutter.dart';

import 'package:family_budget/domain/entity/user.dart';

part 'category_transaction.g.dart';

@HiveType(typeId: 3)
class NameCategory extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String type;

  @HiveField(2)
  double? fix;
  
  @HiveField(3)
  HiveList<User>? users;
  

  NameCategory({
    required this.name,
    required this.type,
  });

  @override
  String toString() {
    return 'NameCategory(name: $name, type: $type, fix: $fix, users: $users)';
  }
}
