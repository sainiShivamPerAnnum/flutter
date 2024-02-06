import 'package:bloc/bloc.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/model/sip_model/sip_data_model.dart';
import 'package:felloapp/core/model/subscription_models/all_subscription_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/sip/cubit/sip_data_handler.dart';
import 'package:felloapp/feature/sip/cubit/sub_data_handler.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_amount_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/modalsheets/pause_autosave_modalsheet.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

part 'autosave_state.dart';

class AutosaveCubit extends Cubit<AutosaveCubitState> {
  AutosaveCubit() : super(AutosaveCubitState());
  final SubService _subService = locator<SubService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final locale = locator<S>();

  Future<void> init() async {
    await getData();
    final upiApps = await _subService.getUPIApps();
    emit(state.copyWith(upiApps: upiApps));
  }

  Future<void> getData() async {
    emit(state.copyWith(isFetchingDetails: true));
    await _subService.getSubscription();
    await _subService.getSipScreenData();
    SipDataHolder.init(_subService.sipData!);
    AllSubscriptionHolder.init(_subService.subscriptionData!);
    emit(state.copyWith(
        sipScreenData: SipDataHolder.instance.data,
        activeSubscription: AllSubscriptionHolder.instance.data,
        isFetchingDetails: false));
  }

  void updatePauseResumeStatus() {
    emit(state.copyWith(isPauseOrResuming: _subService.isPauseOrResuming));
  }

  Future editSip(num principalAmount, String frequency, int index,
      SIPAssetTypes assetType) async {
    Future.delayed(
        Duration.zero, () => AppState.backButtonDispatcher!.didPopRoute());
    AppState.delegate!.appState.currentAction = PageAction(
      page: SipFormPageConfig,
      widget: SipFormAmountView(
        sipAssetType: assetType,
        mandateAvailable: true,
        prefillAmount: principalAmount.toInt(),
        prefillFrequency: frequency,
        isEdit: true,
        editId: AllSubscriptionHolder.instance.data.subs![index].id,
      ),
      state: PageState.addWidget,
    );

    ///TODO@Hirdesh2101
    ///WHEN COMPLETE CALL INIT
  }

  Future pauseResume(int index) async {
    if (_subService.isPauseOrResuming) return;
    updatePauseResumeStatus();
    final status = _subService.subscriptionData!.subs![index].status;
    if (status.isPaused) {
      locator<AnalyticsService>()
          .track(eventName: AnalyticsEvents.asResumeTapped, properties: {
        "frequency": state.activeSubscription!.subs![index].frequency,
        "amount": state.activeSubscription!.subs![index].amount,
      });

      bool response = await _subService.resumeSubscription(
        state.activeSubscription!.subs![index].id,
      );
      updatePauseResumeStatus();
      if (!response) {
        BaseUtil.showNegativeAlert("Failed to resume SIP", "Please try again");
        Future.delayed(
            Duration.zero, () => AppState.backButtonDispatcher!.didPopRoute());
      } else {
        await getData();
        await AppState.backButtonDispatcher!.didPopRoute();
        BaseUtil.showPositiveAlert(
            "SIP resumed successfully", "For more details check SIP section");
      }
    } else {
      _analyticsService
          .track(eventName: AnalyticsEvents.asPauseTapped, properties: {
        "frequency": state.activeSubscription!.subs![index].frequency,
        "amount": state.activeSubscription!.subs![index].amount,
      });
      return BaseUtil.openModalBottomSheet(
        addToScreenStack: true,
        hapticVibrate: true,
        backgroundColor: UiConstants.gameCardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.roundness16),
          topRight: Radius.circular(SizeConfig.roundness16),
        ),
        isBarrierDismissible: true,
        isScrollControlled: true,
        content: PauseAutosaveModal(
          model: _subService,
          id: state.activeSubscription!.subs![index].id,
        ),
      ).then((value) async {
        updatePauseResumeStatus();
        await getData();
        Future.delayed(const Duration(milliseconds: 10),
            () async => await AppState.backButtonDispatcher!.didPopRoute());
      });
    }
  }
}
