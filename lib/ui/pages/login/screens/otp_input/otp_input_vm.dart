import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class LoginOtpViewModel extends BaseModel {
  final pinEditingController = new TextEditingController();
  Log log = new Log("OtpInputScreen");
  FocusNode _focusNode;
  String _otp;
  String _loaderMessage = "Enter the received OTP..";
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
  FocusNode get focusNode => _focusNode;

  set showResendOption(bool val) {
    _showResendOption = val;
    notifyListeners();
  }

  set focusNode(FocusNode val) {
    _focusNode = val;
    notifyListeners();
  }

  init(BuildContext context) {
    focusNode = new FocusNode();
    focusNode.addListener(
      () => print('focusNode updated: hasFocus: ${focusNode.hasFocus}'),
    );

    Future.delayed(Duration(seconds: 2), () {
      FocusScope.of(context).requestFocus(focusNode);
    });

    Future.delayed(Duration(seconds: 30), () {
      try {
        showResendOption = true;
      } catch (e) {
        log.error('Screen no longer active');
      }
    });
  }

  modelDispose() {
    focusNode.dispose();
  }

  onOtpReceived() {
    _otpFieldEnabled = false;
    _loaderMessage = "Signing in..";
    notifyListeners();
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
}
