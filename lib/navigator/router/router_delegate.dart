//Project Imports
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/hamburger/chatsupport_page.dart';
import 'package:felloapp/ui/pages/hamburger/faq_page.dart';
import 'package:felloapp/ui/pages/hamburger/freshdesk_help.dart';
import 'package:felloapp/ui/pages/hamburger/referral_policy_page.dart';
import 'package:felloapp/ui/pages/hamburger/support.dart';
import 'package:felloapp/ui/pages/login/login_controller_view.dart';
import 'package:felloapp/ui/pages/notifications/notifications_view.dart';
import 'package:felloapp/ui/pages/onboarding/blocked_user.dart';
import 'package:felloapp/ui/pages/onboarding/getstarted/autosave_walkthrough.dart';
import 'package:felloapp/ui/pages/onboarding/getstarted/walkthrough_page.dart';
import 'package:felloapp/ui/pages/onboarding/update_screen.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/all_participants.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_details/augmont_gold_details_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/augmont_gold_sell_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/edit_augmont_bank_details.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/gold_balance_details/gold_balance_details_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_details_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_transaction/autopay_transactions_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/user_autopay_details/user_autopay_details_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/dailyPicksDraw/dailyPicksDraw_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/show_all_tickets.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_game/tambola_game_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_walkthrough.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/weekly_result.dart';
import 'package:felloapp/ui/pages/others/games/web/web_home/web_home_view.dart';
import 'package:felloapp/ui/pages/others/profile/bank_details/bank_details_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_view.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_view.dart';
import 'package:felloapp/ui/pages/others/profile/referrals/referral_details/referral_details_view.dart';
import 'package:felloapp/ui/pages/others/profile/referrals/referral_history/referral_history_view.dart';
import 'package:felloapp/ui/pages/others/profile/transactions_history/transactions_history_view.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_view.dart';
import 'package:felloapp/ui/pages/others/profile/verify_email.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_milestones/golden_milestones_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_card/gt_detailed_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_tickets/golden_tickets_view.dart';
import 'package:felloapp/ui/pages/root/root_view.dart';
import 'package:felloapp/ui/pages/splash/splash_view.dart';
import 'package:felloapp/ui/pages/static/poolview.dart';
import 'package:felloapp/ui/pages/static/transactions_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
//Flutter Imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FelloRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final _analytics = locator<AnalyticsService>();

  final List<Page> _pages = [];

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  BaseUtil _baseUtil = locator<BaseUtil>(); //required to fetch client token
  final AppState appState;

  FelloRouterDelegate(this.appState) : navigatorKey = GlobalKey() {
    appState.addListener(() {
      notifyListeners();
    });
  }

  List<MaterialPage> get pages => List.unmodifiable(_pages);

  int numPages() => _pages.length;

  @override
  PageConfiguration get currentConfiguration =>
      _pages.last.arguments as PageConfiguration;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: buildPages(),
    );
  }

  bool _onPopPage(Route<dynamic> route, result) {
    // 1
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    // 2
    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

  void pop() {
    if (canPop()) {
      _removePage(_pages.last);
    }
  }

  bool canPop() {
    return _pages.length > 1;
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(_pages.last);
      print("Current Stack: ${AppState.screenStack}");
      notifyListeners();
      return Future.value(true);
    }
    notifyListeners();
    return Future.value(false);
  }

  void _removePage(MaterialPage page) {
    if (page != null) {
      AppState.screenStack.removeLast();
      _pages.remove(page);
    }
  }

  MaterialPage _createPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
      child: child,
      key: Key(pageConfig.key),
      name: pageConfig.path,
      arguments: pageConfig,
    );
  }

  void _addPageData(Widget child, PageConfiguration pageConfig) {
    AppState.screenStack.add(ScreenItem.page);
    print("Added a page ${pageConfig.key}");
    log("Current Stack: ${AppState.screenStack}");
    _analytics.trackScreen(screen: pageConfig.name);
    _pages.add(
      _createPage(child, pageConfig),
    );
    //notifyListeners();
  }

  void addPage(PageConfiguration pageConfig) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            pageConfig.uiPage;

    if (shouldAddPage) {
      switch (pageConfig.uiPage) {
        case Pages.Splash:
          _addPageData(LauncherView(), SplashPageConfig);
          break;
        case Pages.Login:
          _addPageData(LoginControllerView(), LoginPageConfig);
          break;
        case Pages.Root:
          _addPageData(Root(), RootPageConfig);
          break;
        case Pages.UserProfileDetails:
          _addPageData(UserProfileDetails(), UserProfileDetailsConfig);
          break;

        case Pages.Transaction:
          _addPageData(Transactions(), TransactionPageConfig);
          break;
        case Pages.TxnHistory:
          _addPageData(TransactionsHistory(), TransactionsHistoryPageConfig);
          break;
        case Pages.KycDetails:
          _addPageData(KYCDetailsView(), KycDetailsPageConfig);
          break;
        case Pages.BankDetails:
          _addPageData(BankDetailsView(), BankDetailsPageConfig);
          break;
        case Pages.Faq:
          _addPageData(FAQPage(), FaqPageConfig);
          break;
        case Pages.EditAugBankDetails:
          _addPageData(EditAugmontBankDetail(), EditAugBankDetailsPageConfig);
          break;

        case Pages.UpdateRequired:
          _addPageData(UpdateRequiredScreen(), UpdateRequiredConfig);
          break;
        case Pages.RefPolicy:
          _addPageData(ReferralPolicy(), RefPolicyPageConfig);
          break;
        case Pages.ChatSupport:
          _addPageData(ChatSupport(), ChatSupportPageConfig);
          break;
        case Pages.VerifyEmail:
          _addPageData(VerifyEmail(), VerifyEmailPageConfig);
          break;
        case Pages.Support:
          _addPageData(SupportPage(), SupportPageConfig);
          break;

        case Pages.THome:
          _addPageData(TambolaHomeView(), THomePageConfig);
          break;
        case Pages.TGame: //
          _addPageData(TambolaGameView(), TGamePageConfig);
          break;
        case Pages.TPickDraw:
          _addPageData(PicksDraw(), TPickDrawPageConfig);
          break;
        case Pages.TShowAllTickets:
          _addPageData(ShowAllTickets(), TShowAllTicketsPageConfig);
          break;
        case Pages.TWalkthrough:
          _addPageData(Walkthrough(), TWalkthroughPageConfig);
          break;
        case Pages.AutosaveWalkthrough:
          _addPageData(AutosaveWalkthrough(), AutosaveWalkThroughConfig);
          break;
        case Pages.TWeeklyResult:
          _addPageData(WeeklyResult(), TWeeklyResultPageConfig);
          break;
        case Pages.Notifications:
          _addPageData(NotficationsPage(), NotificationsConfig);
          break;
        case Pages.AugGoldSell:
          _addPageData(AugmontGoldSellView(), AugmontGoldSellPageConfig);
          break;
        case Pages.AugGoldDetails:
          _addPageData(AugmontGoldDetailsView(), AugmontGoldDetailsPageConfig);
          break;
        case Pages.ReferralDetails:
          _addPageData(ReferralDetailsView(), ReferralDetailsPageConfig);
          break;
        case Pages.ReferralHistory:
          _addPageData(ReferralHistoryView(), ReferralHistoryPageConfig);
          break;
        case Pages.MyWinnings:
          _addPageData(MyWinningsView(), MyWinnigsPageConfig);
          break;
        case Pages.BlockedUser:
          _addPageData(BlockedUserView(), BlockedUserPageConfig);
          break;
        case Pages.FreshDeskHelp:
          _addPageData(FreshDeskHelp(), FreshDeskHelpPageConfig);
          break;
        case Pages.GoldenTicketView:
          _addPageData(GTDetailedView(), GoldenTicketViewPageConfig);
          break;
        case Pages.GoldenTicketsView:
          _addPageData(GoldenTicketsView(), GoldenTicketsViewPageConfig);
          break;
        case Pages.GoldenMilestonesView:
          _addPageData(GoldenMilestonesView(), GoldenMilestonesViewPageConfig);
          break;
        case Pages.TopSaverView:
          _addPageData(TopSaverView(), TopSaverViewPageConfig);
          break;
        case Pages.AllParticipantsView:
          _addPageData(AllParticipantsView(), AllParticipantsViewPageConfig);
          break;
        case Pages.GoldBalanceDetailsView:
          _addPageData(
              GoldBalanceDetailsView(), GoldBalanceDetailsViewPageConfig);
          break;
        // case Pages.WebHomeView:
        //   _addPageData(WebHomeView(), WebHomeViewPageConfig);
        //   break;
        // case Pages.WebGameView:
        //   _addPageData(WebGameView(), WebGameViewPageConfig);
        //   break;
        // case Pages.PoolView:
        //   _addPageData(PoolView(), PoolViewPageConfig);
        case Pages.AutosaveDetailsView:
          _addPageData(AutosaveDetailsView(), AutosaveDetailsViewPageConfig);
          break;
        case Pages.AutosaveProcessView:
          _addPageData(AutosaveProcessView(), AutosaveProcessViewPageConfig);
          break;
        case Pages.UserAutosaveDetailsView:
          _addPageData(
              UserAutosaveDetailsView(), UserAutosaveDetailsViewPageConfig);
          break;
        case Pages.AutosaveTransactionsView:
          _addPageData(
              AutosaveTransactionsView(), AutosaveTransactionsViewPageConfig);
          break;
        default:
          break;
      }
    }
  }

