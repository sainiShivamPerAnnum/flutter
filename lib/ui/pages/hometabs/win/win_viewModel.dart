import 'dart:async';

import 'package:felloapp/base_util.dart';
// import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/fello_facts_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/repository/prizing_repo.dart';
import 'package:felloapp/core/repository/referral_repo.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/appflyer_analytics.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/elements/fello_dialog/fello_in_app_review.dart';
import 'package:felloapp/ui/pages/userProfile/my_winnings/my_winnings_view.dart';
import 'package:felloapp/ui/service_elements/last_week/last_week_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class WinViewModel extends BaseViewModel {
  final UserService _userService = locator<UserService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final JourneyRepository _journeyRepo = locator<JourneyRepository>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final ReferralRepo _refRepo = locator<ReferralRepo>();
  final AppFlyerAnalytics _appFlyer = locator<AppFlyerAnalytics>();

  // final WinnerService? _winnerService = locator<WinnerService>();
  final LeaderboardService _lbService = locator<LeaderboardService>();
  final UserRepository? userRepo = locator<UserRepository>();
  final TxnHistoryService _transactionHistoryService =
      locator<TxnHistoryService>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();
  final PrizingRepo _prizingRepo = locator<PrizingRepo>();
  final CampaignRepo _campaignRepo = locator<CampaignRepo>();
  final ScratchCardRepository _gtRepo = locator<ScratchCardRepository>();
  final UserRepository _userRepo = locator<UserRepository>();
  final int _unscratchedGTCount = 0;
  S locale = locator<S>();

  Timer? _timer;
  List<FelloFactsModel>? fellofacts = [];
  bool _isFelloFactsLoading = false;

  get isFelloFactsLoading => _isFelloFactsLoading;

  set isFelloFactsLoading(value) {
    _isFelloFactsLoading = value;
    notifyListeners();
  }

  final bool _isShareAlreadyClicked = false;

  bool get isShareAlreadyClicked => _isShareAlreadyClicked;

  bool shareWhatsappInProgress = false;
  bool shareLinkInProgress = false;
  final bool _isShareLoading = false;

  bool get isShareLoading => _isShareLoading;
  final String _refUrl = "";

  get refUrl => _refUrl;

  double get getUnclaimedPrizeBalance =>
      _userService.userFundWallet!.unclaimedBalance;

  Future<void> init() async {
    getFelloFacts();
    // _lbService!.fetchReferralLeaderBoard();
    locator<ScratchCardService>().updateUnscratchedGTCount();
  }

  // Future<void> shareWhatsApp() async {
  //   if (await BaseUtil.showNoInternetAlert()) return;
  //   _fcmListener!.addSubscription(FcmTopic.REFERRER);
  //   BaseAnalytics.analytics!.logShare(
  //     contentType: 'referral',
  //     itemId: _userService!.baseUser!.uid!,
  //     method: 'whatsapp',
  //   );
  //   shareWhatsappInProgress = true;
  //   refresh();

  //   String? url = await this.generateLink();
  //   shareWhatsappInProgress = false;
  //   refresh();

  //   if (url == null) {
  //     BaseUtil.showNegativeAlert(locale.generatingLinkFailed, locale.tryLater);
  //     return;
  //   } else
  //     _logger!.d(url);
  //   try {
  //     _analyticsService.track(eventName: AnalyticsEvents.whatsappShare);
  //     FlutterShareMe().shareToWhatsApp(msg: _shareMsg + url).then((flag) {
  //       if (flag == "false") {
  //         FlutterShareMe()
  //             .shareToWhatsApp4Biz(msg: _shareMsg + url)
  //             .then((flag) {
  //           _logger!.d(flag);
  //           if (flag == "false") {
  //             BaseUtil.showNegativeAlert(
  //                 locale.whatsappNotDetected, locale.otherShareOption);
  //           }
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     _logger!.d(e.toString());
  //   }
  // }

  // setupAutoEventScroll() {
  //   try {
  //     Future.delayed(Duration(seconds: 6), () {
  //       _timer = Timer.periodic(Duration(seconds: 6), (Timer timer) {
  //         if (eventScrollController.position.pixels <
  //             eventScrollController.position.maxScrollExtent) {
  //           eventScrollController.animateTo(
  //               eventScrollController.position.pixels +
  //                   SizeConfig.screenWidth! * 0.64,
  //               duration: Duration(seconds: 1),
  //               curve: Curves.decelerate);
  //         } else {
  //           eventScrollController.animateTo(0,
  //               duration: Duration(seconds: 2), curve: Curves.decelerate);
  //         }
  //       });
  //     });
  //   } catch (e) {
  //     _logger!.e(e.toString());
  //   }
  // }

  void clear() {
    _timer?.cancel();
  }

  String getWinningsButtonText() {
    if (_userService.userFundWallet!.isPrizeBalanceUnclaimed()) {
      return locale.redeem;
    } else {
      return locale.share;
    }
  }

  // Future<PrizeClaimChoice> getClaimChoice() async {
  //   return await _localDBModel!.getPrizeClaimChoice();
  // }

  void navigateToMyWinnings() {
    AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: MyWinningsPageConfig,
        widget: const MyWinningsView());
  }

  void navigateToRefer() {
    _analyticsService.track(eventName: AnalyticsEvents.winReferral);
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: ReferralDetailsPageConfig,
    );
  }

  // showConfirmDialog(PrizeClaimChoice choice) {
  //   //TODO fields empty for winredeemWinningsTapped
  //   _analyticsService.track(
  //     eventName: AnalyticsEvents.winRedeemWinningsTapped,
  //     properties: AnalyticsProperties.getDefaultPropertiesMap(
  //       extraValuesMap: {
  //         "Total Winnings Amount":
  //             _userService?.userFundWallet?.prizeLifetimeWin ?? 0
  //       },
  //     ),
  //   );
  //   BaseUtil.openDialog(
  //     addToScreenStack: true,
  //     isBarrierDismissible: false,
  //     hapticVibrate: true,
  //     content: ConfirmationDialog(
  //       confirmAction: () async {
  //         await claim(choice, _userService!.userFundWallet!.unclaimedBalance);
  //       },
  //       title: locale.confirmation,
  //       description: choice == PrizeClaimChoice.AMZ_VOUCHER
  //           ? locale.redeemAmznGiftVchr(BaseUtil.digitPrecision(
  //               _userService!.userFundWallet!.unclaimedBalance, 2, false))
  //           : locale.redeemDigitalGold(BaseUtil.digitPrecision(
  //               _userService!.userFundWallet!.unclaimedBalance, 2, false)),
  //       buttonText: locale.btnYes,
  //       cancelBtnText: locale.btnNo,
  //       cancelAction: AppState.backButtonDispatcher!.didPopRoute,
  //     ),
  //   );
  // }

  // Future<String> getGramsWon(double amount) async {
  //   AugmontService? augmontService = locator<AugmontService>();
  //   if (augmontService == null) return '0.0gm';
  //   AugmontRates? goldRates = await augmontService.getRates();

  //   if (goldRates != null && goldRates.goldSellPrice != 0.0)
  //     return '${BaseUtil.digitPrecision(amount / goldRates.goldSellPrice!, 4, false)}gm';
  //   else
  //     return '0.0gm';
  // }

  // showSuccessPrizeWithdrawalDialog(PrizeClaimChoice choice, String subtitle,
  //     double claimPrize, String gramsWon) async {
  //   //Starting the redemption sucessfull screen
  //   AppState.delegate!.appState.currentAction = PageAction(
  //     state: PageState.addWidget,
  //     widget: RedeemSucessfulScreen(
  //         subTitleWidget: getSubtitleWidget(subtitle),
  //         claimPrize: claimPrize,
  //         dpUrl: _userService!.myUserDpUrl,
  //         choice: choice,
  //         wonGrams: gramsWon //await getGramsWon(claimPrize),
  //         ),
  //     page: RedeemSuccessfulScreenPageConfig,
  //   );
  // }

  // claim(PrizeClaimChoice choice, double claimPrize) {
  //   // double _claimAmt = claimPrize;
  //   _registerClaimChoice(choice).then((flag) {
  //     getGramsWon(claimPrize).then((value) {
  //       if (flag) {
  //         showSuccessPrizeWithdrawalDialog(
  //             choice,
  //             choice == PrizeClaimChoice.AMZ_VOUCHER ? "amazon" : "gold",
  //             claimPrize,
  //             value);
  //       }
  //     });
  //   });

  //   _analyticsService.track(
  //     eventName: AnalyticsEvents.winRedeemWinnings,
  //     properties: AnalyticsProperties.getDefaultPropertiesMap(
  //       extraValuesMap: {
  //         "Total Winnings Amount":
  //             _userService?.userFundWallet?.prizeLifetimeWin ?? 0
  //       },
  //     ),
  //   );
  // }

