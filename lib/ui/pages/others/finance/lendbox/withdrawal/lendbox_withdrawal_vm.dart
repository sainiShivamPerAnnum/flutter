import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/repository/lendbox_repo.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

class LendboxWithdrawalViewModel extends BaseViewModel {
  final _logger = locator<CustomLogger>();
  final _txnService = locator<LendboxTransactionService>();
  final _analyticsService = locator<AnalyticsService>();
  final _lendboxRepo = locator<LendboxRepo>();
  final _paymentRepo = locator<PaymentRepository>();
  final _userService = locator<UserService>();

  double incomingAmount;
  List<ApplicationMeta> appMetaList = [];
  UpiApplication upiApplication;
  String selectedUpiApplicationName;
  int lastTappedChipIndex = 1;
  bool _skipMl = false;
  final double minAmount = 1;

  FocusNode fieldNode = FocusNode();
  String buyNotice;

  bool _inProgress = false;
  get inProgress => this._inProgress;

  TextEditingController amountController;
  TextEditingController vpaController;

  bool get skipMl => this._skipMl;

  set skipMl(bool value) {
    this._skipMl = value;
  }

  double get processingQty =>
      _userService.userFundWallet?.wLbProcessingQty ?? 0;
  double get withdrawableQty => _userService.userFundWallet?.wLbBalance ?? 0;

  init(int amount, bool isSkipMilestone) async {
    setState(ViewState.Busy);
    skipMl = isSkipMilestone;
    incomingAmount = amount?.toDouble() ?? 0;
    amountController = TextEditingController(
      text: "5",
    );
    setState(ViewState.Idle);
  }

  resetBuyOptions() {
    amountController.text = '1';
    lastTappedChipIndex = 1;
    notifyListeners();
  }

  //BUY FLOW
  //1
  initiateWithdraw() async {
    final amount = await initChecks();
    if (amount == 0) return;

    log(amount.toString());
    _inProgress = true;
    notifyListeners();

    final bankRes = await _paymentRepo.getActiveBankAccountDetails();
    if (bankRes.isSuccess()) {
      final withdrawalTxn = await _lendboxRepo.createWithdrawal(
        amount,
        bankRes.model.id,
      );

      if (withdrawalTxn.isSuccess()) {
        await _txnService.initiateWithdrawal(
          amount.toDouble(),
          withdrawalTxn.model,
        );
      } else {
        _logger.e(withdrawalTxn.errorMessage);
        BaseUtil.showNegativeAlert(
          'Withdrawal Failed',
          withdrawalTxn.errorMessage,
        );
      }
    } else {
      _logger.e(bankRes.errorMessage);
      BaseUtil.showNegativeAlert('Withdrawal Failed', bankRes.errorMessage);
    }

    _inProgress = false;
    notifyListeners();
  }

  //2 Basic Checks
  Future<int> initChecks() async {
    final amount = int.tryParse(this.amountController.text) ?? 0;

    if (amount == 0) {
      BaseUtil.showNegativeAlert('No amount entered', 'Please enter an amount');
      return 0;
    }

    if (amount < minAmount) {
      BaseUtil.showNegativeAlert(
        'Min amount is ${this.minAmount}',
        'Please enter an amount grater than ${this.minAmount}',
      );
      return 0;
    }

    if (amount > withdrawableQty) {
      BaseUtil.showNegativeAlert(
        'Max amount is ${this.withdrawableQty}',
        'Please enter an amount lower than ${this.withdrawableQty}',
      );
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
    return amount;
  }

  int getAmount(int amount) {
    if (amount > amount.toInt())
      return amount;
    else
      return amount.toInt();
  }
}
