import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/marketing_event_handler_enum.dart';
import 'package:felloapp/core/model/daily_bonus_event_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/service_elements/events/daily_app_check_in.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MarketingEventHandlerService
    extends PropertyChangeNotifier<MarketingEventsHandlerProperties> {
  DailyAppCheckInEventModel? _dailyAppCheckInEventData;

  DailyAppCheckInEventModel? get dailyAppCheckInEventData =>
      this._dailyAppCheckInEventData;

  set dailyAppCheckInEventData(DailyAppCheckInEventModel? value) {
    this._dailyAppCheckInEventData = value;
    notifyListeners(MarketingEventsHandlerProperties.DailyAppCheckIn);
  }

  checkRunningEvents() {
    dailyAppCheckInEventData = DailyAppCheckInEventModel(
        title: "Daily Bonus",
        subtitle: "Open the app everyday for a week and win assured rewards");
    if (AppState.isRootAvailableForIncomingTaskExecution == false) return;
    checkUserDailyAppCheckInStatus();
  }

  checkUserDailyAppCheckInStatus() {
    if (AppState.isRootAvailableForIncomingTaskExecution == false) return;
    AppState.isRootAvailableForIncomingTaskExecution = false;
    BaseUtil.openModalBottomSheet(
        isBarrierDismissible: true,
        addToScreenStack: true,
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
        backgroundColor: UiConstants.kSaveDigitalGoldCardBg,
        hapticVibrate: true,
        isScrollControlled: true,
        content: DailyAppCheckInEventModalSheet());
  }
}
