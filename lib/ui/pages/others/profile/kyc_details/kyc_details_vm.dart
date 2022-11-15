import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_kyc_data_model.dart';
import 'package:felloapp/core/model/verify_pan_response_model.dart';
import 'package:felloapp/core/repository/banking_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/app_exceptions.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

enum KycVerificationStatus { UNVERIFIED, FAILED, VERIFIED, INPROCESS, NONE }

class KYCDetailsViewModel extends BaseViewModel {
  String stateChosenValue;
  TextEditingController nameController, panController;
  bool inEditMode = true;
  bool isUpadtingKycDetails = false;
  bool _hasDetails = false;
  XFile _capturedImage;
  double _fileSize;
  UserKycDataModel _userKycData;

  UserKycDataModel get userKycData => this._userKycData;

  set userKycData(value) {
    this._userKycData = value;
    notifyListeners();
  }

  get fileSize => this._fileSize;

  set fileSize(value) {
    this._fileSize = value;
    notifyListeners();
  }

  KycVerificationStatus _kycVerificationStatus =
      KycVerificationStatus.UNVERIFIED;

  KycVerificationStatus get kycVerificationStatus =>
      this._kycVerificationStatus;

  set kycVerificationStatus(value) {
    this._kycVerificationStatus = value;
    notifyListeners();
  }

  XFile get capturedImage => this._capturedImage;

  set capturedImage(value) {
    this._capturedImage = value;
    notifyListeners();
  }

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

  // checkForKeyboardChange(String val) {
  //   if (val.length >= 0 &&
  //       val.length < 5 &&
  //       panTextInputType != TextInputType.name) {
  //     panFocusNode.unfocus();
  //     panTextInputType = TextInputType.name;
  //     notifyListeners();
  //     // Future.delayed(Duration(milliseconds: 100), () {
  //     //   panFocusNode.requestFocus();
  //     // });
  //     return;
  //   }
  //   if (val.length >= 5 &&
  //       val.length < 9 &&
  //       panTextInputType != TextInputType.number) {
  //     print("I got called");
  //     panFocusNode.unfocus();
  //     panTextInputType = TextInputType.number;
  //     notifyListeners();
  //     Future.delayed(Duration(milliseconds: 100), () {
  //       panFocusNode.requestFocus();
  //     });
  //     return;
  //   }

  //   if (val.length >= 9 && panTextInputType != TextInputType.name) {
  //     panFocusNode.unfocus();
  //     panTextInputType = TextInputType.name;
  //     notifyListeners();
  //     Future.delayed(Duration(milliseconds: 100), () {
  //       panFocusNode.requestFocus();
  //     });
  //   }

  //   return;
  // }

  void verifyImage() {
    if (capturedImage == null) return;
    final String ext = capturedImage.name.split('.').last.toLowerCase();

    if (ext == 'png' || ext == 'jpg' || ext == 'jpeg') {
      File imageFile = File(capturedImage.path);
      fileSize =
          BaseUtil.digitPrecision(imageFile.lengthSync() / 1048576, 2, true);
      print("File size: $fileSize");
      if (fileSize > 5) {
        capturedImage = null;
        BaseUtil.openDialog(
            addToScreenStack: true,
            isBarrierDismissable: false,
            hapticVibrate: true,
            content: MoreInfoDialog(
                title: 'Snap!',
                text:
                    'Selected file is too big, please add an image less than 5 MB'));
      } else
        return;
    } else {
      capturedImage = null;
      BaseUtil.openDialog(
          addToScreenStack: true,
          isBarrierDismissable: false,
          hapticVibrate: true,
          content: MoreInfoDialog(
              title: 'Snap!',
              text:
                  'Selected file is invalid, please add a valid image (PNG, JPEG, JPG)'));
    }
  }

  checkForKycExistence() async {
    setState(ViewState.Busy);
    // if (_userService.baseUser.isSimpleKycVerified != null &&
    //     _sellService.userPan != null &&
    //     _sellService.userPan.isNotEmpty) {
    //   if (_userService.baseUser.isSimpleKycVerified) {
    //     hasDetails = true;
    //     panController.text = _sellService.userPan;
    //     nameController.text = _userService.baseUser.kycName;
    //     inEditMode = false;
    //   }
    // }
    final kycRes = await _bankingRepo.getUserKycInfo();
    if (kycRes.isSuccess()) {
      userKycData = kycRes.model;

      if (kycRes.model.ocrVerified) {
        kycVerificationStatus = KycVerificationStatus.VERIFIED;
        panController.text = kycRes.model.pan;
        nameController.text = kycRes.model.name;
        inEditMode = false;
        hasDetails = true;
      } else if (kycRes.model.trackResult != null) {
        switch (kycRes.model.trackResult.status) {
          case 'pending':
            kycVerificationStatus = KycVerificationStatus.INPROCESS;
            break;
          case 'failed':
            kycVerificationStatus = KycVerificationStatus.FAILED;
            break;
        }
      }
    } else {
      kycVerificationStatus = KycVerificationStatus.NONE;
    }
    setState(ViewState.Idle);
  }

