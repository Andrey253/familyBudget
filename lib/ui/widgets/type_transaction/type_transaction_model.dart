import 'dart:async';

import 'package:family_budget/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';
import 'package:family_budget/domain/entity/task.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';

class TypeTransactionsWidgetModel extends ChangeNotifier {
  var _types = <String>[];

  List<String> get types => _types.toList();

  void addCategory(BuildContext context) async {
    final textEditController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Введите имя категории'),
              content: TextField(controller: textEditController),
              actions: [
                TextButton(
                    onPressed: () async {
                      Hive.box<String>(HiveDbName.typeBox).add(textEditController.text);
                      Navigator.of(context).pop();
                    },
                    child: Text('Ок')),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text('Отмена'))
              ],
            ));
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.userAdd);
  }

  void showTasks(BuildContext context, int groupIndex) {
    final box = Hive.box<String>(HiveDbName.typeBox);
    final groupKey = box.keyAt(groupIndex) as int;

    unawaited(
      Navigator.of(context).pushNamed(
        MainNavigationRouteNames.userProfile,
        arguments: groupKey,
      ),
    );
  }

  void deleteGroup(int groupIndex, BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () async {
                      final box =  Hive.box<String>(HiveDbName.typeBox);
                      await box.deleteAt(groupIndex);
                      Navigator.pop(context);
                    },
                    child: Text('Удалить тип транзакции ')),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text('Отмена'))
              ],
            ));
  }
}