// SET AND GET CLAIM CHOICE
  // Future<bool> _registerClaimChoice(PrizeClaimChoice choice) async {
  //   if (choice == PrizeClaimChoice.NA) return false;
  //   final response = await _prizingRepo!.claimPrize(
  //     _userService!.userFundWallet!.unclaimedBalance,
  //     choice,
  //   );

  //   if (response.isSuccess()) {
  //     _userService!.getUserFundWalletData();
  //     _transactionHistoryService!.updateTransactions(InvestmentType.AUGGOLD99);
  //     notifyListeners();
  //     // await _localDBModel!.savePrizeClaimChoice(choice);
  //     AppState.backButtonDispatcher!.didPopRoute();

  //     return true;
  //   } else {
  //     AppState.backButtonDispatcher!.didPopRoute();
  //     BaseUtil.showNegativeAlert(
  //       locale.withDrawalFailed,
  //       response.errorMessage ?? locale.tryLater,
  //     );
  //     return false;
  //   }
  // }

  // Widget getSubtitleWidget(String subtitle) {
  //   if (subtitle == "gold" || subtitle == "amazon")
  //     return RichText(
  //       textAlign: TextAlign.center,
  //       text: TextSpan(
  //         text: subtitle == "gold"
  //             ? locale.goldCreditedInWallet
  //             : locale.giftCard,
  //         style: TextStyles.body3.colour(Colors.white),
  //         children: [
  //           TextSpan(
  //             text: locale.businessDays,
  //             style: TextStyles.body3.colour(Colors.white),
  //           )
  //         ],
  //       ),
  //     );
  //   return Text(
  //     subtitle,
  //     textAlign: TextAlign.center,
  //     style: TextStyles.body2.colour(Colors.white),
  //   );
  // }

// Capture Share card Logic

  void navigateToWinnings() {
    _analyticsService.track(eventName: AnalyticsEvents.winReferral);
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: MyWinningsPageConfig,
    );
  }

  openProfile() {
    _baseUtil.openProfileDetailsScreen();
  }

  double calculateFillHeight(
      double winningAmount, double containerHeight, int redeemAmount) {
    double fillPercent = (winningAmount / redeemAmount) * 100;
    double heightToFill = (fillPercent / 100) * containerHeight;

    return heightToFill;
  }

  getFelloFacts() async {
    isFelloFactsLoading = true;
    final res = await _campaignRepo.getFelloFacts();
    if (res.isSuccess()) {
      fellofacts = res.model;
      _logger.d("Fello Facts Fetched Length: ${fellofacts!.length}");
    } else {
      fellofacts = [];
    }
    _logger.d("Fello Facts Length: ${fellofacts!.length}");
    isFelloFactsLoading = false;
  }

  Future<void> showLastWeekSummary() async {
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: LastWeekOverviewConfig,
      widget: const LastWeekOverView(
        callCampaign: false,
      ),
    );
  }

  void showRatingSheet() {
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
  }
}
