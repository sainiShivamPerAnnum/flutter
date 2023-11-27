import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_kyc_data_model.dart';
import 'package:felloapp/core/repository/banking_repo.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/google_sign_in_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum KycVerificationStatus { UNVERIFIED, FAILED, VERIFIED, NONE }

class KYCDetailsViewModel extends BaseViewModel {
  final _bankAndPanService = locator<BankAndPanService>();
  final GoogleSignInService _googleService = locator<GoogleSignInService>();
  S locale = locator<S>();
  TextEditingController? nameController, panController;
  bool inEditMode = true;
  String? get email => _userService.email;
  bool _isUpdatingKycDetails = false;
  bool _isEmailUpdating = false;
  get isEmailUpdating => _isEmailUpdating;
  bool isPanTileOpen = false;
  bool isEmailTileOpen = false;

  set isEmailUpdating(value) {
    _isEmailUpdating = value;
    notifyListeners();
  }

  int permissionFailureCount = 0;
  get isUpdatingKycDetails => _isUpdatingKycDetails;

  bool _isPanVerified = false;
  // bool _isEmailVerified = false;
  bool get isPanVerified => _isPanVerified;

  set isPanVerified(bool value) {
    _isPanVerified = value;
    notifyListeners();
  }

  get isEmailVerified => _userService.isEmailVerified;

  // set isEmailVerified(value) {
  //   this._isEmailVerified = value;
  //   notifyListeners();
  // }

  set isUpdatingKycDetails(value) {
    _isUpdatingKycDetails = value;
    notifyListeners();
  }

  bool showKycHelpView = false;
  bool _hasDetails = false;
  XFile? _capturedImage;
  double? _fileSize;
  UserKycDataModel? _userKycData;
  String? _kycErrorMessage;

  get kycErrorMessage => _kycErrorMessage;

  set kycErrorMessage(value) {
    _kycErrorMessage = value;
    notifyListeners();
  }

  void changeView() {
    showKycHelpView = false;
    notifyListeners();
  }

  UserKycDataModel? get userKycData => _userKycData;

  set userKycData(value) {
    _userKycData = value;
    notifyListeners();
  }

  get fileSize => _fileSize;

  set fileSize(value) {
    _fileSize = value;
    notifyListeners();
  }

  KycVerificationStatus _kycVerificationStatus = KycVerificationStatus.NONE;

  KycVerificationStatus get kycVerificationStatus => _kycVerificationStatus;

  set kycVerificationStatus(value) {
    _kycVerificationStatus = value;
    notifyListeners();
  }

  XFile? get capturedImage => _capturedImage;

  set capturedImage(value) {
    _capturedImage = value;
    notifyListeners();
  }

  final CustomLogger _logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();
  final BankingRepository _bankingRepo = locator<BankingRepository>();

  final _cacheService = CacheService();
  bool get isConfirmDialogInView => _userService.isConfirmationDialogOpen;

  FocusNode kycNameFocusNode = FocusNode();

  FocusNode panFocusNode = FocusNode();
  TextInputType panTextInputType = TextInputType.name;

  final depositformKey3 = GlobalKey<FormState>();

  get hasDetails => _hasDetails;

  set hasDetails(value) {
    _hasDetails = value;
    notifyListeners();
  }

  init() {
    nameController = TextEditingController();
    panController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkForKycExistence();
    });
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
                title: locale.invalidFile, text: locale.invalidFileSubtitle));
      } else {
        return;
      }
    } else {
      capturedImage = null;
      BaseUtil.openDialog(
          addToScreenStack: true,
          isBarrierDismissible: false,
          hapticVibrate: true,
          content: MoreInfoDialog(
              title: locale.invalidFile, text: locale.invalidFileSubtitle));
    }
  }

  Future checkForKycExistence() async {
    _logger.d("${_bankAndPanService.userKycData?.toString()}");
    setState(ViewState.Busy);
    if (_bankAndPanService.isKYCVerified &&
        _bankAndPanService.userKycData != null) {
      userKycData = _bankAndPanService.userKycData;
    } else {
      await _bankAndPanService.checkForUserPanDetails();
      userKycData = _bankAndPanService.userKycData;
    }
    if (userKycData != null) {
      if (userKycData!.ocrVerified) {
        _bankAndPanService.isKYCVerified = true;
        kycVerificationStatus = KycVerificationStatus.VERIFIED;
        panController!.text = userKycData!.pan;
        nameController!.text = userKycData!.name;
        inEditMode = false;
        hasDetails = true;
        isPanTileOpen = false;
        if (!isEmailVerified) isEmailTileOpen = true;
      } else {
        isPanTileOpen = true;
        kycVerificationStatus = KycVerificationStatus.UNVERIFIED;
      }
    } else {
      isPanTileOpen = true;
      kycVerificationStatus = KycVerificationStatus.UNVERIFIED;
    }
    if (kycVerificationStatus == KycVerificationStatus.UNVERIFIED) {
      showKycHelpView = true;
    }
    setState(ViewState.Idle);
  }

  Future<bool> veryGmail() async {
    if (isEmailVerified) return false;
    if (isEmailUpdating) return false;
    Haptic.vibrate();
    isEmailUpdating = true;
    final String? response = await _googleService.signInWithGoogle();
    isEmailUpdating = false;
    if (response != null) {
      // email = response;
      BaseUtil.showPositiveAlert(
          "Email verified successfully", "Your email was successfully added");
      _logger.d("Email $email verified successfully");
      return true;
    } else {
      _logger.d("failed to verify email, try again");
      return false;
    }
  }

  Future<void> onSubmit(context) async {
    kycErrorMessage = null;
    if (isEmailUpdating) {
      return BaseUtil.showNegativeAlert(
          "Updating your email", "please wait for this process to finish");
    }

    if (capturedImage == null) {
      return BaseUtil.showNegativeAlert(
          locale.noFileSelected, locale.selectValidPan);
    }
    if (!_userService.isEmailVerified) {
      return BaseUtil.showNegativeAlert(
          "Email not verified", "please verify an email to continue");
    }
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
          await CacheService.invalidateByKey(CacheKeys.USER);
          await _userService.setBaseUser();

          _bankAndPanService.checkForUserBankAccountDetails();
          AppState.backButtonDispatcher!.didPopRoute();
          BaseUtil.showPositiveAlert(
              locale.kycSuccessTitle, locale.kycSuccessSubTitle);
        } else {
          capturedImage = null;
          kycErrorMessage = forgeryUploadRes.errorMessage;
          kycVerificationStatus = KycVerificationStatus.FAILED;
          BaseUtil.showNegativeAlert(
              forgeryUploadRes.errorMessage ?? locale.panVerifyFailed,
              locale.selectValidPan);
        }
      } else {
        capturedImage = null;
        kycErrorMessage = imageUploadRes.errorMessage;
        kycVerificationStatus = KycVerificationStatus.FAILED;
        BaseUtil.showNegativeAlert(
            imageUploadRes.errorMessage ?? locale.failedToUploadPAN,
            locale.tryLater);
      }
    } else {
      capturedImage = null;
      kycErrorMessage = res.errorMessage;
      kycVerificationStatus = KycVerificationStatus.FAILED;
      BaseUtil.showNegativeAlert(
          res.errorMessage ?? locale.failedToUploadPAN, locale.tryLater);
    }
    isUpdatingKycDetails = false;
    AppState.unblockNavigation();
  }
}
