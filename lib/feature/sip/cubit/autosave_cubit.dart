import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/model/sip_model/sip_data_model.dart';
import 'package:felloapp/core/model/subscription_models/all_subscription_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/sip/cubit/sip_data_holder.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_amount_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/modalsheets/pause_autosave_modalsheet.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

part 'autosave_state.dart';

class SipCubit extends Cubit<SipState> {
  SipCubit() : super(const LoadingSipData());
  final CustomLogger logger = locator<CustomLogger>();
  final _subService = locator<SubService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final locale = locator<S>();

  Future<void> init() async {
    await getData();
  }

  Future<void> getData() async {
    emit(const LoadingSipData());
    await _subService.getSubscription();
    await _subService.getSipScreenData();
    if (_subService.sipData == null || _subService.subscriptionData == null) {
      emit(const ErrorSipState());
    } else {
      SipDataHolder.init(_subService.sipData!);
      emit(LoadedSipData(
        sipScreenData: SipDataHolder.instance.data,
        activeSubscription: _subService.subscriptionData!,
      ));
    }
  }

  void updatePauseResumeStatus(bool isPauseOrResuming) {
    final currentState = state;
    if (currentState is LoadedSipData) {
      emit(currentState.copyWith(isPauseOrResuming: isPauseOrResuming));
    }
  }

  void updateSeeAll(bool value) {
    final currentState = state;
    if (currentState is LoadedSipData) {
      emit(currentState.copyWith(showAllSip: value));
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

  Future<void> resume(int index) async {
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
          if (response) {
            await getData();
            await AppState.backButtonDispatcher!.didPopRoute();
          }
        }
      }
    } catch (e) {
      logger.e('Error in Resume: $e');
    } finally {
      updatePauseResumeStatus(false);
    }
  }

  Future<void> pause(int index) async {
    if (_subService.isPauseOrResuming) return;
    updatePauseResumeStatus(true);
    try {
      final subs = _subService.subscriptionData?.subs;
      if (subs != null && subs.isNotEmpty) {
        final subscription = subs[index];
        final status = subscription.status;
        if (status.isActive) {
          _analyticsService
              .track(eventName: AnalyticsEvents.asPauseTapped, properties: {
            "frequency": subscription.frequency,
            "amount": subscription.amount,
          });

          await AppState.backButtonDispatcher!.didPopRoute();
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
              getData: getData,
            ),
          );
        }
      }
    } catch (e) {
      logger.e('Error in pause: $e');
    } finally {
      updatePauseResumeStatus(false);
    }
  }
}