  // bool _preVerifyInputs() {
  //   RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
  //   if (panController.text.isEmpty) {
  //     BaseUtil.showNegativeAlert(
  //         'Invalid Pan', 'Kindly enter a valid PAN Number');
  //     return false;
  //   } else if (!panCheck.hasMatch(panController.text) ||
  //       panController.text.length != 10) {
  //     BaseUtil.showNegativeAlert(
  //         'Invalid Pan', 'Kindly enter a valid PAN Number');
  //     return false;
  //   } else if (nameController.text.isEmpty) {
  //     BaseUtil.showNegativeAlert(
  //         'Name missing', 'Kindly enter your name as per your pan card');
  //     return false;
  //   }
  //   return true;
  // }

  Future<void> onSubmit(context) async {
    if (capturedImage == null)
      return BaseUtil.showNegativeAlert(
          "No file selected", "Please select a file");
    if (isUpadtingKycDetails) return;
    isUpadtingKycDetails = true;
    final res = await _bankingRepo.getSignedImageUrl(capturedImage.name);

    if (res.isSuccess()) {
      final imageUploadRes =
          await _bankingRepo.uploadPanImageFile(res.model.url, capturedImage);
      if (imageUploadRes.isSuccess()) {
        final forgeryUploadRes =
            await _bankingRepo.postForgeryUpload(res.model.key, res.model.id);
        if (forgeryUploadRes.isSuccess()) {
          kycVerificationStatus = KycVerificationStatus.INPROCESS;
          capturedImage = null;
          BaseUtil.showPositiveAlert(
              "Successful", "We'll notify you in a moment");
        } else {
          BaseUtil.showNegativeAlert(
              forgeryUploadRes.errorMessage ?? "Something went wrong!", "");
        }
      } else {
        capturedImage = null;
        BaseUtil.showNegativeAlert("You are fraud", "Use a real pan image");
      }
    } else
      BaseUtil.showNegativeAlert("Failed to get Url", "Please try again");
    isUpadtingKycDetails = false;
    // if (!_preVerifyInputs()) {
    //   isUpadtingKycDetails = false;
    //   return;
    // }

    // FocusScope.of(context).unfocus();

    // _analyticsService.track(eventName: AnalyticsEvents.openKYCSection);

    // ///next get all details required for registration

    // try {
    //   ApiResponse<VerifyPanResponseModel> response =
    //       await _bankingRepo.verifyPan(
    //           uid: _userService.baseUser.uid,
    //           panNumber: panController.text.trim(),
    //           panName: nameController.text.trim().toUpperCase());

    //   if (response.code == 200) {
    //     if (response.model.flag) {
    //       await _cacheService.invalidateByKey(CacheKeys.USER);
    //       await _userService.setBaseUser();
    //       _sellService.checkForUserPanDetails();
    //       _sellService.isKYCVerified = true;
    //       _analyticsService.track(
    //         eventName: AnalyticsEvents.panVerified,
    //         properties: {'userId': _userService.baseUser.uid},
    //       );

    //       isUpadtingKycDetails = false;

    //       BaseUtil.showPositiveAlert(
    //           'Verification Successful', 'You are successfully verified!');
    //       // isKycInProgress = false;

    //       _gtService.fetchAndVerifyGoldenTicketByID();

    //       AppState.backButtonDispatcher.didPopRoute();
    //     }
    //   } else {
    //     isUpadtingKycDetails = false;

    //     BaseUtil.showNegativeAlert(
    //         'Registration failed', response.errorMessage ?? 'Please try again');

    //     _analyticsService.track(
    //       eventName: AnalyticsEvents.kycVerificationFailed,
    //       properties: {'userId': _userService.baseUser.uid},
    //     );
    //   }
    // } on BadRequestException catch (e) {
    //   return ApiResponse(
    //     model: false,
    //     code: 400,
    //     errorMessage: e.toString(),
    //   );
    // } catch (e) {
    //   _logger.e(e.toString());
    // }
  }
}
