//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_viewmodel.dart';
import 'package:felloapp/ui/dialogs/change_profile_picture_dialog.dart';
import 'package:felloapp/ui/modals/simple_kyc_modal_sheet.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';

//Flutter & Dart Imports
import 'package:flutter/material.dart';
import 'dart:io';

//Pub Imports
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class UserProfileViewModel extends BaseModel {
  final _userService = locator<UserService>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  double picSize;

  //Define this in constants
  String defaultPan = "**********";
  String pan = "**********";

  bool isPanVisible = false;

  get myUserDpUrl => _userService.myUserDpUrl;

//Model should never user Widgets in it. We should never pass context here...
  chooseprofilePicture(BuildContext context) async {
    final temp = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 45);
    if (temp != null) {
      print(File(temp.path).lengthSync() / 1024);
      Haptic.vibrate();
      await showDialog(
        context: context,
        builder: (BuildContext context) => ChangeProfilePicture(
          image: File(temp.path),
        ),
      );
      notifyListeners();
    }
  }

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

  
}
