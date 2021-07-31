import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/change_profile_picture_dialog.dart';
import 'package:felloapp/ui/elements/confirm_action_dialog.dart';
import 'package:felloapp/ui/elements/update_name.dart';
import 'package:felloapp/ui/pages/onboarding/augmont/augmont_onboarding_page.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../../base_util.dart';

class UserProfileDetails extends StatefulWidget {
  @override
  _UserProfileDetailsState createState() => _UserProfileDetailsState();
}

class _UserProfileDetailsState extends State<UserProfileDetails> {
  BaseUtil baseProvider;
  DBModel dbProvider;
  FcmListener fcmProvider;
  double picSize;
  String defaultPan = "**********";
  String pan = "**********";
  bool isPanVisible = false;

  chooseprofilePicture() async {
    final temp = await ImagePicker().getImage(source: ImageSource.gallery);
    if (temp != null) {
      HapticFeedback.vibrate();
      showDialog(
        context: context,
        builder: (BuildContext context) => ChangeProfilePicture(
          image: File(temp.path),
        ),
      );
    }
  }

  showHidePan() {
    if (isPanVisible) {
      //Hide the pan
      setState(() {
        pan = defaultPan;
        isPanVisible = false;
      });
    } else {
      //show pan
      setState(() {
        pan = baseProvider.userRegdPan;
        isPanVisible = true;
      });
    }
  }

