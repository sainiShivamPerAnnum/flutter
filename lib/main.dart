//Flutter imports
//Project imports
import 'package:device_preview/device_preview.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/leaderboard_service_enum.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/enums/user_coin_service_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/enums/winner_service_enum.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/core/service/connectivity_service.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/leaderboard_service.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/core/service/winners_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/back_dispatcher.dart';
import 'package:felloapp/navigator/router/route_parser.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/app_theme.dart';
//Pub imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

import 'core/service/user_coin_service.dart';

void main() async {
  FlavorConfig(
      flavor: Flavor.PROD,
      color: Colors.deepPurpleAccent,
      values: FlavorValues(
          awsAugmontStage: AWSAugmontStage.PROD,
          awsIciciStage: AWSIciciStage.PROD,
          freshchatStage: FreshchatStage.DEV,
          razorpayStage: RazorpayStage.PROD,
          signzyStage: SignzyStage.PROD,
          signzyPanStage: SignzyPanStage.PROD,
          baseUriUS: 'us-central1-fello-d3a9c.cloudfunctions.net',
          mixpanelToken: MixpanelService.PROD_TOKEN,
          baseUriAsia: 'asia-south1-fello-d3a9c.cloudfunctions.net',
          dynamicLinkPrefix: 'https://fello.in'));
  await mainInit();
  runApp(MyApp());
}

Future mainInit() async {
  setupLocator();

  final logger = locator<Logger>();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    logger.d("Firebase Initialised");
  } catch (e) {
    logger.e(e.toString());
  }
  FirebaseMessaging.onBackgroundMessage(FcmListener.backgroundMessageHandler);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appState = AppState();
  final parser = FelloParser();
  FelloRouterDelegate delegate;
  FelloBackButtonDispatcher backButtonDispatcher;

  _MyAppState() {
    delegate = FelloRouterDelegate(appState);
    delegate.setNewRoutePath(SplashPageConfig);
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
          ChangeNotifierProvider(create: (_) => locator<DBModel>()),
          ChangeNotifierProvider(create: (_) => locator<LocalDBModel>()),
          ChangeNotifierProvider(create: (_) => locator<HttpModel>()),
          ChangeNotifierProvider(create: (_) => locator<ICICIModel>()),
          ChangeNotifierProvider(create: (_) => locator<RazorpayModel>()),
          ChangeNotifierProvider(create: (_) => locator<AugmontModel>()),
          ChangeNotifierProvider(create: (_) => locator<BaseUtil>()),
          ChangeNotifierProvider(create: (_) => locator<FcmHandler>()),
          ChangeNotifierProvider(create: (_) => locator<PaymentService>()),
          ChangeNotifierProvider(create: (_) => locator<TransactionService>()),
          StreamProvider<ConnectivityStatus>(
            create: (_) {
              ConnectivityService connectivityService =
                  locator<ConnectivityService>();
              connectivityService.initialLoad();
              return connectivityService.connectionStatusController.stream;
            },
            initialData: ConnectivityStatus.Offline,
          ),
          ChangeNotifierProvider(create: (_) => appState),
        ],
        child: PropertyChangeProvider<LeaderboardService,
            LeaderBoardServiceProperties>(
          value: locator<LeaderboardService>(),
          child: PropertyChangeProvider<TransactionService,
              TransactionServiceProperties>(
            value: locator<TransactionService>(),
            child: PropertyChangeProvider<UserCoinService,
                UserCoinServiceProperties>(
              value: locator<UserCoinService>(),
              child: PropertyChangeProvider<UserService, UserServiceProperties>(
                value: locator<UserService>(),
                child: PropertyChangeProvider<WinnerService,
                    WinnerServiceProperties>(
                  value: locator<WinnerService>(),
                  child: MaterialApp.router(
                    locale:
                        DevicePreview.locale(context), // Add the locale here
                    builder: DevicePreview.appBuilder,
                    title: Constants.APP_NAME,
                    theme: FelloTheme.lightMode(),
                    debugShowCheckedModeBanner: false,
                    backButtonDispatcher: backButtonDispatcher,
                    routerDelegate: delegate,
                    routeInformationParser: parser,
                    localizationsDelegates: [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
