import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

class LendboxBuyViewModel extends BaseViewModel {
  final _txnService = locator<LendboxTransactionService>();
  final _analyticsService = locator<AnalyticsService>();

  double incomingAmount;
  List<ApplicationMeta> appMetaList = [];
  UpiApplication upiApplication;
  String selectedUpiApplicationName;
  int lastTappedChipIndex = 1;
  bool _skipMl = false;

  FocusNode buyFieldNode = FocusNode();
  String buyNotice;

  bool _isBuyInProgress = false;
  bool get isBuyInProgress => this._isBuyInProgress;

  TextEditingController amountController;
  TextEditingController vpaController;
  final List<int> chipAmountList = [101, 201, 501, 1001];
  final double minAmount = 100;
  final double maxAmount = 50000;

  bool get skipMl => this._skipMl;

  set skipMl(bool value) {
    this._skipMl = value;
  }

  init(int amount, bool isSkipMilestone) async {
    setState(ViewState.Busy);
    skipMl = isSkipMilestone;
    amountController = TextEditingController(
      text: amount?.toString() ?? chipAmountList[2].toInt().toString(),
    );
    setState(ViewState.Idle);
  }

  resetBuyOptions() {
    amountController.text = chipAmountList[1].toInt().toString();
    lastTappedChipIndex = 2;
    notifyListeners();
  }

  //BUY FLOW
  //1
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

    await _txnService.initiateTransaction(amount.toDouble(), skipMl);
    _isBuyInProgress = false;
    notifyListeners();
  }

  //2 Basic Checks
  Future<int> initChecks() async {
    final buyAmount = int.tryParse(this.amountController.text) ?? 0;

    if (buyAmount == 0) {
      BaseUtil.showNegativeAlert('No amount entered', 'Please enter an amount');
      return 0;
    }

    if (buyAmount < minAmount) {
      BaseUtil.showNegativeAlert(
        'Min amount is ${this.minAmount}',
        'Please enter an amount grater than ${this.minAmount}',
      );
      return 0;
    }

    if (buyAmount > maxAmount) {
      BaseUtil.showNegativeAlert(
        'Max amount is ${this.maxAmount}',
        'Please enter an amount lower than ${this.maxAmount}',
      );
      return 0;
    }

    _analyticsService.track(eventName: AnalyticsEvents.buyGold);
    return buyAmount;
  }

  void navigateToKycScreen() {
    AppState.delegate.appState.currentAction = PageAction(
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
