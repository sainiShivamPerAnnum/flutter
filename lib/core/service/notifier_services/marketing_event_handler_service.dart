import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/marketing_event_handler_enum.dart';
import 'package:felloapp/core/model/daily_bonus_event_model.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/rewards/instant_scratch_card/gt_instant_view.dart';
import 'package:felloapp/ui/service_elements/events/daily_app_bonus_modalsheet.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarketingEventHandlerService
    extends PropertyChangeNotifier<MarketingEventsHandlerProperties> {
  final ScratchCardRepository _gtRepo = locator<ScratchCardRepository>();
  final ScratchCardService _gtService = locator<ScratchCardService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  int currentDay = -1;
  DailyAppBonusClaimRewardModel? _dailyAppBonusClaimRewardData;
  DailyAppCheckInEventModel? _dailyAppCheckInEventData;
  bool _isDailyAppBonusClaimInProgress = false;
  bool _isDailyAppBonusClaimed = false;
  bool _showModalsheet = true;
  bool get showModalsheet => _showModalsheet;

  set showModalsheet(bool value) {
    _showModalsheet = value;
    notifyListeners(MarketingEventsHandlerProperties.DailyAppCheckIn);
  }

  bool get isDailyAppBonusClaimed => _isDailyAppBonusClaimed;

  set isDailyAppBonusClaimed(value) {
    _isDailyAppBonusClaimed = value;
    notifyListeners(MarketingEventsHandlerProperties.DailyAppCheckIn);
  }

  bool get isDailyAppBonusClaimInProgress => _isDailyAppBonusClaimInProgress;

  set isDailyAppBonusClaimInProgress(value) {
    _isDailyAppBonusClaimInProgress = value;
    notifyListeners(MarketingEventsHandlerProperties.DailyAppCheckIn);
  }

  DailyAppCheckInEventModel? get dailyAppCheckInEventData =>
      _dailyAppCheckInEventData;

  set dailyAppCheckInEventData(DailyAppCheckInEventModel? value) {
    _dailyAppCheckInEventData = value;
    notifyListeners(MarketingEventsHandlerProperties.DailyAppCheckIn);
  }

  // Future<void> checkRunningEvents() async {
  //   if (AppState.isRootAvailableForIncomingTaskExecution == false) return;
  //   await checkUserDailyAppCheckInStatus();
  // }

  void removeHappyHourBanner() {
    showHappyHourBanner = false;
    notifyListeners(MarketingEventsHandlerProperties.HappyHour);
  }

  late bool showHappyHourBanner = false;

  Future<void> getHappyHourCampaign() async {
    showHappyHourBanner = false;
    notifyListeners(MarketingEventsHandlerProperties.HappyHour);
    final campaign = await locator<CampaignRepo>().getHappyHourCampaign();
    if (campaign.code == 200 && campaign.model != null) {
      final data = campaign.model!.data!;
      //[Not Started]
      if (data.happyHourType == HappyHourType.notStarted) return;

      if (locator.isRegistered<HappyHourCampign>()) {
        locator.unregister<HappyHourCampign>();
      }
      locator.registerSingleton<HappyHourCampign>(campaign.model!);

      // [PREBUZZ]
      if (data.happyHourType == HappyHourType.preBuzz) {
        await locator<BaseUtil>().showHappyHourDialog(campaign.model!);
        await _sharePreference.remove('duringHappyHourVisited');
        await _sharePreference.remove('timStampOfHappyHour');
        await _sharePreference.remove('showedAfterHappyHourDialog');
        return;
      }

      //Clear Cache

      clearCache();

      //[Live]
      if (data.happyHourType == HappyHourType.live) {
        if (!_isDuringHappyHourVisited && !AppState.isFirstTime) {
          await locator<BaseUtil>().showHappyHourDialog(campaign.model!);
          await _sharePreference.setBool("duringHappyHourVisited", true);
          await _sharePreference.setString(
              'timStampOfHappyHour', DateTime.now().toString());
        }
        showHappyHourBanner = true;
        notifyListeners(MarketingEventsHandlerProperties.HappyHour);
        return;
      }

      //[Expired]
      final endTime = DateTime.parse(campaign.model!.data!.endTime!);

      if (endTime.day != DateTime.now().day) {
        return;
      }

      if (DateTime.now().isAfter(endTime) &&
          !_isDuringHappyHourVisited &&
          !alreadyShowed) {
        await locator<BaseUtil>().showHappyHourDialog(campaign.model!);
        await _sharePreference.setBool("showedAfterHappyHourDialog", true);
      }
    }
  }

  void clearCache() {
    final date = _sharePreference.getString("timStampOfHappyHour") ?? "0";

    final day = DateTime.tryParse(date)?.day;
    if (day == null) return;

    if (DateTime.now().day != day) {
      _sharePreference.remove('timStampOfHappyHour');
      _sharePreference.remove('duringHappyHourVisited');
      _sharePreference.remove('showedAfterHappyHourDialog');
    }
  }

  final _sharePreference = locator<SharedPreferences>();
  bool get _isDuringHappyHourVisited =>
      _sharePreference.getBool("duringHappyHourVisited") ?? false;

  bool get alreadyShowed =>
      _sharePreference.getBool("showedAfterHappyHourDialog") ?? false;

  dump() {
    currentDay = -1;
    _dailyAppBonusClaimRewardData = null;
    _dailyAppCheckInEventData = null;
    _isDailyAppBonusClaimInProgress = false;
    _isDailyAppBonusClaimed = false;
  }

  //Daily App Bonus Methods

  Future<void> getCampaigns() async {
    await checkUserDailyAppCheckInStatus()
        .then((value) => getHappyHourCampaign());
  }

  Future<void> checkUserDailyAppCheckInStatus() async {
    _logger.d("DAILY APP BONUS: checking begin");
    if (AppState.isRootAvailableForIncomingTaskExecution == false) return;
    final dailyAppBonusEventResponse =
        await _gtRepo.getDailyBonusEventDetails();
    if (dailyAppBonusEventResponse.isSuccess()) {
      dailyAppCheckInEventData = dailyAppBonusEventResponse.model;
      AppState.isRootAvailableForIncomingTaskExecution = false;
      getCurrentDay(dailyAppCheckInEventData!);
      if (dailyAppCheckInEventData!.gtId.isNotEmpty) {
        await BaseUtil.openModalBottomSheet(
          isBarrierDismissible: true,
          addToScreenStack: true,
          backgroundColor: Colors.transparent,
          hapticVibrate: true,
          isScrollControlled: true,
          content: const DailyAppCheckInEventModalSheet(),
        );
      }
      AppState.isRootAvailableForIncomingTaskExecution = true;
    } else {
      _logger.d(
          "DAILY APP BONUS GET: ERROR :: ${dailyAppBonusEventResponse.errorMessage}");
    }
  }

  // Future<bool> _claimDailyAppBonusReward() async {
  //   final res = await _gtRepo.claimDailyBonusEventDetails();
  //   if (res.isSuccess()) {
  //     _dailyAppBonusClaimRewardData = res.model;
  //     PreferenceHelper.setString(
  //         PreferenceHelper.CACHE_LAST_DAILY_APP_BONUS_REWARD_CLAIM_DAY,
  //         DateTime.now().toIso8601String());
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<void> sudoClaimDailyReward() async {
    isDailyAppBonusClaimInProgress = true;
    _analyticsService
        .track(eventName: AnalyticsEvents.dailyAppBonusClaimed, properties: {
      "claim day": (dailyAppCheckInEventData?.currentDay ?? 0) + 1,
      "Retries left": dailyAppCheckInEventData?.streakReset ?? 0
    });
    notifyListeners(MarketingEventsHandlerProperties.DailyAppCheckIn);
    await _gtService.fetchAndVerifyScratchCardByID();
    _isDailyAppBonusClaimed = true;
    isDailyAppBonusClaimInProgress = false;
    showModalsheet = false;
    Future.delayed(const Duration(milliseconds: 250), () {
      _gtService.showInstantScratchCardView(
        source: GTSOURCE.game,
        onJourney: true,
        showRatingDialog: false,
      );
    });
  }

  gotItTapped() {
    _analyticsService.track(
        eventName: AnalyticsEvents.dailyAppBonusGotItTapped);
    AppState.backButtonDispatcher!.didPopRoute();
  }

  getCurrentDay(DailyAppCheckInEventModel data) {
    if (data.streakEnd == TimestampModel.none()) {
      currentDay = 0;
    } else if (data.showStreakBreakMessage) {
      currentDay = 0;
    } else {
      currentDay = TimestampModel.daysBetween(
          dailyAppCheckInEventData!.streakStart.toDate(), DateTime.now());
    }
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
