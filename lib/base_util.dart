//Project Imports
//Dart & Flutter Imports
import 'dart:async';
import 'dart:developer' as d;
import 'dart:math';

//Pub Imports
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/feed_card_model.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/model/prize_leader_model.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/model/referral_leader_model.dart';
import 'package:felloapp/core/model/settings_items_model.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/model/user_icici_detail_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/referrals/ui/referral_rating_sheet.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/elements/fello_dialog/fello_in_app_review.dart';
import 'package:felloapp/ui/modalsheets/confirm_exit_modal.dart';
import 'package:felloapp/ui/modalsheets/happy_hour_modal.dart';
import 'package:felloapp/ui/pages/asset_selection.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/gold_buy_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_sell/gold_sell_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/withdrawal/lendbox_withdrawal_view.dart';
import 'package:felloapp/ui/pages/games/web/web_home/web_game_modal_sheet.dart';
import 'package:felloapp/ui/pages/support/bug_report/ui/found_bug.dart';
import 'package:felloapp/ui/service_elements/username_input/username_input_view.dart';
import 'package:felloapp/util/app_toasts_utils.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'core/model/timestamp_model.dart';
import 'ui/pages/finance/lendbox/deposit/lendbox_buy_view.dart';

enum FileType { svg, lottie, unknown, png }

class BaseUtil extends ChangeNotifier {
  final CustomLogger logger = locator<CustomLogger>();

  // final LocalDBModel? _lModel = locator<LocalDBModel>();
  final AppState _appState = locator<AppState>();
  final UserService _userService = locator<UserService>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  S locale = locator<S>();
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
  static String? referredCode;
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
      firebaseUser = _userService.firebaseUser;
      isUserOnboarded = _userService.isUserOnboarded;

