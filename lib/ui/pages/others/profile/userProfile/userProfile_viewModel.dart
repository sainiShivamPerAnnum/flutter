//Project Imports
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/change_profile_picture_dialog.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/mixpanel_events.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
//Flutter & Dart Imports
import 'package:flutter/material.dart';
//Pub Imports
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UserProfileVM extends BaseModel {
  Log log = new Log('User Profile');
  bool inEditMode = false;
  final _userService = locator<UserService>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final DBModel _dbModel = locator<DBModel>();
  final fcmlistener = locator<FcmListener>();
  final _txnService = locator<TransactionService>();
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  final S _locale = locator<S>();
  double picSize;
  XFile selectedProfilePicture;
  ValueChanged<bool> upload;
  bool isUpdaingUserDetails = false;
  bool _isTambolaNotificationLoading = false;
  int gen;
  String gender;
  DateTime selectedDate;
  String dateInputError = "";

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String get myUserDpUrl => _userService.myUserDpUrl;
  String get myname => _userService.baseUser.name ?? "";
  String get myUsername => _userService.baseUser.username ?? "";
  String get myDob => _userService.baseUser.dob ?? "";
  String get myEmail => _userService.baseUser.email ?? "";
  String get myGender => _userService.baseUser.gender ?? "";
  String get myMobile => _userService.baseUser.mobile ?? "";
  bool get isEmailVerified => _userService.baseUser.isEmailVerified;
  bool get isTambolaNotificationLoading => _isTambolaNotificationLoading;

  bool get applock =>
      _userService.baseUser.userPreferences
          .getPreference(Preferences.APPLOCK) ==
      1;
  bool get tambolaNotification =>
      _userService.baseUser.userPreferences
          .getPreference(Preferences.TAMBOLANOTIFICATIONS) ==
      1;

  // Setters
  set isTambolaNotificationLoading(bool val) {
    _isTambolaNotificationLoading = val;
    notifyListeners();
  }

  //controllers
  TextEditingController nameController,
      dobController,
      genderController,
      emailController,
      mobileController,
      dateFieldController,
      monthFieldController,
      yearFieldController;

  init() {
    nameController = new TextEditingController(text: myname);
    dobController = new TextEditingController(text: myDob);
    genderController = new TextEditingController();
    setDate();
    setGender();
    emailController = new TextEditingController(text: myEmail);
    mobileController = new TextEditingController(text: myMobile);
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
      dateFieldController =
          new TextEditingController(text: myDob.split("-")[2]);
      monthFieldController =
          new TextEditingController(text: myDob.split("-")[1]);
      yearFieldController =
          new TextEditingController(text: myDob.split("-")[0]);
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
    );
    if (res != null) print(res);
    selectedDate = res;
    dateFieldController.text = res.day.toString().padLeft(2, '0');
    monthFieldController.text = res.month.toString().padLeft(2, '0');
    yearFieldController.text = res.year.toString();
    notifyListeners();
  }

  enableEdit() {
    inEditMode = true;
    notifyListeners();
  }

  updateDetails() async {
    if (formKey.currentState.validate() && isValidDate()) {
      if (_checkForChanges()) {
        if (_isAdult(selectedDate)) {
          isUpdaingUserDetails = true;
          notifyListeners();
          _userService.baseUser.name = nameController.text.trim();
          _userService.baseUser.dob =
              "${yearFieldController.text}-${monthFieldController.text}-${dateFieldController.text}";
          _userService.baseUser.gender = getGender();
          await _dbModel.updateUser(_userService.baseUser).then((res) {
            if (res) {
              _userService.setMyUserName(_userService.baseUser.name);
              _userService.setDateOfBirth(_userService.baseUser.dob);
              _userService.setGender(_userService.baseUser.gender);
              genderController.text = setGender();
              dobController.text = _userService.baseUser.dob;
              isUpdaingUserDetails = false;
              inEditMode = false;
              notifyListeners();
              BaseUtil.showPositiveAlert(
                  "Updated Successfully", "Profile updated successfully");
            } else {
              isUpdaingUserDetails = false;
              notifyListeners();
              BaseUtil.showNegativeAlert(
                  "Ahh Snap", "Please try again in some time");
            }
          });
        } else {
          BaseUtil.showNegativeAlert(
            'Ineligible',
            'You need to be above 18 to join',
          );
        }
      } else
        BaseUtil.showNegativeAlert(
            "No changes found", "please make some changes");
    } else
      BaseUtil.showNegativeAlert(
          "Invalid details", "please check the fields again");
  }

  bool _checkForChanges() {
    if (myname != nameController.text.trim() ||
        isDOBChanged() ||
        isGenderChanged()) return true;
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
    else if (gen == -1) return "O";
  }

  bool _isAdult(DateTime dt) {
    // Current time - at this moment
    DateTime today = DateTime.now();
    // Date to check but moved 18 years ahead
    DateTime adultDate = DateTime(
      dt.year + 18,
      dt.month,
      dt.day,
    );

    return adultDate.isBefore(today);
  }
  // showUnsavedChanges() {
  //   if (_checkForChanges()) {
  //     AppState.unsavedChanges = true;
  //     BaseUtil.openDialog(
  //         addToScreenStack: true,
  //         isBarrierDismissable: false,
  //         content: ConfirmActionDialog(
  //             title: "You have unsaved changes",
  //             description:
  //                 "Are you sure want to exit. All changes will be discarded",
  //             buttonText: "Yes",
  //             confirmAction: () {
  //               AppState.backButtonDispatcher.didPopRoute();
  //             },
  //             cancelAction: () {}));
  //   }
  // }

  signout() async {
    if (await BaseUtil.showNoInternetAlert()) return;
    BaseUtil.openDialog(
      isBarrierDismissable: false,
      addToScreenStack: true,
      content: WillPopScope(
        onWillPop: () {
          AppState.backButtonDispatcher.didPopRoute();
          return Future.value(true);
        },
        child: ConfirmActionDialog(
          title: 'Confirm',
          description: 'Are you sure you want to sign out?',
          buttonText: 'Yes',
          confirmAction: () {
            Haptic.vibrate();

            _mixpanelService.track(
                MixpanelEvents.signOut, {'userId': _userService.baseUser.uid});
            _mixpanelService.signOut();

            _userService.signout().then((flag) {
              if (flag) {
                //log.debug('Sign out process complete');
                _txnService.signOut();
                AppState.delegate.appState.currentAction = PageAction(
                    state: PageState.replaceAll, page: SplashPageConfig);
                BaseUtil.showPositiveAlert(
                  'Signed out',
                  'Hope to see you soon',
                );
              } else {
                BaseUtil.showNegativeAlert(
                    'Sign out failed', 'Couldn\'t signout. Please try again');
                //log.error('Sign out process failed');
              }
            });
          },
          cancelAction: () {},
        ),
      ),
    );
  }

  bool isValidDate() {
    dateInputError = "";
    notifyListeners();
    String inputDate = yearFieldController.text +
        monthFieldController.text +
        dateFieldController.text;
    print("Input date : " + inputDate);
    if (inputDate == null || inputDate.isEmpty) {
      dateInputError = "Invalid date";
      notifyListeners();
      return false;
    }
    final date = DateTime.tryParse(inputDate);
    if (date == null) {
      dateInputError = "Invalid date";
      notifyListeners();
      return false;
    } else {
      final originalFormatString = toOriginalFormatString(date);
      if (inputDate == originalFormatString) {
        selectedDate = date;
        return true;
      } else {
        dateInputError = "Invalid date";
        notifyListeners();
        return false;
      }
    }
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  handleDPOperation() async {
    BuildContext context;
    if (await BaseUtil.showNoInternetAlert()) return;
    var _status = await Permission.photos.status;
    if (_status.isRestricted || _status.isLimited || _status.isDenied) {
      BaseUtil.openDialog(
          isBarrierDismissable: false,
          addToScreenStack: true,
          content: ConfirmActionDialog(
              title: "Request Permission",
              description:
                  "Access to the gallery is requested. This is only required for choosing your profile picture 🤳🏼",
              buttonText: "Continue",
              asset: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Image.asset("images/gallery.png",
                    height: SizeConfig.screenWidth * 0.24),
              ),
              confirmAction: () {
                _chooseprofilePicture();
              },
              cancelAction: () {}));
    } else if (_status.isGranted) {
      await _chooseprofilePicture();
      _mixpanelService.track(MixpanelEvents.updatedProfilePicture,
          {'userId': _userService.baseUser.uid});
    } else {
      BaseUtil.showNegativeAlert('Permission Unavailable',
          'Please enable permission from settings to continue');
    }
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
        content: ChangeProfilePicture(
          image: File(selectedProfilePicture.path),
          upload: (value) {
            if (value)
              _updateProfilePicture()
                  .then((flag) => _postProfilePictureUpdate(flag));
          },
        ),
      );
      // _rootViewModel.refresh();
      notifyListeners();
    }
  }

  Future<bool> _updateProfilePicture() async {
    Directory supportDir;
    UploadTask uploadTask;
    try {
      supportDir = await getApplicationSupportDirectory();
    } catch (e1) {
      log.error('Support Directory not found');
      log.error('$e1');
      return false;
    }

    String imageName = selectedProfilePicture.path.split("/").last;
    String targetPath = "${supportDir.path}/c-$imageName";
    print("temp path: " + targetPath);
    print("orignal path: " + selectedProfilePicture.path);

    File compressedFile = File(selectedProfilePicture.path);

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child("dps/${_userService.baseUser.uid}/image");
      uploadTask = ref.putFile(compressedFile);
    } catch (e2) {
      log.error('putFile Failed. Reference Error');
      log.error('$e2');
      return false;
    }

    try {
      TaskSnapshot res = await uploadTask;
      String url = await res.ref.getDownloadURL();
      if (url != null) {
        await CacheManager.writeCache(
            key: 'dpUrl', value: url, type: CacheType.string);
        _userService.setMyUserDpUrl(url);
        //_baseUtil.setDisplayPictureUrl(url);
        log.debug('Final DP Uri: $url');
        return true;
      } else
        return false;
    } catch (e) {
      if (_baseUtil.myUser.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Method call to upload picture failed',
        };
        _dbModel.logFailure(_baseUtil.myUser.uid,
            FailType.ProfilePictureUpdateFailed, errorDetails);
      }
      print('$e');
      return false;
    }
  }

  _postProfilePictureUpdate(bool flag) {
    if (flag) {
      BaseAnalytics.logProfilePictureAdded();
      BaseUtil.showPositiveAlert(
          'Complete', 'Your profile Picture has been updated');
    } else {
      BaseUtil.showNegativeAlert(
        'Failed',
        'Your Profile Picture could not be updated at the moment',
      );
    }
    //upload(false);
    AppState.backButtonDispatcher.didPopRoute();
  }

  onAppLockPreferenceChanged(val) async {
    if (await BaseUtil.showNoInternetAlert()) return;
    _userService.baseUser.userPreferences
        .setPreference(Preferences.APPLOCK, (val) ? 1 : 0);
    AppState.unsavedPrefs = true;
    notifyListeners();
  }

  onTambolaNotificationPreferenceChanged(val) async {
    if (await BaseUtil.showNoInternetAlert()) return;
    isTambolaNotificationLoading = true;
    bool res = await fcmlistener.toggleTambolaDrawNotificationStatus(val);
    if (res) {
      _userService.baseUser.userPreferences
          .setPreference(Preferences.TAMBOLANOTIFICATIONS, (val) ? 1 : 0);
      AppState.unsavedPrefs = true;
    }
    isTambolaNotificationLoading = false;
  }
}
