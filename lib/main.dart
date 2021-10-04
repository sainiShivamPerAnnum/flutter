//Flutter imports
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

//Pub imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//Project imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/back_dispatcher.dart';
import 'package:felloapp/navigator/router/route_parser.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/core/service/connectivity_service.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<DBModel>()),
        ChangeNotifierProvider(create: (_) => locator<LocalDBModel>()),
        ChangeNotifierProvider(create: (_) => locator<HttpModel>()),
        ChangeNotifierProvider(create: (_) => locator<ICICIModel>()),
        ChangeNotifierProvider(create: (_) => locator<RazorpayModel>()),
        ChangeNotifierProvider(create: (_) => locator<AugmontModel>()),
        ChangeNotifierProvider(create: (_) => locator<BaseUtil>()),
        ChangeNotifierProvider(create: (_) => locator<FcmListener>()),
        ChangeNotifierProvider(create: (_) => locator<FcmHandler>()),
        ChangeNotifierProvider(create: (_) => locator<PaymentService>()),
        ChangeNotifierProvider(create: (_) => locator<UserService>()),
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
      child: MaterialApp.router(
        title: Constants.APP_NAME,
        theme: _felloTheme(),
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
    );
  }

  ThemeData _felloTheme() {
    return ThemeData(
      primaryColor: UiConstants.primaryColor,
      primarySwatch: UiConstants.kPrimaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.montserratTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: UiConstants.primaryColor.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: UiConstants.primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
