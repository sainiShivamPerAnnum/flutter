//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/enums/cache_type.dart';
import 'package:felloapp/core/enums/screen_item.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/change_profile_picture_dialog.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/modals/simple_kyc_modal_sheet.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
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

  final _userService = locator<UserService>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final DBModel _dbModel = locator<DBModel>();
  double picSize;
  XFile selectedProfilePicture;
  ValueChanged<bool> upload;
  final RootViewModel _rootViewModel = locator<RootViewModel>();

  //Define this in constants
  String defaultPan = "**********";
  String pan = "**********";

  bool isPanVisible = false;

  get myUserDpUrl => _userService.myUserDpUrl;

  showHidePan() {
    if (isPanVisible) {
      //Hide the pan
      pan = defaultPan;
      isPanVisible = false;
      notifyListeners();
    } else {
      //show pan
      pan = _baseUtil.userRegdPan;
      isPanVisible = true;
      notifyListeners();
    }
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

  Widget getPanContent(BuildContext context) {
    if (_baseUtil.userRegdPan != null && _baseUtil.userRegdPan != "") {
      return InkWell(
        onTap: () => showHidePan(),
        child: Row(
          children: [
            Text(
              pan,
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
            SizedBox(width: 4),
            !isPanVisible
                ? Lottie.asset("images/lottie/eye.json",
                    height: SizeConfig.largeTextSize, repeat: false)
                : Icon(
                    Icons.remove_red_eye_outlined,
                    color: UiConstants.primaryColor,
                    size: SizeConfig.largeTextSize,
                  ),
          ],
        ),
      );
    } else
      return Wrap(
        children: [
          ElevatedButton(
            onPressed: () async {
              if (await _baseUtil.showNoInternetAlert(context)) return;
              AppState.screenStack.add(ScreenItem.dialog);
              showModalBottomSheet(
                  isDismissible: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return SimpleKycModalSheet();
                  });
            },
            child: Text(
              "Verify",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
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

  handleDPOperation(ValueChanged<bool> needsRefresh) async {
    BuildContext context;
    if (await _baseUtil.showNoInternetAlert(context)) return;
    var _status = await Permission.photos.status;
    if (_status.isRestricted || _status.isLimited || _status.isDenied) {
      _baseUtil.openDialog(
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
                chooseprofilePicture();
              },
              cancelAction: () => Navigator.pop(context)));
    } else if (_status.isGranted) {
      await chooseprofilePicture();
      needsRefresh(true);
    } else {
      _baseUtil.showNegativeAlert('Permission Unavailable',
          'Please enable permission from settings to continue', context);
    }
  }

//Model should never user Widgets in it. We should never pass context here...
  chooseprofilePicture() async {
    selectedProfilePicture = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 45);
    if (selectedProfilePicture != null) {
      print(File(selectedProfilePicture.path).lengthSync() / 1024);
      Haptic.vibrate();
      AppState.screenStack.add(ScreenItem.dialog);
      await _baseUtil.openDialog(
        isBarrierDismissable: false,
        content: ChangeProfilePicture(
          image: File(selectedProfilePicture.path),
          upload: (value) {
            if (value)
              updateProfilePicture()
                  .then((flag) => postProfilePictureUpdate(flag));
          },
        ),
      );
      _rootViewModel.refresh();
      notifyListeners();
    }
  }

  Future<bool> updateProfilePicture() async {
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
        //TODO: Add user service here.
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

  postProfilePictureUpdate(bool flag) {
    BuildContext context;
    if (flag) {
      BaseAnalytics.logProfilePictureAdded();
      _baseUtil.showPositiveAlert(
          'Complete', 'Your profile Picture has been updated', context);
    } else {
      _baseUtil.showNegativeAlert('Failed',
          'Your Profile Picture could not be updated at the moment', context);
    }
    //upload(false);
    AppState.backButtonDispatcher.didPopRoute();
  }
}
