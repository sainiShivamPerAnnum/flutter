import 'dart:async';

import 'package:felloapp/base_util.dart';
// import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/model/fello_facts_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
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

class MyAccountVM extends BaseViewModel {
  final UserService _userService = locator<UserService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final UserRepository? userRepo = locator<UserRepository>();
  final CampaignRepo _campaignRepo = locator<CampaignRepo>();

  S locale = locator<S>();

  Timer? _timer;
  List<FelloFactsModel>? fellofacts = [];
  bool _isFelloFactsLoading = false;

  bool get isFelloFactsLoading => _isFelloFactsLoading;

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

  String get refUrl => _refUrl;

  double get getUnclaimedPrizeBalance =>
      _userService.userFundWallet!.unclaimedBalance;

  SuperFelloLevel get superFelloLevel => _userService.baseUser!.superFelloLevel;

  Future<void> init() async {
    await getFelloFacts();
    // _lbService!.fetchReferralLeaderBoard();
    await locator<ScratchCardService>().updateUnscratchedGTCount();
  }

  void clear() {
    _timer?.cancel();
  }

  String getWinningsButtonText() {
    return _userService.userFundWallet!.isPrizeBalanceUnclaimed()
        ? locale.redeem
        : locale.share;
  }

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

  void navigateToWinnings() {
    _analyticsService.track(eventName: AnalyticsEvents.winReferral);
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: MyWinningsPageConfig,
    );
  }

  void openProfile() {
    _baseUtil.openProfileDetailsScreen();
  }

  double calculateFillHeight(
      double winningAmount, double containerHeight, int redeemAmount) {
    double fillPercent = (winningAmount / redeemAmount) * 100;
    double heightToFill = (fillPercent / 100) * containerHeight;

    return heightToFill;
  }

  Future<void> getFelloFacts() async {
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
