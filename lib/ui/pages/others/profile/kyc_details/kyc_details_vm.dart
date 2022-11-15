import 'dart:io';

import 'package:camera/camera.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_kyc_data_model.dart';
import 'package:felloapp/core/repository/banking_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

enum KycVerificationStatus { UNVERIFIED, FAILED, VERIFIED, NONE }

class KYCDetailsViewModel extends BaseViewModel {
  final _bankAndPanService = locator<BankAndPanService>();
  String stateChosenValue;
  TextEditingController nameController, panController;
  bool inEditMode = true;
  bool _isUpdatingKycDetails = false;

  get isUpdatingKycDetails => this._isUpdatingKycDetails;

  set isUpdatingKycDetails(value) {
    this._isUpdatingKycDetails = value;
    notifyListeners();
  }

  bool _hasDetails = false;
  XFile _capturedImage;
  double _fileSize;
  UserKycDataModel _userKycData;
  String _kycErrorMessage;

  get kycErrorMessage => this._kycErrorMessage;

  set kycErrorMessage(value) {
    this._kycErrorMessage = value;
    notifyListeners();
  }

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
            isBarrierDismissible: false,
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
          isBarrierDismissible: false,
          hapticVibrate: true,
          content: MoreInfoDialog(
              title: 'Snap!',
              text:
                  'Selected file is invalid, please add a valid image (PNG, JPEG, JPG)'));
    }
  }

  checkForKycExistence() async {
    setState(ViewState.Busy);
    final kycRes = await _bankingRepo.getUserKycInfo();
    if (kycRes.isSuccess()) {
      userKycData = kycRes.model;
      if (userKycData.ocrVerified) {
        kycVerificationStatus = KycVerificationStatus.VERIFIED;
        panController.text = userKycData.pan;
        nameController.text = userKycData.name;
        inEditMode = false;
        hasDetails = true;
      } else
        kycVerificationStatus = KycVerificationStatus.UNVERIFIED;
    } else {
      kycVerificationStatus = KycVerificationStatus.NONE;
    }
    setState(ViewState.Idle);
  }

  Future<void> onSubmit(context) async {
    if (capturedImage == null)
      return BaseUtil.showNegativeAlert(
          "No file selected", "Please select a file");
    if (isUpdatingKycDetails) return;
    isUpdatingKycDetails = true;
    final res = await _bankingRepo.getSignedImageUrl(capturedImage.name);

    if (res.isSuccess()) {
      final imageUploadRes =
          await _bankingRepo.uploadPanImageFile(res.model.url, capturedImage);
      if (imageUploadRes.isSuccess()) {
        final forgeryUploadRes =
            await _bankingRepo.processForgeryUpload(res.model.key);
        if (forgeryUploadRes.isSuccess()) {
          capturedImage = null;
          _bankAndPanService.activeBankAccountDetails = null;
          _bankAndPanService.isBankDetailsAdded = false;
          checkForKycExistence();
          BaseUtil.showPositiveAlert(
              "Kyc Verification Successful!", "Sell Unlocked");
          AppState.backButtonDispatcher.didPopRoute();
        } else {
          kycErrorMessage = forgeryUploadRes.errorMessage;
          BaseUtil.showNegativeAlert(
              forgeryUploadRes.errorMessage ?? "Something went wrong!", "");
        }
      } else {
        capturedImage = null;
        kycErrorMessage = imageUploadRes.errorMessage;
        BaseUtil.showNegativeAlert(
            imageUploadRes.errorMessage ?? "You are fraud",
            "Use a real pan image");
      }
    } else
      BaseUtil.showNegativeAlert(
          res.errorMessage ?? "Failed to get Url", "Please try again");
    isUpdatingKycDetails = false;
  }
}
