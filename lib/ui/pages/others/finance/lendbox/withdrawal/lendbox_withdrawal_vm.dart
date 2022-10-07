import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/lendbox_withdrawable_quantity.dart';
import 'package:felloapp/core/repository/lendbox_repo.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/service_elements/bank_details_card.dart';
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

  List<ApplicationMeta> appMetaList = [];
  UpiApplication upiApplication;
  String selectedUpiApplicationName;
  int lastTappedChipIndex = 1;
  final double minAmount = 1;

  FocusNode fieldNode = FocusNode();
  String buyNotice;

  bool _inProgress = false;
  get inProgress => this._inProgress;

  TextEditingController amountController;
  TextEditingController vpaController;

  LendboxWithdrawableQuantity withdrawableQuantity;

  Future<void> init() async {
    setState(ViewState.Busy);
    amountController = TextEditingController(
      text: "1",
    );

    final response = await _lendboxRepo.getWithdrawableQuantity();
    if (response.isSuccess()) {
      withdrawableQuantity = response.model;
    }

    setState(ViewState.Idle);
  }

  void resetBuyOptions() {
    amountController.text = '1';
    lastTappedChipIndex = 1;
    notifyListeners();
  }

  Future<void> initiateWithdraw() async {
    final amount = await initChecks();
    if (amount == 0) return;

    BaseUtil.openDialog(
      addToScreenStack: true,
      hapticVibrate: true,
      isBarrierDismissable: false,
      content: ConfirmationDialog(
        title: 'Are you sure you want\nto sell?',
        asset: BankDetailsCard(),
        description: '₹$amount will be credited to your linked bank account',
        buttonText: 'SELL',
        confirmAction: () async {
          AppState.backButtonDispatcher.didPopRoute();
          await this.processWithdraw(amount);
        },
        cancelAction: () {
          AppState.backButtonDispatcher.didPopRoute();
        },
      ),
    );
  }

  Future<void> processWithdraw(int amount) async {
    log(amount.toString());
    _inProgress = true;
    notifyListeners();

    AppState.blockNavigation();
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

    AppState.unblockNavigation();
    _inProgress = false;
    notifyListeners();
  }

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

    if (amount > withdrawableQuantity.amount) {
      BaseUtil.showNegativeAlert(
        'Max amount is ${this.withdrawableQuantity.amount}',
        'Please enter an amount lower than ${this.withdrawableQuantity.amount}',
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
