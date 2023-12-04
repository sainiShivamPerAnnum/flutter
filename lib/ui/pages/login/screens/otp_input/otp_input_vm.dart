import 'dart:io';

import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginOtpViewModel extends BaseViewModel with CodeAutoFill {
  final CustomLogger logger = locator<CustomLogger>();
  final pinEditingController = TextEditingController();
  final iosScreenShotChannel = const MethodChannel('secureScreenshotChannel');
  Log log = const Log("OtpInputScreen");
  FocusNode otpFocusNode = FocusNode();
  late LoginControllerViewModel parentModelInstance;
  String? mobileNo;
  bool _otpFieldEnabled = true;
  bool _autoDetectingOtp = true;
  bool _isResendClicked = false;
  bool _isTriesExceeded = false;
  bool _showResendOption = false;

  bool get otpFieldEnabled => _otpFieldEnabled;

  bool get isTriesExceeded => _isTriesExceeded;

  bool get isResendClicked => _isResendClicked;

  bool get autoDetectingOtp => _autoDetectingOtp;

  bool get showResendOption => _showResendOption;

  String get otp => pinEditingController.text;

  set showResendOption(bool val) {
    _showResendOption = val;
    notifyListeners();
  }

  set otpFieldEnabled(bool val) {
    _otpFieldEnabled = val;
    notifyListeners();
  }

  Future<void> init() async {
    if (Platform.isAndroid) {
      logger.d("Disabling Screenshots in OTP Screen for Android");
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
    if (Platform.isIOS) {
      logger.d("Disabling Screenshots in OTP Screen for iOS");
      await iosScreenShotChannel.invokeMethod('secureiOS');
    }
    listenForCode();
    assert(() {
      listenForDummyCode();
      return true;
    }());
    Future.delayed(const Duration(seconds: 30), () {
      try {
        showResendOption = true;
      } catch (e) {
        log.error('Screen no longer active');
      }
    });
  }

  void listenForDummyCode() {
    Future.delayed(const Duration(seconds: 2), () {
      if (parentModelInstance.userMobile ==
          FlavorConfig.instance!.values.dummyMobileNo) {
        pinEditingController.text = "937521";
        parentModelInstance.processScreenInput(1);
        notifyListeners();
      }
    });
  }

  void onOtpReceived() {
    _otpFieldEnabled = false;
  }

  void onOtpAutoDetectTimeout() {
    _otpFieldEnabled = true;
    _autoDetectingOtp = false;
    notifyListeners();
  }

  void onOtpResendConfirmed(bool flag) {
    if (flag) {
      //otp successfully resent
      listenForCode();
      _isTriesExceeded = false;
      _isResendClicked = false;
      _otpFieldEnabled = true;
      _autoDetectingOtp = true;
      notifyListeners();
    } else {
      //otp tries exceeded
      _isTriesExceeded = true;
      _isResendClicked = true;
      _otpFieldEnabled = true;
      _autoDetectingOtp = false;
      notifyListeners();
    }
  }

  @override
  void codeUpdated() {
    if (code != null) {
      pinEditingController.text = code!;
      parentModelInstance.processScreenInput(1);
      notifyListeners();
    }
  }

  Future<void> exit() async {
    if (Platform.isAndroid) {
      logger.d("Enabling Screenshots in OTP Screen for Android");
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
    if (Platform.isIOS) {
      logger.d("Enabling Screenshots in OTP Screen for iOS");
      await iosScreenShotChannel.invokeMethod("unSecureiOS");
    }
  }
}
