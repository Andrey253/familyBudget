import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/extentions.dart';
import 'package:family_budget/ui/widgets/user_profile/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCategoryInProfile extends StatefulWidget {
  const ListCategoryInProfile({Key? key}) : super(key: key);

  @override
  State<ListCategoryInProfile> createState() => _ListCategoryInProfileState();
}

class _ListCategoryInProfileState extends State<ListCategoryInProfile> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserProfileModel>();
    final size = MediaQuery.of(context).size;

    return GridView(
        primary: false,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: size.width / 2, childAspectRatio: 1.2),
        shrinkWrap: true,
        children: model.listCategory
            .map((e) => Card(
                elevation: 8,
                child: categoryTransactionItem(model, e, context)))
            .toList());
  }
}

Widget categoryTransactionItem(
    UserProfileModel model, NameCategory nameCategory, BuildContext context) {
  final TextEditingController textEditingController = TextEditingController();
  final userName = model.user!.name;
  Widget buildSaveLimit() {
    return TextButton(
        onPressed: () =>
            model.saveLimit(nameCategory, context, textEditingController),
        child: const Text('Save'));
  }

  Widget buildCancel() {
    return TextButton(
        onPressed: () => Navigator.pop(context), child: const Text('Cancel'));
  }

  model.getSummOfUser(nameCategory);
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
          (nameCategory.fix == null
                  ? 'Нет ограничений в семейном бюджете'
                  : 'Ограничение в семейном бюджете ${nameCategory.fix}')
              .toString(),
          style: nameCategory.fix != null &&
                  nameCategory.fix! < model.summaOfUser
              ? const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
              : const TextStyle(),
          textAlign: TextAlign.center),
      Row(
        children: [
          Text(nameCategory.name,
                  style: TextStyle(
                      shadows: const [Shadow(offset: Offset(0.5, 0.5))],
                      color: nameCategory.type == TypeTransaction.expense
                          ? Colors.red
                          : Colors.green))
              .paddingAll(6),
          Expanded(
              child: Text(model.summaOfUser.toString(),
                      style: const TextStyle(overflow: TextOverflow.ellipsis))
                  .paddingAll(6)),
        ],
      ),
      Container(
        color: Colors.green,
        child: IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => model.addTransaction(context, nameCategory),
            icon: const Icon(Icons.add)),
      ),
      TextButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: TextField(
                        keyboardType: TextInputType.number,
                        controller: textEditingController,
                        autofocus: true),
                    actions: [buildCancel(), buildSaveLimit()],
                  )),
          child: Text(
              nameCategory.users?[userName] == null
                  ? 'Нет ограничений'
                  : 'Личное оганичение ${nameCategory.users?[userName].toString()}',
              style: TextStyle(
                  color: nameCategory.users?[userName] != null &&
                          model.summaOfUser > nameCategory.users![userName]!
                      ? Colors.red
                      : Colors.green),
              textAlign: TextAlign.center)),
    ],
  );
}
