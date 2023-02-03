//Project Imports
//Dart & Flutter Imports
import 'dart:async';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
//Pub Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/feed_card_model.dart';
import 'package:felloapp/core/model/game_stats_model.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/model/prize_leader_model.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/model/referral_leader_model.dart';
import 'package:felloapp/core/model/settings_items_model.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/model/user_icici_detail_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/modalsheets/confirm_exit_modal.dart';
import 'package:felloapp/ui/modalsheets/deposit_options_modal_sheet.dart';
import 'package:felloapp/ui/modalsheets/happy_hour_modal.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/gold_buy_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_sell/gold_sell_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/withdrawal/lendbox_withdrawal_view.dart';
import 'package:felloapp/ui/pages/games/web/web_home/web_game_modal_sheet.dart';
import 'package:felloapp/ui/service_elements/username_input/username_input_view.dart';
import 'package:felloapp/util/app_toasts_utils.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class BaseUtil extends ChangeNotifier {
  final CustomLogger logger = locator<CustomLogger>();
  final DBModel? _dbModel = locator<DBModel>();
  // final LocalDBModel? _lModel = locator<LocalDBModel>();
  final AppState? _appState = locator<AppState>();
  final UserService? _userService = locator<UserService>();
  final UserRepository? _userRepo = locator<UserRepository>();
  final InternalOpsService? _internalOpsService = locator<InternalOpsService>();
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  S locale = locator<S>();
  static Flushbar? flushbar;
  BaseUser? _myUser;
  UserFundWallet? _userFundWallet;
  int? _ticketCount;
  User? firebaseUser;
  FirebaseAnalytics? baseAnalytics;
  List<FeedCard>? feedCards;
  String? userRegdPan;
  List<SettingsListItemModel>? settingsItemList;

  ///ICICI global objects
  UserIciciDetail? _iciciDetail;
  UserTransaction? _currentICICITxn;
  UserTransaction? _currentICICINonInstantWthrlTxn;

  ///Augmont global objects
  UserAugmontDetail? _augmontDetail;
  AugmontRates? augmontGoldRates;

  ///KYC global object
  List<PrizeLeader> prizeLeaders = [];
  List<ReferralLeader> referralLeaders = [];
  String? myUserDpUrl;
  List<UserTransaction>? userMiniTxnList;
  List<ReferralDetail>? userReferralsList;
  ReferralDetail? myReferralInfo;
  static PackageInfo? packageInfo;
  Map<String, dynamic>? freshchatKeys;
  double? activeGoldWithdrawalQuantity;
  int? withdrawFlowStackCount;
  UserTransaction? firstAugmontTransaction;

  /// Objects for Transaction list Pagination
  DocumentSnapshot? lastTransactionListDocument;
  bool hasMoreTransactionListDocuments = true;

  DateTime? _userCreationTimestamp;
  int isOtpResendCount = 0;
  String? zeroBalanceAssetUri;
  static String? manualReferralCode;
  static String? referrerUserId;
  static bool? isNewUser, isFirstFetchDone; // = 'jdF1';

  ///Flags in various screens defined as global variables
  bool? isUserOnboarded,
      isLoginNextInProgress,
      isEditProfileNextInProgress,
      isRedemptionOtpInProgress,
      isAugmontRegnInProgress,
      isAugmontRegnCompleteAnimateInProgress,
      isSimpleKycInProgress,
      isIciciDepositRouteLogicInProgress,
      isEditAugmontBankDetailInProgress,
      isAugDepositRouteLogicInProgress,
      isAugWithdrawRouteLogicInProgress,
      isAugWithdrawalInProgress,
      isAugmontRealTimeBalanceFetched,
      isWeekWinnersFetched,
      isPrizeLeadersFetched,
      isReferralLeadersFetched,
      weeklyDrawFetched,
      weeklyTicksFetched,
      referralsFetched,
      userReferralInfoFetched,
      isProfilePictureUpdated,
      isReferralLinkBuildInProgressWhatsapp,
      isReferralLinkBuildInProgressOther,
      isHomeCardsFetched,
      _isGoogleSignInProgress,
      show_home_tutorial,
      show_game_tutorial,
      _isUpiInfoMissing,
      show_finance_tutorial;
  static bool? isDeviceOffline, ticketRequestSent, playScreenFirst;
  static int? ticketCountBeforeRequest, infoSliderIndex;

  BuildContext get rootContext =>
      AppState.delegate!.navigatorKey.currentContext!;

  _setRuntimeDefaults() {
    isNewUser = false;
    isFirstFetchDone = true;
    isUserOnboarded = false;
    isLoginNextInProgress = false;
    isEditProfileNextInProgress = false;
    isRedemptionOtpInProgress = false;
    isAugmontRegnInProgress = false;
    isAugmontRegnCompleteAnimateInProgress = false;
    isSimpleKycInProgress = false;
    isIciciDepositRouteLogicInProgress = false;
    isEditAugmontBankDetailInProgress = false;
    isAugDepositRouteLogicInProgress = false;
    isAugWithdrawRouteLogicInProgress = false;
    isAugWithdrawalInProgress = false;
    isAugmontRealTimeBalanceFetched = false;
    isWeekWinnersFetched = false;
    isPrizeLeadersFetched = false;
    isReferralLeadersFetched = false;
    weeklyDrawFetched = false;
    weeklyTicksFetched = false;
    referralsFetched = false;
    userReferralInfoFetched = false;
    isProfilePictureUpdated = false;
    isReferralLinkBuildInProgressWhatsapp = false;
    isReferralLinkBuildInProgressOther = false;
    isHomeCardsFetched = false;
    show_home_tutorial = false;
    show_game_tutorial = false;
    show_finance_tutorial = false;
    isGoogleSignInProgress = false;
    isDeviceOffline = false;
    ticketRequestSent = false;
    isUpiInfoMissing = true;
    ticketCountBeforeRequest = Constants.NEW_USER_TICKET_COUNT;
    infoSliderIndex = 0;
    playScreenFirst = true;

    firstAugmontTransaction = null;
  }

  void init() {
    try {
      logger.i('inside init base util');
      _setRuntimeDefaults();

      //Analytics logs app open state.
      BaseAnalytics.init();
      BaseAnalytics.analytics!.logAppOpen();

      setPackageInfo();

      ///fetch on-boarding status and User details
      firebaseUser = _userService!.firebaseUser;
      isUserOnboarded = _userService!.isUserOnboarded;

      if (isUserOnboarded!) {
        //set current user
        myUser = _userService!.baseUser;

        ///get user creation time
        _userCreationTimestamp = firebaseUser!.metadata.creationTime;

        ///pick zerobalance asset
        Random rnd = new Random();
        zeroBalanceAssetUri = 'zerobal/zerobal_${rnd.nextInt(4) + 1}';
      }
    } catch (e) {
      logger.e(e.toString());
      _internalOpsService!.logFailure(
        _userService!.baseUser?.uid ?? '',
        FailType.Splash,
        {'error': "base util init : $e"},
      );
    }
  }

  void setPackageInfo() async {
    //Appversion //add it seperate method
    packageInfo = await PackageInfo.fromPlatform();
  }

  Future<void> refreshFunds() async {
    //TODO: ADD LOADER
    print("-----------------> I got called");
    return _userRepo!.getFundBalance().then((aValue) {
      if (aValue.code == 200) {
        userFundWallet = aValue.model;
        if (userFundWallet!.augGoldQuantity > 0)
          _updateAugmontBalance(); //setstate call in method

      }
      notifyListeners();
    });
  }

  openProfileDetailsScreen() {
    // if (JourneyService.isAvatarAnimationInProgress) return;
    // if (_userService!.userJourneyStats!.mlIndex! > 1)
    AppState.delegate!.parseRoute(Uri.parse("profile"));
    // else {
    // print("Reachng");

    // print(
    //     "Testing 123  ${AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
    //       "Test": "test"
    //     })}");

    // AppState.delegate!.appState.currentAction = PageAction(
    //   page: UserProfileDetailsConfig,
    //   state: PageState.addWidget,
    //   widget: UserProfileDetails(isNewUser: true),
    // );
    // }

    _analyticsService!.track(
        eventName: AnalyticsEvents.profileClicked,
        properties: AnalyticsProperties.getDefaultPropertiesMap(
            extraValuesMap: {"location": getLocationForCurrentTab()}));
  }

  getLocationForCurrentTab() {
    int tab = AppState.delegate!.appState.getCurrentTabIndex;

    switch (tab) {
      case 0:
        return "Journey View, top Left Corner";
        break;
      case 1:
        return "Save Section, top Left Corner";
        break;
      case 2:
        return "Play Section, top Left Corner";
        break;
      case 3:
        return "Win Section, top Left Corner";
        break;
      default:
        return "";
        break;
    }
  }

  static showUsernameInputModalSheet() {
    return openModalBottomSheet(
      isScrollControlled: true,
      isBarrierDismissible: false,
      addToScreenStack: true,
      content: UsernameInputView(),
      hapticVibrate: true,
    );
  }

  static openGameModalSheet(String game) {
    AppState.screenStack.add(ScreenItem.modalsheet);
    return openModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      isBarrierDismissible: true,
      addToScreenStack: false,
      content: WebGameModalSheet(
        game: game,
      ),
      backgroundColor: Color(0xff39393C),
      hapticVibrate: true,
    );
  }

  openRechargeModalSheet({
    int? amt,
    bool? isSkipMl,
    required InvestmentType investmentType,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // if (_userService!.userJourneyStats?.mlIndex == 1)
      //   return BaseUtil.openDialog(
      //     addToScreenStack: true,
      //     isBarrierDismissible: true,
      //     hapticVibrate: false,
      //     content: CompleteProfileDialog(),
      //   );
      final bool? isAugDepositBanned = _userService
          ?.userBootUp?.data!.banMap?.investments?.deposit?.augmont?.isBanned;
      final String? augDepositBanNotice = _userService
          ?.userBootUp?.data!.banMap?.investments?.deposit?.augmont?.reason;
      final bool? islBoxlDepositBanned = _userService
          ?.userBootUp?.data!.banMap?.investments?.deposit?.lendBox?.isBanned;
      final String? lBoxDepositBanNotice = _userService
          ?.userBootUp?.data!.banMap?.investments?.deposit?.lendBox?.reason;
      if (investmentType == InvestmentType.AUGGOLD99 &&
          isAugDepositBanned != null &&
          isAugDepositBanned) {
        return BaseUtil.showNegativeAlert(
            augDepositBanNotice ?? locale.assetNotAvailable, locale.tryLater);
      }

      if (investmentType == InvestmentType.LENDBOXP2P &&
          islBoxlDepositBanned != null &&
          islBoxlDepositBanned) {
        return BaseUtil.showNegativeAlert(
          lBoxDepositBanNotice ?? locale.assetNotAvailable,
          locale.tryLater,
        );
      }
      double amount = 0;

      BaseUtil.openModalBottomSheet(
        addToScreenStack: true,
        enableDrag: false,
        hapticVibrate: true,
        isBarrierDismissible: false,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        content: investmentType == InvestmentType.AUGGOLD99
            ? GoldBuyView(
                onChanged: (p0) => amount = p0,
                amount: amt,
                skipMl: isSkipMl ?? false,
              )
            : LendboxBuyView(
                amount: amt,
                skipMl: isSkipMl ?? false,
                onChanged: (p0) => amount = p0,
              ),
      ).then((value) =>
          locator<BackButtonActions>().isTransactionCancelled = false);
    });
  }

  Future<void> showConfirmExit() async {
    await openModalBottomSheet(
        isBarrierDismissible: false,
        addToScreenStack: true,
        content: ConfirmExitModal());
  }

  void openSellModalSheet({required InvestmentType investmentType}) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final bool? isAugSellLocked = _userService?.userBootUp?.data!.banMap
          ?.investments?.withdrawal?.augmont?.isBanned;
      final String? augSellBanNotice = _userService
          ?.userBootUp?.data?.banMap?.investments?.withdrawal?.augmont?.reason;
      final bool? islBoxSellBanned = _userService?.userBootUp?.data?.banMap
          ?.investments?.withdrawal?.lendBox?.isBanned;
      final String? lBoxSellBanNotice = _userService
          ?.userBootUp?.data?.banMap?.investments?.withdrawal?.lendBox?.reason;
      if (investmentType == InvestmentType.AUGGOLD99 &&
          isAugSellLocked != null &&
          isAugSellLocked) {
        return BaseUtil.showNegativeAlert(
            augSellBanNotice ?? locale.assetNotAvailable, locale.tryLater);
      }
      if (investmentType == InvestmentType.LENDBOXP2P &&
          islBoxSellBanned != null &&
          islBoxSellBanned) {
        return BaseUtil.showNegativeAlert(
            lBoxSellBanNotice ?? locale.assetNotAvailable, locale.tryLater);
      }
      _analyticsService!.track(
          eventName: investmentType == InvestmentType.AUGGOLD99
              ? AnalyticsEvents.goldSellModalSheet
              : AnalyticsEvents.lBoxSellModalSheet);

      BaseUtil.openModalBottomSheet(
        addToScreenStack: true,
        enableDrag: false,
        hapticVibrate: true,
        isBarrierDismissible: false,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        content: investmentType == InvestmentType.AUGGOLD99
            ? GoldSellView()
            : LendboxWithdrawalView(),
      );
    });
  }

  openDepositOptionsModalSheet({int? amount, bool isSkipMl = false}) {
    // if (_userService!.userJourneyStats!.mlIndex == 1)
    //   return BaseUtil.openDialog(
    //       addToScreenStack: true,
    //       isBarrierDismissible: true,
    //       hapticVibrate: false,
    //       content: CompleteProfileDialog());
    _analyticsService!
        .track(eventName: AnalyticsEvents.assetOptionsModalTapped);
    return BaseUtil.openModalBottomSheet(
        addToScreenStack: true,
        enableDrag: false,
        hapticVibrate: true,
        backgroundColor:
            UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
        isBarrierDismissible: true,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            SizeConfig.roundness12,
          ),
          topRight: Radius.circular(SizeConfig.roundness24),
        ),
        content: DepositOptionModalSheet(amount: amount, isSkipMl: isSkipMl));
  }

  static showPositiveAlert(String? title, String? message, {int seconds = 2}) {
    AppToasts.showPositiveToast(
        title: title, subtitle: message, seconds: seconds);
  }

  static showNegativeAlert(String? title, String? message, {int? seconds}) {
    AppToasts.showNegativeToast(
        title: title, subtitle: message, seconds: seconds);
  }

  static showNoInternetAlert() {
    return AppToasts.showNoInternetToast();
  }

  // Future<bool> getDrawStatus() async {
  //   if (DateTime.now().weekday != await _lModel!.getDailyPickAnimLastDay() &&
  //       DateTime.now().hour >= 18 &&
  //       DateTime.now().hour < 24) return true;

  //   return false;
  // }

  static void openDialog({
    Widget? content,
    bool? addToScreenStack,
    bool? hapticVibrate,
    required bool isBarrierDismissible,
    ValueChanged<dynamic>? callback,
  }) {
    if (addToScreenStack != null && addToScreenStack == true)
      AppState.screenStack.add(ScreenItem.dialog);
    print("Current Stack: ${AppState.screenStack}");
    if (hapticVibrate != null && hapticVibrate == true) Haptic.vibrate();
    showDialog(
      context: AppState.delegate!.navigatorKey.currentContext!,
      barrierDismissible: isBarrierDismissible,
      builder: (ctx) => content!,
      useSafeArea: true,
    );
  }

  static Future<void> openModalBottomSheet({
    Widget? content,
    bool? addToScreenStack,
    bool? hapticVibrate,
    Color? backgroundColor,
    required bool isBarrierDismissible,
    BorderRadius? borderRadius,
    bool isScrollControlled = false,
    BoxConstraints? boxContraints,
    bool enableDrag = false,
  }) async {
    if (addToScreenStack != null && addToScreenStack == true)
      AppState.screenStack.add(ScreenItem.dialog);
    if (hapticVibrate != null && hapticVibrate == true) Haptic.vibrate();
    print("Current Stack: ${AppState.screenStack}");
    await showModalBottomSheet(
      enableDrag: enableDrag,
      constraints: boxContraints,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ??
            BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.padding16),
              topRight: Radius.circular(SizeConfig.padding16),
            ),
      ),
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor ??
          UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
      isDismissible: isBarrierDismissible,
      context: AppState.delegate!.navigatorKey.currentContext!,
      builder: (ctx) => content!,
    );
  }

  Future<bool> authenticateUser(AuthCredential credential) {
    logger.d("Verification credetials: " + credential.toString());
    // FirebaseAuth.instance.signInWithCustomToken(token)
    return FirebaseAuth.instance.signInWithCredential(credential).then((res) {
      this.firebaseUser = res.user;
      logger.i("New Firebase User: ${res.additionalUserInfo!.isNewUser}");
      return true;
    }).catchError((e) {
      logger.e(
          "User Authentication failed with credential: Error: " + e.toString());
      return false;
    });
  }

  Future<bool> signOut() async {
    try {
      // await _lModel!.deleteLocalAppData();
      logger.d('Cleared local cache');
      _appState!.setCurrentTabIndex = 0;

      //remove  token from remote
      //await _dbModel.updateClientToken(myUser, '');

      //TODO better fix required
      ///IMP: When a user signs out and attempts
      /// to sign in again without closing the apcp,
      /// the old variables are still in effect
      /// resetting them like below for now
      _myUser = null;
      isNewUser = null;
      isFirstFetchDone = null;
      _userFundWallet = null;
      _ticketCount = null;
      firebaseUser = null;
      baseAnalytics = null;
      feedCards = null;
      // _dailyPickCount = null;
      userRegdPan = null;
      // weeklyDigits = null;
      // userWeeklyBoards = null;
      _iciciDetail = null;
      _currentICICITxn = null;
      _currentICICINonInstantWthrlTxn = null;

      _augmontDetail = null;
      augmontGoldRates = null;
      prizeLeaders = [];
      referralLeaders = [];
      myUserDpUrl = null;
      userMiniTxnList = null;
      userReferralsList = null;
      myReferralInfo = null;
      packageInfo = null;
      freshchatKeys = null;
      _userCreationTimestamp = null;
      lastTransactionListDocument = null;
      hasMoreTransactionListDocuments = true;
      isOtpResendCount = 0;
      isUpiInfoMissing = true;

      AppState.delegate!.appState.setCurrentTabIndex = 0;
      manualReferralCode = null;
      referrerUserId = null;
      _setRuntimeDefaults();

      return true;
    } catch (e) {
      logger.e('Failed to clear data/sign out user: ' + e.toString());
      return false;
    }
  }

  static void launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      launchUrl(url);
    } else {
      BaseUtil.showNegativeAlert("Operation cannot be completed at the moment",
          "Please try after some time");
    }
  }

  // void openTambolaGame() async {
  //   if (await getDrawStatus()) {
  //     await _lModel!.saveDailyPicksAnimStatus(DateTime.now().weekday).then(
  //           (value) =>
  //               print("Daily Picks Draw Animation Save Status Code: $value"),
  //         );
  //     AppState.delegate!.appState.currentAction =
  //         PageAction(state: PageState.addPage, page: TPickDrawPageConfig);
  //   } else
  //     AppState.delegate!.appState.currentAction =
  //         PageAction(state: PageState.addPage, page: TGamePageConfig);
  // }

  static int getRandomRewardAmount(index) {
    if (index < 5)
      return 50;
    else if (index < 10)
      return 100;
    else if (index < 15)
      return 150;
    else if (index < 20)
      return 200;
    else if (index < 50)
      return 500;
    else
      return 100;
  }

  bool isOldCustomer() {
    //all users before april 2021 are marked old
    if (userCreationTimestamp == null) return false;
    return (userCreationTimestamp!.isBefore(Constants.VERSION_2_RELEASE_DATE));
  }

  static int getWeekNumber({DateTime? currentDate}) {
    DateTime tdt = (currentDate != null) ? currentDate : new DateTime.now();
    int dayn = tdt.weekday;
    //tdt = new DateTime(tdt.year, tdt.month, tdt.day-dayn+3);
    //tdt.setDate(tdt.getDate() - dayn + 3);
    DateTime firstThursday =
        new DateTime(tdt.year, tdt.month, tdt.day - dayn + 3);
    tdt = new DateTime(tdt.year, 1, 1);
    if (tdt.weekday != DateTime.friday) {
      //tdt.setMonth(0, 1 + ((4 - tdt.getDay()) + 7) % 7);
      int x = tdt.weekday;
      x = (tdt.weekday == 7) ? 0 : tdt.weekday;
      tdt = new DateTime(tdt.year, 1, 1 + ((5 - x) + 7) % 7);
    }
    int n = 1 +
        ((firstThursday.millisecondsSinceEpoch - tdt.millisecondsSinceEpoch) /
                604800000)
            .ceil();
    return n;
  }

  double getUpdatedWithdrawalClosingBalance(double investment) =>
      (toDouble(_userFundWallet!.iciciBalance) +
          toDouble(_userFundWallet!.augGoldBalance) +
          toDouble(_userFundWallet!.prizeBalance) +
          toDouble(_userFundWallet!.lockedPrizeBalance) -
          investment);

  double getCurrentTotalClosingBalance() =>
      (toDouble(_userFundWallet!.iciciBalance) +
          toDouble(_userFundWallet!.augGoldBalance) +
          toDouble(_userFundWallet!.prizeBalance) +
          toDouble(_userFundWallet!.lockedPrizeBalance));

  static T? _cast<T>(x) => x is T ? x : null;

  static double toDouble(dynamic x) {
    if (x == null) return 0.0;
    try {
      int? y = _cast<int>(x);
      if (y != null) return y + .0;
    } catch (e) {}

    try {
      double? z = _cast<double>(x);
      if (z != null) return z;
    } catch (e) {}

    return 0.0;
  }

  static int toInt(dynamic x) {
    if (x == null) return 0;
    try {
      int? y = _cast<int>(x);
      if (y != null) return y;
    } catch (e) {}

    try {
      String? z = _cast<String>(x);
      if (z != null) return int.parse(z);
    } catch (e) {}

    return 0;
  }

  static getIntOrDouble(double x) {
    if (x - x.round() != 0)
      return x;
    else
      return x.toInt();
  }

  static double digitPrecision(double x, [int offset = 2, bool round = true]) {
    double y = x * pow(10, offset);
    int z = (round) ? y.round() : y.truncate();
    return z / pow(10, offset);
  }

  int getTicketCountForTransaction(double investment) =>
      (investment / Constants.INVESTMENT_AMOUNT_FOR_TICKET).floor();

  void setDisplayPictureUrl(String url) {
    myUserDpUrl = url;
    notifyListeners();
  }

  void setName(String newName) {
    myUser!.name = newName;
    notifyListeners();
  }

  void setKycVerified(bool val) {
    myUser!.isSimpleKycVerified = val;
    notifyListeners();
  }

  void setUsername(String userName) {
    myUser!.username = userName;
    notifyListeners();
  }

  void setEmailVerified() {
    myUser!.isEmailVerified = true;
    notifyListeners();
  }

  void setEmail(String email) {
    myUser!.email = email;
    notifyListeners();
  }

  void refreshAugmontBalance() async {
    _userRepo!.getFundBalance().then((aValue) {
      if (aValue.code == 200) {
        userFundWallet = aValue.model;
        if (userFundWallet!.augGoldQuantity > 0) _updateAugmontBalance();
      }
    });
  }

  // Future<void> fetchUserAugmontDetail() async {
  //   if (augmontDetail == null) {
  //     ApiResponse<UserAugmontDetail> augmontDetailResponse =
  //         await _userRepo.getUserAugmontDetails();
  //     if (augmontDetailResponse.code == 200)
  //       augmontDetail = augmontDetailResponse.model;
  //   }
  // }

  Future<void> _updateAugmontBalance() async {
    if (augmontDetail == null ||
        (userFundWallet!.augGoldQuantity == 0 &&
            userFundWallet!.augGoldBalance == 0)) return;
    AugmontService().getRates().then((currRates) {
      if (currRates == null ||
          currRates.goldSellPrice == null ||
          userFundWallet!.augGoldQuantity == 0) return;

      augmontGoldRates = currRates;
      double gSellRate = augmontGoldRates!.goldSellPrice!;
      userFundWallet!.augGoldBalance =
          BaseUtil.digitPrecision(userFundWallet!.augGoldQuantity * gSellRate);
      notifyListeners(); //might cause ui error if screen no longer active
    }).catchError((err) {
      if (_myUser!.uid != null) {
        var errorDetails = {'error_msg': err.toString()};
        _internalOpsService!.logFailure(_myUser!.uid,
            FailType.UserAugmontBalanceUpdateFailed, errorDetails);
      }
      print('$err');
    });
  }

  void updateAugmontDetails(
      String holderName, String accountNumber, String ifscode) {
    _augmontDetail!.bankHolderName = holderName;
    _augmontDetail!.bankAccNo = accountNumber;
    _augmontDetail!.ifsc = ifscode;
    notifyListeners();
  }

  void updateAugmontOnboarded(bool newValue) {
    _myUser!.isAugmontOnboarded = newValue;
    notifyListeners();
  }

  void flipSecurityValue(bool value) {
    _myUser!.userPreferences
        .setPreference(Preferences.APPLOCK, (value) ? 1 : 0);
    notifyListeners();
  }

  static String getMonthName({required int monthNum, bool trim = true}) {
    String res = "January";
    switch (monthNum) {
      case 1:
        res = "January";
        break;
      case 2:
        res = "February";
        break;
      case 3:
        res = "March";
        break;
      case 4:
        res = "April";
        break;
      case 5:
        res = "May";
        break;
      case 6:
        res = "June";
        break;
      case 7:
        res = "July";
        break;
      case 8:
        res = "August";
        break;
      case 9:
        res = "September";
        break;
      case 10:
        res = "October";
        break;
      case 11:
        res = "November";
        break;
      case 12:
        res = "December";
        break;
      default:
        res = "Janurary";
    }
    if (trim) return res.substring(0, 3);
    return res;
  }

  BaseUser? get myUser => _myUser;

  set myUser(BaseUser? value) {
    _myUser = value;
  }

  UserFundWallet? get userFundWallet => _userFundWallet;

  set userFundWallet(UserFundWallet? value) {
    _userFundWallet = value;
  }

  UserIciciDetail? get iciciDetail => _iciciDetail;

  set iciciDetail(UserIciciDetail? value) {
    _iciciDetail = value;
  }

  UserTransaction? get currentICICITxn => _currentICICITxn;

  set currentICICITxn(UserTransaction? value) {
    _currentICICITxn = value;
  }

  UserTransaction? get currentICICINonInstantWthrlTxn =>
      _currentICICINonInstantWthrlTxn;

  set currentICICINonInstantWthrlTxn(UserTransaction? value) {
    _currentICICINonInstantWthrlTxn = value;
  }

  UserAugmontDetail? get augmontDetail => _augmontDetail;

  set augmontDetail(UserAugmontDetail? value) {
    _augmontDetail = value;
    notifyListeners();
  }

  bool isSignedIn() => (firebaseUser != null && firebaseUser!.uid != null);

  // bool isActiveUser() => (_myUser != null && !_myUser!.hasIncompleteDetails());

  DateTime? get userCreationTimestamp => _userCreationTimestamp;

  int? get ticketCount => _ticketCount;

  set ticketCount(int? value) {
    _ticketCount = value;
    notifyListeners();
  }

  get isGoogleSignInProgress => this._isGoogleSignInProgress;

  set isGoogleSignInProgress(value) {
    this._isGoogleSignInProgress = value;
    notifyListeners();
  }

  static String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  bool? get isUpiInfoMissing => this._isUpiInfoMissing;

  set isUpiInfoMissing(bool? value) {
    this._isUpiInfoMissing = value;
    notifyListeners();
  }

  Future showHappyHourDialog(HappyHourCampign model,
      {bool afterHappyHour = false, bool isComingFromSave = false}) async {
    return openModalBottomSheet(
      backgroundColor: Colors.transparent,
      addToScreenStack: true,
      hapticVibrate: true,
      content: HappyHourModel(
        model: model,
        isAfterHappyHour: afterHappyHour,
        isComingFromSave: isComingFromSave,
      ),
      isBarrierDismissible: true,
    );
  }
}

class CompleteProfileDialog extends StatelessWidget {
  final String? title, subtitle;
  CompleteProfileDialog({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return WillPopScope(
      onWillPop: () async {
        AppState.backButtonDispatcher!.didPopRoute();
        return Future.value(true);
      },
      child: MoreInfoDialog(
        title: title ?? locale.obCompleteProfile,
        text: subtitle ?? locale.obCompleteProfileSubTitle,
        imagePath: Assets.completeProfile,
        btnText: locale.btnComplete.toUpperCase(),
        onPressed: () {
          while (AppState.screenStack.length > 1)
            AppState.backButtonDispatcher!.didPopRoute();
          AppState.delegate!.appState.setCurrentTabIndex = 0;
        },
      ),
    );
  }
}
