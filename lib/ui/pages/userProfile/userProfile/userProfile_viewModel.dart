//Project Imports
import 'dart:async';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/username_response_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/core/service/notifier_services/google_sign_in_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/tambola/src/repos/tambola_repo.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/dialogs/user_avatars_dialog.dart';
import 'package:felloapp/ui/pages/static/profile_image.dart';
import 'package:felloapp/ui/pages/userProfile/userProfile/components/sign_in_options.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/date_helper.dart';
import 'package:felloapp/util/debouncer.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
//Flutter & Dart Imports
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/repository/user_repo.dart';

class UserProfileVM extends BaseViewModel {
  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final usernameRegex = RegExp(r"^(?!\.)(?!.*\.$)(?!.*?\.\.)[a-z0-9.]{4,20}$");
  UsernameResponse? response;
  Debouncer? _debouncer;

  Log log = const Log('User Profile');
  bool _inEditMode = false;
  bool _isgmailFieldEnabled = true;

  // bool _isNewUser = false;
  bool _isEmailEnabled = false;
  bool _isContinuedWithGoogle = false;
  bool _isSigningInWithGoogle = false;
  bool _isNameEnabled = true;
  bool _isDateEnabled = true;

  bool isUsernameLoading = false;
  bool? isValid = false;

  final UserRepository _userRepo = locator<UserRepository>();
  final UserService _userService = locator<UserService>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final FcmListener? fcmlistener = locator<FcmListener>();
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();
  S locale = locator<S>();
  final AppState _appstate = locator<AppState>();
  final TambolaService _tambolaService = locator<TambolaService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final S _locale = locator<S>();
  final BaseUtil? baseProvider = locator<BaseUtil>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();
  final JourneyService _journeyService = locator<JourneyService>();
  final GoogleSignInService _googleSignInService =
      locator<GoogleSignInService>();
  final BankAndPanService _bankAndKycService = locator<BankAndPanService>();
  final DBModel? dbProvider = locator<DBModel>();
  final ScratchCardService _gtService = locator<ScratchCardService>();
  final PowerPlayService _powerPlayService = locator<PowerPlayService>();

  final MarketingEventHandlerService _marketingService =
      locator<MarketingEventHandlerService>();
  final TambolaRepo _tambolaRepo = locator<TambolaRepo>();
  bool isUsernameUpdated = false;
  double? picSize;
  XFile? selectedProfilePicture;
  ValueChanged<bool>? upload;
  bool _isUpdaingUserDetails = false;
  bool _isTambolaNotificationLoading = false;
  bool _isApplockLoading = false;
  bool _isFloInvoiceMailLoading = false;

  bool _hasInputError = false;
  int? _gen;
  String? gender;
  DateTime? selectedDate;
  String _dateInputError = "";
  String username = "";
  double _errorPadding = 0;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //controllers
  TextEditingController? nameController,
      dobController,
      genderController,
      emailController,
      mobileController,
      dateFieldController,
      monthFieldController,
      yearFieldController,
      usernameController;

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailOptionsFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  String? get myUserDpUrl => _userService.myUserDpUrl;

  String get myname => _userService.name ?? "";

  String get myUsername => _userService.baseUser?.username ?? "";

  String get myDob => _userService.dob ?? "";

  String get myEmail => _userService.email ?? "";

  String get myGender => _userService.gender ?? "";

