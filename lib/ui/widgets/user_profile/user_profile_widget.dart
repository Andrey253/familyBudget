import 'package:family_budget/ui/widgets/indicators/indicator_name.dart';
import 'package:family_budget/ui/widgets/indicators/indicator_type.dart';
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
    return Scaffold(
      drawer: Drawer(
          child: TextButton.icon(
              onPressed: () {}, icon:const Icon(Icons.add), label:const Text('First'))),
      appBar: AppBar(
        actions: [
          Builder(
              builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon:const Icon(Icons.menu)))
        ],
        leading: BackButton(
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TypeInUserProfile(),
            const ListCategoryInProfile(),
            const SelectPeriod(),
            IndicatorFamalyBudget(userName: model.user?.name),
            IndicatorPerson(userName: model.user?.name),
          ],
        ),
      ),
    );
  }
}

