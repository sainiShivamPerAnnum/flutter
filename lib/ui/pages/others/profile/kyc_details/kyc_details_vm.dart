import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
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
import 'package:image_picker/image_picker.dart';

enum KycVerificationStatus { UNVERIFIED, FAILED, VERIFIED, NONE }

class KYCDetailsViewModel extends BaseViewModel {
  final _bankAndPanService = locator<BankAndPanService>();
  TextEditingController? nameController, panController;
  bool inEditMode = true;
  bool _isUpdatingKycDetails = false;
  int permissionFailureCount = 0;
  get isUpdatingKycDetails => this._isUpdatingKycDetails;

  set isUpdatingKycDetails(value) {
    this._isUpdatingKycDetails = value;
    notifyListeners();
  }

  bool _hasDetails = false;
  XFile? _capturedImage;
  double? _fileSize;
  UserKycDataModel? _userKycData;
  String? _kycErrorMessage;

  get kycErrorMessage => this._kycErrorMessage;

  set kycErrorMessage(value) {
    this._kycErrorMessage = value;
    notifyListeners();
  }

  UserKycDataModel? get userKycData => this._userKycData;

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

  XFile? get capturedImage => this._capturedImage;

  set capturedImage(value) {
    this._capturedImage = value;
    notifyListeners();
  }

  final CustomLogger? _logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();
  final BankingRepository _bankingRepo = locator<BankingRepository>();

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
    final String ext = capturedImage!.name.split('.').last.toLowerCase();

    if (ext == 'png' || ext == 'jpg' || ext == 'jpeg') {
      File imageFile = File(capturedImage!.path);
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
                title: 'Invalid File',
                text:
                    'Selected file size is very large. Please select an image of size less than 5 MB.'));
      } else
        return;
    } else {
      capturedImage = null;
      BaseUtil.openDialog(
          addToScreenStack: true,
          isBarrierDismissible: false,
          hapticVibrate: true,
          content: MoreInfoDialog(
              title: 'Invalid File',
              text:
                  'Selected file is invalid. Please select a valid PNG, JPEG or JPG image.'));
    }
  }

  Future checkForKycExistence() async {
    _logger!.d("${_bankAndPanService.userKycData?.toString()}");
    setState(ViewState.Busy);
    if (_bankAndPanService.isKYCVerified &&
        _bankAndPanService.userKycData != null)
      userKycData = _bankAndPanService.userKycData;
    else {
      await _bankAndPanService.checkForUserPanDetails();
      userKycData = _bankAndPanService.userKycData;
    }
    if (userKycData != null) {
      if (userKycData!.ocrVerified) {
        kycVerificationStatus = KycVerificationStatus.VERIFIED;
        panController!.text = userKycData!.pan;
        nameController!.text = userKycData!.name;
        inEditMode = false;
        hasDetails = true;
      } else
        kycVerificationStatus = KycVerificationStatus.UNVERIFIED;
    } else {
      kycVerificationStatus = KycVerificationStatus.UNVERIFIED;
    }
    setState(ViewState.Idle);
  }

  Future<void> onSubmit(context) async {
    kycErrorMessage = null;
    if (capturedImage == null)
      return BaseUtil.showNegativeAlert(
          "No file selected", "Please select a valid PAN image");
    if (isUpdatingKycDetails) return;
    isUpdatingKycDetails = true;
    AppState.blockNavigation();
    final res = await _bankingRepo.getSignedImageUrl(capturedImage!.name);

    if (res.isSuccess()) {
      final imageUploadRes =
          await _bankingRepo.uploadPanImageFile(res.model!.url, capturedImage!);
      if (imageUploadRes.isSuccess()) {
        final forgeryUploadRes =
            await _bankingRepo.processForgeryUpload(res.model!.key);
        if (forgeryUploadRes.isSuccess()) {
          capturedImage = null;
          _bankAndPanService.activeBankAccountDetails = null;
          _bankAndPanService.isBankDetailsAdded = false;
          await checkForKycExistence();
          _cacheService.invalidateByKey(CacheKeys.USER);
          await _userService.setBaseUser();

          _bankAndPanService.checkForUserBankAccountDetails();
          BaseUtil.showPositiveAlert("KYC successfully completed ✅",
              "Your KYC verification has been successfully completed");
          AppState.backButtonDispatcher!.didPopRoute();
        } else {
          capturedImage = null;
          kycErrorMessage = forgeryUploadRes.errorMessage;
          kycVerificationStatus = KycVerificationStatus.FAILED;
          BaseUtil.showNegativeAlert(
              forgeryUploadRes.errorMessage ?? "PAN verification failed",
              "Please upload a valid PAN image and try again");
        }
      } else {
        capturedImage = null;
        kycErrorMessage = imageUploadRes.errorMessage;
        kycVerificationStatus = KycVerificationStatus.FAILED;
        BaseUtil.showNegativeAlert(
            imageUploadRes.errorMessage ?? "Failed to upload your PAN image",
            "Please try again after sometime");
      }
    } else {
      capturedImage = null;
      kycErrorMessage = res.errorMessage;
      kycVerificationStatus = KycVerificationStatus.FAILED;
      BaseUtil.showNegativeAlert(
          res.errorMessage ?? "Failed to upload your PAN image",
          "Please try again after sometime");
    }
    isUpdatingKycDetails = false;
    AppState.unblockNavigation();
  }
}
