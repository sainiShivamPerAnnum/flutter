import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/marketing_event_handler_enum.dart';
import 'package:felloapp/core/model/daily_bonus_event_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/repository/golden_ticket_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/service_elements/events/daily_app_bonus_modalsheet.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MarketingEventHandlerService
    extends PropertyChangeNotifier<MarketingEventsHandlerProperties> {
  final GoldenTicketRepository _gtRepo = locator<GoldenTicketRepository>();
  int currentDay = 2;
  DailyAppCheckInEventModel? _dailyAppCheckInEventData;
  bool _isDailyAppBonusClaimInProgress = false;
  bool _isDailyAppBonusClaimed = false;

  get isDailyAppBonusClaimed => this._isDailyAppBonusClaimed;

  set isDailyAppBonusClaimed(value) {
    this._isDailyAppBonusClaimed = value;
    notifyListeners(MarketingEventsHandlerProperties.DailyAppCheckIn);
  }

  get isDailyAppBonusClaimInProgress => this._isDailyAppBonusClaimInProgress;

  set isDailyAppBonusClaimInProgress(value) {
    this._isDailyAppBonusClaimInProgress = value;
    notifyListeners(MarketingEventsHandlerProperties.DailyAppCheckIn);
  }

  DailyAppCheckInEventModel? get dailyAppCheckInEventData =>
      this._dailyAppCheckInEventData;

  set dailyAppCheckInEventData(DailyAppCheckInEventModel? value) {
    this._dailyAppCheckInEventData = value;
    notifyListeners(MarketingEventsHandlerProperties.DailyAppCheckIn);
  }

  Future<void> checkRunningEvents() async {
    if (AppState.isRootAvailableForIncomingTaskExecution == false) return;
    await checkUserDailyAppCheckInStatus();
  }

  //Daily App Bounus Methods

  Future<void> checkUserDailyAppCheckInStatus() async {
    if (AppState.isRootAvailableForIncomingTaskExecution == false) return;
    final dailyAppBonusEventResponse =
        await _gtRepo.getDailyBonusEventDetails();
    if (dailyAppBonusEventResponse.isSuccess()) {
      dailyAppCheckInEventData = dailyAppBonusEventResponse.model;
      AppState.isRootAvailableForIncomingTaskExecution = false;
      BaseUtil.openModalBottomSheet(
        isBarrierDismissible: true,
        addToScreenStack: true,
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
        backgroundColor: UiConstants.kSaveDigitalGoldCardBg,
        hapticVibrate: true,
        isScrollControlled: true,
        content: DailyAppCheckInEventModalSheet(),
      );
    }
  }

  Future<bool> claimDailyAppBonusReward() async {
    isDailyAppBonusClaimInProgress = true;
    // final res = await _gtRepo.claimDailyBonusEventDetails();
    // if (res.isSuccess()) {
    //   //update modalsheet ui to completed
    //   //show instant gt view with new gt
    // } else {
    //   BaseUtil.showNegativeAlert(res.errorMessage, "");
    // }
    await Future.delayed(Duration(seconds: 3));
    PreferenceHelper.setString(
        PreferenceHelper.CACHE_LAST_DAILY_APP_BONUS_REWARD_CLAIM_TIMESTAMP,
        DateTime.now().toIso8601String());
    _isDailyAppBonusClaimed = true;
    currentDay++;
    isDailyAppBonusClaimInProgress = false;
    return true;
    // return res.model ?? false;
  }
}
