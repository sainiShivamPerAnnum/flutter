import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/repository/winners_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_events.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/leaderboard_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/core/service/winners_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/custom_logger.dart';

class WinViewModel extends BaseModel {
  final _userService = locator<UserService>();
  final _winnersRepo = locator<WinnersRepository>();
  final _logger = locator<CustomLogger>();
  final _winnerService = locator<WinnerService>();
  final _lbService = locator<LeaderboardService>();
  final _analyticsService = locator<AnalyticsService>();

  LocalDBModel _localDBModel = locator<LocalDBModel>();
  bool isWinnersLoading = false;
  WinnersModel _winners;

  WinnersModel get winners => _winners;

  double get winnings => _userService.userFundWallet.prizeBalance;

  set winners(val) {
    _winners = val;
    notifyListeners();
  }

  double get getUnclaimedPrizeBalance =>
      _userService.userFundWallet.unclaimedBalance;

  init() {}

  String getWinningsButtonText() {
    if (_userService.userFundWallet.isPrizeBalanceUnclaimed())
      return "Redeem";
    else
      return "Share";
  }

  Future<PrizeClaimChoice> getClaimChoice() async {
    return await _localDBModel.getPrizeClaimChoice();
  }

  void navigateToMyWinnings() {
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: MyWinnigsPageConfig);
  }

  void navigateToRefer() {
    _analyticsService.track(eventName: AnalyticsEvents.winReferral);
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: ReferralDetailsPageConfig,
    );
  }

  void navigateToWinnings() {
    _analyticsService.track(eventName: AnalyticsEvents.winReferral);
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: MyWinnigsPageConfig,
    );
  }

  openVoucherModal(
    String asset,
    String title,
    String subtitle,
    Color color,
    bool commingsoon,
    List<String> instructions,
  ) {
    if (Platform.isIOS && commingsoon)
      return;
    else
      return BaseUtil.openModalBottomSheet(
        addToScreenStack: true,
        content: VoucherModal(
          color: color,
          asset: asset,
          commingSoon: commingsoon,
          title: title,
          subtitle: subtitle,
          instructions: instructions,
        ),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.padding24),
            topRight: Radius.circular(SizeConfig.padding24)),
        // backgroundColor: Color(0xffFFDBF6),
        isBarrierDismissable: false,
        hapticVibrate: true,
      );
  }
}
