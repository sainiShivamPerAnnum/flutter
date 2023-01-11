import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/lendbox_withdrawable_quantity.dart';
import 'package:felloapp/core/repository/lendbox_repo.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/finance/sell_confirmation_screen.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

class LendboxWithdrawalViewModel extends BaseViewModel {
  final CustomLogger? _logger = locator<CustomLogger>();
  final LendboxTransactionService? _txnService =
      locator<LendboxTransactionService>();
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  final LendboxRepo? _lendboxRepo = locator<LendboxRepo>();
  final PaymentRepository? _paymentRepo = locator<PaymentRepository>();
  final UserService? _userService = locator<UserService>();
  S locale = locator<S>();
  String withdrawableResponseMessage = "";

  List<ApplicationMeta> appMetaList = [];
  UpiApplication? upiApplication;
  String? selectedUpiApplicationName;
  int lastTappedChipIndex = 1;
  final double minAmount = 1;

  FocusNode fieldNode = FocusNode();
  String? buyNotice;

  bool _inProgress = false;
  get inProgress => this._inProgress;

  TextEditingController? amountController;
  TextEditingController? vpaController;

  LendboxWithdrawableQuantity? withdrawableQuantity;

  bool _readOnly = true;

  bool get readOnly => this._readOnly;

  set readOnly(value) {
    this._readOnly = value;
    notifyListeners();
  }

  Future<void> init() async {
    setState(ViewState.Busy);
    amountController = TextEditingController(
      text: "1",
    );

    final response = await _lendboxRepo!.getWithdrawableQuantity();
    if (response.isSuccess()) {
      withdrawableQuantity = response.model;
    } else {
      withdrawableResponseMessage = response.errorMessage ?? '';
    }

    setState(ViewState.Idle);
  }

  void resetBuyOptions() {
    amountController!.text = '1';
    lastTappedChipIndex = 1;
    notifyListeners();
  }

  Future<void> initiateWithdraw() async {
    final amount = await initChecks();
    if (amount == 0) return;
    AppState.delegate!.appState.currentAction = PageAction(
      widget: SellConfirmationView(
        amount: amount.toDouble(),
        grams: 0.0,
        onSuccess: () {
          AppState.backButtonDispatcher!.didPopRoute();
          this.processWithdraw(amount);
        },
        investmentType: InvestmentType.LENDBOXP2P,
      ),
      page: SellConfirmationViewConfig,
      state: PageState.addWidget,
    );
    // BaseUtil.openDialog(
    //   addToScreenStack: true,
    //   hapticVibrate: true,
    //   isBarrierDismissible: false,
    //   content: ConfirmationDialog(
    //     title: 'Are you sure you want\nto sell?',
    //     asset: BankDetailsCard(),
    //     description: '₹$amount will be credited to your linked bank account',
    //     buttonText: 'SELL',
    //     confirmAction: () async {
    //       AppState.backButtonDispatcher!.didPopRoute();
    //       await this.processWithdraw(amount);
    //     },
    //     cancelAction: () {
    //       AppState.backButtonDispatcher!.didPopRoute();
    //     },
    //   ),
    // );
  }

  Future<void> processWithdraw(int amount) async {
    log(amount.toString());
    _inProgress = true;
    notifyListeners();

    _analyticsService!.track(
      eventName: AnalyticsEvents.sellInitiate,
      properties: {
        'Amount to be sold': amountController!.text,
        "Weight (Gold)": "",
        "Asset": "Flo"
      },
    );

    AppState.blockNavigation();
    final bankRes = await _paymentRepo!.getActiveBankAccountDetails();
    if (bankRes.isSuccess()) {
      final withdrawalTxn = await _lendboxRepo!.createWithdrawal(
        amount,
        bankRes.model!.id,
      );

      if (withdrawalTxn.isSuccess()) {
        await _txnService!.initiateWithdrawal(
          amount.toDouble(),
          withdrawalTxn.model,
        );
      } else {
        _logger!.e(withdrawalTxn.errorMessage);
        BaseUtil.showNegativeAlert(
          locale.withDrawalFailed,
          withdrawalTxn.errorMessage,
        );
      }
    } else {
      _logger!.e(bankRes.errorMessage);
      BaseUtil.showNegativeAlert(locale.withDrawalFailed, bankRes.errorMessage);
    }

    AppState.unblockNavigation();
    _inProgress = false;
    notifyListeners();
  }

  Future<int> initChecks() async {
    final amount = int.tryParse(this.amountController!.text) ?? 0;

    if (amount == 0) {
      BaseUtil.showNegativeAlert(locale.noAmountEntered, locale.enterAmount);
      return 0;
    }
    if (withdrawableQuantity!.amount == 0.0) {
      BaseUtil.showNegativeAlert(
        "No available amount for withdrawal",
        "Please retry after sometime",
      );
      return 0;
    }

    if (amount < minAmount) {
      BaseUtil.showNegativeAlert(
        locale.minAmountIs + '${this.minAmount}',
        locale.enterAmountGreaterThan + '${this.minAmount}',
      );
      return 0;
    }

    if (amount > withdrawableQuantity!.amount) {
      BaseUtil.showNegativeAlert(
        locale.maxAmountIs + '${this.withdrawableQuantity!.amount}',
        locale.enterAmountLowerThan + '${this.withdrawableQuantity!.amount}',
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

    return amount;
  }

  int getAmount(int amount) {
    if (amount > amount.toInt())
      return amount;
    else
      return amount.toInt();
  }
}
