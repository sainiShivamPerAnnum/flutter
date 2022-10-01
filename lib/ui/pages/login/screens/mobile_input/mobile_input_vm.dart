import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginMobileViewModel extends BaseViewModel {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _referralCodeController = TextEditingController();
  final _analyticsService = locator<AnalyticsService>();
  final logger = locator<CustomLogger>();
  final FocusNode mobileFocusNode = FocusNode();
  bool _validate = true;
  bool _showTickCheck = false;
  bool showAvailableMobileNos = true;
  Log log = new Log("MobileInputScreen");
  static final GlobalKey<FormFieldState<String>> _phoneFieldKey =
      GlobalKey<FormFieldState<String>>();
  String code = "+91";
  // bool hasReferralCode = false;
  get formKey => _formKey;
  get showTickCheck => _showTickCheck;
  get validate => _validate;
  get phoneFieldKey => _phoneFieldKey;
  TextEditingController get mobileController => _mobileController;
  get truecallerMobileController => _mobileController;
  get referralCodeController => _referralCodeController;

  // set validate(bool val) {
  //   _validate = val;
  //   notifyListeners();
  // }

  void showAvailablePhoneNumbers() async {
    if (Platform.isAndroid && showAvailableMobileNos) {
      showAvailableMobileNos = false;
      mobileFocusNode.unfocus();
      final SmsAutoFill _autoFill = SmsAutoFill();
      String completePhoneNumber = await _autoFill.hint;
      if (completePhoneNumber != null) {
        _mobileController.text =
            completePhoneNumber.substring(completePhoneNumber.length - 10);
        upDateCheckTick();
        // notifyListeners();
      }
      Future.delayed(Duration(milliseconds: 500), () {
        mobileFocusNode.requestFocus();
      });
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

    if (!(_mobileController.text.startsWith("6") ||
        _mobileController.text.startsWith("7") ||
        _mobileController.text.startsWith("8") ||
        _mobileController.text.startsWith("9")))
      return "Enter a valid mobile number";
    else
      return null;
  }

  void upDateCheckTick() {
    if (_mobileController.text.length == 10) {
      _showTickCheck = true;
    } else {
      _showTickCheck = false;
    }

    notifyListeners();
  }

  void onTermsAndConditionsClicked() {
    Haptic.vibrate();
    BaseUtil.launchUrl('https://fello.in/policy/tnc');
    _analyticsService.track(eventName: AnalyticsEvents.termsAndConditions);
  }

  String getMobile() => _mobileController.text;
  String getReferralCode() => _referralCodeController.text;
}