// 1
  void replace(PageConfiguration newRoute) {
    if (_pages.isNotEmpty) {
      AppState.screenStack.removeLast();
      _pages.removeLast();
    }
    addPage(newRoute);
  }

// 2
  void setPath(List<MaterialPage> path) {
    _pages.clear();
    AppState.screenStack.clear();
    _pages.addAll(path);
    notifyListeners();
  }

// 3
  void replaceAll(PageConfiguration newRoute) {
    setNewRoutePath(newRoute);
  }

// 4
  void push(PageConfiguration newRoute) {
    addPage(newRoute);
  }

// 5
  void pushWidget(Widget child, PageConfiguration newRoute) {
    _addPageData(child, newRoute);
  }

// 6
  void addAll(List<PageConfiguration> routes) {
    routes.forEach((route) {
      addPage(route);
    });
  }

  // 7
  void replaceWidget(Widget child, PageConfiguration newRoute) {
    if (_pages.isNotEmpty) {
      AppState.screenStack.removeLast();
      _pages.removeLast();
    }
    _addPageData(child, newRoute);
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            configuration.uiPage;
    if (shouldAddPage) {
      _pages.clear();
      AppState.screenStack.clear();
      addPage(configuration);
    }
    return SynchronousFuture(null);
  }

  void _setPageAction(PageAction action) {
    switch (action.page.uiPage) {
      case Pages.Splash:
        SplashPageConfig.currentPageAction = action;
        break;
      case Pages.Login:
        LoginPageConfig.currentPageAction = action;
        break;
      case Pages.Onboard:
        OnboardPageConfig.currentPageAction = action;
        break;
      case Pages.Root:
        RootPageConfig.currentPageAction = action;
        break;
      case Pages.UserProfileDetails:
        UserProfileDetailsConfig.currentPageAction = action;
        break;
      case Pages.MfDetails:
        MfDetailsPageConfig.currentPageAction = action;
        break;
      case Pages.AugDetails:
        AugDetailsPageConfig.currentPageAction = action;
        break;
      case Pages.Transaction:
        TransactionPageConfig.currentPageAction = action;
        break;
      case Pages.TxnHistory:
        TransactionsHistoryPageConfig.currentPageAction = action;
        break;
      case Pages.KycDetails:
        KycDetailsPageConfig.currentPageAction = action;
        break;
      case Pages.BankDetails:
        BankDetailsPageConfig.currentPageAction = action;
        break;

      case Pages.Referral:
        ReferralPageConfig.currentPageAction = action;
        break;
      case Pages.Faq:
        FaqPageConfig.currentPageAction = action;
        break;
      case Pages.AugOnboard:
        AugOnboardPageConfig.currentPageAction = action;
        break;
      case Pages.AugWithdrawal:
        AugWithdrawalPageConfig.currentPageAction = action;
        break;
      case Pages.EditAugBankDetails:
        EditAugBankDetailsPageConfig.currentPageAction = action;
        break;

      case Pages.RefPolicy:
        RefPolicyPageConfig.currentPageAction = action;
        break;
      case Pages.ChatSupport:
        ChatSupportPageConfig.currentPageAction = action;
        break;
      case Pages.ClaimUsername:
        ClaimUsernamePageConfig.currentPageAction = action;
        break;
      case Pages.VerifyEmail:
        VerifyEmailPageConfig.currentPageAction = action;
        break;
      case Pages.Support:
        SupportPageConfig.currentPageAction = action;
        break;

        break;
      case Pages.YourFunds:
        YourFundsConfig.currentPageAction = action;
        break;
      case Pages.THome:
        THomePageConfig.currentPageAction = action;
        break;
      case Pages.TGame:
        TGamePageConfig.currentPageAction = action;
        break;
      case Pages.TPickDraw:
        TPickDrawPageConfig.currentPageAction = action;
        break;
      case Pages.TShowAllTickets:
        TShowAllTicketsPageConfig.currentPageAction = action;
        break;
      case Pages.TWalkthrough:
        TWalkthroughPageConfig.currentPageAction = action;
        break;
      case Pages.TWeeklyResult:
        TWeeklyResultPageConfig.currentPageAction = action;
        break;
      case Pages.TSummaryDetails:
        TSummaryDetailsPageConfig.currentPageAction = action;
        break;
      case Pages.Notifications:
        NotificationsConfig.currentPageAction = action;
        break;
      case Pages.AugGoldSell:
        AugmontGoldSellPageConfig.currentPageAction = action;
        break;
      case Pages.AugGoldDetails:
        AugmontGoldDetailsPageConfig.currentPageAction = action;
        break;
      case Pages.ReferralDetails:
        ReferralDetailsPageConfig.currentPageAction = action;
        break;
      case Pages.ReferralHistory:
        ReferralHistoryPageConfig.currentPageAction = action;
        break;
      case Pages.MyWinnings:
        MyWinnigsPageConfig.currentPageAction = action;
        break;
      case Pages.BlockedUser:
        BlockedUserPageConfig.currentPageAction = action;
        break;
      case Pages.FreshDeskHelp:
        FreshDeskHelpPageConfig.currentPageAction = action;
        break;
      case Pages.GoldenTicketView:
        GoldenTicketViewPageConfig.currentPageAction = action;
        break;
      case Pages.GoldenTicketsView:
        GoldenTicketsViewPageConfig.currentPageAction = action;
        break;
      case Pages.GoldenMilestonesView:
        GoldenMilestonesViewPageConfig.currentPageAction = action;
        break;
      case Pages.TopSaverView:
        TopSaverViewPageConfig.currentPageAction = action;
        break;
      case Pages.AllParticipantsView:
        AllParticipantsViewPageConfig.currentPageAction = action;
        break;
      case Pages.GoldBalanceDetailsView:
        GoldBalanceDetailsViewPageConfig.currentPageAction = action;
        break;
      case Pages.PoolView:
        PoolViewPageConfig.currentPageAction = action;
        break;
      case Pages.WebHomeView:
        WebHomeViewPageConfig.currentPageAction = action;
        break;
      case Pages.WebGameView:
        WebGameViewPageConfig.currentPageAction = action;
        break;
      case Pages.AutosaveDetailsView:
        AutosaveDetailsViewPageConfig.currentPageAction = action;
        break;
      case Pages.AutosaveProcessView:
        AutosaveProcessViewPageConfig.currentPageAction = action;
        break;
      case Pages.UserAutosaveDetailsView:
        UserAutosaveDetailsViewPageConfig.currentPageAction = action;
        break;
      case Pages.AutosaveTransactionsView:
        AutosaveTransactionsViewPageConfig.currentPageAction = action;
        break;
      case Pages.AutosaveWalkthrough:
        AutosaveWalkThroughConfig.currentPageAction = action;
        break;
      default:
        break;
    }
  }

  List<Page> buildPages() {
    switch (appState.currentAction.state) {
      // 3
      case PageState.none:
        break;
      case PageState.addPage:
        // 4
        _setPageAction(appState.currentAction);
        addPage(appState.currentAction.page);
        break;
      case PageState.pop:
        // 5
        pop();
        break;
      case PageState.replace:
        // 6
        _setPageAction(appState.currentAction);
        replace(appState.currentAction.page);
        break;
      case PageState.replaceAll:
        // 7
        _setPageAction(appState.currentAction);
        replaceAll(appState.currentAction.page);
        break;
      case PageState.addWidget:
        // 8
        _setPageAction(appState.currentAction);
        pushWidget(appState.currentAction.widget, appState.currentAction.page);
        break;
      case PageState.addAll:
        // 9
        addAll(appState.currentAction.pages);
        break;
      case PageState.replaceWidget:
        replaceWidget(
            appState.currentAction.widget, appState.currentAction.page);
        break;
    }
    // 10
    appState.resetCurrentAction();
    return List.of(_pages);
  }

  void parseRoute(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      setNewRoutePath(SplashPageConfig);
      return;
    } else {
      for (int i = 0; i < uri.pathSegments.length; i++) {
        final segment = uri.pathSegments[i];
        if (segment.startsWith('d-', 0)) {
          dialogCheck(segment.split('-').last);
        } else if (segment.startsWith('c-', 0)) {
          appState.scrollHome(num.tryParse(segment.split('-').last));
        } else {
          screenCheck(segment);
        }
      }
    }
    // for one segement [bottom]
  }

  void dialogCheck(String dialogKey) {
    Widget dialogWidget;
    bool barrierDismissable = true;
    switch (dialogKey) {
      case "panInfo":
        dialogWidget = MoreInfoDialog(
          text: Assets.infoWhyPan,
          title: 'Where is my PAN Number used?',
        );
        break;
    }
    if (dialogWidget != null) {
      AppState.screenStack.add(ScreenItem.dialog);
      showDialog(
          context: navigatorKey.currentContext,
          barrierDismissible: barrierDismissable,
          builder: (ctx) {
            return WillPopScope(
                onWillPop: () {
                  AppState.backButtonDispatcher.didPopRoute();
                  print("Popped the dialog");
                  return Future.value(true);
                },
                child: dialogWidget);
          });
    }
  }

  void screenCheck(String screenKey) {
    PageConfiguration pageConfiguration;
    switch (screenKey) {
      case 'save':
        appState.setCurrentTabIndex = 0;
        break;
      case 'play':
        appState.setCurrentTabIndex = 1;
        break;
      case 'win':
        appState.setCurrentTabIndex = 2;
        break;
      case 'editProfile':
        pageConfiguration = UserProfileDetailsConfig;
        break;
      case 'augDetails':
        pageConfiguration = AugmontGoldDetailsPageConfig;
        break;
      case 'kycVerify':
        pageConfiguration = KycDetailsPageConfig;
        break;
      case 'augSell':
        pageConfiguration = AugmontGoldSellPageConfig;
        break;

      case 'transactions':
        pageConfiguration = TransactionsHistoryPageConfig;
        break;
      case 'txns':
        pageConfiguration = TransactionsHistoryPageConfig;
        break;
      case 'trans':
        pageConfiguration = TransactionsHistoryPageConfig;
        break;
      case 'referral':
        pageConfiguration = ReferralDetailsPageConfig;
        break;
      case 'tambolaHome':
        _baseUtil.openTambolaHome();
        break;
      case 'myWinnings':
        pageConfiguration = MyWinnigsPageConfig;
        break;
      case 'faq':
        pageConfiguration = FaqPageConfig;
        break;
      case 'editAugBankDetails':
        pageConfiguration = EditAugBankDetailsPageConfig;
        break;
      case 'chatSupport':
        pageConfiguration = ChatSupportPageConfig;
        break;
      case 'claimUsername':
        pageConfiguration = ClaimUsernamePageConfig;
        break;
      case 'verifyEmail':
        pageConfiguration = VerifyEmailPageConfig;
        break;
      case 'blocked':
        pageConfiguration = BlockedUserPageConfig;
        break;
      case 'dailySaver':
        openTopSaverScreen(Constants.HS_DAILY_SAVER);
        break;
      case 'weeklySaver':
        openTopSaverScreen(Constants.HS_WEEKLY_SAVER);
        break;
      case 'monthlySaver':
        openTopSaverScreen(Constants.HS_MONTHLY_SAVER);
        break;
      case 'FPL':
        openTopSaverScreen('FPL');
        break;
      case 'footballHome':
        openWebGame(Constants.GAME_TYPE_FOOTBALL);
        break;
      case 'cricketHome':
        openWebGame(Constants.GAME_TYPE_CRICKET);
        break;
      case 'poolHome':
        openWebGame(Constants.GAME_TYPE_POOLCLUB);
        break;
      case 'milestones':
        pageConfiguration = GoldenMilestonesViewPageConfig;
        break;
      case 'goldBalanceDetails':
        pageConfiguration = GoldBalanceDetailsViewPageConfig;
        break;
      case 'pop':
        AppState.backButtonDispatcher.didPopRoute();
        break;
      case 'autosaveDetails':
        pageConfiguration = AutosaveDetailsViewPageConfig;
        break;
      case 'autosaveProcess':
        pageConfiguration = AutosaveProcessViewPageConfig;
        break;
      case 'UserAutosaveDetails':
        pageConfiguration = UserAutosaveDetailsViewPageConfig;
        break;
      case 'AutosaveTxns':
        pageConfiguration = AutosaveTransactionsViewPageConfig;
        break;
      case 'AppWalkthrough':
        openAppWalkthrough();
        break;
      case 'AutosaveWalkthrough':
        pageConfiguration = AutosaveWalkThroughConfig;
        break;
    }
    if (pageConfiguration != null) {
      addPage(pageConfiguration);
      notifyListeners();
    }
  }

  openTopSaverScreen(String eventType) {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        widget: TopSaverView(
          eventType: eventType,
        ),
        page: TopSaverViewPageConfig);
  }

  openWebGame(String game) {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        widget: WebHomeView(game: game),
        page: WebHomeViewPageConfig);
  }

  openAppWalkthrough() {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        widget: WalkThroughPage(
          lottieList: [Assets.onb1, Assets.onb2, Assets.onb3],
          titleList: ["SAVE", "PLAY", "WIN"],
          descList: [
            "Save and invest in strong assets and earn tokens 🪙",
            "Use these tokens to play fun and exciting games 🎮",
            "Stand to win exclusive prizes and fun rewards 🎉"
          ],
        ),
        page: WalkThroughConfig);
  }

  // openAutosaveWalkthrough() {
  //   AppState.delegate.appState.currentAction = PageAction(
  //       state: PageState.addWidget,
  //       widget: WalkThroughPage(

  //       ),
  //       page: WalkThroughConfig);
  // }
}