      if (isUserOnboarded!) {
        //set current user
        myUser = _userService.baseUser;

        _userCreationTimestamp = firebaseUser!.metadata.creationTime;
      }
    } catch (e) {
      logger.e(e.toString());
      _internalOpsService.logFailure(
        _userService.baseUser?.uid ?? '',
        FailType.Splash,
        {'error': "base util init : $e"},
      );
    }
  }

  Future<void> setPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  void openProfileDetailsScreen() {
    AppState.delegate!.parseRoute(Uri.parse("accounts"));
    _analyticsService.track(
      eventName: AnalyticsEvents.profileClicked,
      properties: AnalyticsProperties.getDefaultPropertiesMap(
        extraValuesMap: {
          "location": getLocationForCurrentTab(),
          'current_level':
              locator<UserService>().baseUser!.superFelloLevel.name,
        },
      ),
    );
  }

  String getLocationForCurrentTab() {
    int tab = AppState.delegate!.appState.getCurrentTabIndex;

    switch (tab) {
      case 0:
        return "Journey View, top Left Corner";
      case 1:
        return "Save Section, top Left Corner";
      case 2:
        return "Play Section, top Left Corner";
      case 3:
        return "Win Section, top Left Corner";
      default:
        return "";
    }
  }

  static dynamic showUsernameInputModalSheet() {
    return openModalBottomSheet(
      isScrollControlled: true,
      isBarrierDismissible: false,
      addToScreenStack: true,
      content: UsernameInputView(),
      hapticVibrate: true,
    );
  }

  void openGoldProBuyView({required String location}) {
    final bool? isAugDepositBanned = _userService
        .userBootUp?.data!.banMap?.investments?.deposit?.goldPro?.isBanned;
    final String? augDepositBanNotice = _userService
        .userBootUp?.data!.banMap?.investments?.deposit?.goldPro?.reason;

    if (isAugDepositBanned != null && isAugDepositBanned) {
      BaseUtil.showNegativeAlert(
          augDepositBanNotice ?? locale.assetNotAvailable, locale.tryLater);
      return;
    }
    Haptic.vibrate();
    AppState.delegate!.appState.currentAction =
        PageAction(page: GoldProBuyViewPageConfig, state: PageState.addPage);

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.startNewLeaseTapped,
      properties: {
        'location': location,
        "existing gold balance":
            _userService.userFundWallet?.augGoldQuantity ?? 0,
        "existing lease grams": _userService.userFundWallet?.wAugFdQty ?? 0
      },
    );
  }

  static dynamic openGameModalSheet(String game) {
    AppState.screenStack.add(ScreenItem.modalsheet);
    return openModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      isBarrierDismissible: true,
      addToScreenStack: false,
      content: WebGameModalSheet(
        game: game,
      ),
      backgroundColor: UiConstants.gameCardColor,
      hapticVibrate: true,
    );
  }

  void openRechargeModalSheet({
    required InvestmentType investmentType,
    int? amt,
    bool? isSkipMl,
    double? gms,
    Map<String, dynamic>? queryParams,
    String? entryPoint,
    bool fullPager = false,
  }) {
    final coupon = queryParams?['coupon'];
    final amount = queryParams?['amount'];
    final parsedAmount =
        int.tryParse(amount ?? ''); // For parsing default value to null.
    final grams = queryParams?['grams'];
    final parsedGrams =
        double.tryParse(grams ?? ''); // For parsing default value to null.
    final quickCheckout =
        // ignore: sdk_version_since
        bool.parse(queryParams?['shouldQuickCheckout'] ?? 'false');

    final bool? isAugDepositBanned = _userService
        .userBootUp?.data!.banMap?.investments?.deposit?.augmont?.isBanned;
    final String? augDepositBanNotice = _userService
        .userBootUp?.data!.banMap?.investments?.deposit?.augmont?.reason;

    if (investmentType == InvestmentType.AUGGOLD99 &&
        isAugDepositBanned != null &&
        isAugDepositBanned) {
      BaseUtil.showNegativeAlert(
          augDepositBanNotice ?? locale.assetNotAvailable, locale.tryLater);
      return;
    }

    AppState.isRepeated = false;
    AppState.onTap = null;
    AppState.isTxnProcessing = false;
    locator<BackButtonActions>().isTransactionCancelled = false;

    if (investmentType == InvestmentType.LENDBOXP2P) {
      AppState.delegate!.appState.currentAction = PageAction(
        page: AssetSelectionViewConfig,
        state: PageState.addWidget,
        widget: AssetSelectionPage(
          showGold: false,
          amount: amt,
          isSkipMl: isSkipMl ?? false,
        ),
      );
      return;
    }

    if (fullPager && investmentType == InvestmentType.AUGGOLD99) {
      AppState.delegate!.appState.currentAction = PageAction(
        page: AssetSelectionViewConfig,
        state: PageState.addWidget,
        widget: GoldBuyView(
          amount: parsedAmount ?? amt,
          initialCoupon: coupon,
          gms: parsedGrams ?? gms,
          skipMl: isSkipMl ?? false,
          entryPoint: entryPoint,
          quickCheckout: quickCheckout,
        ),
      );
      return;
    }

    if (investmentType == InvestmentType.AUGGOLD99) {
      BaseUtil.openModalBottomSheet(
        addToScreenStack: true,
        enableDrag: false,
        hapticVibrate: true,
        isBarrierDismissible: false,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        content: GoldBuyView(
          amount: parsedAmount ?? amt,
          initialCoupon: coupon,
          gms: parsedGrams ?? gms,
          skipMl: isSkipMl ?? false,
          entryPoint: entryPoint,
          quickCheckout: quickCheckout,
        ),
      );
      return;
    }
  }

  static void openFloBuySheet({
    required String floAssetType,
    int? amt,
    Map<String, dynamic>? queryParams,
    bool? isSkipMl,
    String? entryPoint,
  }) {
    final coupon = queryParams?['coupon'];
    final amount = queryParams?['amount'];
    final parsedAmount =
        int.tryParse(amount ?? ''); // For parsing default value to null.
    final quickCheckout =
        // ignore: sdk_version_since
        bool.parse(queryParams?['shouldQuickCheckout'] ?? 'false');

    final userService = locator<UserService>();
    final locale = locator<S>();
    bool isUserBanned = false;

    AppState.isRepeated = false;
    AppState.onTap = null;
    AppState.isTxnProcessing = false;
    locator<BackButtonActions>().isTransactionCancelled = false;
    switch (floAssetType) {
      case Constants.ASSET_TYPE_FLO_FIXED_6:
        final bool? islBoxDepositBanned = userService.userBootUp?.data!.banMap
            ?.investments?.deposit?.lendBoxFd2?.isBanned;
        final String? lBoxDepositBanNotice = userService
            .userBootUp?.data!.banMap?.investments?.deposit?.lendBoxFd2?.reason;
        if (islBoxDepositBanned != null && islBoxDepositBanned) {
          BaseUtil.showNegativeAlert(
            lBoxDepositBanNotice ?? locale.assetNotAvailable,
            locale.tryLater,
          );
          isUserBanned = true;
        }
        break;

      case Constants.ASSET_TYPE_FLO_FIXED_3:
        final bool? islBoxDepositBanned = userService.userBootUp?.data!.banMap
            ?.investments?.deposit?.lendBoxFd1?.isBanned;
        final String? lBoxDepositBanNotice = userService
            .userBootUp?.data!.banMap?.investments?.deposit?.lendBoxFd1?.reason;
        if (islBoxDepositBanned != null && islBoxDepositBanned) {
          BaseUtil.showNegativeAlert(
            lBoxDepositBanNotice ?? locale.assetNotAvailable,
            locale.tryLater,
          );
          isUserBanned = true;
        }
        break;
      case Constants.ASSET_TYPE_FLO_FELXI:
        final bool? islBoxDepositBanned = userService
            .userBootUp?.data!.banMap?.investments?.deposit?.lendBox?.isBanned;
        final String? lBoxDepositBanNotice = userService
            .userBootUp?.data!.banMap?.investments?.deposit?.lendBox?.reason;
        if (islBoxDepositBanned != null && islBoxDepositBanned) {
          BaseUtil.showNegativeAlert(
            lBoxDepositBanNotice ?? locale.assetNotAvailable,
            locale.tryLater,
          );
          isUserBanned = true;
        }
        break;
    }

    Haptic.vibrate();

    if (isUserBanned) return;
    AppState.delegate!.appState.currentAction = PageAction(
      page: LendboxBuyViewConfig,
      state: PageState.addWidget,
      widget: LendboxBuyView(
        amount: parsedAmount ?? amt,
        initialCouponCode: coupon,
        skipMl: isSkipMl ?? false,
        onChanged: (p0) => p0,
        floAssetType: floAssetType,
        entryPoint: entryPoint,
        quickCheckout: quickCheckout,
      ),
    );
  }

  Future<void> updateUser() async {
    unawaited(locator<MarketingEventHandlerService>().getHappyHourCampaign());

    if (_userService.userSegments.contains("NEW_USER")) {
      await CacheService.invalidateByKey(CacheKeys.USER);
      await _userService.setBaseUser();
      // Another hack because microservices take time to update user data post
      // transaction 🤷🏻. And app uses this segment to check wether user is new
      // user or not.
      _userService.userSegments.remove('NEW_USER');
    }
  }

  static String getMaturityPref(String maturityEnum, bool isFrom10) {
    switch (maturityEnum) {
      case '0':
        return "Withdrawing to your bank account after maturity";
      case '1':
        return "Auto-investing in ${isFrom10 ? 10 : 12}% Flo on maturity";
      case '2':
        return "Move to ${isFrom10 ? 8 : 10}% Flo after maturity";
      default:
        return "Move to ${isFrom10 ? 8 : 10}% Flo after maturity";
    }
  }

  Future<void> showConfirmExit() async {
    await openModalBottomSheet(
        isBarrierDismissible: false,
        addToScreenStack: true,
        isScrollControlled: true,
        content: const ConfirmExitModal());
  }

  void openSellModalSheet({required InvestmentType investmentType}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final bool? isAugSellLocked = _userService
          .userBootUp?.data!.banMap?.investments?.withdrawal?.augmont?.isBanned;
      final String? augSellBanNotice = _userService
          .userBootUp?.data?.banMap?.investments?.withdrawal?.augmont?.reason;
      final bool? islBoxSellBanned = _userService
          .userBootUp?.data?.banMap?.investments?.withdrawal?.lendBox?.isBanned;
      final String? lBoxSellBanNotice = _userService
          .userBootUp?.data?.banMap?.investments?.withdrawal?.lendBox?.reason;
      if (investmentType == InvestmentType.AUGGOLD99 &&
          isAugSellLocked != null &&
          isAugSellLocked) {
        BaseUtil.showNegativeAlert(
            augSellBanNotice ?? locale.assetNotAvailable, locale.tryLater);
        return;
      }
      if (investmentType == InvestmentType.LENDBOXP2P &&
          islBoxSellBanned != null &&
          islBoxSellBanned) {
        BaseUtil.showNegativeAlert(
            lBoxSellBanNotice ?? locale.assetNotAvailable, locale.tryLater);
        return;
      }
      _analyticsService.track(
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
            ? const GoldSellView()
            : LendboxWithdrawalView(),
      );
    });
  }

  static void openDepositOptionsModalSheet(
      {int? amount, bool isSkipMl = false, int timer = 500}) {
    locator<AnalyticsService>()
        .track(eventName: AnalyticsEvents.assetOptionsModalTapped);
    Haptic.vibrate();
    Future.delayed(
      Duration(milliseconds: timer),
      () {
        return AppState.delegate!.appState.currentAction = PageAction(
          page: AssetSelectionViewConfig,
          state: PageState.addWidget,
          widget: AssetSelectionPage(
            amount: amount,
            isSkipMl: isSkipMl,
          ),
        );
      },
    );
  }

  static void showPositiveAlert(String? title, String? message,
      {int seconds = 2}) {
    AppToasts.showPositiveToast(
        title: title, subtitle: message, seconds: seconds);
  }

  static void showNegativeAlert(String? title, String? message,
      {int? seconds}) {
    AppToasts.showNegativeToast(
        title: title, subtitle: message, seconds: seconds);
  }

  static dynamic showNoInternetAlert() {
    return AppToasts.showNoInternetToast();
  }

  static Future<void> openDialog({
    required bool isBarrierDismissible,
    Widget? content,
    bool? addToScreenStack,
    bool? hapticVibrate,
    ValueChanged<dynamic>? callback,
    Color? barrierColor,
  }) async {
    if (addToScreenStack != null && addToScreenStack == true) {
      AppState.screenStack.add(ScreenItem.dialog);
    }
    d.log("Current Stack: ${AppState.screenStack}");
    Haptic.vibrate();
    await showDialog(
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.7),
      context: AppState.delegate!.navigatorKey.currentContext!,
      barrierDismissible: isBarrierDismissible,
      builder: (ctx) => content!,
      useSafeArea: true,
    );
  }

  static Future<void> openModalBottomSheet({
    required bool isBarrierDismissible,
    Widget? content,
    bool? addToScreenStack,
    bool? hapticVibrate,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    bool isScrollControlled = false,
    BoxConstraints? boxContraints,
    bool enableDrag = false,
  }) async {
    if (addToScreenStack != null && addToScreenStack) {
      AppState.screenStack.add(ScreenItem.dialog);
    }
    d.log("Current Stack: ${AppState.screenStack}");
    await showModalBottomSheet(
      enableDrag: enableDrag,
      constraints: boxContraints,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ??
            BorderRadius.vertical(
              top: Radius.circular(SizeConfig.padding16),
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

  static void showFelloRatingSheet() {
    d.log("qwertyuio", name: "showFelloRatingSheet");

    if (PreferenceHelper.getBool(PreferenceHelper.APP_RATING_SUBMITTED) ==
        false) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Haptic.vibrate();

        BaseUtil.openModalBottomSheet(
          addToScreenStack: true,
          enableDrag: false,
          hapticVibrate: true,
          isBarrierDismissible: true,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          content: const FelloInAppReview(),
        );
      });
    } else {
      Future.delayed(const Duration(milliseconds: 300), () {
        Haptic.vibrate();

        BaseUtil.openModalBottomSheet(
          addToScreenStack: true,
          enableDrag: false,
          hapticVibrate: true,
          isBarrierDismissible: true,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          content: const ReferralRatingSheet(),
        );
      });
    }
  }

  static FileType getFileType(String fileUrl) {
    String extension = fileUrl.toLowerCase().split('.').last;

    switch (extension) {
      case "svg":
        return FileType.svg;
      case "json":
      case "lottie":
        return FileType.lottie;
      case "png":
      case "jpeg":
      case "webp":
      case "jpg":
        return FileType.png;
      default:
        return FileType.unknown;
    }
  }

  static Widget getWidgetBasedOnUrl(String fileUrl,
      {double? height, double? width}) {
    FileType fileType = getFileType(fileUrl);

    switch (fileType) {
      case FileType.svg:
        return SvgPicture.network(
          fileUrl,
          fit: BoxFit.contain,
          height: height,
          width: width,
        );

      case FileType.lottie:
        return Lottie.network(fileUrl,
            fit: BoxFit.contain, height: height, width: width);
      case FileType.png:
        return CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: fileUrl,
          height: height,
          width: width,
        );
      default:
        return const Icon(
          Icons.add,
          color: Colors.white,
        );
    }
  }

  static int extractIntFromString(String input) {
    // Remove all non-digit characters from the string
    final sanitizedString = input.replaceAll(RegExp(r'[^0-9]'), '');

    // Parse the sanitized string as an integer
    final parsedInt = int.tryParse(sanitizedString);

    // Return the parsed integer value, or 0 if it couldn't be parsed
    return parsedInt ?? 0;
  }

  Future<bool> signOut() async {
    try {
      // await _lModel!.deleteLocalAppData();
      logger.d('Cleared local cache');
      _appState.setCurrentTabIndex = 0;

      //remove  token from remote
      //await _dbModel.updateClientToken(myUser, '');

      //TODO better fix required
      ///IMP: When a user signs out and attempts
      /// to sign in again without closing the app,
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
      referredCode = null;

      // AppState.delegate!.appState.setCurrentTabIndex = 0;
      manualReferralCode = null;
      referrerUserId = null;
      _setRuntimeDefaults();
      await FirebaseMessaging.instance.deleteToken();

      return true;
    } catch (e) {
      logger.e('Failed to clear data/sign out user: $e');
      return false;
    }
  }

  static Future<bool> launchUrl(String url) async {
    if (!await launchUrlString(url, mode: LaunchMode.externalApplication)) {
      BaseUtil.showNegativeAlert("Operation cannot be completed at the moment",
          "Please try after some time");
      return false;
    }
    return true;
  }

  static int getRandomRewardAmount(index) {
    if (index < 5) {
      return 50;
    } else if (index < 10) {
      return 100;
    } else if (index < 15) {
      return 150;
    } else if (index < 20) {
      return 200;
    } else if (index < 50) {
      return 500;
    } else {
      return 100;
    }
  }

  bool isOldCustomer() {
    //all users before april 2021 are marked old
    if (userCreationTimestamp == null) return false;
    return userCreationTimestamp!.isBefore(Constants.VERSION_2_RELEASE_DATE);
  }

  static int getWeekNumber({DateTime? currentDate}) {
    DateTime tdt = (currentDate != null) ? currentDate : DateTime.now();
    int dayn = tdt.weekday;

    DateTime firstThursday = DateTime(tdt.year, tdt.month, tdt.day - dayn + 3);
    tdt = DateTime(tdt.year, 1, 1);
    if (tdt.weekday != DateTime.friday) {
      //tdt.setMonth(0, 1 + ((4 - tdt.getDay()) + 7) % 7);
      int x = tdt.weekday;
      x = (tdt.weekday == 7) ? 0 : tdt.weekday;
      tdt = DateTime(tdt.year, 1, 1 + ((5 - x) + 7) % 7);
    }
    int n = 1 +
        ((firstThursday.millisecondsSinceEpoch - tdt.millisecondsSinceEpoch) /
                604800000)
            .ceil();
    return n;
  }

  double getUpdatedWithdrawalClosingBalance(double investment) =>
      toDouble(_userFundWallet!.iciciBalance) +
      toDouble(_userFundWallet!.augGoldBalance) +
      toDouble(_userFundWallet!.prizeBalance) +
      toDouble(_userFundWallet!.lockedPrizeBalance) -
      investment;

  double getCurrentTotalClosingBalance() =>
      toDouble(_userFundWallet!.iciciBalance) +
      toDouble(_userFundWallet!.augGoldBalance) +
      toDouble(_userFundWallet!.prizeBalance) +
      toDouble(_userFundWallet!.lockedPrizeBalance);

  static T? _cast<T>(x) => x is T ? x : null;

  static double toDouble(x) {
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

  static int toInt(x) {
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

  static dynamic getIntOrDouble(double x) {
    return x - x.round() != 0 ? x : x.toInt();
  }

  static double digitPrecision(double x, [int offset = 2, bool round = true]) {
    final precision = pow(10, offset);
    double y = x * precision;
    int z = round ? y.round() : y.truncate();
    return z / precision;
  }

  static String formatIndianRupees(double value) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  static String formatRupees(double value) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  static String formatCompactRupees(double value) {
    final formatter = NumberFormat.compactCurrency(
      decimalDigits: 0,
      locale: 'en_IN',
      symbol: '',
    );
    return formatter.format(value);
  }

  static Future<bool> isFirstTimeThisWeek() async {
    /// Get the current week number
    final currentWeekNumber =
        (DateTime.now().difference(DateTime.utc(0, 1, 1)).inDays ~/ 7) + 1;

    final TimestampModel? userCreatedOn =
        locator<UserService>().baseUser?.createdOn;

    /// if user signup date is same as current week number then return false
    if (userCreatedOn != null) {
      final userCreatedOnDate = DateTime.fromMillisecondsSinceEpoch(
          userCreatedOn.millisecondsSinceEpoch);
      final userCreatedOnWeekNumber =
          (userCreatedOnDate.difference(DateTime.utc(0, 1, 1)).inDays ~/ 7) + 1;
      if (userCreatedOnWeekNumber == currentWeekNumber) {
        return false;
      }
    }

    /// Get the last week number when the app was opened
    final lastWeekNumber =
        PreferenceHelper.getInt(PreferenceHelper.LAST_WEEK_NUMBER);

    /// Update the last week number in preferences
    await PreferenceHelper.setInt(
        PreferenceHelper.LAST_WEEK_NUMBER, currentWeekNumber);

    /// Check if the current week is the same as the last week when the app was opened
    return currentWeekNumber != lastWeekNumber;
  }

  static int calculateRemainingDays(DateTime endDate) {
    DateTime now = DateTime.now();
    Duration difference = endDate.difference(now);
    int remaining = difference.inDays;
    return remaining;
  }

  void showFoundBugSheet() {
    Haptic.vibrate();

    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      enableDrag: false,
      hapticVibrate: true,
      isBarrierDismissible: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      content: const FoundBug(),
    );
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
    _myUser!.userPreferences.setPreference(Preferences.APPLOCK, value ? 1 : 0);
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

  bool isSignedIn() => firebaseUser != null;

  // bool isActiveUser() => (_myUser != null && !_myUser!.hasIncompleteDetails());

  DateTime? get userCreationTimestamp => _userCreationTimestamp;

  int? get ticketCount => _ticketCount;

  set ticketCount(int? value) {
    _ticketCount = value;
    notifyListeners();
  }

  bool? get isGoogleSignInProgress => _isGoogleSignInProgress;

  set isGoogleSignInProgress(value) {
    _isGoogleSignInProgress = value;
    notifyListeners();
  }

  static String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  bool? get isUpiInfoMissing => _isUpiInfoMissing;

  set isUpiInfoMissing(bool? value) {
    _isUpiInfoMissing = value;
    notifyListeners();
  }

  Future showHappyHourDialog(HappyHourCampign model,
      {bool isComingFromSave = false}) async {
    return openModalBottomSheet(
      backgroundColor: Colors.transparent,
      addToScreenStack: true,
      hapticVibrate: true,
      content: HappyHourModel(
        model: model,
        isComingFromSave: isComingFromSave,
      ),
      isBarrierDismissible: true,
    );
  }
}

class CompleteProfileDialog extends StatelessWidget {
  final String? title, subtitle;

  const CompleteProfileDialog({super.key, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return WillPopScope(
      onWillPop: () async {
        await AppState.backButtonDispatcher!.didPopRoute();
        return Future.value(true);
      },
      child: MoreInfoDialog(
        title: title ?? locale.obCompleteProfile,
        text: subtitle ?? locale.obCompleteProfileSubTitle,
        imagePath: Assets.completeProfile,
        btnText: locale.btnComplete.toUpperCase(),
        onPressed: () {
          while (AppState.screenStack.length > 1) {
            AppState.backButtonDispatcher!.didPopRoute();
          }
          AppState.delegate!.appState.setCurrentTabIndex = 0;
        },
      ),
    );
  }
}
