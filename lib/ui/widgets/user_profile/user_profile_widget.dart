import 'package:family_budget/ui/navigation/main_navigation.dart';
import 'package:family_budget/ui/widgets/indicators/cilcle_diagramm.dart';
import 'package:family_budget/ui/widgets/general_widgets/drawer_report.dart';

import 'package:family_budget/ui/widgets/general_widgets/select_period.dart';
import 'package:family_budget/ui/widgets/user_profile/list_category_in_profile.dart';
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

    void selectReport(int i, [String? userName]) {
      Navigator.pushNamed(context, MainNavigationRouteNames.reports,
          arguments: [userName, i]);
    }

    return SafeArea(
      child: Scaffold(
        drawer: DrawerReport(selectReport: selectReport, userName: model.user?.name),
        appBar: appBar(context, title),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const TypeInUserProfile(),
              const ListCategoryInProfile(),
              SelectPeriod(
                  setDateTimeRange: model.setDateTimeRange,
                  start: model.start,
                  end: model.end),
              CircleDiagramm(chartData: model.getDataTypeTransactions(title)),
              CircleDiagramm(chartData: model.getDataNameTransactions(title)),
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
