import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginMobileViewModel extends BaseViewModel {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _referralCodeController = TextEditingController();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final CustomLogger? logger = locator<CustomLogger>();
  final FocusNode mobileFocusNode = FocusNode();
  final bool _validate = true;
  bool _showTickCheck = false;
  bool showAvailableMobileNos = true;
  Log log = const Log("MobileInputScreen");
  static final GlobalKey<FormFieldState<String>> _phoneFieldKey =
      GlobalKey<FormFieldState<String>>();
  String code = "+91";

  get formKey => _formKey;

  get showTickCheck => _showTickCheck;

  get validate => _validate;

  get phoneFieldKey => _phoneFieldKey;

  TextEditingController get mobileController => _mobileController;

  get truecallerMobileController => _mobileController;

  get referralCodeController => _referralCodeController;
  S locale = locator<S>();

  void showAvailablePhoneNumbers() async {
    if (Platform.isAndroid && showAvailableMobileNos) {
      showAvailableMobileNos = false;
      mobileFocusNode.unfocus();
      final SmsAutoFill _autoFill = SmsAutoFill();
      String? completePhoneNumber = await _autoFill.hint;
      if (completePhoneNumber != null) {
        _mobileController.text =
            completePhoneNumber.substring(completePhoneNumber.length - 10);
        upDateCheckTick();
      } else {
        mobileFocusNode.requestFocus();
      }
      Future.delayed(
          const Duration(milliseconds: 500), mobileFocusNode.requestFocus);
    }
  }

  String? validateMobile() {
    Pattern pattern = "^[0-9]*\$";
    RegExp regex = RegExp(pattern as String);
    if (!regex.hasMatch(_mobileController.text) ||
        _mobileController.text.length != 10) {
      return locale.validMobileNumber;
    }

    RegExp numberPattern = RegExp(r"^[6-9]");
    return !numberPattern.hasMatch(_mobileController.text)
        ? locale.validMobileNumber
        : null;
  }

  void upDateCheckTick() {
    _showTickCheck = _mobileController.text.length == 10;
    notifyListeners();
  }

  void onTermsAndConditionsClicked() {
    Haptic.vibrate();
    BaseUtil.launchUrl('https://fello.in/policy/terms-of-use');
    _analyticsService.track(eventName: AnalyticsEvents.termsAndConditions);
  }

  String getMobile() => _mobileController.text;

  String getReferralCode() => _referralCodeController.text;
}