  String get joinedData =>
      DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(
          _userService.baseUser!.createdOn.millisecondsSinceEpoch));

  String get myMobile => _userService.baseUser?.mobile ?? "";

  bool get isEmailVerified => _userService.isEmailVerified;

  bool get isTambolaNotificationLoading => _isTambolaNotificationLoading;

  bool get isApplockLoading => _isApplockLoading;
  bool get isFloInvoiceMailLoading => _isFloInvoiceMailLoading;

  bool get hasInputError => _hasInputError;

  get isEmailEnabled => _isEmailEnabled;

  get isContinuedWithGoogle => _isContinuedWithGoogle;

  bool get isSigningInWithGoogle => _isSigningInWithGoogle;

  bool get inEditMode => _inEditMode;

  bool get applock =>
      _userService.baseUser!.userPreferences
          .getPreference(Preferences.APPLOCK) ==
      1;

  bool get floInvoiceEmail =>
      _userService.baseUser!.userPreferences
          .getPreference(Preferences.FLOINVOICEMAIL) ==
      1;

  bool get tambolaNotification =>
      _userService.baseUser!.userPreferences
          .getPreference(Preferences.TAMBOLANOTIFICATIONS) ==
      1;

  int? get gen => _gen;

  String get dateInputError => _dateInputError;

  bool get isUpdaingUserDetails => _isUpdaingUserDetails;

  // get isNewUser => this._isNewUser;
  get isgmailFieldEnabled => _isgmailFieldEnabled;

  get errorPadding => _errorPadding;

  get isNameEnabled => _isNameEnabled;

  get isDateEnabled => _isDateEnabled;

  // Setters
  set isTambolaNotificationLoading(bool val) {
    _isTambolaNotificationLoading = val;
    notifyListeners();
  }

  set isApplockLoading(bool val) {
    _isApplockLoading = val;
    notifyListeners();
  }

  set gen(int? val) {
    _gen = val;
    notifyListeners();
  }

  set hasInputError(bool val) {
    _hasInputError = val;
    notifyListeners();
  }

  set dateInputError(String val) {
    _dateInputError = val;
    notifyListeners();
  }

  set isUpdaingUserDetails(value) {
    _isUpdaingUserDetails = value;
    notifyListeners();
  }

  set isFloInvoiceMailLoading(bool value) {
    _isFloInvoiceMailLoading = value;
    notifyListeners();
  }

  set isEmailEnabled(value) {
    _isEmailEnabled = value;
    notifyListeners();
  }

  set isContinuedWithGoogle(value) {
    _isContinuedWithGoogle = value;
    notifyListeners();
  }

  set isSigningInWithGoogle(bool val) {
    _isSigningInWithGoogle = val;
    notifyListeners();
  }

  set inEditMode(value) {
    _inEditMode = value;
    notifyListeners();
  }

  set isgmailFieldEnabled(value) {
    _isgmailFieldEnabled = value;
    notifyListeners();
  }

  set errorPadding(value) {
    _errorPadding = value.toDouble();
    notifyListeners();
  }

  set isNameEnabled(value) => _isNameEnabled = value;

  set isDateEnabled(value) => _isDateEnabled = value;

  init() {
    // isNewUser = inu;
    // if (isNewUser) enableEdit();
    nameController = TextEditingController(text: myname);
    dobController = TextEditingController(text: myDob);
    genderController = TextEditingController(text: gender);
    setDate();
    setGender();
    emailController = TextEditingController(text: myEmail);
    mobileController = TextEditingController(text: myMobile);
    if (_userService.isEmailVerified) isgmailFieldEnabled = false;
    // if (isNewUser) usernameController = TextEditingController();
    checkIfUserIsKYCVerified();
  }

  @override
  dispose() {
    nameController?.dispose();
    dobController?.dispose();
    genderController?.dispose();
    emailController?.dispose();
    mobileController?.dispose();
    usernameController?.dispose();
  }

  usernameInit() {
    _debouncer = Debouncer();
    inEditMode = true;
    usernameController = TextEditingController();
  }

  usernameDispose() {
    usernameController?.dispose();
  }

  setGender() {
    if (myGender == "M") {
      gender = _locale.obGenderMale;
      genderController = TextEditingController(text: locale.obMale);
      gen = 1;
    } else if (myGender == "F") {
      gender = _locale.obGenderFemale;
      genderController = TextEditingController(text: locale.obFemale);
      gen = 0;
    } else if (myGender == "O") {
      gender = _locale.obGenderOthers;
      genderController = TextEditingController(text: locale.obPreferNotToSay);
      gen = -1;
    }
  }

  setDate() {
    if (myDob.isNotEmpty) {
      String dob = myDob.replaceAll('/', '-');
      dateFieldController = TextEditingController(text: dob.split("-")[2]);
      monthFieldController = TextEditingController(text: dob.split("-")[1]);
      yearFieldController = TextEditingController(text: dob.split("-")[0]);
    } else {
      dateFieldController = TextEditingController(text: "");
      monthFieldController = TextEditingController(text: "");
      yearFieldController = TextEditingController(text: "");
    }
  }

  void showAndroidDatePicker() async {
    var res = await showDatePicker(
      context: AppState.delegate!.navigatorKey.currentContext!,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950, 1, 1),
      lastDate: DateTime(2004, 1, 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              onPrimary: Colors.black, // selected text color
              onSurface: Colors.white70, // default text color
              primary: UiConstants.primaryColor, // circle color
            ),
            primaryColor: UiConstants.primaryColor,
            dialogBackgroundColor: UiConstants.kBackgroundColor,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: TextStyles.rajdhaniSB.body3,
                primary: UiConstants.primaryColor, // color of button's letters
                // backgroundColor: Colors.black54, // Background color
                // shape: RoundedRectangleBorder(
                //   side: const BorderSide(
                //       color: Colors.transparent,
                //       width: 1,
                //       style: BorderStyle.solid),
                //   borderRadius: BorderRadius.circular(50),
                // ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (res != null) {
      print(res);
      selectedDate = res;
      dateFieldController!.text = res.day.toString().padLeft(2, '0');
      monthFieldController!.text = res.month.toString().padLeft(2, '0');
      yearFieldController!.text = res.year.toString();
      dobController!.text =
          "${yearFieldController!.text}-${monthFieldController!.text}-${dateFieldController!.text}";
      notifyListeners();
    }
  }

  enableEdit() {
    inEditMode = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      nameFocusNode.requestFocus();
    });
  }

  checkIfUserIsKYCVerified() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(ViewState.Busy);
      if (_bankAndKycService.isKYCVerified) {
        // nameController!.text =
        //     _userService!.baseUser!.kycName ?? _userService!.baseUser!.name!;
        isNameEnabled = false;
        if (myDob.isNotEmpty) isDateEnabled = false;
      }
      setState(ViewState.Idle);
    });
  }

  updateDetails() async {
    if (formKey.currentState!.validate() && isValidDate()) {
      if (_checkForChanges() && checkForNullData()) {
        if (checkIfAdult()) {
          isUpdaingUserDetails = true;
          if (isNameEnabled) {
            _userService.baseUser!.name = nameController!.text.trim();
          }
          if (isDateEnabled) {
            _userService.baseUser!.dob =
                "${yearFieldController!.text}-${monthFieldController!.text}-${dateFieldController!.text}";
          }
          _userService.baseUser!.gender = getGender();
          _userService.baseUser!.isEmailVerified = _userService.isEmailVerified;
          _userService.baseUser!.email = emailController!.text.trim();
          _userService.baseUser!.username =
              // isNewUser ? username : _userService!.baseUser!.username;
              await _userRepo.updateUser(
            uid: _userService.baseUser!.uid,
            dMap: {
              BaseUser.fldName: _userService.baseUser!.name!
                  .trim()
                  .replaceAll(RegExp(r"\s+\b|\b\s"), " "),
              BaseUser.fldDob: _userService.baseUser!.dob,
              BaseUser.fldGender: _userService.baseUser!.gender,
              BaseUser.fldIsEmailVerified:
                  _userService.baseUser!.isEmailVerified,
              BaseUser.fldEmail: _userService.baseUser!.email,
              BaseUser.fldAvatarId: _userService.avatarId,
              BaseUser.fldUsername: _userService.baseUser!.username
            },
          ).then((ApiResponse<bool> res) async {
            if (res.isSuccess()) {
              await _userRepo.getUserById(id: _userService.baseUser!.uid);
              await _userService.setBaseUser();
              // _userService!.setMyUserName(_userService?.baseUser?.kycName ??
              //     _userService!.baseUser!.name);
              // _userService!.setEmail(_userService!.baseUser!.email);
              // _userService!.setDateOfBirth(_userService!.baseUser!.dob);
              // _userService!.setGender(_userService!.baseUser!.gender);
              setGender();
              setDate();
              nameController!.text = _userService.name!;
              dobController!.text = _userService.baseUser!.dob!;
              isUpdaingUserDetails = false;
              inEditMode = false;
              // if (isNewUser) AppState.backButtonDispatcher!.didPopRoute();
              // isNewUser = false;
              isEmailEnabled = false;
              BaseUtil.showPositiveAlert(
                locale.updatedSuccessfully,
                locale.profileUpdated,
              );
            } else {
              isUpdaingUserDetails = false;
              BaseUtil.showNegativeAlert(
                locale.profileUpdateFailed,
                locale.tryLater,
              );
            }
          });
        } else {
          BaseUtil.showNegativeAlert(
            locale.ineligible,
            locale.above18,
          );
        }
      }
    } else {
      BaseUtil.showNegativeAlert(locale.invalidDetails, locale.checkFeilds);
    }
  }

  bool checkIfAdult() {
    if (selectedDate == null && !isDateEnabled) {
      return true;
    } else {
      return DateHelper.isAdult(selectedDate);
    }
  }

  // Future<bool> usernameIsValid() async {
  //   if (!isNewUser) return true;
  //   if (!(await (validateUsername()) ?? false)) {
  //     BaseUtil.showNegativeAlert(
  //         locale.invalidUsername, locale.anotherUserName);
  //     return false;
  //   }
  //   return (username != null &&
  //       username.isNotEmpty &&
  //       isValid != null &&
  //       isValid! &&
  //       isUsernameLoading == false);
  // }

  bool _checkForChanges() {
    // if (isNewUser) return true;
    if (myname != nameController!.text.trim() ||
        myEmail != emailController!.text.trim() ||
        isDOBChanged() ||
        isGenderChanged()) {
      return true;
    }
    inEditMode = false;
    // BaseUtil.showNegativeAlert("No changes", "please make some changes");
    return false;
  }

  bool checkForNullData() {
    if (nameController!.text.isNotEmpty &&
        emailController!.text.isNotEmpty &&
        genderController!.text.isNotEmpty &&
        dateFieldController!.text.isNotEmpty &&
        monthFieldController!.text.isNotEmpty &&
        yearFieldController!.text.isNotEmpty) return true;
    BaseUtil.showNegativeAlert(locale.feildsEmpty, locale.fillAllFeilds);
    return false;
  }

  bool isDOBChanged() {
    String newDob =
        "${yearFieldController!.text}-${monthFieldController!.text}-${dateFieldController!.text}";
    if (newDob == myDob) {
      return false;
    } else {
      return true;
    }
  }

  bool isGenderChanged() {
    if ((gen == 1 && myGender == "M") ||
        (gen == 0 && myGender == "F") ||
        (gen == -1 && myGender == "O")) {
      return false;
    } else {
      return true;
    }
  }

  getGender() {
    if (gen == 1) {
      return "M";
    } else if (gen == 0) {
      return "F";
    } else if (gen == -1) {
      return "O";
    } else {
      return "M";
    }
  }

  String setGenderField() {
    if (gen == 1) {
      return "Male";
    } else if (gen == 0) {
      return "Female";
    } else if (gen == -1) {
      return "Others";
    } else {
      return "Male";
    }
  }

  Future<void> signout() async {
    if (await BaseUtil.showNoInternetAlert()) return;
    unawaited(BaseUtil.openDialog(
      isBarrierDismissible: false,
      addToScreenStack: true,
      content: ConfirmationDialog(
          title: locale.confirm,
          description: locale.signOutAlert,
          buttonText: locale.btnYes,
          // acceptColor: UiConstants.primaryColor,
          // asset: Assets.signout,
          cancelBtnText: locale.btnNo,
          // rejectColor: UiConstants.tertiarySolid,
          // showCrossIcon: false,
          confirmAction: () {
            Haptic.vibrate();

            _userService.signOut(() async {
              _analyticsService.track(eventName: AnalyticsEvents.signOut);
              _analyticsService.signOut();
            }).then((flag) async {
              if (flag) {
                await _baseUtil.signOut();
                _marketingService.dump();
                _txnHistoryService.signOut();
                _analyticsService.signOut();
                _bankAndKycService.dump();
                _powerPlayService.dump();
                _gtService.dump();
                _tambolaRepo.dump();
                locator<JourneyRepository>().dump();
                _appstate.dump();
                locator<SubService>().dump();
                _tambolaService.dump();
                locator<LendboxMaturityService>().dump();
                AppState.backButtonDispatcher!.didPopRoute();

                AppState.delegate!.appState.currentAction = PageAction(
                    state: PageState.replaceAll, page: SplashPageConfig);
                BaseUtil.showPositiveAlert(
                  locale.signedOut,
                  locale.hopeToSeeYouSoon,
                );
              } else {
                BaseUtil.showNegativeAlert(
                  locale.signOutFailed,
                  locale.SignOutFailedSubTitle,
                );
                //log.error('Sign out process failed');
              }
            });
          },
          cancelAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
          }),
    ));
  }

  bool isValidDate() {
    if (!isDateEnabled) {
      selectedDate = null;
      return true;
    }
    dateInputError = "";
    String inputDate = yearFieldController!.text +
        monthFieldController!.text +
        dateFieldController!.text;
    print("Input date : " + inputDate);
    if (inputDate.isEmpty) {
      dateInputError = "Invalid date";
      return false;
    }
    final date = DateTime.tryParse(inputDate);
    if (date == null) {
      dateInputError = "Invalid date";
      return false;
    } else {
      final originalFormatString = BaseUtil.toOriginalFormatString(date);
      if (inputDate == originalFormatString) {
        selectedDate = date;
        return true;
      } else {
        dateInputError = "Invalid date";
        return false;
      }
    }
  }

  Future<bool> checkGalleryPermission() async {
    if (await BaseUtil.showNoInternetAlert()) return false;
    var _status = await Permission.photos.status;
    if (_status.isRestricted || _status.isLimited || _status.isDenied) {
      BaseUtil.openDialog(
        isBarrierDismissible: false,
        addToScreenStack: true,
        content: ConfirmationDialog(
          title: locale.reqPermission,
          description: locale.galleryAccess,
          buttonText: locale.btnContinue,
          asset: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Image.asset(
              "images/gallery.png",
              height: SizeConfig.screenWidth! * 0.24,
            ),
          ),
          confirmAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
            _chooseprofilePicture();
          },
          cancelAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
          },
        ),
      );
    } else if (_status.isGranted) {
      _chooseprofilePicture();
    } else {
      BaseUtil.showNegativeAlert(
        locale.permissionUnavailable,
        locale.enablePermission,
      );
      return false;
    }
    return false;
  }

  handleDPOperation() async {
    if (await BaseUtil.showNoInternetAlert()) return;
    AppState.backButtonDispatcher!.didPopRoute();
    checkGalleryPermission();

    // var _status = await Permission.photos.status;
    // if (_status.isRestricted || _status.isLimited || _status.isDenied) {
    //   BaseUtil.openDialog(
    //     isBarrierDismissable: false,
    //     addToScreenStack: true,
    //     content: ConfirmationDialog(
    //       title: "Request Permission",
    //       description:
    //           "Access to the gallery is requested. This is only required for choosing your profile picture 🤳🏼",
    //       buttonText: "Continue",
    //       asset: Padding(
    //         padding: EdgeInsets.symmetric(vertical: 8),
    //         child: Image.asset(
    //           "images/gallery.png",
    //           height: SizeConfig.screenWidth * 0.24,
    //         ),
    //       ),
    //       confirmAction: () {
    //         AppState.backButtonDispatcher.didPopRoute();
    //         _chooseprofilePicture();
    //       },
    //       cancelAction: () {
    //         AppState.backButtonDispatcher.didPopRoute();
    //       },
    //     ),
    //   );
    // } else if (_status.isGranted) {
    //   await _chooseprofilePicture();
    //   _analyticsService.track(eventName: AnalyticsEvents.updatedProfilePicture);
    // } else {
    //   BaseUtil.showNegativeAlert(
    //     'Permission Unavailable',
    //     'Please enable permission from settings to continue',
    //   );
    // }
  }

  showCustomAvatarsDialog() {
    return BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissible: false,
      hapticVibrate: true,
      content: UserAvatarSelectionDialog(
        onCustomAvatarSelection: handleDPOperation,
        onPresetAvatarSelection: updateUserAvatar,
      ),
    );
  }

  updateUserAvatar({String? avatarId}) async {
    final res = await _userRepo.updateUser(
        dMap: {BaseUser.fldAvatarId: avatarId},
        uid: _userService.baseUser!.uid);
    AppState.backButtonDispatcher!.didPopRoute();
    if (res.isSuccess() && res.model!) {
      _userService.setMyAvatarId(avatarId);

      return BaseUtil.showPositiveAlert(
          locale.updatedSuccessfully, locale.profileUpdated);
    } else {
      BaseUtil.showNegativeAlert(locale.obSomeThingWentWrong, locale.tryLater);
    }
  }

  //Model should never user Widgets in it. We should never pass context here...
  _chooseprofilePicture() async {
    selectedProfilePicture = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 45);
    if (selectedProfilePicture != null) {
      print(File(selectedProfilePicture!.path).lengthSync() / 1024);
      Haptic.vibrate();
      BaseUtil.openDialog(
        addToScreenStack: true,
        isBarrierDismissible: false,
        content: ConfirmationDialog(
          asset: NewProfileImage(
            showAction: false,
            image: ClipOval(
              child: Image.file(
                File(selectedProfilePicture!.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          buttonText: locale.btnSave,
          cancelBtnText: locale.btnDiscard,
          description: locale.profileUpdateAlert,
          confirmAction: () {
            _userService.updateProfilePicture(selectedProfilePicture).then(
                  (flag) => _postProfilePictureUpdate(flag),
                );
          },
          cancelAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
          },
          title: locale.updatePicture,
        ),
      );
      // _rootViewModel.refresh();
      notifyListeners();
    }
  }

  verifyEmail() {
    if (!isEmailVerified) {
      AppState.delegate!.appState.currentAction =
          PageAction(state: PageState.addPage, page: VerifyEmailPageConfig);
    }
  }

  _postProfilePictureUpdate(bool flag) {
    if (flag) {
      BaseAnalytics.logProfilePictureAdded();
      BaseUtil.showPositiveAlert(
        locale.btnComplete,
        locale.profileUpdated1,
      );
    } else {
      BaseUtil.showNegativeAlert(
        locale.failed,
        locale.profileUpdateFailedSubtitle,
      );
    }
    AppState.backButtonDispatcher!.didPopRoute();
  }

  Future<void> onAppLockPreferenceChanged(bool val) async {
    if (await BaseUtil.showNoInternetAlert()) return;
    isApplockLoading = true;
    _userService.baseUser!.userPreferences.setPreference(
      Preferences.APPLOCK,
      (val) ? 1 : 0,
    );
    await _userRepo.updateUser(
      uid: _userService.baseUser!.uid,
      dMap: {
        'mUserPrefsAl': val,
        'mUserPrefsTn': _userService.baseUser!.userPreferences.getPreference(
              Preferences.TAMBOLANOTIFICATIONS,
            ) ==
            1,
        'mUserPrefsEr': _userService.baseUser!.userPreferences.getPreference(
              Preferences.FLOINVOICEMAIL,
            ) ==
            1,
        'mUserPrefsTo': _userService.baseUser!.userPreferences.getPreference(
              Preferences.TAMBOLAONBOARDING,
            ) ==
            1,
      },
    ).then((value) {
      _userService.setBaseUser();
      const Log("Preferences updated");
    });
    isApplockLoading = false;
  }

  Future<void> onFloInvoiceEmailPreferenceChanged(bool val) async {
    if (await BaseUtil.showNoInternetAlert()) return;
    isFloInvoiceMailLoading = true;
    _userService.baseUser!.userPreferences.setPreference(
      Preferences.FLOINVOICEMAIL,
      val ? 1 : 0,
    );
    await _userRepo.updateUser(
      uid: _userService.baseUser!.uid,
      dMap: {
        'mUserPrefsAl': _userService.baseUser!.userPreferences.getPreference(
              Preferences.APPLOCK,
            ) ==
            1,
        'mUserPrefsTn': _userService.baseUser!.userPreferences.getPreference(
              Preferences.TAMBOLANOTIFICATIONS,
            ) ==
            1,
        'mUserPrefsEr': val,
        'mUserPrefsTo': _userService.baseUser!.userPreferences.getPreference(
              Preferences.TAMBOLAONBOARDING,
            ) ==
            1,
      },
    ).then((value) {
      _userService.setBaseUser();
      const Log("Preferences updated");
    });
    isFloInvoiceMailLoading = false;
  }

  Future<void> onTambolaNotificationPreferenceChanged(bool val) async {
    if (await BaseUtil.showNoInternetAlert()) return;
    isTambolaNotificationLoading = true;
    bool res = await fcmlistener!.toggleTambolaDrawNotificationStatus(val);
    if (res) {
      _userService.baseUser!.userPreferences
          .setPreference(Preferences.TAMBOLANOTIFICATIONS, (val) ? 1 : 0);
      await _userRepo.updateUser(
        uid: _userService.baseUser!.uid,
        dMap: {
          'mUserPrefsTn': val,
          'mUserPrefsAl': _userService.baseUser!.userPreferences.getPreference(
                Preferences.APPLOCK,
              ) ==
              1,
          'mUserPrefsEr': _userService.baseUser!.userPreferences.getPreference(
                Preferences.FLOINVOICEMAIL,
              ) ==
              1,
          'mUserPrefsTo': _userService.baseUser!.userPreferences.getPreference(
                Preferences.TAMBOLAONBOARDING,
              ) ==
              1,
        },
      ).then(
        (value) {
          if (val) {
            const Log("Preferences updated");
          } else {
            const Log("Preference update error");
          }
        },
      );
    }
    isTambolaNotificationLoading = false;
  }

  void showEmailOptions() {
    baseProvider!.isGoogleSignInProgress = false;
    emailOptionsFocusNode.unfocus();
    BaseUtil.openModalBottomSheet(
        isBarrierDismissible: true,
        backgroundColor:
            UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        content: SignInOptions(
          onEmailSignIn: continueWithEmail,
          onGoogleSignIn: handleSignInWithGoogle,
        ),
        addToScreenStack: true,
        hapticVibrate: true);
  }

  continueWithEmail() {
    isEmailEnabled = true;
    AppState.backButtonDispatcher!.didPopRoute();
    Future.delayed(const Duration(milliseconds: 200), () {
      emailFocusNode.requestFocus();
    });
  }

  void handleSignInWithGoogle() async {
    isSigningInWithGoogle = true;
    String? email = await _googleSignInService.signInWithGoogle();
    if (email != null) {
      AppState.backButtonDispatcher!.didPopRoute();
      isgmailFieldEnabled = false;
      emailController!.text = email;
      // isGoogleVerified = true;
    }
    isSigningInWithGoogle = false;
  }

  Future updateUsername() async {
    if (isUpdaingUserDetails || isUsernameLoading) return;
    if (usernameController!.text.isEmpty) {
      return BaseUtil.showNegativeAlert(
          "No username entered", "Please add a good username to continue");
    }
    if (usernameController!.text.length < 4) {
      return BaseUtil.showNegativeAlert("Username too small",
          "Please try a username with more than 3 characters");
    }
    AppState.blockNavigation();
    isUpdaingUserDetails = true;
    inEditMode = false;

    final res = await _userRepo
        .updateUser(dMap: {BaseUser.fldUsername: usernameController?.text});
    isUpdaingUserDetails = false;
    AppState.unblockNavigation();
    if (res.isSuccess()) {
      await _userService.setBaseUser();
      isUsernameUpdated = true;
      notifyListeners();
      AppState.backButtonDispatcher!.didPopRoute();
      BaseUtil.showPositiveAlert(
          locale.userNameSuccess,
          locale.userNameSuccessSubtitle(
              _userService.baseUser?.username.toString() ?? ''));
      return true;
    } else {
      inEditMode = true;
      BaseUtil.showNegativeAlert(res.errorMessage, "");
    }
  }

  Widget showResult() {
    print("Response " + response.toString());

    if (isValid == null || isUsernameUpdated) {
      return const SizedBox();
    }
    if (isUsernameLoading) {
      return Row(
        children: [
          Container(
            height: SizeConfig.padding16,
            width: SizeConfig.padding16,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ],
      );
    } else if (response == UsernameResponse.EMPTY) {
      return Text(
        locale.userNameEmptyAlert,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
      );
    } else if (response == UsernameResponse.UNAVAILABLE) {
      return Text(
        "@${usernameController!.text.trim()} " + locale.isNotAvailable,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (response == UsernameResponse.AVAILABLE) {
      return Text(
        "@${usernameController!.text.trim()} " + locale.isAvailable,
        style: const TextStyle(
          color: UiConstants.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (response == UsernameResponse.INVALID) {
      if (usernameController!.text.trim().length < 4) {
        return Text(
          locale.userNameVal1,
          maxLines: 2,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        );
      } else if (usernameController!.text.trim().length > 20) {
        return Text(
          locale.userNameVal2,
          maxLines: 2,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        );
      } else {
        return Text(
          "@${usernameController!.text.trim()}" + locale.isValid,
          maxLines: 2,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        );
      }
    }

    return SizedBox(
      height: SizeConfig.padding16,
    );
  }

  checkIfUsernameIsAvailable() {
    log.debug("username check called");
    _debouncer!.call(validateUsername);
  }

  Future<bool?>? validateUsername() async {
    // if (isUsernameLoading) return false;
    isUsernameLoading = true;
    notifyListeners();
    if (usernameController!.text.isEmpty) {
      errorPadding = 0;
      isValid = null;
      response = UsernameResponse.EMPTY;
      isUsernameLoading = false;
      notifyListeners();
      return isValid;
    }
    username = usernameController!.text.trim();
    if (username == "") {
      errorPadding = 0;
      isValid = null;
      response = UsernameResponse.EMPTY;
    } else {
      errorPadding = SizeConfig.padding8;

      if (usernameRegex.hasMatch(username)) {
        bool res = false;
        final apiResponse = await _userRepo.isUsernameAvailable(username);
        if (apiResponse.isSuccess()) res = apiResponse.model ?? false;
        // dbProvider!.checkIfUsernameIsAvailable(username.replaceAll('.', '@'));
        isValid = res;
        if (res) {
          response = UsernameResponse.AVAILABLE;
        } else {
          response = UsernameResponse.UNAVAILABLE;
        }
      } else {
        isValid = false;
        response = UsernameResponse.INVALID;
      }
    }

    isUsernameLoading = false;
    notifyListeners();
    return isValid;
  }

  navigateToKycScreen() {
    Haptic.vibrate();
    _analyticsService.track(eventName: AnalyticsEvents.kycDetailsTapped);
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.replace,
      page: KycDetailsPageConfig,
    );
  }

  navigateToBankDetailsScreen() {
    _analyticsService.track(eventName: AnalyticsEvents.bankDetailsTapped);

    Haptic.vibrate();
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.replace,
      page: BankDetailsPageConfig,
    );
  }
}
