import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/bank_account_details_model.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class BankDetailsViewModel extends BaseViewModel {
  final BaseAnalyticsService _analyticsService = locator<AnalyticsService>();
  final BankAndPanService _sellService = locator<BankAndPanService>();
  final PaymentRepository _paymentRepo = locator<PaymentRepository>();
  S locale = locator<S>();
  final formKey = GlobalKey<FormState>();
  bool _isDetailsUpdating = false;
  bool _inEditMode = false;

  FocusNode nameFocusNode = FocusNode();

  BankAccountDetailsModel? activeBankDetails;

  // UserAugmontDetail augmontDetails;
  TextEditingController? bankHolderNameController;
  TextEditingController? bankAccNoController;
  TextEditingController? bankIfscController;
  TextEditingController? bankAccNoConfirmController;

  String? bankHoldername;
  String? bankAccNo;
  String? cnfBankAccNo;
  String? ifscCode;

  get isDetailsUpdating => _isDetailsUpdating;

  get inEditMode => _inEditMode;

  set inEditMode(value) {
    _inEditMode = value;
    notifyListeners();
  }

  bool showBankDetailsHelpView = true;

  void changeView() {
    showBankDetailsHelpView = false;
    notifyListeners();
  }

  set isDetailsUpdating(value) {
    _isDetailsUpdating = value;
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
    if (activeBankDetails != null) {
      bankHolderNameController!.text = activeBankDetails!.name!;
      bankAccNoController!.text = activeBankDetails!.account!;
      bankAccNoConfirmController!.text = activeBankDetails!.account!;
      bankIfscController!.text = activeBankDetails!.ifsc!;
    } else {
      inEditMode = true;
    }

    setState(ViewState.Idle);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (inEditMode) nameFocusNode.requestFocus();
    });
  }

  updateBankDetails() async {
    if (checkIfDetailsAreSame()) {
      return BaseUtil.showNegativeAlert(
          locale.noChangesDetected, locale.makeSomeChanges);
    }
    setUpDataValues();
    if (!confirmBankAccountNumber()) {
      return BaseUtil.showNegativeAlert(
          locale.feildsMismatch, locale.bankAccDidNotMatch);
    }
    isDetailsUpdating = true;

    final ApiResponse<bool> response = await _paymentRepo.addBankDetails(
        bankAccno: bankAccNo,
        bankHolderName: bankHoldername,
        bankIfsc: ifscCode);

    if (response.isSuccess()) {
      await _sellService.checkForUserBankAccountDetails();
      _sellService.isBankDetailsAdded = true;
      _analyticsService.track(eventName: AnalyticsEvents.bankDetailsUpdated);

      BaseUtil.showPositiveAlert(
          locale.bankDetailsUpdatedTitle, locale.bankDetailsUpdatedSubTitle);
      inEditMode = false;
      isDetailsUpdating = false;

      if (_sellService.isFromFloWithdrawFlow) {
        AppState.delegate!.appState.currentAction = PageAction(
          state: PageState.replace,
          page: BalloonLottieScreenViewConfig,
        );
      } else {
        AppState.backButtonDispatcher!.didPopRoute();
      }
    } else {
      BaseUtil.showNegativeAlert(response.errorMessage ?? locale.updateFailed,
          locale.obPleaseTryAgain);
      isDetailsUpdating = false;
    }
  }

  checkIfDetailsAreSame() =>
      activeBankDetails != null &&
      bankAccNoController!.text == activeBankDetails!.account &&
      bankHolderNameController!.text == activeBankDetails!.name &&
      bankAccNoConfirmController!.text == activeBankDetails!.account &&
      bankIfscController!.text == activeBankDetails!.ifsc;

  setUpDataValues() {
    bankHoldername = bankHolderNameController!.text.trim().toUpperCase();
    bankAccNo = bankAccNoController!.text.trim();
    cnfBankAccNo = bankAccNoConfirmController!.text.trim();
    ifscCode = bankIfscController!.text.trim();
  }

  confirmBankAccountNumber() {
    log("Bank acc no: $bankAccNo || Bank confirm acc no: $cnfBankAccNo");
    return bankAccNo == cnfBankAccNo;
  }
}
