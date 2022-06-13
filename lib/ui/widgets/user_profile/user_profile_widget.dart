import 'package:family_budget/domain/entity/cilcle_diagramm.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/ui/widgets/indicators/indicator_name.dart';
import 'package:family_budget/ui/widgets/indicators/indicator_type.dart';
import 'package:family_budget/ui/widgets/reports/transaction_list_main.dart';
import 'package:family_budget/ui/widgets/user_profile/list_category_in_profile.dart';
import 'package:family_budget/ui/widgets/user_profile/select_period.dart';
import 'package:family_budget/ui/widgets/user_profile/type_in_user_widget.dart';
import 'package:family_budget/ui/widgets/user_profile/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileWidget extends StatefulWidget {
  final int userKey;
  const UserProfileWidget({
    Key? key,
    required this.userKey,
  }) : super(key: key);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProfileModel(userKey: widget.userKey),
      child: const UserProfileWidgetBody(),
    );
  }
}

class UserProfileWidgetBody extends StatelessWidget {
  const UserProfileWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserProfileModel>();
    final title = model.user?.name ?? '';

    return SafeArea(
      child: Scaffold(
        drawer: _Drawer(model: model),
        appBar: appBar(context, title),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const TypeInUserProfile(),
              const ListCategoryInProfile(),
              const SelectPeriod(),
              CircleDiagramm(chartData: model.getDataTypeTransactions(title)),
              CircleDiagramm(chartData: model.getDataNameTransactions(title)),
              IndicatorName(userName: model.user?.name),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context, String title) {
    return AppBar(
      actions: [
        Builder(
            builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu)))
      ],
      leading: BackButton(
        onPressed: () => Navigator.pop(context, false),
      ),
      title: Text(title),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({
    Key? key,
    required this.model,
  }) : super(key: key);

  final UserProfileModel model;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        TextButton.icon(
            onPressed: () {
              Navigator.pop(context);

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TransactionListMain(
                    typeTransaction: TypeTransaction.all,
                    userName: model.user?.name);
              }));
            },
            icon: const Icon(Icons.add),
            label: const Text('Все операции')),
      ],
    ));
  }
}
