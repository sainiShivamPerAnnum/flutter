import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/core/service/payments/razorpay_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

class LendboxBuyViewModel extends BaseViewModel {
  static const int STATUS_UNAVAILABLE = 0;
  static const int STATUS_REGISTER = 1;
  static const int STATUS_OPEN = 2;

  final _logger = locator<CustomLogger>();
  final _baseUtil = locator<BaseUtil>();
  final _userService = locator<UserService>();
  final _razorpayService = locator<RazorpayService>();
  final _txnService = locator<LendboxTransactionService>();

  final _analyticsService = locator<AnalyticsService>();
  final _paytmService = locator<PaytmService>();

  double incomingAmount;
  List<ApplicationMeta> appMetaList = [];
  UpiApplication upiApplication;
  String selectedUpiApplicationName;
  int lastTappedChipIndex = 1;
  bool _skipMl = false;

  FocusNode buyFieldNode = FocusNode();
  String buyNotice;

  bool _isBuyInProgress = false;
  get isBuyInProgress => this._isBuyInProgress;

  TextEditingController amountController;
  TextEditingController vpaController;
  List<int> chipAmountList = [101, 201, 501, 1001];

  bool get skipMl => this._skipMl;

  set skipMl(bool value) {
    this._skipMl = value;
  }

  init(int amount, bool isSkipMilestone) async {
    setState(ViewState.Busy);
    skipMl = isSkipMilestone;
    incomingAmount = amount?.toDouble() ?? 0;
    amountController = TextEditingController(
      text: amount.toString() ?? chipAmountList[1].toInt().toString(),
    );
    setState(ViewState.Idle);
  }

  resetBuyOptions() {
    amountController.text = chipAmountList[1].toInt().toString();
    lastTappedChipIndex = 1;
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

    await _txnService.initiateTransaction(amount.toDouble(), false);
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

    // if (_baseUtil.augmontDetail.isDepLocked) {
    //   BaseUtil.showNegativeAlert(
    //     'Purchase Failed',
    //     "${buyNotice ?? 'Gold buying is currently on hold. Please try again after sometime.'}",
    //   );
    //   return false;
    // }

    _analyticsService.track(eventName: AnalyticsEvents.buyGold);
    return buyAmount;
  }

  double getTaxOnAmount(double amount, double taxRate) {
    return BaseUtil.digitPrecision((amount * taxRate) / (100 + taxRate));
  }

  int getAmount(int amount) {
    if (amount > amount.toInt())
      return amount;
    else
      return amount.toInt();
  }
}
