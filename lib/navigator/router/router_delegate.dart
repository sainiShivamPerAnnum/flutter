//Project Imports
import 'dart:developer';

// import 'package:apxor_flutter/observer.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/fello_badges/ui/fello_badges_home.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/balloon_lottie_screen.dart';
import 'package:felloapp/feature/referrals/ui/referral_home.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/transition_delegate.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/elements/fello_dialog/fello_in_app_review.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_details/gold_pro_details_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_sell/gold_pro_sell_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_transactions/gold_pro_txns_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_details/autosave_details_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_onboarding/autosave_onboarding_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_update/autosave_update_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/detail_page/flo_premium_details_view.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transactions_history_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_view.dart';
import 'package:felloapp/ui/pages/hometabs/my_account/my_account_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/blogs.dart';
import 'package:felloapp/ui/pages/login/login_controller_view.dart';
import 'package:felloapp/ui/pages/notifications/notifications_view.dart';
import 'package:felloapp/ui/pages/onboarding/blocked_user.dart';
import 'package:felloapp/ui/pages/onboarding/onboarding_main/onboarding_main_view.dart';
import 'package:felloapp/ui/pages/onboarding/update_screen.dart';
import 'package:felloapp/ui/pages/power_play/how_it_works/how_it_works_view.dart';
import 'package:felloapp/ui/pages/power_play/leaderboard/widgets/prize_distribution_sheet.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/power_play_home_view.dart';
import 'package:felloapp/ui/pages/power_play/season_leaderboard/season_leaderboard_view.dart';
import 'package:felloapp/ui/pages/power_play/welcome_page/power_play_welcome_page.dart';
import 'package:felloapp/ui/pages/rewards/scratch_card/scratch_card_view.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/root/root_view.dart';
import 'package:felloapp/ui/pages/splash/splash_view.dart';
import 'package:felloapp/ui/pages/static/earn_more_returns_view.dart';
import 'package:felloapp/ui/pages/static/web_view.dart';
import 'package:felloapp/ui/pages/support/freshdesk_help.dart';
import 'package:felloapp/ui/pages/support/referral_policy_page.dart';
import 'package:felloapp/ui/pages/support/support.dart';
import 'package:felloapp/ui/pages/userProfile/bank_details/bank_details_view.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_view_new.dart';
import 'package:felloapp/ui/pages/userProfile/my_winnings/my_winnings_view.dart';
import 'package:felloapp/ui/pages/userProfile/settings/settings_view.dart';
import 'package:felloapp/ui/pages/userProfile/userProfile/userProfile_view.dart';
import 'package:felloapp/ui/pages/userProfile/verify_email.dart';
import 'package:felloapp/ui/service_elements/quiz/quiz_web_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/styles.dart';
//Flutter Imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/enums/app_config_keys.dart';
import '../../core/model/app_config_model.dart';
import '../../feature/tambola/src/ui/onboarding/tickets_intro_view.dart';
import '../../feature/tambola/src/ui/onboarding/tickets_tutorial_assets_view.dart';

class FelloRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final AnalyticsService _analytics = locator<AnalyticsService>();

  final List<Page> _pages = [];

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final CustomLogger _logger = locator<CustomLogger>();
  final AppState appState;

  FelloRouterDelegate(this.appState) : navigatorKey = GlobalKey() {
    appState.addListener(() {
      log(navigatorKey.currentState.toString());
      notifyListeners();
    });
  }

  List<MaterialPage> get pages => List.unmodifiable(_pages);

  @override
  PageConfiguration? get currentConfiguration =>
      _pages.isEmpty ? null : _pages.last.arguments as PageConfiguration?;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: buildPages(),
      transitionDelegate: const MyTransitionDelegate(),
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
      debugPrint("Current Stack: ${AppState.screenStack}");
      // if (AppState.screenStack.length == 1) {
      //   _journeyService!.checkForMilestoneLevelChange();
      // }
      notifyListeners();

      return Future.value(true);
    }
    notifyListeners();
    return Future.value(false);
  }

  void _removePage<T>(Page<T> page) {
    if ((_pages.last.name ?? "").contains('kyc')) {
      locator<AnalyticsService>().track(
        eventName: AnalyticsEvents.backTappedOnKycPage,
      );
    }
    AppState.screenStack.removeLast();
    _pages.remove(page);
  }

  MaterialPage _createPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
      child: child,
      key: Key(pageConfig.key) as LocalKey?,
      name: pageConfig.path,
      arguments: pageConfig,
    );
  }

  MaterialPage _insertPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
      child: child,
      key: Key(pageConfig.key) as LocalKey?,
      name: pageConfig.path,
      arguments: pageConfig,
    );
  }

  void _insertPageData(Widget child, PageConfiguration pageConfig,
      {int? index}) {
    AppState.screenStack
        .insert(index ?? AppState.screenStack.length, ScreenItem.page);
    debugPrint("Inserted a page ${pageConfig.key} to Index $index");
    log("Current Stack: ${AppState.screenStack}");
    _analytics.trackScreen(screen: pageConfig.name);
    _pages.insert(
      index ?? _pages.length - 1,
      _insertPage(child, pageConfig),
    );
    //notifyListeners();
  }

  void _addPageData(Widget child, PageConfiguration pageConfig) {
    AppState.screenStack.add(ScreenItem.page);
    debugPrint("Added a page ${pageConfig.key}");
    log("Current Stack: ${AppState.screenStack}");
    if (pageConfig.name != null && pageConfig.name!.isNotEmpty) {
      _analytics.trackScreen(screen: pageConfig.name);
    }
    _pages.add(
      _createPage(child, pageConfig),
    );
    //notifyListeners();
  }

  void addPage(PageConfiguration? pageConfig,
      {Map<String, dynamic>? queryParams}) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            pageConfig!.uiPage;

    if (shouldAddPage) {
      switch (pageConfig!.uiPage) {
        case Pages.Splash:
          _addPageData(const LauncherView(), SplashPageConfig);
          break;
        case Pages.Login:
          _addPageData(const LoginControllerView(), LoginPageConfig);
          break;
        case Pages.Root:
          _addPageData(const Root(), RootPageConfig);
          break;
        case Pages.UserProfileDetails:
          _addPageData(const UserProfileDetails(), UserProfileDetailsConfig);
          break;
        case Pages.AccountsView:
          _addPageData(const MyAccount(), AccountsViewConfig);
          break;
        case Pages.TxnHistory:
          _addPageData(
              const TransactionsHistory(), TransactionsHistoryPageConfig);
          break;
        case Pages.KycDetails:
          _addPageData(const KYCDetailsViewNew(), KycDetailsPageConfig);
          break;
        case Pages.BankDetails:
          _addPageData(
            BankDetailsView(
                validation: bool.tryParse(
              queryParams?['withNetBankingValidation'] ?? 'false',
            )),
            BankDetailsPageConfig,
          );
          break;
        case Pages.UpdateRequired:
          _addPageData(const UpdateRequiredScreen(), UpdateRequiredConfig);
          break;
        case Pages.RefPolicy:
          _addPageData(const ReferralPolicy(), RefPolicyPageConfig);
          break;
        case Pages.VerifyEmail:
          _addPageData(const VerifyEmail(), VerifyEmailPageConfig);
          break;
        case Pages.Support:
          _addPageData(const SupportPage(), SupportPageConfig);
          break;
        case Pages.Notifications:
          _addPageData(const NotificationsPage(), NotificationsConfig);
          break;
        case Pages.ReferralDetails:
          _addPageData(const ReferralHome(), ReferralDetailsPageConfig);
          break;

        case Pages.MyWinnings:
          _addPageData(const MyWinningsView(), MyWinningsPageConfig);
          break;
        case Pages.BlockedUser:
          _addPageData(const BlockedUserView(), BlockedUserPageConfig);
          break;
        case Pages.FreshDeskHelp:
          _addPageData(const FreshDeskHelp(), FreshDeskHelpPageConfig);
          break;

        case Pages.ScratchCardsView:
          _addPageData(const ScratchCardsView(), ScratchCardsViewPageConfig);
          break;
        case Pages.AutosaveOnboardingView:
          _addPageData(
              const AutosaveOnboardingView(), AutosaveOnboardingViewPageConfig);
          break;
        case Pages.AutosaveProcessView:
          _addPageData(
              const AutosaveProcessView(), AutosaveProcessViewPageConfig);
          break;
        case Pages.AutosaveDetailsView:
          _addPageData(
              const AutosaveDetailsView(), AutosaveDetailsViewPageConfig);
          break;
        case Pages.AutosaveUpdateView:
          _addPageData(
              const AutosaveUpdateView(), AutosaveUpdateViewPageConfig);
          break;
        case Pages.JourneyView:
          _addPageData(const JourneyView(), JourneyViewPageConfig);
          break;
        case Pages.OnBoardingView:
          _addPageData(const OnBoardingView(), OnBoardingViewPageConfig);
          break;
        case Pages.BlogPostWebView:
          _addPageData(const BlogWebView(), BlogPostWebViewConfig);
          break;
        case Pages.SettingsView:
          _addPageData(const SettingsView(), SettingsViewPageConfig);
          break;

        case Pages.PowerPlayHome:
          _addPageData(const PowerPlayHome(), PowerPlayHomeConfig);
          break;

        case Pages.PowerPlayHowItWorks:
          _addPageData(const HowItWorks(), pageConfig);
          break;
        case Pages.PowerPlaySeasonLeaderboard:
          _addPageData(const SeasonLeaderboard(),
              PowerPlaySeasonLeaderboardDetailsConfig);
          break;

        case Pages.PowerPlayFTUX:
          _addPageData(const PowerPlayWelcomePage(), pageConfig);
          break;
        case Pages.EarnMoreReturnsView:
          _addPageData(const EarnMoreReturns(), EarnMoreReturnsViewPageConfig);
          break;
        case Pages.PlayView:
          _addPageData(const Play(), TransactionDetailsPageConfig);
          break;
        case Pages.GoldProDetailsView:
          _addPageData(
              const GoldProDetailsView(), GoldProDetailsViewPageConfig);
          break;
        case Pages.GoldProBuyView:
          _addPageData(const GoldProBuyView(), GoldProBuyViewPageConfig);
          break;
        case Pages.GoldProSellView:
          _addPageData(const GoldProSellView(), GoldProSellViewPageConfig);
          break;
        case Pages.GoldProTxnsView:
          _addPageData(const GoldProTxnsView(), GoldProTxnsViewPageConfig);
          break;
        case Pages.QuizWebView:
          _addPageData(const QuizWebView(), QuizWebViewConfig);
          break;
        case Pages.TicketsIntroViewPath:
          _addPageData(const TicketsIntroView(), TicketsIntroViewPageConfig);
          break;

        case Pages.TicketsTutorialViewPath:
          _addPageData(
              const TicketsTutorialsView(), TicketsTutorialViewPageConfig);
          break;

        case Pages.BalloonLottieScreen:
          _addPageData(
              const BalloonLottieScreen(), BalloonLottieScreenViewConfig);
          break;

        case Pages.FelloBadgeHome:
          _addPageData(const FelloBadgeHome(), FelloBadgeHomeViewPageConfig);
          break;

        default:
          break;
      }
    }
  }

