//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/change_profile_picture_dialog.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/modals_sheets/simple_kyc_modal_sheet.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

//Flutter & Dart Imports
import 'package:flutter/material.dart';
import 'dart:io';

//Pub Imports
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UserProfileViewModel extends BaseModel {
  Log log = new Log('User Profile');
  bool inEditMode = false;
  final _userService = locator<UserService>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final DBModel _dbModel = locator<DBModel>();
  double picSize;
  XFile selectedProfilePicture;
  ValueChanged<bool> upload;
  bool isUpdaingUserDetails = false;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  get myUserDpUrl => _userService.myUserDpUrl;
  get myname => _userService.baseUser.name;
  get myUsername => _userService.baseUser.username;
  get myAge => _userService.baseUser.dob;
  get myEmail => _userService.baseUser.email;
  get myGender => _userService.baseUser.gender;
  get myMobile => _userService.baseUser.mobile;

  //controllers

  TextEditingController nameController,
      dobController,
      genderController,
      emailController,
      mobileController;

  init() {
    nameController = new TextEditingController(text: myname);
    dobController = new TextEditingController(text: myAge);
    genderController = new TextEditingController(text: myGender);
    emailController = new TextEditingController(text: myEmail);
    mobileController = new TextEditingController(text: myMobile);
  }

  enableEdit() {
    inEditMode = true;
    notifyListeners();
  }

  updateDetails() async {
    if (_checkForChanges()) {
      isUpdaingUserDetails = true;
      notifyListeners();
      _userService.baseUser.name = nameController.text.trim();
      _userService.baseUser.dob = dobController.text.trim();
      _userService.baseUser.gender = genderController.text.trim()[0];
      await _dbModel.updateUser(_userService.baseUser).then((res) {
        if (res) {
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
    } else
      BaseUtil.showNegativeAlert("No changes found", "make some changes bruh");
  }

  bool _checkForChanges() {
    if (myname != nameController.text.trim() ||
        myAge != dobController.text.trim() ||
        myGender != genderController.text.trim()[0]) return true;
    return false;
  }

  signout() async {
    await _userService.signout();
  }

  Map<String, String> getBankDetail() {
    Map<String, String> bankCreds = {};
    if (_baseUtil.augmontDetail != null &&
        _baseUtil.augmontDetail.bankAccNo != "") {
      bankCreds["name"] = _baseUtil.augmontDetail.bankHolderName;
      bankCreds["number"] = _baseUtil.augmontDetail.bankAccNo;
      bankCreds["ifsc"] = _baseUtil.augmontDetail.ifsc;
    } else {
      bankCreds = {"name": "N/A", "number": "N/A", "ifsc": "N/A"};
    }
    return bankCreds;
  }

  String getGender() {
    if (_baseUtil.myUser.gender == "M")
      return "Male";
    else if (_baseUtil.myUser.gender == "F")
      return "Female";
    else if (_baseUtil.myUser.gender == "O") return "Prefer not say";
    return "unavailable";
  }

  String getDob() {
    if (_baseUtil.myUser.dob != null)
      return _baseUtil.myUser.dob;
    else
      return "N/A";
  }

  Widget cardItem(String title, String subTitle) {
    return Expanded(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: UiConstants.primaryColor.withOpacity(0.5),
              fontSize: SizeConfig.mediumTextSize * 0.8),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: SizeConfig.mediumTextSize,
          ),
        ),
      ),
    );
  }

  handleDPOperation() async {
    BuildContext context;
    if (await BaseUtil.showNoInternetAlert()) return;
    var _status = await Permission.photos.status;
    if (_status.isRestricted || _status.isLimited || _status.isDenied) {
      BaseUtil.openDialog(
          isBarrierDismissable: false,
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
                Navigator.pop(context);
                _chooseprofilePicture();
              },
              cancelAction: () => Navigator.pop(context)));
    } else if (_status.isGranted) {
      await _chooseprofilePicture();
      // needsRefresh(true);
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
}
