import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/ui/pages/app_root.dart';
import 'package:felloapp/ui/pages/faq_page.dart';
import 'file:///C:/Users/shour/StudioProjects/felloapp/lib/ui/pages/tabs/home_screen.dart';
import 'package:felloapp/ui/pages/launcher_screen.dart';
import 'package:felloapp/ui/pages/login/login_controller.dart';
import 'package:felloapp/ui/pages/onboarding/onboarding_widget.dart';
import 'package:felloapp/ui/pages/settings_page.dart';
import 'package:felloapp/ui/pages/tabs/upi_screen.dart';
import 'package:felloapp/ui/pages/tabs/upi_screen_2.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => locator<DBModel>()),
        ChangeNotifierProvider(builder: (_) => locator<LocalDBModel>()),
        ChangeNotifierProvider(builder: (_) =>  locator<BaseUtil>()),
        ChangeNotifierProvider(builder: (_) =>  locator<FcmListener>()),
        ChangeNotifierProvider(builder: (_) =>  locator<FcmHandler>()),
      ],
      child: MaterialApp(
        title: Constants.APP_NAME,
        theme: ThemeData(
          primaryColor: UiConstants.primaryColor,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder> {
          '/launcher': (BuildContext context) => SplashScreen(),
          '/approot': (BuildContext context) => AppRoot(),
          '/onboarding': (BuildContext context) => OnboardingMainPage(),
          '/login': (BuildContext context) => LoginController(),
          '/gametab': (BuildContext context) => MyHomePage(title: Constants.APP_NAME),
          '/savetab': (BuildContext context) => MyHomePage(title: Constants.APP_NAME),
          '/refertab': (BuildContext context) => MyHomePage(title: Constants.APP_NAME),
          '/settings': (BuildContext context) => SettingsPage(),
          '/faq': (BuildContext context) => FAQPage(),
          '/deposit': (BuildContext context) => UpiPayment(),
        },
      ),
    );
  }
}

