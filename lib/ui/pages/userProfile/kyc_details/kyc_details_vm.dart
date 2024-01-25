import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_kyc_data_model.dart';
import 'package:felloapp/core/repository/banking_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/google_sign_in_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/modalsheets/upload_pan_modal.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

enum KycVerificationStatus { UNVERIFIED, FAILED, VERIFIED, NONE }

enum CurrentStep {
  pan(1),
  email(2);

  const CurrentStep(this.value);
  final int value;
}

class KYCDetailsViewModel extends BaseViewModel {
  final _bankAndPanService = locator<BankAndPanService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final GoogleSignInService _googleService = locator<GoogleSignInService>();
  S locale = locator<S>();
  TextEditingController? nameController, panController;
  bool inEditMode = true;
  String? get email => _userService.email;
  bool _isUpdatingKycDetails = false;
  bool _isEmailUpdating = false;
  bool get isEmailUpdating => _isEmailUpdating;
  bool isPanTileOpen = false;
  bool isEmailTileOpen = false;
  CurrentStep _currentStep = CurrentStep.email;
  ImagePicker? _imagePicker = ImagePicker();

  set isEmailUpdating(value) {
    _isEmailUpdating = value;
    notifyListeners();
  }

  int permissionFailureCount = 0;
  bool get isUpdatingKycDetails => _isUpdatingKycDetails;

  bool _isPanVerified = false;
  bool get isPanVerified => _isPanVerified;

  CurrentStep get currentStep => _currentStep;

  set setCurrentStep(CurrentStep value) {
    _currentStep = value;
    notifyListeners();
  }

  set isPanVerified(bool value) {
    _isPanVerified = value;
    notifyListeners();
  }

  bool get isEmailVerified => _userService.isEmailVerified;

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

  String? get kycErrorMessage => _kycErrorMessage;

  set kycErrorMessage(value) {
    _kycErrorMessage = value;
    notifyListeners();
  }

  void changeView() {
    showKycHelpView = false;
    notifyListeners();
  }

  Future<void> imageCapture(BuildContext context) async {
    Haptic.vibrate();
    trackSelectedPanType('Camera');
    try {
      capturedImage = await _imagePicker?.pickImage(source: ImageSource.camera);
      verifyImage(context);
    } catch (e) {
      final internalOpsService = locator<InternalOpsService>();
      final userService = locator<UserService>();
      await internalOpsService.logFailure(
        userService.baseUser?.uid ?? '',
        FailType.KycImageCaptureFailed,
        {'message': "Kyc image caputre failed", 'reason': e.toString()},
      );

      permissionFailureCount += 1;
      const Permission cameraPermission = Permission.camera;
      final PermissionStatus cameraPermissionStatus =
          await cameraPermission.status;
      if (permissionFailureCount > 2) {
        return BaseUtil.openDialog(
          isBarrierDismissible: true,
          addToScreenStack: true,
          hapticVibrate: true,
          content: MoreInfoDialog(
            title: locale.btnAlert,
            text: locale.kycGrantPermissionText,
            btnText: locale.btnGrantPermission,
            onPressed: () async {
              await openAppSettings();
              await AppState.backButtonDispatcher!.didPopRoute();
            },
          ),
        );
      } else if (cameraPermissionStatus == PermissionStatus.denied) {
        return BaseUtil.openDialog(
          isBarrierDismissible: true,
          addToScreenStack: true,
          hapticVibrate: true,
          content: MoreInfoDialog(
            title: locale.btnAlert,
            text: locale.kycGrantPermissionText,
          ),
        );
      }
    }
  }

  Future<void> selectImage(BuildContext context) async {
    Haptic.vibrate();
    trackSelectedPanType('Device');
    capturedImage = await _imagePicker?.pickImage(source: ImageSource.gallery);
    verifyImage(context);
  }

  UserKycDataModel? get userKycData => _userKycData;

  set userKycData(value) {
    _userKycData = value;
    notifyListeners();
  }

  double? get fileSize => _fileSize;

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

  bool get isConfirmDialogInView => _userService.isConfirmationDialogOpen;

  FocusNode kycNameFocusNode = FocusNode();

  FocusNode panFocusNode = FocusNode();
  TextInputType panTextInputType = TextInputType.name;

  final depositformKey3 = GlobalKey<FormState>();

  bool get hasDetails => _hasDetails;

  set hasDetails(value) {
    _hasDetails = value;
    notifyListeners();
  }

  void init() {
    setState(ViewState.Busy);
    nameController = TextEditingController();
    panController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkForKycExistence();
    });
  }

  void disposeImagePicker() {
    _imagePicker = null;
  }

  void panUploadProceed() {
    trackUploadPanClicked();
      BaseUtil.openModalBottomSheet(
        isBarrierDismissible: true,
        addToScreenStack: true,
        content: UploadPanModal(
          model: this,
        ),
      );
  }

  void verifyImage(BuildContext context) {
    if (capturedImage == null) return;
    final String ext = capturedImage!.name.split('.').last.toLowerCase();

    if (ext == 'png' || ext == 'jpg' || ext == 'jpeg') {
      File imageFile = File(capturedImage!.path);
      fileSize =
          BaseUtil.digitPrecision(imageFile.lengthSync() / 1048576, 2, true);
      if (fileSize! > 5.0) {
        capturedImage = null;
        BaseUtil.openDialog(
            addToScreenStack: true,
            isBarrierDismissible: false,
            hapticVibrate: true,
            content: MoreInfoDialog(
                title: locale.invalidFile, text: locale.invalidFileSubtitle));
      } else {
        onSubmit(context);
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
        _currentStep = !isEmailVerified ? CurrentStep.email : CurrentStep.pan;
        if (!isEmailVerified) isEmailTileOpen = true;
      } else {
        _currentStep = !isEmailVerified ? CurrentStep.email : CurrentStep.pan;
        isPanTileOpen = true;
        kycVerificationStatus = KycVerificationStatus.UNVERIFIED;
      }
    } else {
      _currentStep = !isEmailVerified ? CurrentStep.email : CurrentStep.pan;
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
    trackEmailVerifyClicked();
    isEmailUpdating = true;
    final String? response = await _googleService.signInWithGoogle();
    isEmailUpdating = false;
    if (response != null) {
      _currentStep = CurrentStep.pan;
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
    if (capturedImage == null) {
      return BaseUtil.showNegativeAlert(
          locale.noFileSelected, locale.selectValidPan);
    }
    if (isUpdatingKycDetails) return;
    isUpdatingKycDetails = true;
    await AppState.backButtonDispatcher!.didPopRoute();
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
          await _bankAndPanService.checkForUserBankAccountDetails();
          await AppState.backButtonDispatcher!.didPopRoute();
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

   void trackEmailVerifyClicked() {
    _analyticsService.track(
      eventName: AnalyticsEvents.kycVerifyEmailClicked
    );
  }
   void trackUploadPanClicked() {
    _analyticsService.track(
      eventName: AnalyticsEvents.kycUploadPanClicked,
    );
  }
   void trackSelectedPanType(String mode) {
    _analyticsService.track(
      eventName: AnalyticsEvents.kycScreenPanType,
      properties: {
        "mode": mode,
      },
    );
  }
  void trackKycDoneClicked() {
    _analyticsService.track(
      eventName: AnalyticsEvents.kycScreenDone,
    );
  }
}