// 1
  void replace(PageConfiguration? newRoute) {
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
  void replaceAll(PageConfiguration? newRoute) {
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
    routes.forEach(addPage);
  }

  void pushBelow(Widget child, PageConfiguration newRoute, {int? index}) {
    _insertPageData(child, newRoute, index: index);
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
  Future<void> setNewRoutePath(PageConfiguration? configuration) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            configuration!.uiPage;
    if (shouldAddPage) {
      _pages.clear();
      AppState.screenStack.clear();
      addPage(configuration);
    }
    return SynchronousFuture(null);
  }

  void _setPageAction(PageAction action) {
    switch (action.page!.uiPage) {
      case Pages.Splash:
        SplashPageConfig.currentPageAction = action;
        break;
      case Pages.Login:
        LoginPageConfig.currentPageAction = action;
        break;

      case Pages.AccountsView:
        AccountsViewConfig.currentPageAction = action;
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

      case Pages.YourFunds:
        YourFundsConfig.currentPageAction = action;
        break;
      case Pages.THome:
        THomePageConfig.currentPageAction = action;
        break;
      case Pages.TExistingUser:
        TambolaExistingUser.currentPageAction = action;
        break;
      case Pages.TNewUser:
        TambolaNewUser.currentPageAction = action;
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
      case Pages.FloPremiumDetails:
        FloPremiumDetailsPageConfig.currentPageAction = action;
        break;
      case Pages.ReferralDetails:
        ReferralDetailsPageConfig.currentPageAction = action;
        break;
      case Pages.ReferralHistory:
        ReferralHistoryPageConfig.currentPageAction = action;
        break;
      case Pages.MyWinnings:
        MyWinningsPageConfig.currentPageAction = action;
        break;
      case Pages.BlockedUser:
        BlockedUserPageConfig.currentPageAction = action;
        break;
      case Pages.FreshDeskHelp:
        FreshDeskHelpPageConfig.currentPageAction = action;
        break;
      case Pages.ScratchCardView:
        ScratchCardViewPageConfig.currentPageAction = action;
        break;
      case Pages.ScratchCardsView:
        ScratchCardsViewPageConfig.currentPageAction = action;
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

      case Pages.PoolView:
        PoolViewPageConfig.currentPageAction = action;
        break;
      case Pages.WebHomeView:
        WebHomeViewPageConfig.currentPageAction = action;
        break;
      case Pages.WebGameView:
        WebGameViewPageConfig.currentPageAction = action;
        break;
      case Pages.AutosaveOnboardingView:
        AutosaveOnboardingViewPageConfig.currentPageAction = action;
        break;
      case Pages.AutosaveProcessView:
        AutosaveProcessViewPageConfig.currentPageAction = action;
        break;
      case Pages.AutosaveDetailsView:
        AutosaveDetailsViewPageConfig.currentPageAction = action;
        break;
      case Pages.AutosaveUpdateView:
        AutosaveUpdateViewPageConfig.currentPageAction = action;
        break;
      case Pages.AutosaveTransactionsView:
        AutosaveTransactionsViewPageConfig.currentPageAction = action;
        break;
      case Pages.NewWebHomeView:
        NewWebHomeViewPageConfig.currentPageAction = action;
        break;
      case Pages.TopPlayerLeaderboard:
        TopPlayerLeaderboardPageConfig.currentPageAction = action;
        break;
      case Pages.JourneyView:
        JourneyViewPageConfig.currentPageAction = action;
        break;
      case Pages.OnBoardingView:
        OnBoardingViewPageConfig.currentPageAction = action;
        break;
      case Pages.CompleteProfileView:
        CompleteProfileViewPageConfig.currentPageAction = action;
        break;
      case Pages.CampaignView:
        CampaignViewPageConfig.currentPageAction = action;
        break;
      // case Pages.SaveAssetView:
      //   SaveAssetsViewConfig.currentPageAction = action;
      //   break;
      case Pages.SellConfirmationView:
        SellConfirmationViewConfig.currentPageAction = action;
        break;
      case Pages.TransactionDetailsPage:
        TransactionDetailsPageConfig.currentPageAction = action;
        break;
      case Pages.ViewAllBlogsView:
        ViewAllBlogsViewConfig.currentPageAction = action;
        break;
      case Pages.AllParticipantsWinnersTopReferrersView:
        AllParticipantsWinnersTopReferrersConfig.currentPageAction = action;
        break;
      case Pages.RedeemSuccessfulScreenView:
        RedeemSuccessfulScreenPageConfig.currentPageAction = action;
        break;
      case Pages.SharePriceScreenView:
        SharePriceScreenPageConfig.currentPageAction = action;
        break;
      case Pages.AllTambolaTicketsView:
        AllTambolaTicketsPageConfig.currentPageAction = action;
        break;
      case Pages.UserUpiDetailsView:
        UserUpiDetailsViewPageConfig.currentPageAction = action;
        break;
      case Pages.InfoStoriesView:
        InfoStoriesViewPageConfig.currentPageAction = action;
        break;
      case Pages.WebView:
        WebViewPageConfig.currentPageAction = action;
        break;
      case Pages.SettingsView:
        SettingsViewPageConfig.currentPageAction = action;
        break;
      case Pages.AssetViewSection:
        AssetViewPageConfig.currentPageAction = action;
        break;
      case Pages.FppCompletedMatchDetails:
        FppCompletedMatchDetailsConfig.currentPageAction = action;
        break;
      case Pages.PowerPlaySeasonLeaderboard:
        PowerPlaySeasonLeaderboardDetailsConfig.currentPageAction = action;
        break;
      case Pages.YoutubePlayerView:
        YoutubePlayerViewConfig.currentPageAction = action;
        break;
      case Pages.EarnMoreReturnsView:
        EarnMoreReturnsViewPageConfig.currentPageAction = action;
        break;
      case Pages.PlayView:
        PlayViewConfig.currentPageAction = action;
        break;
      case Pages.AssetSelectionView:
        AssetSelectionViewConfig.currentPageAction = action;
        break;
      case Pages.LendboxBuyView:
        LendboxBuyViewConfig.currentPageAction = action;
        break;
      case Pages.GoldProDetailsView:
        GoldenMilestonesViewPageConfig.currentPageAction = action;
        break;
      case Pages.GoldProBuyView:
        GoldProBuyViewPageConfig.currentPageAction = action;
        break;
      case Pages.GoldProSellView:
        GoldProSellViewPageConfig.currentPageAction = action;
        break;
      case Pages.GoldProTxnsView:
        GoldProTxnsViewPageConfig.currentPageAction = action;
        break;
      case Pages.GoldProTxnsDetailsView:
        GoldProTxnsDetailsViewPageConfig.currentPageAction = action;
        break;
      case Pages.TicketsIntroViewPath:
        TicketsIntroViewPageConfig.currentPageAction = action;
        break;
      case Pages.TicketsTutorialViewPath:
        TicketsTutorialViewPageConfig.currentPageAction = action;
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
        pushWidget(
            appState.currentAction.widget!, appState.currentAction.page!);
        break;
      case PageState.addBelow:
        _setPageAction(appState.currentAction);
        pushBelow(appState.currentAction.widget!, appState.currentAction.page!);

        break;
      case PageState.addAll:
        // 9
        addAll(appState.currentAction.pages!);
        break;
      case PageState.replaceWidget:
        replaceWidget(
            appState.currentAction.widget!, appState.currentAction.page!);
        break;
    }
    // 10
    appState.resetCurrentAction();
    return List.of(_pages);
  }

  void parseRoute(
    Uri uri, {
    String? title,
    bool isExternal = false,
  }) {
    _logger.d("Url: ${uri.toString()}");
    Haptic.vibrate();
    if (uri.scheme == "http" || uri.scheme == "https") {
      if (isExternal) {
        BaseUtil.launchUrl(uri.toString());
        return;
      }

      AppState.delegate!.appState.currentAction = PageAction(
        page: WebViewPageConfig,
        state: PageState.addWidget,
        widget: WebViewScreen(
          url: uri.toString(),
          title: title,
        ),
      );
      return;
    }
    if (uri.pathSegments.isEmpty) {
      setNewRoutePath(SplashPageConfig);
      return;
    } else {
      for (int i = 0; i < uri.pathSegments.length; i++) {
        final segment = uri.pathSegments[i];
        if (segment.startsWith('d-', 0)) {
          dialogCheck(segment.split('-').last);
        } else if (segment.startsWith('GM_')) {
          openWebGame(
            segment,
          );
        } else if (segment.startsWith('c-', 0)) {
          appState.scrollHome(num.tryParse(segment.split('-').last) as int);
        } else if (segment.startsWith('story-')) {
          // openStoryView(segment.split('-').last);
        } else {
          screenCheck(segment, uri.queryParameters);
        }
      }
    }
    // for one segement [bottom]
  }

  void dialogCheck(String dialogKey) {
    Widget? dialogWidget;
    bool barrierDismissable = true;
    switch (dialogKey) {
      case "panInfo":
        dialogWidget = MoreInfoDialog(
          text: Assets.infoWhyPan,
          title: 'Where is my PAN Number used?',
        );
        break;
      case "appRating":
        if (checkForRatingDialog()) dialogWidget = const FelloInAppReview();
        break;
    }
    if (dialogWidget != null) {
      AppState.screenStack.add(ScreenItem.dialog);
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: barrierDismissable,
        builder: (ctx) {
          return WillPopScope(
              onWillPop: () {
                AppState.backButtonDispatcher!.didPopRoute();
                debugPrint("Popped the dialog");
                return Future.value(true);
              },
              child: dialogWidget!);
        },
      );
    }
  }

  // void openStoryView(String topic) {
  //   AppState.screenStack.add(ScreenItem.dialog);
  //   Navigator.of(AppState.delegate!.navigatorKey.currentContext!).push(
  //     PageRouteBuilder(
  //       pageBuilder: (context, animation, anotherAnimation) {
  //         return InfoStories(
  //           topic: topic,
  //         );
  //       },
  //       transitionDuration: const Duration(milliseconds: 500),
  //       transitionsBuilder: (context, animation, anotherAnimation, child) {
  //         animation =
  //             CurvedAnimation(curve: Curves.easeInCubic, parent: animation);
  //         return Align(
  //           child: SizeTransition(
  //             sizeFactor: animation,
  //             child: child,
  //             axisAlignment: 0.0,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  void screenCheck(String screenKey, [Map<String, String>? queryParams]) {
    PageConfiguration? pageConfiguration;

    var rootController = locator<RootController>();

    switch (screenKey) {
      case 'super-fello':
        pageConfiguration = FelloBadgeHomeViewPageConfig;

      case 'journey':
        pageConfiguration = JourneyViewPageConfig;
        break;
      case 'save':
        onTapItem(RootController.saveNavBarItem);

        break;
      case 'play':
        pageConfiguration = PlayViewConfig;
        break;
      case 'win':
        onTapItem(RootController.winNavBarItem);
        break;

      case 'profile':
        pageConfiguration = UserProfileDetailsConfig;
        break;
      case "accounts":
        pageConfiguration = AccountsViewConfig;
        break;
      case "goldDetails":
        appState.currentAction = PageAction(
            state: PageState.addWidget,
            page: SaveAssetsViewConfig,
            widget: AssetSectionView(
              type: InvestmentType.AUGGOLD99,
            ));
        break;
      case "floDetails":
        appState.currentAction = PageAction(
          state: PageState.addWidget,
          page: SaveAssetsViewConfig,
          widget: AssetSectionView(
            type: InvestmentType.LENDBOXP2P,
          ),
        );
        break;
      case "flo10Details":
        appState.currentAction = PageAction(
            state: PageState.addWidget,
            page: FloPremiumDetailsPageConfig,
            widget: const FloPremiumDetailsView(is12: false));
        break;
      case "flo12Details":
        appState.currentAction = PageAction(
            state: PageState.addWidget,
            page: FloPremiumDetailsPageConfig,
            widget: const FloPremiumDetailsView(is12: true));
        break;

      case 'quickTour':
        // Future.delayed(const Duration(seconds: 2),
        //     SpotLightController.instance.startQuickTour);

        break;

      case 'kycVerify':
        pageConfiguration = KycDetailsPageConfig;
        break;
      case 'assetBuy':
        BaseUtil.openDepositOptionsModalSheet();
        break;
      case 'augBuy':
        BaseUtil().openRechargeModalSheet(
          investmentType: InvestmentType.AUGGOLD99,
          queryParams: queryParams,
        );
        break;
      case 'augSell':
        BaseUtil().openSellModalSheet(
          investmentType: InvestmentType.AUGGOLD99,
        );
        break;
      case 'lboxBuy':
        BaseUtil().openRechargeModalSheet(
          investmentType: InvestmentType.LENDBOXP2P,
          queryParams: queryParams,
        );
        break;
      case 'lboxBuy12':
        BaseUtil.openFloBuySheet(
          floAssetType: Constants.ASSET_TYPE_FLO_FIXED_6,
          queryParams: queryParams,
        );
        break;
      case 'lboxBuy8':
        BaseUtil.openFloBuySheet(
          floAssetType: Constants.ASSET_TYPE_FLO_FELXI,
          queryParams: queryParams,
        );
        break;

      case 'lboxBuy10':
        BaseUtil.openFloBuySheet(
          floAssetType: Constants.ASSET_TYPE_FLO_FIXED_3,
          queryParams: queryParams,
        );
        break;

      case 'lboxSell':
        BaseUtil()
            .openSellModalSheet(investmentType: InvestmentType.LENDBOXP2P);
        break;
      case 'augTxns':
        openTransactions(InvestmentType.AUGGOLD99);
        break;
      case 'lboxTxns':
        openTransactions(InvestmentType.LENDBOXP2P);
        break;
      case 'referrals':
        pageConfiguration = ReferralDetailsPageConfig;
        break;
      case 'tambolaHome':
        if (rootController.navItems
            .containsValue(RootController.tambolaNavBar)) {
          if (locator<UserService>()
                  .baseUser!
                  .userPreferences
                  .getPreference(Preferences.TAMBOLAONBOARDING) ==
              1) {
            onTapItem(RootController.tambolaNavBar);
          } else {
            pageConfiguration = TicketsIntroViewPageConfig;
          }
          break;
        }
        pageConfiguration = THomePageConfig;
        break;
      case 'myWinnings':
        pageConfiguration = MyWinningsPageConfig;
        break;
      case 'bankDetails':
        pageConfiguration = BankDetailsPageConfig;
        break;
      case 'verifyEmail':
        pageConfiguration = VerifyEmailPageConfig;
        break;
      case 'blocked':
        pageConfiguration = BlockedUserPageConfig;
        break;
      // BACKWARD COMPATIBILITY --START
      case 'footballHome':
        openWebGame(Constants.GAME_TYPE_FOOTBALL);
        break;
      case 'candyFiestaHome':
        openWebGame(Constants.GAME_TYPE_CANDYFIESTA);
        break;
      case 'cricketHome':
        openWebGame(Constants.GAME_TYPE_CRICKET);
        break;
      case 'poolHome':
        openWebGame(Constants.GAME_TYPE_POOLCLUB);
        break;
      case 'bowlingHome':
        openWebGame(Constants.GAME_TYPE_BOWLING);
        break;
      case 'bottleFlipHome':
        openWebGame(Constants.GAME_TYPE_BOTTLEFLIP);
        break;
      // BACKWARD COMPATIBILITY --END
      case 'pop':
        AppState.backButtonDispatcher!.didPopRoute();
        break;

      case 'autosaveDetails':
        if (!(AppConfig.getValue(AppConfigKey.showNewAutosave) as bool)) break;
        pageConfiguration = AutosaveDetailsViewPageConfig;
        break;
      case "autosave":
        if (!(AppConfig.getValue(AppConfigKey.showNewAutosave) as bool)) break;
        pageConfiguration = AutosaveOnboardingViewPageConfig;
        break;
      case 'autosaveTxns':
        openTransactions(InvestmentType.AUGGOLD99);
        break;
      case 'AppWalkthrough':
        openAppWalkthrough();
        break;
      case 'settings':
        pageConfiguration = SettingsViewPageConfig;
        break;
      case 'seasonLeaderboard':
        pageConfiguration = PowerPlaySeasonLeaderboardDetailsConfig;
        break;
      case 'powerPlayWelcome':
        pageConfiguration = PowerPlayFTUXPageConfig;
        break;
      case 'powerPlayHome':
        pageConfiguration = PowerPlayHomeConfig;
        break;
      case 'powerPlayPrizes':
        openPowerPlayModalSheet();
        break;
      case "earnMoreReturns":
        pageConfiguration = EarnMoreReturnsViewPageConfig;
        break;
      case "goldProDetails":
        pageConfiguration = GoldProDetailsViewPageConfig;
        break;
      case "goldProBuy":
        pageConfiguration = GoldProBuyViewPageConfig;
        break;
      case "goldProSell":
        pageConfiguration = GoldProSellViewPageConfig;
        break;
      case "ticketsIntro":
        pageConfiguration = TicketsIntroViewPageConfig;
        break;
      case "ticketsTutorial":
        pageConfiguration = TicketsTutorialViewPageConfig;
        break;
      case "quizHome":
        pageConfiguration = QuizWebViewConfig;
        break;
    }
    if (pageConfiguration != null) {
      addPage(pageConfiguration, queryParams: queryParams);
      notifyListeners();
    }
  }

  void onTapItem(NavBarItemModel item) {
    log('onTapItem ${item.title}');
    while (AppState.screenStack.length > 1) {
      AppState.backButtonDispatcher!.didPopRoute();
    }
    if (item.title == "Tickets") {
      if (locator<UserService>()
              .baseUser!
              .userPreferences
              .getPreference(Preferences.TAMBOLAONBOARDING) !=
          1) {
        AppState.delegate!.parseRoute(Uri.parse("ticketsIntro"));
        return;
      }
    }
    var rootController = locator<RootController>();

    rootController.onChange(rootController.navItems.values
        .toList()[rootController.navItems.values.toList().indexOf(item)]);

    appState.setCurrentTabIndex =
        rootController.navItems.values.toList().indexOf(item);
  }

  void onSilentTapItem(NavBarItemModel item) {
    log('onSilentTapItem ${item.title}');

    var rootController = locator<RootController>();

    rootController.onChange(rootController.navItems.values
        .toList()[rootController.navItems.values.toList().indexOf(item)]);

    appState.setCurrentTabIndex =
        rootController.navItems.values.toList().indexOf(item);
  }

  // openTopSaverScreen(String eventType) {
  //   AppState.delegate!.appState.currentAction = PageAction(
  //     page: CampaignViewPageConfig,
  //     state: PageState.addWidget,
  //     widget: CampaignView(eventType: eventType),
  //   );
  // }

  void openWebGame(String game) {
    bool isLocked = false;
    double netWorth = locator<UserService>().userPortfolio.augmont.principle +
        (locator<UserService>().userPortfolio.flo.principle);
    for (final i in locator<GameRepo>().gameTier.data) {
      for (final j in i!.games) {
        if (j!.gameCode == game) {
          isLocked = netWorth < i.minInvestmentToUnlock;
          break;
        }
      }
    }

    if (isLocked) {
      BaseUtil.showNegativeAlert('Game is locked for you',
          'Save more in Gold or Flo to unlock the game and complete the milestone');
      appState.onItemTapped(
          DynamicUiUtils.navBar.indexWhere((element) => element == 'PL'));
    } else {
      BaseUtil.openGameModalSheet(game);
    }
  }

  void openAppWalkthrough() {
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      widget: const OnBoardingView(),
      page: OnBoardingViewPageConfig,
    );
  }

  void openTransactions(InvestmentType investmentType) {
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      widget: TransactionsHistory(investmentType: investmentType),
      page: TransactionsHistoryPageConfig,
    );
  }

  void openPowerPlayModalSheet() {
    BaseUtil.openModalBottomSheet(
      isBarrierDismissible: true,
      addToScreenStack: true,
      backgroundColor: UiConstants.kGoldProBgColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeConfig.roundness32),
        topRight: Radius.circular(SizeConfig.roundness32),
      ),
      isScrollControlled: true,
      hapticVibrate: true,
      content: const PrizeDistributionSheet(),
    );
  }

  bool checkForRatingDialog() {
    bool isUserAlreadyRated =
        PreferenceHelper.exists(PreferenceHelper.CACHE_RATING_IS_RATED);
    if (isUserAlreadyRated) return false;

    if (PreferenceHelper.exists(
        PreferenceHelper.CACHE_RATING_EXPIRY_TIMESTAMP)) {
      int expiryTimeStampInMSE = PreferenceHelper.getInt(
          PreferenceHelper.CACHE_RATING_EXPIRY_TIMESTAMP);
      if (DateTime.now().millisecondsSinceEpoch < expiryTimeStampInMSE) {
        return false;
      }
    }
    PreferenceHelper.setInt(PreferenceHelper.CACHE_RATING_EXPIRY_TIMESTAMP,
        DateTime.now().add(const Duration(days: 10)).millisecondsSinceEpoch);
    return true;
  }
}
