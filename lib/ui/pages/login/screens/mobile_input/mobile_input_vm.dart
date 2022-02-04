import 'dart:async';
import 'dart:io';

import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'package:truecaller_sdk/truecaller_sdk.dart';

class MobileInputScreenViewModel extends BaseModel {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _referralCodeController = TextEditingController();
  bool _validate = true;
  bool showAvailableMobileNos = true;
  Log log = new Log("MobileInputScreen");
  static final GlobalKey<FormFieldState<String>> _phoneFieldKey =
      GlobalKey<FormFieldState<String>>();
  String code = "+91";
  bool hasReferralCode = false;

  get formKey => _formKey;
  get validate => _validate;
  get phoneFieldKey => _phoneFieldKey;
  get mobileController => _mobileController;
  get referralCodeController => _referralCodeController;

  StreamSubscription streamSubscription;
  // set validate(bool val) {
  //   _validate = val;
  //   notifyListeners();
  // }

  void disp() {
    streamSubscription?.cancel();
  }

  void init() async {
    TruecallerSdk.initializeSDK(
        sdkOptions: TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP);
    TruecallerSdk.isUsable.then((isUsable) {
      isUsable ? TruecallerSdk.getProfile : print("***Not usable***");
    });

    streamSubscription =
        TruecallerSdk.streamCallbackData.listen((truecallerSdkCallback) {
      switch (truecallerSdkCallback.result) {
        case TruecallerSdkCallbackResult.success:
          String firstName = truecallerSdkCallback.profile?.firstName;
          String lastName = truecallerSdkCallback.profile?.lastName;
          String phNo = truecallerSdkCallback.profile?.phoneNumber;
          break;
        case TruecallerSdkCallbackResult.failure:
          int errorCode = truecallerSdkCallback.error?.code;
          break;
        case TruecallerSdkCallbackResult.verification:
          print("Verification Required!!");
          break;
        default:
          print("Invalid result");
      }
    });
  }

  void showAvailablePhoneNumbers() async {
    if (Platform.isAndroid && showAvailableMobileNos) {
      final SmsAutoFill _autoFill = SmsAutoFill();
      String completePhoneNumber = await _autoFill.hint;
      if (completePhoneNumber != null) {
        _mobileController.text =
            completePhoneNumber.substring(completePhoneNumber.length - 10);
        notifyListeners();
      }
      showAvailableMobileNos = false;
    }
  }

  // setError() {
  //   validate = false;
  // }

  String validateMobile() {
    Pattern pattern = "^[0-9]*\$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(_mobileController.text) ||
        _mobileController.text.length != 10)
      return "Enter a valid mobile number";
    else
      return null;
  }

  String getMobile() => _mobileController.text;
  String getReferralCode() => _referralCodeController.text;
}
