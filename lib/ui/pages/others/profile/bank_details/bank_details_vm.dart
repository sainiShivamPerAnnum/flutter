import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/bank_account_details_model.dart';
import 'package:felloapp/core/model/transfer_amount_api_model.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/model/verify_amount_api_response_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/repository/banking_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/core/service/payments/sell_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/augmont_confirm_register_dialog.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class BankDetailsViewModel extends BaseViewModel {
  final BaseAnalyticsService _analyticsService = locator<AnalyticsService>();
  final BankingRepository _bankingRepo = locator<BankingRepository>();
  final CustomLogger _logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();
  final SellService _sellService = locator<SellService>();
  final PaymentRepository _paymentRepo = locator<PaymentRepository>();
  final formKey = GlobalKey<FormState>();
  bool _isDetailsUpdating = false;
  bool _inEditMode = false;

  FocusNode nameFocusNode = FocusNode();

  BankAccountDetailsModel activeBankDetails;
  // UserAugmontDetail augmontDetails;
  TextEditingController bankHolderNameController;
  TextEditingController bankAccNoController;
  TextEditingController bankIfscController;
  TextEditingController bankAccNoConfirmController;

  String bankHoldername;
  String bankAccNo;
  String cnfBankAccNo;
  String ifscCode;

  get isDetailsUpdating => this._isDetailsUpdating;

  get inEditMode => this._inEditMode;

  set inEditMode(value) {
    this._inEditMode = value;
    notifyListeners();
  }

  set isDetailsUpdating(value) {
    this._isDetailsUpdating = value;
    notifyListeners();
  }

  init() {
    bankHolderNameController = TextEditingController();
    bankAccNoController = TextEditingController();
    bankIfscController = TextEditingController();
    bankAccNoConfirmController = TextEditingController();
    checkForBankDetailsExistence();
  }

  checkForBankDetailsExistence() async {
    setState(ViewState.Busy);
    await _sellService.checkForUserBankAccountDetails();
    // augmontDetails = _userService.userAugmontDetails;
    activeBankDetails = _sellService.activeBankAccountDetails;
    if (hasPastBankDetails()) {
      bankHolderNameController.text = activeBankDetails.name;
      bankAccNoController.text = activeBankDetails.account;
      bankAccNoConfirmController.text = activeBankDetails.account;
      bankIfscController.text = activeBankDetails.ifsc;
    } else {
      inEditMode = true;
    }

    setState(ViewState.Idle);
    Future.delayed(Duration(milliseconds: 500), () {
      if (inEditMode) nameFocusNode.requestFocus();
    });
  }

  updateBankDetails() async {
    if (checkIfDetailsAreSame())
      return BaseUtil.showNegativeAlert(
          "No changes detected", "Please make some changes to update details");
    setUpDataValues();
    if (!confirmBankAccountNumber())
      return BaseUtil.showNegativeAlert(
          'Fields mismatch', 'Bank account numbers do not match');
    isDetailsUpdating = true;

    final ApiResponse<bool> response = await _paymentRepo.addBankDetails(
        bankAccno: bankAccNo,
        bankHolderName: bankHoldername,
        bankIfsc: ifscCode);

    if (response.isSuccess()) {
      await _sellService.checkForUserBankAccountDetails();
      _sellService.isBankDetailsAdded = true;
      _analyticsService.track(eventName: AnalyticsEvents.bankDetailsUpdated);

      BaseUtil.showPositiveAlert('Complete', 'Your details have been updated');
      AppState.backButtonDispatcher.didPopRoute();
      isDetailsUpdating = false;
    } else {
      BaseUtil.showNegativeAlert(
          response.errorMessage ?? "Update failed", "Please try again");
      isDetailsUpdating = false;
    }
  }

  checkIfDetailsAreSame() => (activeBankDetails != null &&
      bankAccNoController.text == activeBankDetails.account &&
      bankHolderNameController.text == activeBankDetails.name &&
      bankAccNoConfirmController.text == activeBankDetails.account &&
      bankIfscController.text == activeBankDetails.ifsc);

  setUpDataValues() {
    bankHoldername = bankHolderNameController.text.trim();
    bankAccNo = bankAccNoController.text.trim();
    cnfBankAccNo = bankAccNoConfirmController.text.trim();
    ifscCode = bankIfscController.text.trim();
  }

  confirmBankAccountNumber() {
    log("Bank acc no: $bankAccNo || Bank confirm acc no: $cnfBankAccNo");
    return bankAccNo == cnfBankAccNo;
  }

  bool hasPastBankDetails() => activeBankDetails != null;
}
