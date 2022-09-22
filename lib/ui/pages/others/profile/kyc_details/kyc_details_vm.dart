import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/verify_pan_response_model.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/repository/banking_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/payments/sell_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/app_exceptions.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/core/service/cache_service.dart';

class KYCDetailsViewModel extends BaseViewModel {
  String stateChosenValue;
  TextEditingController nameController, panController;
  bool inEditMode = true;
  bool isUpadtingKycDetails = false;
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  final _httpModel = locator<HttpModel>();
  final _baseUtil = locator<BaseUtil>();
  final _analyticsService = locator<AnalyticsService>();
  final _bankingRepo = locator<BankingRepository>();
  final _gtService = locator<GoldenTicketService>();
  final _internalOpsService = locator<InternalOpsService>();
  final _sellService = locator<SellService>();
  final _cacheService = new CacheService();
  final _userRepo = locator<UserRepository>();
  bool get isConfirmDialogInView => _userService.isConfirmationDialogOpen;

  FocusNode kycNameFocusNode = FocusNode();
  FocusNode panFocusNode = FocusNode();
  TextInputType panTextInputType = TextInputType.name;

  final depositformKey3 = GlobalKey<FormState>();

  // bool _isKycInProgress = false;

  // get isKycInProgress => _isKycInProgress;

  // set isKycInProgress(val) {
  //   this._isKycInProgress = val;
  //   notifyListeners();
  // }

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
              panName: nameController.text.trim());

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

          _gtService.fetchAndVerifyGoldenTicketByID().then((bool res) {
            if (res)
              _gtService.showInstantGoldenTicketView(
                  title: 'Your KYC is complete', source: GTSOURCE.panVerify);
          });

          AppState.backButtonDispatcher.didPopRoute();
        }
      } else {
        isUpadtingKycDetails = false;
        // if (veriDetails['fail_code'] == 0) {
        //   BaseUtil.openDialog(
        //     addToScreenStack: true,
        //     content: MoreInfoDialog(
        //       text: veriDetails['reason'],
        //       imagePath: Assets.dummyPanCardShowNumber,
        //       title: 'Invalid Details',
        //     ),
        //     hapticVibrate: true,
        //     isBarrierDismissable: false,
        //   );
        // } else
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

  // Future<Map<String, dynamic>> _getVerifiedDetails(
  //     String enteredPan, String enteredPanName) async {
  //   if (enteredPan == null || enteredPan.isEmpty)
  //     return {'flag': false, 'reason': 'Invalid Details'};
  //   bool _flag = true;
  //   int _failCode = 0;
  //   String _reason = '';
  //   String upstreamName = '';

  //   try {
  //     ApiResponse<VerifyPanResponseModel> _response =
  //         await _bankingRepo.verifyPan(
  //             uid: _userService.baseUser.uid,
  //             panNumber: enteredPan,
  //             panName: enteredPanName);

  //     if (_response.isSuccess()) {
  //       if (_response.model.gtId != null && _response.model.gtId.isNotEmpty)
  //         GoldenTicketService.goldenTicketId = _response.model.gtId;
  //       // clear cache
  //       await _cacheService.invalidateByKey(CacheKeys.USER);
  //       _flag = true;
  //     } else {
  //       _flag = false;
  //       _reason = _response.errorMessage;
  //     }

  //     if (!_flag) {
  //       _reason =
  //           'The name on your PAN card does not match with the entered name. Please try again.';
  //     } else {
  //       upstreamName = _response.model.upstreamName;
  //     }
  //   } catch (e) {
  //     _flag = false;
  //     _logger.e(e.toString());
  //     _reason =
  //         'The name on your PAN card does not match with the entered name. Please try again.';
  //   }
  //   // }
  //   // if (!_flag) {
  //   //   _analyticsService.track(
  //   //     eventName: AnalyticsEvents.kycVerificationFailed,
  //   //     properties: {'userId': _userService.baseUser.uid},
  //   //   );

  //   //   print('returning false flag');
  //   //   Map<String, dynamic> _data = {
  //   //     'flag': _flag,
  //   //     'fail_code': _failCode,
  //   //     'reason': _reason,
  //   //     'user_pan_name': enteredPanName,
  //   //     'user_pan_number': enteredPan,
  //   //     'upstream_name': upstreamName,
  //   //   };
  //   //   _internalOpsService.logFailure(
  //   //       _userService.baseUser.uid, FailType.UserKYCFlagFetchFailed, _data);
  //   //   return {'flag': _flag, 'fail_code': _failCode, 'reason': _reason};
  //   // }

  //   return {
  //     'upstreamName': upstreamName,
  //     'flag': true,
  //   };
  // }
}
