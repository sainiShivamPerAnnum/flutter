import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/pages/home_screen.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      ],
      child: MaterialApp(
        title: Constants.APP_NAME,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: Constants.APP_NAME),
        routes: <String, WidgetBuilder> {
          // '/launcher': (BuildContext context) => SplashScreen(),
          // '/home': (BuildContext context) => Dashboard(onLoginRequest: (pageNo) {
          //   Navigator.push(context, MaterialPageRoute(
          //       builder: (context) => LoginController(initPage: pageNo)
          //   ));
          // }),
        },
      ),
    );
  }
}

