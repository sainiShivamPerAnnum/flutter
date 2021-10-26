//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/aboutus_dialog.dart';
import 'package:felloapp/ui/dialogs/game-poll-dialog.dart';
import 'package:felloapp/ui/dialogs/guide_dialog.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/hamburger/chatsupport_page.dart';
import 'package:felloapp/ui/pages/hamburger/faq_page.dart';
import 'package:felloapp/ui/pages/hamburger/referral_policy_page.dart';
import 'package:felloapp/ui/pages/hamburger/support.dart';
import 'package:felloapp/ui/pages/hamburger/tnc_page.dart';
import 'package:felloapp/ui/pages/login/login_controller.dart';
import 'package:felloapp/ui/pages/notifications/notifications.dart';
import 'package:felloapp/ui/pages/onboarding/getstarted/get_started_page.dart';
import 'package:felloapp/ui/pages/onboarding/getstarted/walkthrough_page.dart';
import 'package:felloapp/ui/pages/onboarding/update_screen.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_details/augmont_gold_details_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/edit_augmont_bank_details.dart';
import 'package:felloapp/ui/pages/others/finance/finance_report.dart';
import 'package:felloapp/ui/pages/others/finance/icici/mf_details_page.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_game/cricket_game_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/dailyPicksDraw/dailyPicksDraw_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/show_all_tickets.dart';
import 'package:felloapp/ui/pages/others/games/tambola/summary_tickets_display.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_game/tambola_game_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_walkthrough.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_result.dart';
import 'package:felloapp/ui/pages/others/profile/bank_details/bank_details_view.dart';
import 'package:felloapp/ui/pages/others/profile/claim_username.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_view.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_view.dart';
import 'package:felloapp/ui/pages/others/profile/referrals/referral_history/referrals_page.dart';
import 'package:felloapp/ui/pages/others/profile/transactions_history/transactions_history_view.dart';
import 'package:felloapp/ui/pages/others/profile/referrals/referral_details/referral_details_view.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_view.dart';
import 'package:felloapp/ui/pages/others/profile/verify_email.dart';
import 'package:felloapp/ui/pages/root/root_view.dart';
import 'package:felloapp/ui/pages/splash/splash_view.dart';
import 'package:felloapp/ui/pages/static/transactions_view.dart';
import 'package:felloapp/util/locator.dart';

import 'package:felloapp/util/assets.dart';

//Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FelloRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
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
        arguments: pageConfig);
  }

  void _addPageData(Widget child, PageConfiguration pageConfig) {
    AppState.screenStack.add(ScreenItem.page);
    print("Added a page ${pageConfig.key}");
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
          _addPageData(LoginController(), LoginPageConfig);
          break;
        case Pages.Root:
          _addPageData(Root(), RootPageConfig);
          break;
        case Pages.Onboard:
          _addPageData(GetStartedPage(), OnboardPageConfig);
          break;
        case Pages.UserProfileDetails:
          _addPageData(UserProfileDetails(), UserProfileDetailsConfig);
          break;
        case Pages.MfDetails:
          _addPageData(MFDetailsPage(), MfDetailsPageConfig);
          break;
        // case Pages.AugDetails:
        //   _addPageData(AugmontDetailsPage(), AugDetailsPageConfig);
        //   break;
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

        case Pages.Tnc:
          _addPageData(TnC(), TncPageConfig);
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
        case Pages.ClaimUsername:
          _addPageData(ClaimUsername(), ClaimUsernamePageConfig);
          break;
        case Pages.VerifyEmail:
          _addPageData(VerifyEmail(), VerifyEmailPageConfig);
          break;
        case Pages.Support:
          _addPageData(SupportPage(), SupportPageConfig);
          break;
        case Pages.WalkThrough:
          _addPageData(WalkThroughPage(), WalkThroughConfig);
          break;

        case Pages.YourFunds:
          _addPageData(YourFunds(), YourFundsConfig);
          break;
        case Pages.THome:
          _addPageData(TambolaHomeView(), THomePageConfig);
          break;
        case Pages.TGame:
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
        case Pages.TWeeklyResult:
          _addPageData(WeeklyResult(), TWeeklyResultPageConfig);
          break;
        case Pages.TSummaryDetails:
          _addPageData(SummaryTicketsDisplay(), TSummaryDetailsPageConfig);
          break;
        case Pages.Notifications:
          _addPageData(NotficationsPage(), NotificationsConfig);
          break;
        case Pages.CricketHome:
          _addPageData(CricketHomeView(), CricketHomePageConfig);
          break;
        case Pages.CricketGame:
          _addPageData(CricketGameView(), CricketGamePageConfig);
          break;
        case Pages.AugGoldBuy:
          _addPageData(AugmontGoldBuyView(), CricketHomePageConfig);
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
        default:
          break;
      }
    }
  }

// 1
  void replace(PageConfiguration newRoute) {
    if (_pages.isNotEmpty) {
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

      case Pages.Tnc:
        TncPageConfig.currentPageAction = action;
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
      case Pages.WalkThrough:
        WalkThroughConfig.currentPageAction = action;
        break;
      // case Pages.WalkThroughCompleted:
      //   WalkThroughCompletedConfig.currentPageAction = action;
      //   break;
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
      case Pages.CricketHome:
        CricketHomePageConfig.currentPageAction = action;
        break;
      case Pages.CricketGame:
        CricketGamePageConfig.currentPageAction = action;
        break;
      case Pages.AugGoldBuy:
        AugmontGoldBuyPageConfig.currentPageAction = action;
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
      case 'guide':
        dialogWidget = GuideDialog();
        break;
      case 'gamePoll':
        dialogWidget = GamePoll();
        break;
      case "aboutUs":
        dialogWidget = const AboutUsDialog();
        break;
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
      case 'augBuy':
        pageConfiguration = AugmontGoldBuyPageConfig;
        break;

      case 'tran':
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
      case 'walkthrough':
        pageConfiguration = WalkThroughConfig;
      // case 'tambolaTickets':
      //   pageConfiguration = TambolaTicketsPageConfig;
      //   break;
    }
    if (pageConfiguration != null) {
      addPage(pageConfiguration);
      notifyListeners();
    }
  }
}
