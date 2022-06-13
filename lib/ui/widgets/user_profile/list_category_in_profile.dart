import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/user_profile/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
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

    return ValueListenableBuilder<Box<Transaction>>(
        valueListenable:
            Hive.box<Transaction>(HiveDbName.transactionBox).listenable(),
        builder: (context, box, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: size.width / 2),
                  shrinkWrap: true,
                  children: model.listCategory
                      .map((e) => Card(
                          elevation: 8,
                          child: categoryTransactionItem(model, e, context)))
                      .toList()),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: model.listCategory.length,
                  itemBuilder: (context, index) => Card(
                        elevation: 8,
                        child: ListTile(
                          trailing: IconButton(
                              onPressed: () => model.addTransaction(
                                  context, model.listCategory[index]),
                              icon: const Icon(Icons.add)),
                          leading: Text(model.listCategory[index].type),
                          title: TextButton(
                              onPressed: () => {},
                              child: Text(
                                  '${model.listCategory[index].name} ${model.listCategory[index].type}')),
                        ),
                      )),
            ],
          );
        });
  }
}

Widget categoryTransactionItem(
    UserProfileModel model, NameCategory nameCategory, BuildContext context) {
  final TextEditingController textEditingController = TextEditingController();

  final date = DateTime.now();
  final dateStart = DateTime(date.year, date.month);
  final dateEnd = DateTime(date.year, date.month + 1);
  final trans = Hive.box<Transaction>(HiveDbName.transactionBox)
      .values
      .where((e) => e.createdDate.isAfter(dateStart))
      .where((e) => e.createdDate.isBefore(dateEnd))
      .where((element) => element.nameCategory == nameCategory.name);
  final summ = trans.fold<double>(
      0, (previousValue, element) => previousValue + element.amount);

  return Column(
    children: [
      Text(
        (nameCategory.fix ?? '-- -').toString(),
        style: nameCategory.fix != null && nameCategory.fix! < summ
            ? const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
            : const TextStyle(),
      ),
      TextButton(
          onPressed: () {},
          child: Text(
            nameCategory.name,
            style: TextStyle(
                color: nameCategory.type == TypeTransaction.expense
                    ? Colors.red
                    : Colors.green),
          )),
      Text((summ.toString())),
      TextButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: TextField(controller: textEditingController),
                    actions: [buildCancel(context),buildSave()],
                  )),
          child: Text(
            'Фиксировать ${nameCategory.type}',
            style: TextStyle(
                color: nameCategory.type == TypeTransaction.expense
                    ? Colors.red
                    : Colors.green),
          )),
    ],
  );
}

Widget buildSave() {
  return TextButton(onPressed: () {}, child: const Text('Save'));
}
Widget buildCancel(BuildContext context) {
  return TextButton(onPressed: () {Navigator.pop(context);}, child: const Text('Cancel'));
 
}
