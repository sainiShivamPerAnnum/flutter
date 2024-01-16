import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/core/service/notifier_services/connectivity_service.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/back_dispatcher.dart';
import 'package:felloapp/navigator/router/route_parser.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/hometabs/home/card_actions_notifier.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

import 'core/service/notifier_services/user_coin_service.dart';

class MyApp extends HookWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = useMemoized(AppState.new);
    final parser = useMemoized(FelloParser.new);
    final delegate = useMemoized(() => FelloRouterDelegate(appState));

    final backButtonDispatcher =
        useMemoized(() => FelloBackButtonDispatcher(delegate));

    useEffect(() {
      AppState.backButtonDispatcher = backButtonDispatcher;
      AppState.delegate = delegate;
      delegate.setNewRoutePath(SplashPageConfig);
      return null;
    }, []);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
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
          ChangeNotifierProvider(create: (_) => locator<SubService>()),
          ChangeNotifierProvider(create: (_) => locator<BankAndPanService>()),
          ChangeNotifierProvider(create: (_) => locator<TambolaService>()),
          ChangeNotifierProvider(
              create: (_) => locator<AugmontTransactionService>()),
          ChangeNotifierProvider(
              create: (_) => locator<LendboxTransactionService>()),
          ChangeNotifierProvider(create: (_) => locator<PowerPlayService>()),
          ChangeNotifierProvider(
            create: (_) => locator<ScratchCardService>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<CardActionsNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<LendboxMaturityService>(),
          ),
        ],
        child: PropertyChangeProvider<UserService, UserServiceProperties>(
          value: locator<UserService>(),
          child: MaterialApp.router(
            title: Constants.APP_NAME,
            theme: FelloTheme.darkMode(),
            debugShowCheckedModeBanner: false,
            backButtonDispatcher: backButtonDispatcher,
            routerDelegate: delegate,
            routeInformationParser: parser,
            localizationsDelegates: const [
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
