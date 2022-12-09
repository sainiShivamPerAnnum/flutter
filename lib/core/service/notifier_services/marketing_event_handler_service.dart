import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/marketing_event_handler_enum.dart';
import 'package:felloapp/core/model/daily_bonus_event_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/repository/golden_ticket_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/ui/service_elements/events/daily_app_bonus_modalsheet.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MarketingEventHandlerService
    extends PropertyChangeNotifier<MarketingEventsHandlerProperties> {
  final GoldenTicketRepository _gtRepo = locator<GoldenTicketRepository>();
  final GoldenTicketService _gtService = locator<GoldenTicketService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  int currentDay = -1;
  DailyAppBonusClaimRewardModel? _dailyAppBonusClaimRewardData;
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

  //Daily App Bonus Methods

  Future<void> checkUserDailyAppCheckInStatus() async {
    _logger.d("DAILY APP BONUS: checking begin");
    if (AppState.isRootAvailableForIncomingTaskExecution == false) return;
    final dailyAppBonusEventResponse =
        await _gtRepo.getDailyBonusEventDetails();
    if (dailyAppBonusEventResponse.isSuccess()) {
      dailyAppCheckInEventData = dailyAppBonusEventResponse.model;
      AppState.isRootAvailableForIncomingTaskExecution = false;
      getCurrentDay(dailyAppCheckInEventData!);
      // currentDay = dailyAppCheckInEventData!.currentDay;
      if (await _claimDailyAppBonusReward()) {
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
    } else {
      _logger.d(
          "DAILY APP BONUS GET: ERROR :: ${dailyAppBonusEventResponse.errorMessage}");
    }
  }

  Future<bool> _claimDailyAppBonusReward() async {
    final res = await _gtRepo.claimDailyBonusEventDetails();
    if (res.isSuccess()) {
      _dailyAppBonusClaimRewardData = res.model;
      PreferenceHelper.setString(
          PreferenceHelper.CACHE_LAST_DAILY_APP_BONUS_REWARD_CLAIM_TIMESTAMP,
          DateTime.now().toIso8601String());
      return true;
    } else {
      return false;
    }
  }

  Future<void> sudoClaimDailyReward() async {
    isDailyAppBonusClaimInProgress = true;
    _analyticsService
        .track(eventName: AnalyticsEvents.dailyAppBonusClaimed, properties: {
      "claim day": (dailyAppCheckInEventData?.currentDay ?? 0) + 1,
      "Retries left": dailyAppCheckInEventData?.streakReset ?? 0
    });
    notifyListeners(MarketingEventsHandlerProperties.DailyAppCheckIn);
    GoldenTicketService.goldenTicketId = _dailyAppBonusClaimRewardData!.gtId;
    await _gtService.fetchAndVerifyGoldenTicketByID();
    _isDailyAppBonusClaimed = true;
    isDailyAppBonusClaimInProgress = false;
    _gtService.showInstantGoldenTicketView(
        source: GTSOURCE.game, onJourney: true);
  }

  gotItTapped() {
    _analyticsService.track(
        eventName: AnalyticsEvents.dailyAppBonusGotItTapped);
    AppState.backButtonDispatcher!.didPopRoute();
  }

  getCurrentDay(DailyAppCheckInEventModel data) {
    if (data.streakEnd == TimestampModel.none())
      currentDay = 0;
    else if (data.showStreakBreakMessage)
      currentDay = 0;
    else
      currentDay = TimestampModel.daysBetween(
          dailyAppCheckInEventData!.streakStart.toDate(), DateTime.now());
    log("Current Day: $currentDay");
  }
}




//NOTES
/**
 * startedOn: First time streak started on
 * streakStart: current streak first day
 * streakEnd: current streak last day
 * currentDay: no of days completed for streak // -1 == not started yet || 0 == 1 day completed
 * completedDays: streakEnd - streakStart // 0 == 1 day completed || 1 == 2 days completed
 * if(completedDays == currentDay) today's rewards are not claimed
 * 
 */