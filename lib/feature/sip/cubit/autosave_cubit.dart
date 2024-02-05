import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/sip_model/sip_data_model.dart';
import 'package:felloapp/core/model/subscription_models/all_subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/repository/sip_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/modalsheets/pause_autosave_modalsheet.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

import '../../../core/model/sip_model/calculator_details.dart';

part 'autosave_state.dart';

class AutosaveCubit extends Cubit<AutosaveCubitState> {
  AutosaveCubit() : super(AutosaveCubitState());
  final SubService _subService = locator<SubService>();
  final SipRepository _sipRepo = locator<SipRepository>();
  final CustomLogger _logger = locator<CustomLogger>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  PageController? txnPageController = PageController(initialPage: 0);
  TextEditingController sipAmountController = TextEditingController();
  int tabIndex = 0;
  PageController pageController = PageController();
  S locale = locator<S>();
  SipData? sipScreenData;

  // SubscriptionModel? _activeSubscription;
  List<SubscriptionTransactionModel>? augTxnList;
  List<SubscriptionTransactionModel>? lbTxnList;
  List chipsList = [];
  bool hasMoreTxns = false;
  double sliderValue = 0;
  Future<void> init() async {
    state.copyWith(isFetchingDetails: true);
    findActiveSubscription();
    await _sipRepo.getSipScreenData().then((value) {
      sipScreenData = value.model;
      getDefaultValue(tabIndex);
    });
  }

  void getDefaultValue(int tabIndex) {
    Map<String, CalculatorDetails>? data =
        sipScreenData?.calculatorScreen?.calculatorData?.data;
    dynamic sipOptions =
        sipScreenData?.calculatorScreen?.calculatorData?.options;
    emit(state.copyWith(
      sipAmount: data?['${sipOptions[tabIndex]}']?.sipAmount?.defaultValue ?? 0,
      maxSipValue: data?['${sipOptions[tabIndex]}']?.sipAmount?.max ?? 0,
      minSipValue: data?['${sipOptions[tabIndex]}']?.sipAmount?.min ?? 0,
      timePeriod:
          data?['${sipOptions[tabIndex]}']?.timePeriod?.defaultValue ?? 0,
      maxTimePeriod: data?['${sipOptions[tabIndex]}']?.timePeriod?.max ?? 0,
      minTimePeriod: data?['${sipOptions[tabIndex]}']?.timePeriod?.min ?? 0,
      returnPercentage: double.parse(
          data?['${sipOptions[tabIndex]}']?.interest?['default'].toString() ??
              '0'),
      numberOfPeriodsPerYear: sipScreenData?.calculatorScreen?.calculatorData
              ?.data?['${sipOptions[tabIndex]}']?.numberOfPeriodsPerYear ??
          12,
      isFetchingDetails: false,
    ));
  }

  int calculateMaturityValue(double P, double i, int n) {
    double compoundInterest = ((pow(1 + i, n) - 1) / i) * (1 + i);
    double M = P * compoundInterest;
    return M.round();
  }

  String getReturn() {
    double principalAmount = state.sipAmount.toDouble();
    int numberOfPeriods = state.numberOfPeriodsPerYear;
    double interest = state.returnPercentage.toDouble();
    double interestRate = (interest * .001) / numberOfPeriods;
    int numberOfYear = state.timePeriod;

    int numberOfInvestments = numberOfYear * numberOfPeriods;
    final maturityValue = calculateMaturityValue(
        principalAmount, interestRate, numberOfInvestments);

    print("Maturity Value (M): Rs $maturityValue");
    return maturityValue.toString();
  }

  void changeTimePeriod(int value) {
    if (value > state.maxTimePeriod) {
      emit(state.copyWith(timePeriod: state.maxTimePeriod));
    } else if (value < state.minTimePeriod) {
      emit(state.copyWith(timePeriod: state.minTimePeriod));
    } else {
      emit(state.copyWith(timePeriod: value));
    }
  }

  void changeSIPAmount(int value) {
    if (value > state.maxSipValue) {
      state.sipAmount = state.maxSipValue;
      emit(state.copyWith(sipAmount: state.maxSipValue));
    } else if (value < state.minSipValue) {
      emit(state.copyWith(sipAmount: state.minSipValue));
    } else {
      emit(state.copyWith(sipAmount: value));
    }
  }

  void changeRateOfInterest(int value) {
    if (value > 30) {
      emit(state.copyWith(returnPercentage: 30));
    } else if (value < 0) {
      emit(state.copyWith(returnPercentage: 0));
    } else {
      emit(state.copyWith(returnPercentage: value.toDouble()));
    }
  }

  dump() {
    sipAmountController.dispose();
    pageController.dispose();
  }

  diposeEdit() {
    emit(state.getDefault());
  }

  void pageChange(value) {
    emit(state.copyWith(currentPage: value));
  }

  void findActiveSubscription() {
    emit(state.copyWith(activeSubscription: _subService.subscriptionData));
  }

  void updatePauseResumeStatus() {
    emit(state.copyWith(isPauseOrResuming: _subService.isPauseOrResuming));
  }

  Future editSip(num principalAmount, String frequency, int index) async {
    emit(state.copyWith(
        isEdit: true,
        editSipAmount: principalAmount,
        currentSipFrequency: frequency,
        editIndex: index));
    await pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    Future.delayed(
        Duration.zero, () => AppState.backButtonDispatcher!.didPopRoute());
  }

  Future editSipTrigger(
      num principalAmount, String frequency, String id) async {
    bool response = await _subService.updateSubscription(
        freq: frequency, amount: principalAmount.toInt(), id: id);
    if (!response) {
      BaseUtil.showNegativeAlert("Failed to update SIP", "Please try again");
    } else {
      findActiveSubscription();
      BaseUtil.showPositiveAlert("Subscription updated successfully",
          "Effective changes will take place from tomorrow");
    }
  }

  void changeSelectedAsset(int index) {
    emit(state.copyWith(selectedAsset: index));
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
      } else {
        findActiveSubscription();
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
      ).then((value) {
        updatePauseResumeStatus();
        findActiveSubscription();
      });
    }
  }

  // trackPauseAnalytics(int value) {
  //   _analyticsService
  //       .track(eventName: AnalyticsEvents.autosavePauseModal, properties: {
  //     "frequency": state.activeSubscription?.frequency,
  //     "amount": state.activeSubscription?.amount,
  //     // "SIP deducted Count": filteredList != null ? filteredList?.length : 0,
  //     "SIP started timestamp": DateTime.fromMillisecondsSinceEpoch(
  //         state.activeSubscription?.createdOn?.microsecondsSinceEpoch ?? 0),
  //     "Total invested amount": AnalyticsProperties.getGoldInvestedAmount() +
  //         AnalyticsProperties.getFelloFloAmount(),
  //     "Amount invested in gold": AnalyticsProperties.getGoldInvestedAmount(),
  //     "Grams of gold owned": AnalyticsProperties.getGoldQuantityInGrams(),
  //     // "Amount Chip Selected": lastTappedChipIndex,
  //     "Pause Value": value,
  //   });
  // }
}
