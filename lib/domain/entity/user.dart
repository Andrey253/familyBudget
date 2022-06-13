import 'package:hive/hive.dart';


part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  String name;

    @HiveField(2)
  double? fix;

  User({
    required this.name,

    required this.fix,
  });


}
