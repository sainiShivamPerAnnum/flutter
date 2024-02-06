import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/model/sip_model/sip_data_model.dart';
import 'package:felloapp/core/model/subscription_models/all_subscription_model.dart';
import 'package:felloapp/core/repository/subscription_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/sip/cubit/sip_data_holder.dart';
import 'package:felloapp/feature/sip/sip_polling_page/view/sip_polling_view.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_amount_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/modalsheets/pause_autosave_modalsheet.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

part 'autosave_state.dart';

class SipCubit extends Cubit<SipState> {
  SipCubit() : super(const LoadingSipData());
  final _subService = locator<SubService>();
  final _subscriptionRepo = locator<SubscriptionRepo>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final locale = locator<S>();

  Future<void> init() async {
    await getData();
  }

  Future<void> getData() async {
    await _subService.getSubscription();
    await _subService.getSipScreenData();
    SipDataHolder.init(_subService.sipData!);
    emit(LoadedSipData(
      sipScreenData: SipDataHolder.instance.data,
      activeSubscription: _subService.subscriptionData!,
    ));
  }

  void updatePauseResumeStatus(bool isPauseOrResuming) {
    final currentState = state;
    if (currentState is LoadedSipData) {
      emit(currentState.copyWith(isPauseOrResuming: isPauseOrResuming));
    }
  }

  Future<void> editSip(num principalAmount, String frequency, int index,
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
        editId: _subService.subscriptionData!.subs[index].id,
      ),
      state: PageState.addWidget,
    );

    ///TODO@Hirdesh2101
    ///WHEN COMPLETE CALL INIT
  }

  Future<void> pauseResume(int index) async {
    if (_subService.isPauseOrResuming) return;
    updatePauseResumeStatus(true);

    try {
      final subs = _subService.subscriptionData?.subs;
      if (subs != null && subs.isNotEmpty) {
        final subscription = subs[index];
        final status = subscription.status;

        if (status.isPaused) {
          _analyticsService
              .track(eventName: AnalyticsEvents.asResumeTapped, properties: {
            "frequency": subscription.frequency,
            "amount": subscription.amount,
          });
          bool response = await _subService.resumeSubscription(subscription.id);
          if (!response) {
            BaseUtil.showNegativeAlert(
                "Failed to resume SIP", "Please try again");
          } else {
            BaseUtil.showPositiveAlert("SIP resumed successfully",
                "For more details check SIP section");
            await getData();
          }
        } else {
          _analyticsService
              .track(eventName: AnalyticsEvents.asPauseTapped, properties: {
            "frequency": subscription.frequency,
            "amount": subscription.amount,
          });

          await BaseUtil.openModalBottomSheet(
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
              id: subscription.id,
            ),
          ).then((value) async {
            await getData();
          });
        }
      }
    } catch (e) {
      print('Error in pauseResume: $e');
    } finally {
      updatePauseResumeStatus(false);
    }
  }

  Future<void> createSubscription({
    required num amount,
    required String freq,
    required String assetType,
  }) async {
    // TODO(@Hirdesh2101): emit loading state for create subscription to show
    /// loading state for button component..

    final response = await _subscriptionRepo.createSubscription(
      freq: freq,
      amount: amount,
      assetType: assetType,
      lbAmt: amount,
      augAmt: amount,
    );

    final data = response.model?.data;
    final subscription = data?.subscription;

    if (response.isSuccess() && subscription != null) {
      AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: SipPollingPageConfig,
        widget: SipPollingPage(
          data: subscription,
        ),
      );
    } else {
      BaseUtil.showNegativeAlert(
        'Failed to create subscription',
        response.errorMessage,
      );
    }
  }
}
