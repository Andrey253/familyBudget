
import 'package:family_budget/extentions.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/indicators/indicator_name.dart';
import 'package:family_budget/ui/widgets/indicators/indicator_type.dart';
import 'package:family_budget/ui/widgets/main/drawer_main.dart';
import 'package:family_budget/ui/widgets/type_transaction/list_category_transaction.dart';
import 'package:family_budget/ui/widgets/type_transaction/select_period_main.dart';
import 'package:family_budget/ui/widgets/type_transaction/type_transactions_widget.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //final model = GroupsWidgetModel();

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        drawer: const DrawerMain(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Builder(
                builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon:const Icon(Icons.menu)))
          ],
          title: const Text('Члены семьи'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: const [
              _UserListWidget(),
              Text('Типы транзакций'),
              TypeTransactionWidget(),
              CategoryTransaction(),
              SelectPeriodMain(),
              IndicatorFamalyBudget(),
              IndicatorPerson(),
              // TransactionList(typeTransaction: TypeTransaction.all)
            ],
          ),
        ),
      ),
    );
  }
}

class _UserListWidget extends StatelessWidget {
  const _UserListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<User>>(
      valueListenable: Hive.box<User>(HiveDbName.userBox).listenable(),
      builder: (context, box, _) {
        final users = box.values.toList().cast<User>();
        return SizedBox(
          height: 70,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length,
                    itemBuilder: (context, index) => GestureDetector(
                          onLongPress: () => context
                              .read<MainModel>()
                              .deleteUser(index, context),
                          onTap: () => context
                              .read<MainModel>()
                              .showTasks(context, index),
                          child: Container(
                            width: 70,
                            decoration: BoxDecoration(
                              //  color: Colors.primaries[index],
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Colors.primaries[index % 18],
                                Colors.primaries[(index * 2 + 1) % 18]
                              ]),
                            ),
                            // color: Colors.red,
                            child: Center(
                              child: Text(users[index].name),
                            ),
                          ).paddingAll(4),
                        )),
              ),
              GestureDetector(
                onTap: () => context.read<MainModel>().showForm(context),
                child: Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    // color: Colors.primaries[9],
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [Colors.primaries[10], Colors.primaries[12]]),
                  ),
                  // color: Colors.red,
                  child: const Center(
                      child: Text('Добавить члена семьи',
                          textAlign: TextAlign.center)),
                ),
              ).paddingAll(4),
            ],
          ),
        );
      },
    );
  }
}
