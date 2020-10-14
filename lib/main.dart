import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/pages/home_screen.dart';
import 'package:felloapp/ui/pages/launcher_screen.dart';
import 'package:felloapp/ui/pages/onboarding/onboarding_widget.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_util.dart';
import 'core/ops/lcl_db_ops.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => locator<DBModel>()),
        ChangeNotifierProvider(builder: (_) => locator<LocalDBModel>()),
        ChangeNotifierProvider(builder: (_) =>  locator<BaseUtil>()),
      ],
      child: MaterialApp(
        title: Constants.APP_NAME,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder> {
          '/home': (BuildContext context) => MyHomePage(title: Constants.APP_NAME),
          '/onboarding': (BuildContext context) => OnboardingMainPage(),
          '/login': (BuildContext context) => LoginController(),
        },
      ),
    );
  }
}

