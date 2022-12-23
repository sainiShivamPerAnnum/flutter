import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/asset_options_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';


import '../../../../../../core/repository/getters_repo.dart';

class LendboxBuyViewModel extends BaseViewModel {
  final LendboxTransactionService? _txnService =
      locator<LendboxTransactionService>();
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  S locale = locator<S>();

  double? incomingAmount;
 
  
 
  int lastTappedChipIndex = 1;
  bool _skipMl = false;

  FocusNode buyFieldNode = FocusNode();
  String? buyNotice;

  bool _isBuyInProgress = false;
  bool get isBuyInProgress => this._isBuyInProgress;

  TextEditingController? amountController;
  TextEditingController? vpaController;

  final double minAmount = 100;
  final double maxAmount = 50000;
  AssetOptionsModel? assetOptionsModel;
  bool get skipMl => this._skipMl;

  set skipMl(bool value) {
    this._skipMl = value;
  }

  init(
    int? amount,
    bool isSkipMilestone,
  ) async {
    setState(ViewState.Busy);
    await getAssetOptionsModel();
    skipMl = isSkipMilestone;
    amountController = TextEditingController(
      text: amount?.toString() ??
          assetOptionsModel!.data.userOptions[1].value.toString(),
    );

    setState(ViewState.Idle);
  }

  resetBuyOptions() {
    amountController?.text = assetOptionsModel!.data.userOptions[2].toString();
    lastTappedChipIndex = 2;
    notifyListeners();
  }

  Future<void> getAssetOptionsModel() async {
    final res =
        await locator<GetterRepository>().getAssetOptions('weekly', 'flo');
    if (res.code == 200) assetOptionsModel = res.model;
    log(res.model?.message ?? '');
  }

  initiateBuy() async {
    _isBuyInProgress = true;
    notifyListeners();
    final amount = await initChecks();
    if (amount == 0) {
      _isBuyInProgress = false;
      notifyListeners();
      return;
    }

    log(amount.toString());
    _isBuyInProgress = true;
    notifyListeners();

    await _txnService!.initiateTransaction(amount.toDouble(), skipMl);
    _isBuyInProgress = false;
    notifyListeners();
  }

  bool readOnly = true;

  showKeyBoard() {
    if (readOnly) {
      readOnly = false;
      notifyListeners();
    }
  }

  //2 Basic Checks
  Future<int> initChecks() async {
    final buyAmount = int.tryParse(this.amountController!.text) ?? 0;

    if (buyAmount == 0) {
      BaseUtil.showNegativeAlert(locale.noAmountEntered, locale.enterAmount);
      return 0;
    }

    if (buyAmount < minAmount) {
      BaseUtil.showNegativeAlert(
        locale.minAmountIs+'${this.minAmount}',
        locale.enterAmountGreaterThan +'${this.minAmount}',
      );
      return 0;
    }

    if (buyAmount > maxAmount) {
      BaseUtil.showNegativeAlert(
         locale.maxAmountIs+'${this.maxAmount}',
         locale.enterAmountLowerThan+'${this.maxAmount}',
      );
      return 0;
    }

    _analyticsService!.track(
        eventName: AnalyticsEvents.saveCheckout,
        properties:
            AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
          "Asset": "Flo",
          "Amount Entered": amountController?.text,
          "Best flag": assetOptionsModel?.data.userOptions
              .firstWhere(
                  (element) =>
                      element.value.toString() == amountController!.text,
                  orElse: () => UserOption(order: 0, value: 0, best: false))
              .value
        }));
    return buyAmount;
  }

  void navigateToKycScreen() {
    _analyticsService!
        .track(eventName: AnalyticsEvents.completeKYCTapped, properties: {
      "location": "Fello Felo Invest",
      "Total invested amount": AnalyticsProperties.getGoldInvestedAmount() +
          AnalyticsProperties.getFelloFloAmount(),
      "Amount invested in gold": AnalyticsProperties.getGoldInvestedAmount(),
      "Grams of gold owned": AnalyticsProperties.getGoldQuantityInGrams(),
      "Amount invested in Flo": AnalyticsProperties.getFelloFloAmount(),
    });
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: KycDetailsPageConfig,
    );
  }

  int getAmount(int amount) {
    if (amount > amount.toInt())
      return amount;
    else
      return amount.toInt();
  }
}
