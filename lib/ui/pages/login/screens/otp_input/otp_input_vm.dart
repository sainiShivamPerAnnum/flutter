import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginOtpViewModel extends BaseViewModel with CodeAutoFill {
  final pinEditingController = new TextEditingController();
  Log log = new Log("OtpInputScreen");
  String _loaderMessage = "Enter the received OTP..";
  FocusNode otpFocusNode = FocusNode();
  LoginControllerViewModel parentModelInstance;
  String mobileNo;
  bool _otpFieldEnabled = true;
  bool _autoDetectingOtp = true;
  bool _isResendClicked = false;
  bool _isTriesExceeded = false;
  bool _showResendOption = false;

  get otpFieldEnabled => _otpFieldEnabled;
  get isTriesExceeded => _isTriesExceeded;
  get isResendClicked => _isResendClicked;
  get autoDetectingOtp => _autoDetectingOtp;
  bool get showResendOption => _showResendOption;
  String get otp => pinEditingController.text;

  set showResendOption(bool val) {
    _showResendOption = val;
    notifyListeners();
  }

  set otpFieldEnabled(bool val) {
    this._otpFieldEnabled = val;
    notifyListeners();
  }

  init(BuildContext context) {
    listenForCode();
    Future.delayed(Duration(seconds: 30), () {
      try {
        showResendOption = true;
      } catch (e) {
        log.error('Screen no longer active');
      }
    });
  }

  onOtpReceived() {
    _otpFieldEnabled = false;
    _loaderMessage = "Signing in..";
    // notifyListeners();
  }

  onOtpAutoDetectTimeout() {
    _otpFieldEnabled = true;
    _autoDetectingOtp = false;
    _loaderMessage = "Please enter the received otp or request another";
    notifyListeners();
  }

  onOtpResendConfirmed(bool flag) {
    if (flag) {
      //otp successfully resent
      listenForCode();
      _isTriesExceeded = false;
      _isResendClicked = false;
      _otpFieldEnabled = true;
      _loaderMessage = 'OTP has been successfully resent';
      _autoDetectingOtp = true;
      notifyListeners();
    } else {
      //otp tries exceeded
      _isTriesExceeded = true;
      _isResendClicked = true;
      _otpFieldEnabled = true;
      _autoDetectingOtp = false;
      _loaderMessage = 'OTP requests exceeded. Please try again after sometime';
      notifyListeners();
    }
  }

  @override
  void codeUpdated() {
    if (code != null) {
      pinEditingController.text = code;
      parentModelInstance.processScreenInput(1);
      notifyListeners();
    }
  }
}
