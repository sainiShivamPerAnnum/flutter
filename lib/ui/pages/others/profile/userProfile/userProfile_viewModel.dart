//Project Imports
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/username_response_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/google_sign_in_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/dialogs/user_avatars_dialog.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/components/sign_in_options.dart';
import 'package:felloapp/ui/pages/static/profile_image.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/date_helper.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
//Flutter & Dart Imports
import 'package:flutter/material.dart';
//Pub Imports
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/repository/user_repo.dart';

class UserProfileVM extends BaseViewModel {
  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final usernameRegex = RegExp(r"^(?!\.)(?!.*\.$)(?!.*?\.\.)[a-z0-9.]{4,20}$");
  UsernameResponse response;

  Log log = new Log('User Profile');
  bool _inEditMode = false;
  bool _isgmailFieldEnabled = true;
  bool _isNewUser = false;
  bool _isEmailEnabled = false;
  bool _isContinuedWithGoogle = false;
  bool _isSigningInWithGoogle = false;
  bool _isNameEnabled = true;

  bool isUsernameLoading = false;
  bool isValid = false;

  final _userRepo = locator<UserRepository>();
  final _userService = locator<UserService>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final fcmlistener = locator<FcmListener>();
  final _txnHistoryService = locator<TransactionHistoryService>();
  final _tambolaService = locator<TambolaService>();
  final _analyticsService = locator<AnalyticsService>();
  final _paytmService = locator<PaytmService>();
  final S _locale = locator<S>();
  final BaseUtil baseProvider = locator<BaseUtil>();
  final _internalOpsService = locator<InternalOpsService>();
  final _journeyService = locator<JourneyService>();
  final _googleSignInService = locator<GoogleSignInService>();
  final _bankAndKycService = locator<BankAndPanService>();
  final dbProvider = locator<DBModel>();

  double picSize;
  XFile selectedProfilePicture;
  ValueChanged<bool> upload;
  bool _isUpdaingUserDetails = false;
  bool _isTambolaNotificationLoading = false;
  bool _isApplockLoading = false;
  bool _hasInputError = false;
  int _gen;
  String gender;
  DateTime selectedDate;
  String _dateInputError = "";
  String username = "";
  double _errorPadding = 0;

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  //controllers
  TextEditingController nameController,
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

  String get myUserDpUrl => _userService.myUserDpUrl;
  String get myname => _userService.myUserName ?? "";
  String get myUsername => _userService.baseUser.username ?? "";
  String get myDob => _userService.dob ?? "";
  String get myEmail => _userService.email ?? "";
  String get myGender => _userService.gender ?? "";
  String get myMobile => _userService.baseUser.mobile ?? "";
  bool get isEmailVerified => _userService.isEmailVerified;
  bool get isSimpleKycVerified => _userService.isSimpleKycVerified;
  bool get isTambolaNotificationLoading => _isTambolaNotificationLoading;
  bool get isApplockLoading => _isApplockLoading;
  bool get hasInputError => _hasInputError;
  get isEmailEnabled => this._isEmailEnabled;
  get isContinuedWithGoogle => this._isContinuedWithGoogle;
  bool get isSigningInWithGoogle => _isSigningInWithGoogle;
  bool get inEditMode => this._inEditMode;

  bool get applock =>
      _userService.baseUser.userPreferences
          .getPreference(Preferences.APPLOCK) ==
      1;
  bool get tambolaNotification =>
      _userService.baseUser.userPreferences
          .getPreference(Preferences.TAMBOLANOTIFICATIONS) ==
      1;
  int get gen => _gen;

  String get dateInputError => _dateInputError;
  bool get isUpdaingUserDetails => this._isUpdaingUserDetails;
  get isNewUser => this._isNewUser;
  get isgmailFieldEnabled => this._isgmailFieldEnabled;
  get errorPadding => this._errorPadding;
  get isNameEnabled => this._isNameEnabled;

  // Setters
  set isTambolaNotificationLoading(bool val) {
    _isTambolaNotificationLoading = val;
    notifyListeners();
  }

  set isApplockLoading(bool val) {
    _isApplockLoading = val;
    notifyListeners();
  }

  set gen(int val) {
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
    this._isUpdaingUserDetails = value;
    notifyListeners();
  }

  set isNewUser(value) {
    this._isNewUser = value;

    notifyListeners();
  }

  set isEmailEnabled(value) {
    this._isEmailEnabled = value;
    notifyListeners();
  }

