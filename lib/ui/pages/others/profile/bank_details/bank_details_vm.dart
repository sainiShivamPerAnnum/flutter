import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/transfer_amount_api_model.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/model/verify_amount_api_response_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/signzy_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/sell_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/augmont_confirm_register_dialog.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class BankDetailsViewModel extends BaseModel {
  final BaseAnalyticsService _analyticsService = locator<AnalyticsService>();
  final SignzyRepository _signzyRepository = locator<SignzyRepository>();
  final CustomLogger _logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();
  final SellService _sellService = locator<SellService>();
  final formKey = GlobalKey<FormState>();
  bool _isDetailsUpdating = false;
  bool _inEditMode = false;

  FocusNode nameFocusNode = FocusNode();

  UserAugmontDetail augmontDetails;
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
    await _userService.fetchUserAugmontDetail();
    augmontDetails = _userService.userAugmontDetails;
    if (hasPastBankDetails()) {
      //TODO
      //update ui with existing details
      log("bank account details found: ${augmontDetails.bankHolderName}");
      bankHolderNameController.text = augmontDetails.bankHolderName;
      bankAccNoController.text = augmontDetails.bankAccNo;
      bankAccNoConfirmController.text = augmontDetails.bankAccNo;
      bankIfscController.text = augmontDetails.ifsc;
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

    final ApiResponse<TransferAmountApiResponseModel> response =
        await _signzyRepository.transferAmount(
      uid: _userService.baseUser.uid,
      mobile: _userService.baseUser.mobile,
      name: bankHoldername,
      ifsc: ifscCode,
      accountNo: bankAccNo,
    );

    if (response.isSuccess()) {
      final TransferAmountApiResponseModel _transferAmountResponse =
          response.model;

      _logger.d(_transferAmountResponse.toString());

      if (!_transferAmountResponse.active ||
          !_transferAmountResponse.nameMatch) {
        BaseUtil.showNegativeAlert(
          'Account Verification Failed',
          'Please recheck your entered account number and name',
        );
        isDetailsUpdating = false;
        return;
      }

      //Verify Transfer
      final ApiResponse<bool> res = await _signzyRepository.verifyAmount(
        uid: _userService.baseUser.uid,
        signzyId: _transferAmountResponse.signzyReferenceId,
      );

      if (!res.isSuccess()) {
        isDetailsUpdating = false;

        return BaseUtil.showNegativeAlert(
          'Account Verification Failed',
          'Please verify your account details and try again',
        );
      }

      //Update db with details
      augmontDetails.bankAccNo = bankAccNo;
      augmontDetails.bankHolderName = bankHoldername;
      augmontDetails.ifsc = ifscCode;
      _userService.setUserAugmontDetails(augmontDetails);
      _signzyRepository
          .updateBankDetails(
        bankAccno: _userService.userAugmontDetails.bankAccNo,
        bankIfsc: _userService.userAugmontDetails.ifsc,
        bankAccHolderName: _userService.userAugmontDetails.bankHolderName,
      )
          .then((flag) {
        isDetailsUpdating = false;

        if (flag) {
          _sellService.isBankDetailsAdded = true;
          _analyticsService.track(
              eventName: AnalyticsEvents.bankDetailsUpdated);

          BaseUtil.showPositiveAlert(
              'Complete', 'Your details have been updated');
          AppState.backButtonDispatcher.didPopRoute();
        } else {
          BaseUtil.showNegativeAlert(
            'Details could not be updated at the moment',
            'Please try again',
          );
        }
      });
    } else {
      BaseUtil.showNegativeAlert(
        'Account could not be reached',
        'Please verify your account details and try again',
      );
      isDetailsUpdating = false;
      return;
    }
  }

  checkIfDetailsAreSame() => (augmontDetails != null &&
      bankAccNoController.text == augmontDetails.bankAccNo &&
      bankHolderNameController.text == augmontDetails.bankHolderName &&
      bankAccNoConfirmController.text == augmontDetails.bankAccNo &&
      bankIfscController.text == augmontDetails.ifsc);

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

  bool hasPastBankDetails() => (augmontDetails != null &&
      augmontDetails.bankAccNo != null &&
      augmontDetails.bankAccNo.isNotEmpty);
}
