import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/model/sip_model/calculator_details.dart';
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
      getDefaultValue();
    }
  }

  void setAmount(int amount) {
    if (state is LoadedSipData) {
      emit((state as LoadedSipData).copyWith(calculatorAmount: amount));
    }
  }

  void setTP(int tp) {
    if (state is LoadedSipData) {
      emit((state as LoadedSipData).copyWith(calculatorTP: tp));
    }
  }

  void setROI(int roi) {
    if (state is LoadedSipData) {
      emit((state as LoadedSipData).copyWith(calculatorRoi: roi));
    }
  }

  void setTab(int tab) {
    if (state is LoadedSipData) {
      emit((state as LoadedSipData).copyWith(currentTab: tab));
    }
  }

  void getDefaultValue() {
    final currentState = state;
    if (currentState is LoadedSipData) {
      Map<String, CalculatorDetails> data =
          currentState.sipScreenData.calculatorScreen.calculatorData.data;
      List<String> sipOptions =
          currentState.sipScreenData.calculatorScreen.calculatorData.options;
      emit((state as LoadedSipData).copyWith(
          calculatorAmount:
              data[sipOptions[currentState.currentTab]]!.sipAmount.defaultValue,
          calculatorTP: data[sipOptions[currentState.currentTab]]!
              .timePeriod
              .defaultValue,
          calculatorRoi: int.parse(data[sipOptions[currentState.currentTab]]!
              .interest['default']
              .toString())));
    }
  }

  void sendEvent(List options) {
    if (state is LoadedSipData) {
      final properties = {
        'SIP Amount': (state as LoadedSipData).calculatorAmount,
        'Time Period': (state as LoadedSipData).calculatorTP,
        'Return Percentage': (state as LoadedSipData).calculatorRoi,
        'Frequency': options[(state as LoadedSipData).currentTab],
      };

      locator<AnalyticsService>().track(
        eventName: AnalyticsEvents.sipAssetSelected,
        properties: properties,
      );
    }
  }

  void updatePauseResumeStatus(bool isPauseOrResuming) {
    if (state is LoadedSipData) {
      emit((state as LoadedSipData)
          .copyWith(isPauseOrResuming: isPauseOrResuming));
    }
  }

  void updateSeeAll(bool value) {
    if (state is LoadedSipData) {
      emit((state as LoadedSipData).copyWith(showAllSip: value));
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
            BaseUtil.showPositiveAlert("SIP resumed successfully",
                "For more details check SIP section");
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

  void onSetUpSipEventCapture(
      {required int noOfSips, required num totalSipAmount}) {
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.setupSipButtonTap,
      properties: {"No. of SIPS": noOfSips, "Amount of SIPS": totalSipAmount},
    );
  }

  void onExistingSipCardTapEventCapture({
    required String assertName,
    required num sipAmount,
    required String sipStartingDate,
    required String sipNextDueDate,
    required String actionType,
  }) {
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.sipExistingCardTap,
      properties: {
        "Amount": sipAmount,
        "Asset Name": assertName,
        "Date Started": sipStartingDate,
        "Next Due": sipNextDueDate,
        "Action": actionType
      },
    );
  }
}
