import 'package:family_budget/ui/widgets/general_widgets/drawer_report.dart';
import 'package:family_budget/ui/widgets/reports/category/category_report.dart';
import 'package:family_budget/ui/widgets/reports/income_expenses/income_expenses_report.dart';
import 'package:family_budget/ui/widgets/reports/report_model.dart';
import 'package:family_budget/ui/widgets/reports/transaction/transaction_report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({Key? key, this.nameUser, required this.initialPage})
      : super(key: key);

  final String? nameUser;
  final int initialPage;
  @override
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReportModel(nameUser: widget.nameUser ?? ''),
      child: ReportBodyWidget(
        initialPage: widget.initialPage,
      ),
    );
  }
}

class ReportBodyWidget extends StatefulWidget {
  const ReportBodyWidget({Key? key, required this.initialPage})
      : super(key: key);

  final int initialPage;
  @override
  State<ReportBodyWidget> createState() => _ReportBodyWidgetState();
}

class _ReportBodyWidgetState extends State<ReportBodyWidget> {
  int selected = 0;
  int indPage = 0;
  late PageController pageController;
  List<Widget> listWigget = [];
  @override
  void initState() {
    listWigget = const [TransactionListMain(),CategoryReportWidget(), IncomeExpensesReportWidget()];
    pageController = PageController(initialPage: widget.initialPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerReport(selectReport: changePage),
      appBar: appBar(context),
      body: PageView(
        controller: pageController,
        children: listWigget,
        // onPageChanged: (i) => indPage = i,
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: BackButton(
        onPressed: () => Navigator.pop(context, false),
      ),
      actions: [
        Builder(
            builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu)))
      ],
      title: const Text('Отчет'),
    );
  }

  changePage(int i, [String? usrerName]) async {
    indPage = i;
    await pageController.animateToPage(i,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }
}