  set isContinuedWithGoogle(value) {
    this._isContinuedWithGoogle = value;
    notifyListeners();
  }

  set isSigningInWithGoogle(bool val) {
    _isSigningInWithGoogle = val;
    notifyListeners();
  }

  set inEditMode(value) {
    this._inEditMode = value;
    notifyListeners();
  }

  set isgmailFieldEnabled(value) {
    this._isgmailFieldEnabled = value;
    notifyListeners();
  }

  set errorPadding(value) {
    this._errorPadding = value;
    notifyListeners();
  }

  set isNameEnabled(value) {
    this._isNameEnabled = value;
  }

  init(bool inu) {
    isNewUser = inu;
    if (isNewUser) enableEdit();
    nameController = new TextEditingController(text: myname);
    dobController = new TextEditingController(text: myDob);
    genderController = new TextEditingController(text: gender);
    setDate();
    setGender();
    emailController = new TextEditingController(text: myEmail);
    mobileController = new TextEditingController(text: myMobile);
    if (_userService.isEmailVerified) isgmailFieldEnabled = false;
    if (isNewUser) usernameController = TextEditingController();
    checkIfUserIsKYCVerified();
  }

  setGender() {
    if (myGender == "M") {
      gender = _locale.obGenderMale;
      genderController = new TextEditingController(text: "Male");
      gen = 1;
    } else if (myGender == "F") {
      gender = _locale.obGenderFemale;
      genderController = new TextEditingController(text: "Female");
      gen = 0;
    } else if (myGender == "O") {
      gender = _locale.obGenderOthers;
      genderController = new TextEditingController(text: "Rather Not Say");
      gen = -1;
    }
  }

  setDate() {
    if (myDob != null && myDob.isNotEmpty) {
      String dob = myDob.replaceAll('/', '-');
      dateFieldController = new TextEditingController(text: dob.split("-")[2]);
      monthFieldController = new TextEditingController(text: dob.split("-")[1]);
      yearFieldController = new TextEditingController(text: dob.split("-")[0]);
    } else {
      dateFieldController = new TextEditingController(text: "");
      monthFieldController = new TextEditingController(text: "");
      yearFieldController = new TextEditingController(text: "");
    }
  }

