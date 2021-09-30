//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/core/enums/screen_item.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/dialogs/update_name_dialog.dart';
import 'package:felloapp/ui/pages/tabs/profile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';

//Flutter & Dart Imports
import 'dart:ui';
import 'package:flutter/material.dart';

//Pub Imports
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    fcmProvider = Provider.of<FcmListener>(context);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    picSize = SizeConfig.screenHeight / 4.8;
    return BaseView<UserProfileViewModel>(
      //onModelReady: (model) {},
      builder: (ctx, model, child) => Scaffold(
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
                        image: baseProvider.myUserDpUrl == null ||
                                baseProvider.myUserDpUrl == ""
                            ? AssetImage(
                                "images/profile.png",
                              )
                            : CachedNetworkImageProvider(
                                baseProvider.myUserDpUrl,
                              ),
                        // CachedNetworkImageProvider(baseProvider.myUserDpUrl),
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
                                      onPressed: () => AppState
                                          .backButtonDispatcher
                                          .didPopRoute(),
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
                                  child: InkWell(
                                    onTap: () async {
                                      if (await baseProvider
                                          .showNoInternetAlert(context)) return;
                                      var _status =
                                          await Permission.photos.status;
                                      if (_status.isRestricted ||
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Image.asset(
                                                        "images/gallery.png",
                                                        height: SizeConfig
                                                                .screenWidth *
                                                            0.24),
                                                  ),
                                                  confirmAction: () {
                                                    Navigator.pop(context);
                                                    model.chooseprofilePicture(
                                                        context);
                                                  },
                                                  cancelAction: () =>
                                                      Navigator.pop(context));
                                            });
                                      } else if (_status.isGranted) {
                                        model.chooseprofilePicture(context);
                                      } else {
                                        baseProvider.showNegativeAlert(
                                            'Permission Unavailable',
                                            'Please enable permission from settings to continue',
                                            context);
                                      }
                                    },
                                    child: Icon(
                                      Icons.camera,
                                      color: UiConstants.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              FittedBox(
                                child: TextButton.icon(
                                  onPressed: () async {
                                    if (await baseProvider
                                        .showNoInternetAlert(context)) return;
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
                            model.cardItem(
                                "Username",
                                (baseProvider.myUser.username != "" &&
                                            baseProvider.myUser.username != null
                                        ? "@${baseProvider.myUser.username.replaceAll('@', '.')}"
                                        : "unavailable") ??
                                    "N/A"),
                            model.cardItem("Mobile Number",
                                "+91 ${baseProvider.myUser.mobile}" ?? ""),
                          ],
                        ),
                        Row(
                          children: [
                            model.cardItem(
                                "Email",
                                (baseProvider.myUser.email != ""
                                        ? baseProvider.myUser.email
                                        : "unavailable") ??
                                    "N/A"),
                            model.cardItem(
                                (baseProvider.myUser.dob != ""
                                        ? "Date of Birth"
                                        : "Age") ??
                                    "Date of Birth",
                                model.getDob()),
                          ],
                        ),
                        Row(
                          children: [
                            model.cardItem("Gender", model.getGender()),
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
                                  subtitle: model.getPanContent(context)),
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
                            model.cardItem("Account Number",
                                model.getBankDetail()["number"]),
                          ],
                        ),
                        Row(
                          children: [
                            model.cardItem(
                                "Account Name", model.getBankDetail()["name"]),
                            model.cardItem(
                                "IFSC Code", model.getBankDetail()["ifsc"]),
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
                          title: Text(
                            "App Lock",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.mediumTextSize,
                            ),
                          ),
                          trailing: Switch.adaptive(
                              value: (baseProvider.myUser.userPreferences
                                      .getPreference(Preferences.APPLOCK) ==
                                  1),
                              onChanged: (val) async {
                                if (await baseProvider
                                    .showNoInternetAlert(context)) return;
                                baseProvider.flipSecurityValue(val);
                              }),
                        ),
                        ListTile(
                          title: Text(
                            "Tambola Draw Notifications",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.mediumTextSize,
                            ),
                          ),
                          trailing: fcmProvider.isTambolaNotificationLoading
                              ? CircularProgressIndicator()
                              : Switch.adaptive(
                                  value: (baseProvider.myUser.userPreferences
                                          .getPreference(Preferences
                                              .TAMBOLANOTIFICATIONS) ==
                                      1),
                                  onChanged: (val) async {
                                    if (await baseProvider
                                        .showNoInternetAlert(context)) return;

                                    fcmProvider
                                        .toggleTambolaDrawNotificationStatus(
                                            val);
                                  }),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 5),
                  child: TextButton(
                    child: Text(
                      "SIGN OUT",
                      style: GoogleFonts.montserrat(
                        color: Colors.red,
                        fontSize: SizeConfig.largeTextSize,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    onPressed: () async {
                      if (await baseProvider.showNoInternetAlert(context))
                        return;
                      AppState.screenStack.add(ScreenItem.dialog);
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) => WillPopScope(
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
                              baseProvider.signOut().then((flag) {
                                if (flag) {
                                  //log.debug('Sign out process complete');
                                  AppState.backButtonDispatcher.didPopRoute();
                                  AppState.delegate.appState.currentAction =
                                      PageAction(
                                          state: PageState.replaceAll,
                                          page: SplashPageConfig);
                                  baseProvider.showPositiveAlert('Signed out',
                                      'Hope to see you soon', context);
                                } else {
                                  AppState.backButtonDispatcher.didPopRoute();
                                  baseProvider.showNegativeAlert(
                                      'Sign out failed',
                                      'Couldn\'t signout. Please try again',
                                      context);
                                  //log.error('Sign out process failed');
                                }
                              });
                            },
                            cancelAction: () {
                              Haptic.vibrate();
                              AppState.backButtonDispatcher.didPopRoute();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
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
