import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/sip_model/sip_data_model.dart';
import 'package:felloapp/core/model/subscription_models/all_subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/repository/sip_repo.dart';
import 'package:felloapp/core/repository/subscription_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/feature_flag_service/condition_evaluator.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/ui/modalsheets/pause_autosave_modalsheet.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

part 'autosave_state.dart';

class AutosaveCubit extends Cubit<AutosaveCubitState> {
  AutosaveCubit() : super(AutosaveCubitState());
  final SubService _subService = locator<SubService>();
  final SipRepository _sipRepo = locator<SipRepository>();
  final CustomLogger _logger = locator<CustomLogger>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  PageController? txnPageController = PageController(initialPage: 0);
  TextEditingController sipAmountController = TextEditingController();
  PageController pageController = PageController();
  S locale = locator<S>();
  SipData? sipScreenData;

  // SubscriptionModel? _activeSubscription;
  List<SubscriptionTransactionModel>? augTxnList;
  List<SubscriptionTransactionModel>? lbTxnList;
  List chipsList = [];
  bool hasMoreTxns = false;
  double sliderValue = 0;
  init() async {
    //TODO
    // state = ViewState.Busy;
    // setState(ViewState.Busy);
    await findActiveSubscription();
    await _sipRepo.getSipScreenData().then((value) {
      sipScreenData = value.model;
      emit(AutosaveCubitState(
        sipAmount: sipScreenData
                ?.calculatorScreen
                ?.calculatorData
                ?.data?[
                    '${sipScreenData?.calculatorScreen?.calculatorData?.options?[0]}']
                ?.sipAmount
                ?.defaultValue ??
            0,
        maxSipValue: sipScreenData
                ?.calculatorScreen
                ?.calculatorData
                ?.data?[
                    '${sipScreenData?.calculatorScreen?.calculatorData?.options?[0]}']
                ?.sipAmount
                ?.max ??
            0,
        minSipValue: sipScreenData
                ?.calculatorScreen
                ?.calculatorData
                ?.data?[
                    '${sipScreenData?.calculatorScreen?.calculatorData?.options?[0]}']
                ?.sipAmount
                ?.min ??
            0,
        timePeriod: sipScreenData
                ?.calculatorScreen
                ?.calculatorData
                ?.data?[
                    '${sipScreenData?.calculatorScreen?.calculatorData?.options?[0]}']
                ?.timePeriod
                ?.defaultValue ??
            0,
        maxTimePeriod: sipScreenData
                ?.calculatorScreen
                ?.calculatorData
                ?.data?[
                    '${sipScreenData?.calculatorScreen?.calculatorData?.options?[0]}']
                ?.timePeriod
                ?.max ??
            0,
        minTimePeriod: sipScreenData
                ?.calculatorScreen
                ?.calculatorData
                ?.data?[
                    '${sipScreenData?.calculatorScreen?.calculatorData?.options?[0]}']
                ?.timePeriod
                ?.min ??
            0,
        returnPercentage: sipScreenData
                ?.calculatorScreen
                ?.calculatorData
                ?.data?[
                    '${sipScreenData?.calculatorScreen?.calculatorData?.options?[0]}']
                ?.interest?['default'] ??
            0,
        numberOfPeriodsPerYear: sipScreenData
            ?.calculatorScreen
            ?.calculatorData
            ?.data?[
                '${sipScreenData?.calculatorScreen?.calculatorData?.options?[0]}']
            ?.numberOfPeriodsPerYear,
      ));
    });

    // setState(ViewState.Idle);
  }

  int calculateMaturityValue(double P, double i, int n) {
    double compoundInterest = ((pow(1 + i, n) - 1) / i) * (1 + i);
    double M = P * compoundInterest;
    return M.round();
  }

  String getReturn() {
    double principalAmount = state.sipAmount.toDouble(); // Amount
    int numberOfPeriods = 12;
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

  findActiveSubscription() async {
    state.activeSubscription = _subService.subscriptionData;
    if (state.activeSubscription != null) {
      await fetchAutosaveTransactions();
    }
  }

  Future<void> fetchAutosaveTransactions() async {
    state.isFetchingTransactions = true;
    await _subService.getSubscriptionTransactionHistory(
        asset: Constants.ASSET_TYPE_AUGMONT);
    await _subService.getSubscriptionTransactionHistory(
        asset: Constants.ASSET_TYPE_LENDBOX);
    lbTxnList = _subService.lbSubTxnList;
    augTxnList = _subService.augSubTxnList;
    txnPageController = PageController();
    state.isFetchingTransactions = false;
  }

  // Future pauseResume() async {
  //   if (_subService.isPauseOrResuming) return;
  //   if (_subService.autosaveState == AutosaveState.PAUSED ||
  //       _subService.autosaveState == AutosaveState.INACTIVE) {
  //     locator<AnalyticsService>()
  //         .track(eventName: AnalyticsEvents.asResumeTapped, properties: {
  //       "frequency": state.activeSubscription!.frequency,
  //       "amount": state.activeSubscription!.amount,
  //     });

  //     bool response = await _subService.resumeSubscription();
  //     if (!response) {
  //       BaseUtil.showNegativeAlert(
  //           "Failed to resume Autosave", "Please try again");
  //     } else {
  //       BaseUtil.showPositiveAlert("Autosave resumed successfully",
  //           "For more details check Autosave section");
  //     }
  //   } else {
  //     _analyticsService
  //         .track(eventName: AnalyticsEvents.asPauseTapped, properties: {
  //       "frequency": state.activeSubscription!.frequency,
  //       "amount": state.activeSubscription!.amount,
  //     });
  //     return BaseUtil.openModalBottomSheet(
  //       addToScreenStack: true,
  //       hapticVibrate: true,
  //       backgroundColor:
  //           UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(SizeConfig.roundness16),
  //         topRight: Radius.circular(SizeConfig.roundness16),
  //       ),
  //       isBarrierDismissible: false,
  //       isScrollControlled: true,
  //       content: PauseAutosaveModal(
  //         model: _subService,
  //       ),
  //     );
  //   }
  // }

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
