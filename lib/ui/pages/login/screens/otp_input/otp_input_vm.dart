import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:flutter/material.dart';

class OtpInputScreenViewModel extends BaseModel {
  final pinEditingController = new TextEditingController();

  String _otp;
  String _loaderMessage = "Enter the received OTP..";
  bool _otpFieldEnabled = true;
  bool _autoDetectingOtp = true;
  bool _isResendClicked = false;
  bool _isTriesExceeded = false;

  get otpFieldEnabled => _otpFieldEnabled;
  get isTriesExceeded => _isTriesExceeded;
  get isResendClicked => _isResendClicked;
  get autoDetectingOtp => _autoDetectingOtp;
  String get otp => pinEditingController.text;

  String mobileNo;

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
      _loaderMessage =
          'OTP requests exceeded. Please try again in sometime or contact us';
      notifyListeners();
    }
  }
}