  Map<String, String> getBankDetail() {
    Map<String, String> bankCreds = {};
    if (baseProvider.augmontDetail != null) {
      bankCreds["name"] = baseProvider.augmontDetail.bankHolderName;
      bankCreds["number"] = baseProvider.augmontDetail.bankAccNo;
      bankCreds["ifsc"] = baseProvider.augmontDetail.ifsc;
    } else {
      bankCreds = {"name": "N/A", "number": "N/A", "ifsc": "N/A"};
    }
    return bankCreds;
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    fcmProvider = Provider.of<FcmListener>(context);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    picSize = SizeConfig.screenHeight / 4.8;
    return Scaffold(
      backgroundColor: Color(0xffEDEDED),
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          CachedNetworkImageProvider(baseProvider.myUserDpUrl),
                      fit: BoxFit.cover),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.7)
                            ],
                            begin: Alignment(0.5, -1.0),
                            end: Alignment(0.5, 1.0)),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: kToolbarHeight,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_rounded,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        backButtonDispatcher.didPopRoute(),
                                  ),
                                  Spacer(),
                                  Text(
                                    "My Profile",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.largeTextSize,
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(width: 40)
                                ],
                              ),
                            ),
                            Container(
                              height: picSize,
                              width: picSize,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 8),
                                image: DecorationImage(
                                    image: baseProvider.myUserDpUrl == null ||
                                            baseProvider.myUserDpUrl == ""
                                        ? AssetImage(
                                            "images/profile.png",
                                          )
                                        : CachedNetworkImageProvider(
                                            baseProvider.myUserDpUrl,
                                          ),
                                    fit: BoxFit.cover),
                              ),
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: picSize / 4.4,
                                width: picSize / 4.4,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    var _status =
                                        await Permission.photos.status;
                                    if (_status.isUndetermined ||
                                        _status.isRestricted ||
                                        _status.isLimited ||
                                        _status.isDenied) {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return ConfirmActionDialog(
                                                title: "Request Permission",
                                                description:
                                                    "Access to the gallery is requested. This is only required for choosing your profile picture 🤳🏼",
                                                buttonText: "Continue",
                                                asset: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                  child: Image.asset(
                                                      "images/gallery.png",
                                                      height: SizeConfig
                                                              .screenWidth *
                                                          0.24),
                                                ),
                                                confirmAction: () {
                                                  Navigator.pop(context);
                                                  chooseprofilePicture();
                                                },
                                                cancelAction: () =>
                                                    Navigator.pop(context));
                                          });
                                    } else if (_status.isGranted) {
                                      chooseprofilePicture();
                                    } else {
                                      baseProvider.showNegativeAlert(
                                          'Permission Unavailable',
                                          'Please enable permission from settings to continue',
                                          context);
                                    }
                                  },
                                  icon: Icon(Icons.camera),
                                  color: UiConstants.primaryColor,
                                ),
                              ),
                            ),
                            FittedBox(
                              child: TextButton.icon(
                                onPressed: () {
                                  AppState.screenStack.add(ScreenItem.dialog);
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (ctx) => UpdateNameDialog());
                                },
                                icon: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                  size: SizeConfig.cardTitleTextSize,
                                ),
                                label: Text(
                                  baseProvider.myUser.name,
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: SizeConfig.cardTitleTextSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                    // Positioned(
                    //     bottom: 0,
                    //     right: 0,
                    //     child: IconButton(
                    //       onPressed: () {
                    //         AppState.screenStack.add(ScreenItem.dialog);
                    //         showDialog(
                    //             barrierDismissible: false,
                    //             context: context,
                    //             builder: (ctx) => UpdateNameDialog());
                    //       },
                    //       icon: Icon(
                    //         Icons.edit_outlined,
                    //         color: Colors.white,
                    //         size: SizeConfig.largeTextSize,
                    //       ),
                    //     ))
                  ],
                ),
              ),
              SectionCard(
                baseProvider: baseProvider,
                title: "Personal Details",
                content: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          cardItem(
                                  "Username",
                                  (baseProvider.myUser.username != ""
                                      ? "@${baseProvider.myUser.username}"
                                      : "unavailable")) ??
                              "N/A",
                          cardItem("Mobile Number",
                              "+91 ${baseProvider.myUser.mobile}" ?? ""),
                        ],
                      ),
                      Row(
                        children: [
                          cardItem(
                                  "Email",
                                  (baseProvider.myUser.email != ""
                                      ? baseProvider.myUser.email
                                      : "unavailable")) ??
                              "N/A",
                          cardItem(
                              (baseProvider.myUser.dob != ""
                                      ? "Date of Birth"
                                      : "Age") ??
                                  "Date of Birth",
                              getDob()),
                        ],
                      ),
                      Row(
                        children: [
                          cardItem("Gender", getGender()),
                          Expanded(
                            child: ListTile(
                                title: Text(
                                  "PAN",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: UiConstants.primaryColor
                                          .withOpacity(0.5),
                                      fontSize:
                                          SizeConfig.mediumTextSize * 0.8),
                                ),
                                subtitle: getPanContent()),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SectionCard(
                baseProvider: baseProvider,
                title: "Bank Details",
                content: Container(
                  width: SizeConfig.screenWidth,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          cardItem("Account Number", getBankDetail()["number"]),
                        ],
                      ),
                      Row(
                        children: [
                          cardItem("Account Name", getBankDetail()["name"]),
                          cardItem("IFSC Code", getBankDetail()["ifsc"]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).scaffoldBackgroundColor,
                margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 2.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text(
                          "App Preferences",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.mediumTextSize * 1.2),
                        ),
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        title: Text("App Lock"),
                        trailing: Switch.adaptive(
                            value: (baseProvider.myUser.userPreferences
                                    .getPreference(Preferences.APPLOCK) ==
                                1),
                            onChanged: (val) {
                              baseProvider.flipSecurityValue(val);
                            }),
                      ),
                      ListTile(
                        title: Text("Tambola Draw Notifications"),
                        trailing: fcmProvider.isTambolaNotificationLoading
                            ? CircularProgressIndicator()
                            : Switch.adaptive(
                                value: (baseProvider.myUser.userPreferences
                                        .getPreference(
                                            Preferences.TAMBOLANOTIFICATIONS) ==
                                    1),
                                onChanged: (val) {
                                  fcmProvider
                                      .toggleTambolaDrawNotificationStatus(val);
                                }),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPanContent() {
    if (baseProvider.userRegdPan != null && baseProvider.userRegdPan != "") {
      return Row(
        children: [
          Text(
            pan,
            style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.mediumTextSize,
            ),
          ),
          SizedBox(width: 4),
          InkWell(
            onTap: showHidePan,
            child: !isPanVisible
                ? Lottie.asset("images/lottie/eye.json",
                    height: SizeConfig.largeTextSize, repeat: false)
                : Icon(
                    Icons.remove_red_eye_outlined,
                    color: UiConstants.primaryColor,
                    size: SizeConfig.largeTextSize,
                  ),
          )
        ],
      );
    } else
      return Wrap(
        children: [
          ElevatedButton(
            onPressed: () {
              delegate.appState.currentAction = PageAction(
                state: PageState.addWidget,
                widget: AugmontOnboarding(),
                page: AugOnboardPageConfig,
              );
            },
            child: Text(
              "Register",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
  }

  String getGender() {
    if (baseProvider.myUser.gender == "M")
      return "Male";
    else if (baseProvider.myUser.gender == "F")
      return "Female";
    else if (baseProvider.myUser.gender == "O") return "Prefer not say";
    return "unavailable";
  }

  String getDob() {
    if (baseProvider.myUser.dob != null)
      return baseProvider.myUser.dob;
    else if (baseProvider.myUser.age != null)
      return baseProvider.myUser.age;
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

class SectionCard extends StatelessWidget {
  const SectionCard(
      {@required this.baseProvider,
      @required this.title,
      @required this.content});

  final BaseUtil baseProvider;
  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 2.5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                title,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.mediumTextSize * 1.2),
              ),
            ),
            Divider(
              height: 0,
            ),
            content,
            SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }
}
