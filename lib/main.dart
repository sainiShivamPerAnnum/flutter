// import 'package:device_preview/device_preview.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/fcm/background_fcm_handler.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/connectivity_service.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/back_dispatcher.dart';
import 'package:felloapp/navigator/router/route_parser.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/app_theme.dart';
//Pub imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

import 'core/service/notifier_services/user_coin_service.dart';

Future mainInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  try {
    await PreferenceHelper.initiate();

    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialisation error: $e');
  }
  FirebaseMessaging.onBackgroundMessage(
      BackgroundFcmHandler.myBackgroundMessageHandler);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appState = AppState();
  final parser = FelloParser();
  FelloRouterDelegate? delegate;
  FelloBackButtonDispatcher? backButtonDispatcher;

  @override
  void initState() {
    super.initState();
  }

  _MyAppState() {
    delegate = FelloRouterDelegate(appState);
    delegate!.setNewRoutePath(SplashPageConfig);
    backButtonDispatcher = FelloBackButtonDispatcher(delegate);
    AppState.backButtonDispatcher = backButtonDispatcher;
    AppState.delegate = delegate;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => locator<ConnectivityService>()),
          ChangeNotifierProvider(create: (_) => locator<DBModel>()),
          ChangeNotifierProvider(create: (_) => locator<BaseUtil>()),
          ChangeNotifierProvider(create: (_) => appState),
          ChangeNotifierProvider(create: (_) => locator<JourneyService>()),
          ChangeNotifierProvider(create: (_) => locator<LeaderboardService>()),
          ChangeNotifierProvider(create: (_) => locator<TxnHistoryService>()),
          ChangeNotifierProvider(create: (_) => locator<UserCoinService>()),
          ChangeNotifierProvider(create: (_) => locator<WinnerService>()),
          ChangeNotifierProvider(create: (_) => locator<UserService>()),
          ChangeNotifierProvider(create: (_) => locator<ReferralService>()),
          ChangeNotifierProvider(create: (_) => locator<SubscriptionService>()),
          ChangeNotifierProvider(
              create: (_) => locator<AugmontTransactionService>()),
          ChangeNotifierProvider(
              create: (_) => locator<LendboxTransactionService>()),
        ],
        child: PropertyChangeProvider<UserService, UserServiceProperties>(
          value: locator<UserService>(),
          child: MaterialApp.router(
            title: Constants.APP_NAME,
            theme: FelloTheme.darkMode(),
            useInheritedMediaQuery: true,
            debugShowCheckedModeBanner: false,
            backButtonDispatcher: backButtonDispatcher,
            routerDelegate: delegate!,
            routeInformationParser: parser,
            // showPerformanceOverlay: true,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: S.delegate.supportedLocales,
          ),
        ),
      ),
    );
  }
}




//TODO:
//Save screen
//Download Invoice for fello
//QR code module
//Remove 