  void showAndroidDatePicker() async {
    var res = await showDatePicker(
      context: AppState.delegate.navigatorKey.currentContext,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950, 1, 1),
      lastDate: DateTime(2002, 1, 1),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
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
          child: child,
        );
      },
    );
    if (res != null) print(res);
    selectedDate = res;
    dateFieldController.text = res.day.toString().padLeft(2, '0');
    monthFieldController.text = res.month.toString().padLeft(2, '0');
    yearFieldController.text = res.year.toString();
    dobController.text =
        "${yearFieldController.text}-${monthFieldController.text}-${dateFieldController.text}";
    notifyListeners();
  }

  enableEdit() {
    inEditMode = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 1), () {
      nameFocusNode.requestFocus();
    });
  }

  checkIfUserIsKYCVerified() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(ViewState.Busy);
      if (_bankAndKycService.isKYCVerified) {
        nameController.text =
            _userService.baseUser.kycName ?? _userService.baseUser.name;
        isNameEnabled = false;
      }
      setState(ViewState.Idle);
    });
  }

  updateDetails() async {
    if (isNewUser) {
      if (!await validateUsername()) {
        return BaseUtil.showNegativeAlert(
            "Username invalid", "please try another username");
      }
    }
    if (formKey.currentState.validate() && isValidDate() && usernameIsValid()) {
      if (_checkForChanges() && checkForNullData()) {
        if (DateHelper.isAdult(selectedDate)) {
          isUpdaingUserDetails = true;
          _userService.baseUser.name = nameController.text.trim();
          _userService.baseUser.dob =
              "${yearFieldController.text}-${monthFieldController.text}-${dateFieldController.text}";
          _userService.baseUser.gender = getGender();
          _userService.baseUser.isEmailVerified = _userService.isEmailVerified;
          _userService.baseUser.email = emailController.text.trim();
          _userService.baseUser.username =
              isNewUser ? username : _userService.baseUser.username;
          await _userRepo.updateUser(
            uid: _userService.baseUser.uid,
            dMap: {
              BaseUser.fldName: _userService.baseUser.name,
              BaseUser.fldDob: _userService.baseUser.dob,
              BaseUser.fldGender: _userService.baseUser.gender,
              BaseUser.fldIsEmailVerified:
                  _userService.baseUser.isEmailVerified,
              BaseUser.fldEmail: _userService.baseUser.email,
              BaseUser.fldAvatarId: "AV1",
              BaseUser.fldUsername: _userService.baseUser.username
            },
          ).then((ApiResponse<bool> res) async {
            if (res.isSuccess()) {
              await _userRepo.getUserById(id: _userService.baseUser.uid);
              _userService.setMyUserName(_userService?.baseUser?.kycName ??
                  _userService.baseUser.name);
              _userService.setEmail(_userService.baseUser.email);
              _userService.setDateOfBirth(_userService.baseUser.dob);
              _userService.setGender(_userService.baseUser.gender);
              genderController.text = setGender();
              dobController.text = _userService.baseUser.dob;
              isUpdaingUserDetails = false;
              inEditMode = false;
              if (isNewUser) AppState.backButtonDispatcher.didPopRoute();
              isNewUser = false;
              isEmailEnabled = false;
              BaseUtil.showPositiveAlert(
                "Updated Successfully",
                "Profile updated successfully",
              );
            } else {
              isUpdaingUserDetails = false;
              BaseUtil.showNegativeAlert(
                "Profile Update failed",
                "Please try again in some time",
              );
            }
          });
        } else {
          BaseUtil.showNegativeAlert(
            'Ineligible',
            'You need to be above 18 to join',
          );
        }
      }
    } else
      BaseUtil.showNegativeAlert(
          "Invalid details", "please check the fields again");
  }

  bool usernameIsValid() {
    if (!isNewUser) return true;
    return (username != null &&
        username.isNotEmpty &&
        isValid != null &&
        isValid &&
        isUsernameLoading == false);
  }

  bool _checkForChanges() {
    if (isNewUser) return true;
    if (myname != nameController.text.trim() ||
        myEmail != emailController.text.trim() ||
        isDOBChanged() ||
        isGenderChanged()) return true;
    if (!isNewUser) inEditMode = false;
    BaseUtil.showNegativeAlert("No changes", "please make some changes");
    return false;
  }

  bool checkForNullData() {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        genderController.text.isNotEmpty &&
        dateFieldController.text.isNotEmpty &&
        monthFieldController.text.isNotEmpty &&
        yearFieldController.text.isNotEmpty) return true;
    BaseUtil.showNegativeAlert("Empty fields", "please fill all fields");
    return false;
  }

  bool isDOBChanged() {
    String newDob =
        "${yearFieldController.text}-${monthFieldController.text}-${dateFieldController.text}";
    if (newDob == myDob)
      return false;
    else
      return true;
  }

  bool isGenderChanged() {
    if ((gen == 1 && myGender == "M") ||
        (gen == 0 && myGender == "F") ||
        (gen == -1 && myGender == "O"))
      return false;
    else
      return true;
  }

  getGender() {
    if (gen == 1)
      return "M";
    else if (gen == 0)
      return "F";
    else if (gen == -1)
      return "O";
    else
      return "M";
  }

  setGenderField() {
    if (gen == 1)
      return "Male";
    else if (gen == 0)
      return "Female";
    else if (gen == -1)
      return "Others";
    else
      return "Male";
  }

  signout() async {
    if (await BaseUtil.showNoInternetAlert()) return;
    BaseUtil.openDialog(
      isBarrierDismissable: false,
      addToScreenStack: true,
      content: ConfirmationDialog(
          title: 'Confirm',
          description: 'Are you sure you want to sign out?',
          buttonText: 'Yes',
          // acceptColor: UiConstants.primaryColor,
          // asset: Assets.signout,
          cancelBtnText: "No",
          // rejectColor: UiConstants.tertiarySolid,
          // showCrossIcon: false,
          confirmAction: () {
            Haptic.vibrate();

            _userService.signOut(() async {
              _analyticsService.track(eventName: AnalyticsEvents.signOut);
              _analyticsService.signOut();
              await _userRepo.removeUserFCM(_userService.baseUser.uid);
            }).then((flag) async {
              if (flag) {
                //log.debug('Sign out process complete');
                await _baseUtil.signOut();
                _journeyService.dump();
                _txnHistoryService.signOut();
                _tambolaService.signOut();
                _analyticsService.signOut();
                _paytmService.signout();
                _bankAndKycService.dump();
                AppState.backButtonDispatcher.didPopRoute();
                AppState.delegate.appState.currentAction = PageAction(
                    state: PageState.replaceAll, page: SplashPageConfig);
                BaseUtil.showPositiveAlert(
                  'Signed out',
                  'Hope to see you soon',
                );
              } else {
                BaseUtil.showNegativeAlert(
                  'Sign out failed',
                  'Couldn\'t signout. Please try again',
                );
                //log.error('Sign out process failed');
              }
            });
          },
          cancelAction: () {
            AppState.backButtonDispatcher.didPopRoute();
          }),
    );
  }

  bool isValidDate() {
    dateInputError = "";
    String inputDate = yearFieldController.text +
        monthFieldController.text +
        dateFieldController.text;
    print("Input date : " + inputDate);
    if (inputDate == null || inputDate.isEmpty) {
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
        isBarrierDismissable: false,
        addToScreenStack: true,
        content: ConfirmationDialog(
          title: "Request Permission",
          description:
              "Access to the gallery is requested. This is only required for choosing your profile picture 🤳🏼",
          buttonText: "Continue",
          asset: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Image.asset(
              "images/gallery.png",
              height: SizeConfig.screenWidth * 0.24,
            ),
          ),
          confirmAction: () {
            AppState.backButtonDispatcher.didPopRoute();
            _chooseprofilePicture();
          },
          cancelAction: () {
            AppState.backButtonDispatcher.didPopRoute();
          },
        ),
      );
    } else if (_status.isGranted) {
      _chooseprofilePicture();
    } else {
      BaseUtil.showNegativeAlert(
        'Permission Unavailable',
        'Please enable permission from settings to continue',
      );
      return false;
    }
    return false;
  }

  handleDPOperation() async {
    if (await BaseUtil.showNoInternetAlert()) return;
    AppState.backButtonDispatcher.didPopRoute();
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
      isBarrierDismissable: false,
      hapticVibrate: true,
      content: UserAvatarSelectionDialog(
        onCustomAvatarSelection: handleDPOperation,
        onPresetAvatarSelection: updateUserAvatar,
      ),
    );
  }

  updateUserAvatar({String avatarId}) async {
    final res = await _userRepo.updateUser(
        dMap: {BaseUser.fldAvatarId: avatarId}, uid: _userService.baseUser.uid);
    AppState.backButtonDispatcher.didPopRoute();
    if (res.isSuccess() && res.model) {
      _userService.setMyAvatarId(avatarId);

      return BaseUtil.showPositiveAlert(
          "Update Successful", "Profile picture updated successfully");
    } else
      BaseUtil.showNegativeAlert(
          "Something went wrong!", "Please try again in sometime");
  }

  //Model should never user Widgets in it. We should never pass context here...
  _chooseprofilePicture() async {
    selectedProfilePicture = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 45);
    if (selectedProfilePicture != null) {
      print(File(selectedProfilePicture.path).lengthSync() / 1024);
      Haptic.vibrate();
      await BaseUtil.openDialog(
        addToScreenStack: true,
        isBarrierDismissable: false,
        content: ConfirmationDialog(
          asset: NewProfileImage(
            showAction: false,
            isNewUser: isNewUser,
            image: ClipOval(
              child: Image.file(
                File(selectedProfilePicture.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          buttonText: 'Save',
          cancelBtnText: 'Discard',
          description: 'Are you sure you want to update your profile picture',
          confirmAction: () {
            _userService.updateProfilePicture(selectedProfilePicture).then(
                  (flag) => _postProfilePictureUpdate(flag),
                );
          },
          cancelAction: () {
            AppState.backButtonDispatcher.didPopRoute();
          },
          title: 'Update Picture',
        ),
      );
      // _rootViewModel.refresh();
      notifyListeners();
    }
  }

  verifyEmail() {
    if (!isEmailVerified)
      AppState.delegate.appState.currentAction =
          PageAction(state: PageState.addPage, page: VerifyEmailPageConfig);
  }

  _postProfilePictureUpdate(bool flag) {
    if (flag) {
      BaseAnalytics.logProfilePictureAdded();
      BaseUtil.showPositiveAlert(
        'Complete',
        'Your profile picture has been updated',
      );
    } else {
      BaseUtil.showNegativeAlert(
        'Failed',
        'Your Profile Picture could not be updated at the moment',
      );
    }
    AppState.backButtonDispatcher.didPopRoute();
  }

  onAppLockPreferenceChanged(val) async {
    if (await BaseUtil.showNoInternetAlert()) return;
    isApplockLoading = true;
    _userService.baseUser.userPreferences.setPreference(
      Preferences.APPLOCK,
      (val) ? 1 : 0,
    );
    await _userRepo.updateUser(
      uid: _userService.baseUser.uid,
      dMap: {
        'mUserPrefsAl': val,
        'mUserPrefsTn': _userService.baseUser.userPreferences.getPreference(
              Preferences.TAMBOLANOTIFICATIONS,
            ) ==
            1,
      },
    ).then((value) {
      _userService.setBaseUser();
      Log("Preferences updated");
    });
    isApplockLoading = false;
  }

  onTambolaNotificationPreferenceChanged(val) async {
    if (await BaseUtil.showNoInternetAlert()) return;
    isTambolaNotificationLoading = true;
    bool res = await fcmlistener.toggleTambolaDrawNotificationStatus(val);
    if (res) {
      _userService.baseUser.userPreferences
          .setPreference(Preferences.TAMBOLANOTIFICATIONS, (val) ? 1 : 0);
      await _userRepo.updateUser(
        uid: _userService.baseUser.uid,
        dMap: {
          'mUserPrefsTn': val,
          'mUserPrefsAl': _userService.baseUser.userPreferences.getPreference(
                Preferences.APPLOCK,
              ) ==
              1,
        },
      ).then(
        (value) {
          if (val)
            Log("Preferences updated");
          else
            Log("Preference update error");
        },
      );
    }
    isTambolaNotificationLoading = false;
  }

  showEmailOptions() {
    baseProvider.isGoogleSignInProgress = false;
    emailOptionsFocusNode.unfocus();
    BaseUtil.openModalBottomSheet(
        isBarrierDismissable: true,
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
    AppState.backButtonDispatcher.didPopRoute();
    Future.delayed(Duration(milliseconds: 200), () {
      emailFocusNode.requestFocus();
    });
  }

  void handleSignInWithGoogle() async {
    isSigningInWithGoogle = true;
    String email = await _googleSignInService.signInWithGoogle();
    if (email != null) {
      isgmailFieldEnabled = false;
      emailController.text = email;
      // isGoogleVerified = true;
    }
    isSigningInWithGoogle = false;
  }

  Widget showResult() {
    print("Response " + response.toString());
    if (isValid == null) {
      return SizedBox();
    }
    if (isUsernameLoading) {
      return Container(
        height: SizeConfig.padding16,
        width: SizeConfig.padding16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else if (response == UsernameResponse.EMPTY)
      return Text(
        "username cannot be empty",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
      );
    else if (response == UsernameResponse.UNAVAILABLE)
      return Text(
        "@${usernameController.text.trim()} is not available",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      );
    else if (response == UsernameResponse.AVAILABLE) {
      return Text(
        "@${usernameController.text.trim()} is available",
        style: TextStyle(
          color: UiConstants.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (response == UsernameResponse.INVALID) {
      if (usernameController.text.trim().length < 4)
        return Text(
          "please enter a username with more than 3 characters.",
          maxLines: 2,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        );
      else if (usernameController.text.trim().length > 20)
        return Text(
          "please enter a username with less than 20 characters.",
          maxLines: 2,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        );
      else
        return Text(
          "@${usernameController.text.trim()} is invalid",
          maxLines: 2,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        );
    }

    return SizedBox(
      height: SizeConfig.padding16,
    );
  }

  Future<bool> validateUsername() async {
    // if (isUsernameLoading) return false;
    isUsernameLoading = true;
    notifyListeners();
    if (usernameController.text == null || usernameController.text.isEmpty) {
      errorPadding = 0;
      isValid = null;
      response = UsernameResponse.EMPTY;
      isUsernameLoading = false;
      notifyListeners();
      return isValid;
    }
    username = usernameController.text?.trim();
    if (username == null || username == "") {
      errorPadding = 0;
      isValid = null;
      response = UsernameResponse.EMPTY;
    } else {
      errorPadding = SizeConfig.padding8;

      if (usernameRegex.hasMatch(username)) {
        bool res = await dbProvider
            .checkIfUsernameIsAvailable(username.replaceAll('.', '@'));

        isValid = res;
        if (res)
          response = UsernameResponse.AVAILABLE;
        else
          response = UsernameResponse.UNAVAILABLE;
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
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: KycDetailsPageConfig,
    );
  }

  navigateToBankDetailsScreen() {
    Haptic.vibrate();
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: BankDetailsPageConfig,
    );
  }
}
