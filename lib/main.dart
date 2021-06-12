import 'dart:async';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/core/ops/kyc_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/back_dispatcher.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/navigator/router/route_parser.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/hamburger/faq_page.dart';
import 'package:felloapp/ui/pages/hamburger/referral_policy_page.dart';
import 'package:felloapp/ui/pages/hamburger/tnc_page.dart';
import 'package:felloapp/ui/pages/launcher_screen.dart';
import 'package:felloapp/ui/pages/login/login_controller.dart';
import 'package:felloapp/ui/pages/onboarding/getstarted/get_started_page.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/icici_onboard_controller.dart';
import 'package:felloapp/ui/pages/onboarding/icici/kyc_invalid.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/interface/kyc_onboarding_interface.dart';
import 'package:felloapp/ui/pages/root.dart';
import 'package:felloapp/ui/pages/tabs/profile/edit_profile_page.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
FelloRouterDelegate delegate;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appState = AppState();
  final parser = FelloParser();
  FelloBackButtonDispatcher backButtonDispatcher;

  _MyAppState() {
    delegate = FelloRouterDelegate(appState);
    delegate.setNewRoutePath(SplashPageConfig);
    backButtonDispatcher = FelloBackButtonDispatcher(delegate);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<DBModel>()),
        ChangeNotifierProvider(create: (_) => locator<LocalDBModel>()),
        ChangeNotifierProvider(create: (_) => locator<HttpModel>()),
        ChangeNotifierProvider(create: (_) => locator<ICICIModel>()),
        ChangeNotifierProvider(create: (_) => locator<KYCModel>()),
        ChangeNotifierProvider(create: (_) => locator<RazorpayModel>()),
        ChangeNotifierProvider(create: (_) => locator<AugmontModel>()),
        ChangeNotifierProvider(create: (_) => locator<BaseUtil>()),
        ChangeNotifierProvider(create: (_) => locator<FcmListener>()),
        ChangeNotifierProvider(create: (_) => locator<FcmHandler>()),
        ChangeNotifierProvider(create: (_) => locator<PaymentService>()),
        ChangeNotifierProvider(create: (_) => appState),
      ],
      child: MaterialApp.router(
        title: Constants.APP_NAME,
        theme: ThemeData(
            primaryColor: UiConstants.primaryColor,
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.montserratTextTheme()),
        debugShowCheckedModeBanner: false,
        backButtonDispatcher: backButtonDispatcher,
        routerDelegate: delegate,
        routeInformationParser: parser,

        // home: SplashScreen(),
        //onGenerateRoute: generateRoute,
        // routes: <String, WidgetBuilder>{
        //   '/launcher': (BuildContext context) => SplashScreen(),
        //   '/approot': (BuildContext context) => Root(),
        //   '/onboarding': (BuildContext context) => GetStartedPage(),
        //   '/login': (BuildContext context) => LoginController(),
        //   '/faq': (BuildContext context) => FAQPage(),
        //   '/tnc': (BuildContext context) => TnC(),
        //   '/refpolicy': (BuildContext context) => ReferralPolicy(),
        //   '/verifykyc': (BuildContext context) => KycOnboardInterface(),
        //   '/onboardicici': (BuildContext context) => IciciOnboardController(),
        //   '/initkyc': (BuildContext context) => KYCInvalid(),
        //   '/editProf': (BuildContext context) => EditProfile()
        // },
      ),
    );
  }
}
