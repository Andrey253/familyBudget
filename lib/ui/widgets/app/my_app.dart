import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final mainNavigation = MainNavigation();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>MainModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        routes: mainNavigation.routes,
        onGenerateRoute: mainNavigation.onGenerateRoute,
        initialRoute: mainNavigation.initialRoute,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
