import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';

class UserUPIDetailsViewModel extends BaseModel {
  // TextEditingController _upiController;
  // bool _inEditMode = true;
  // bool _isUpiVerificationInProgress = false;
  // final formKey = GlobalKey<FormState>();
  // final PaymentRepository _paymentRepo = locator<PaymentRepository>();
  // final UserService _userService = locator<UserService>();
  // FocusNode focusNode;

  // get isUpiVerificationInProgress => this._isUpiVerificationInProgress;

  // set isUpiVerificationInProgress(value) {
  //   this._isUpiVerificationInProgress = value;
  //   notifyListeners();
  // }

  // get inEditMode => this._inEditMode;

  // set inEditMode(value) {
  //   this._inEditMode = value;
  //   notifyListeners();
  // }

  // TextEditingController get upiController => this._upiController;

  // set upiController(value) {
  //   this._upiController = value;
  //   // notifyListeners();
  // }

  // init() async {
  //   upiController = TextEditingController();
  //   focusNode = FocusNode();
  //   if (_userService.upiId != null && _userService.upiId.isNotEmpty) {
  //     upiController.text = _userService.upiId;
  //     inEditMode = false;
  //     return;
  //   }
  //   setState(ViewState.Busy);
  //   final response = await _paymentRepo.getUserUpi();
  //   if (_userService.upiId != null &&
  //       _userService.upiId.isNotEmpty &&
  //       response.code == 200) {
  //     upiController.text = response.model;
  //     inEditMode = false;
  //   }

  //   setState(ViewState.Idle);
  // }

  // verifyUpiId() async {
  //   isUpiVerificationInProgress = true;
  //   final response = await _paymentRepo.validateUPI(upiController.text);
  //   if (response.code == 200) {
  //     BaseUtil.showPositiveAlert(
  //         "UPI ID saved",
  //         response.errorMessage ??
  //             "Your UPI address has been sucessfully verified.");
  //     inEditMode = false;

  //     AppState.backButtonDispatcher.didPopRoute();
  //   } else
  //     BaseUtil.showNegativeAlert("Unable to save your UPI address",
  //         response.errorMessage ?? "Something went wrong!");
  //   isUpiVerificationInProgress = false;
  // }

  // dump() {}
}
