import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/verify_pan_response_model.dart';
import 'package:felloapp/core/repository/banking_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/app_exceptions.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class KYCDetailsViewModel extends BaseViewModel {
  String stateChosenValue;
  TextEditingController nameController, panController;
  bool inEditMode = true;
  bool isUpadtingKycDetails = false;
  bool _hasDetails = false;

  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  final _analyticsService = locator<AnalyticsService>();
  final _bankingRepo = locator<BankingRepository>();
  final _gtService = locator<GoldenTicketService>();
  final _sellService = locator<BankAndPanService>();
  final _cacheService = new CacheService();
  bool get isConfirmDialogInView => _userService.isConfirmationDialogOpen;

  FocusNode kycNameFocusNode = FocusNode();
  FocusNode panFocusNode = FocusNode();
  TextInputType panTextInputType = TextInputType.name;

  final depositformKey3 = GlobalKey<FormState>();

  get hasDetails => this._hasDetails;

  set hasDetails(value) {
    this._hasDetails = value;
    notifyListeners();
  }

  init() {
    nameController = new TextEditingController();
    panController = new TextEditingController();
    checkForKycExistence();
  }

  checkForKeyboardChange(String val) {
    if (val.length >= 0 &&
        val.length < 5 &&
        panTextInputType != TextInputType.name) {
      panFocusNode.unfocus();
      panTextInputType = TextInputType.name;
      notifyListeners();
      Future.delayed(Duration(milliseconds: 100), () {
        panFocusNode.requestFocus();
      });
      return;
    }
    if (val.length >= 5 &&
        val.length < 9 &&
        panTextInputType != TextInputType.number) {
      print("I got called");
      panFocusNode.unfocus();
      panTextInputType = TextInputType.number;
      notifyListeners();
      Future.delayed(Duration(milliseconds: 100), () {
        panFocusNode.requestFocus();
      });
      return;
    }

    if (val.length >= 9 && panTextInputType != TextInputType.name) {
      panFocusNode.unfocus();
      panTextInputType = TextInputType.name;
      notifyListeners();
      Future.delayed(Duration(milliseconds: 100), () {
        panFocusNode.requestFocus();
      });
    }

    return;
  }

  checkForKycExistence() async {
    setState(ViewState.Busy);
    if (_userService.baseUser.isSimpleKycVerified != null &&
        _sellService.userPan != null &&
        _sellService.userPan.isNotEmpty) {
      if (_userService.baseUser.isSimpleKycVerified) {
        hasDetails = true;
        panController.text = _sellService.userPan;
        nameController.text = _userService.baseUser.kycName;
        inEditMode = false;
      }
    }
    setState(ViewState.Idle);
    Future.delayed(Duration(milliseconds: 500), () {
      if (inEditMode) kycNameFocusNode.requestFocus();
    });
  }

  bool _preVerifyInputs() {
    RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
    if (panController.text.isEmpty) {
      BaseUtil.showNegativeAlert(
          'Invalid Pan', 'Kindly enter a valid PAN Number');
      return false;
    } else if (!panCheck.hasMatch(panController.text) ||
        panController.text.length != 10) {
      BaseUtil.showNegativeAlert(
          'Invalid Pan', 'Kindly enter a valid PAN Number');
      return false;
    } else if (nameController.text.isEmpty) {
      BaseUtil.showNegativeAlert(
          'Name missing', 'Kindly enter your name as per your pan card');
      return false;
    }
    return true;
  }

  Future<void> onSubmit(context) async {
    isUpadtingKycDetails = true;
    if (!_preVerifyInputs()) {
      isUpadtingKycDetails = false;
      return;
    }

    FocusScope.of(context).unfocus();

    _analyticsService.track(eventName: AnalyticsEvents.openKYCSection);

    ///next get all details required for registration

    try {
      ApiResponse<VerifyPanResponseModel> response =
          await _bankingRepo.verifyPan(
              uid: _userService.baseUser.uid,
              panNumber: panController.text.trim(),
              panName: nameController.text.trim().toUpperCase());

      if (response.code == 200) {
        if (response.model.flag) {
          await _cacheService.invalidateByKey(CacheKeys.USER);
          await _userService.setBaseUser();
          _sellService.checkForUserPanDetails();
          _sellService.isKYCVerified = true;
          _analyticsService.track(
            eventName: AnalyticsEvents.panVerified,
            properties: {'userId': _userService.baseUser.uid},
          );

          isUpadtingKycDetails = false;

          BaseUtil.showPositiveAlert(
              'Verification Successful', 'You are successfully verified!');
          // isKycInProgress = false;

          _gtService.fetchAndVerifyGoldenTicketByID();

          AppState.backButtonDispatcher.didPopRoute();
        }
      } else {
        isUpadtingKycDetails = false;

        BaseUtil.showNegativeAlert(
            'Registration failed', response.errorMessage ?? 'Please try again');

        _analyticsService.track(
          eventName: AnalyticsEvents.kycVerificationFailed,
          properties: {'userId': _userService.baseUser.uid},
        );
      }
    } on BadRequestException catch (e) {
      return ApiResponse(
        model: false,
        code: 400,
        errorMessage: e.toString(),
      );
    } catch (e) {
      _logger.e(e.toString());
    }
  }
}
