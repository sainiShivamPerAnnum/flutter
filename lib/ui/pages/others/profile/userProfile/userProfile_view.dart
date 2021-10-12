//Project Imports
//Flutter & Dart Imports
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    picSize = SizeConfig.screenHeight / 4.8;
    return BaseView<UserProfileViewModel>(
      onModelReady: (model) {
        print("This is userProfile view - ${model.myUserDpUrl}");
      },
      builder: (ctx, model, child) => Scaffold(
          backgroundColor: UiConstants.primaryColor,
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "My Profile",
                ),
                if (model.inEditMode)
                  Expanded(
                    child: Container(
                      color: Colors.red,
                    ),
                  )
                else
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.only(
                        top: SizeConfig.scaffoldMargin,
                        left: SizeConfig.scaffoldMargin,
                        right: SizeConfig.scaffoldMargin,
                        bottom: 80,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: SizeConfig.screenWidth / 2.4,
                              height: SizeConfig.screenWidth / 2.4,
                              margin: EdgeInsets.only(bottom: 16),
                              child: Stack(
                                children: [
                                  Container(
                                    width: SizeConfig.screenWidth / 2.4,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          UiConstants.primaryColor,
                                          Colors.white,
                                        ],
                                      ),
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: ProfileImageSE(
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: kToolbarHeight * 1.4,
                                      width: kToolbarHeight * 1.4,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: UiConstants.primaryColor,
                                        border: Border.all(
                                            width: 8, color: Colors.white),
                                      ),
                                      child: Icon(
                                        Icons.camera,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                model.myname,
                                style: TextStyles.title4.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            FittedBox(
                              child: Text(
                                "@${model.myUsername}",
                                style: TextStyles.body3.colour(Colors.grey),
                              ),
                            ),
                            SizedBox(height: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name as per PAN",
                                  style: TextStyles.body3,
                                ),
                                SizedBox(height: 6),
                                TextField(
                                  enabled: model.inEditMode,
                                  controller: model.nameController,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Age",
                                  style: TextStyles.body3,
                                ),
                                SizedBox(height: 6),
                                TextField(
                                  enabled: model.inEditMode,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.unfold_more_rounded),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Gender",
                                  style: TextStyles.body3,
                                ),
                                SizedBox(height: 6),
                                TextField(
                                  enabled: model.inEditMode,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.expand_more_rounded),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyles.body3,
                                ),
                                SizedBox(height: 6),
                                TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.verified,
                                      color: UiConstants.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mobile",
                                  style: TextStyles.body3,
                                ),
                                SizedBox(height: 6),
                                TextField(
                                  enabled: false,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            ),
          )
          // Container(
          //   height: SizeConfig.screenHeight,
          //   width: SizeConfig.screenWidth,
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: [
          //         Container(
          //           width: SizeConfig.screenWidth,
          //           decoration: BoxDecoration(
          //             image: DecorationImage(
          //                 image:
          //                     model.myUserDpUrl == null || model.myUserDpUrl == ""
          //                         ? AssetImage(
          //                             "images/profile.png",
          //                           )
          //                         : CachedNetworkImageProvider(
          //                             model.myUserDpUrl,
          //                           ),
          //                 fit: BoxFit.cover),
          //           ),
          //           child: Stack(
          //             children: [
          //               Container(
          //                 decoration: BoxDecoration(
          //                   gradient: new LinearGradient(
          //                       colors: [
          //                         Colors.black.withOpacity(0.5),
          //                         Colors.black.withOpacity(0.7)
          //                       ],
          //                       begin: Alignment(0.5, -1.0),
          //                       end: Alignment(0.5, 1.0)),
          //                 ),
          //                 child: SafeArea(
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Container(
          //                         height: kToolbarHeight,
          //                         child: Row(
          //                           children: [
          //                             IconButton(
          //                               icon: Icon(
          //                                 Icons.arrow_back_rounded,
          //                                 color: Colors.white,
          //                               ),
          //                               onPressed: () => AppState
          //                                   .backButtonDispatcher
          //                                   .didPopRoute(),
          //                             ),
          //                             Spacer(),
          //                             Text(
          //                               "My Profile",
          //                               style: TextStyle(
          //                                 color: Colors.white,
          //                                 fontSize: SizeConfig.largeTextSize,
          //                               ),
          //                             ),
          //                             Spacer(),
          //                             SizedBox(width: 40)
          //                           ],
          //                         ),
          //                       ),
          //                       Container(
          //                         height: picSize,
          //                         width: picSize,
          //                         margin: EdgeInsets.symmetric(vertical: 8),
          //                         decoration: BoxDecoration(
          //                           shape: BoxShape.circle,
          //                           border:
          //                               Border.all(color: Colors.white, width: 8),
          //                           image: DecorationImage(
          //                               image: model.myUserDpUrl == null ||
          //                                       model.myUserDpUrl == ""
          //                                   ? AssetImage(
          //                                       "images/profile.png",
          //                                     )
          //                                   : CachedNetworkImageProvider(
          //                                       model.myUserDpUrl,
          //                                     ),
          //                               fit: BoxFit.cover),
          //                         ),
          //                         alignment: Alignment.bottomRight,
          //                         child: Container(
          //                           height: picSize / 4.4,
          //                           width: picSize / 4.4,
          //                           decoration: BoxDecoration(
          //                             color: Colors.white,
          //                             shape: BoxShape.circle,
          //                           ),
          //                           child: InkWell(
          //                             onTap: () async {
          //                               await model.handleDPOperation();
          //                             },
          //                             child: Icon(
          //                               Icons.camera,
          //                               color: UiConstants.primaryColor,
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                       FittedBox(
          //                         child: TextButton.icon(
          //                           onPressed: () async {
          //                             if (await BaseUtil.showNoInternetAlert())
          //                               return;
          //                             AppState.screenStack.add(ScreenItem.dialog);
          //                             showDialog(
          //                                 barrierDismissible: false,
          //                                 context: context,
          //                                 builder: (ctx) => UpdateNameDialog());
          //                           },
          //                           icon: Icon(
          //                             Icons.edit_outlined,
          //                             color: Colors.white,
          //                             size: SizeConfig.cardTitleTextSize,
          //                           ),
          //                           label: Text(
          //                             baseProvider.myUser.name,
          //                             overflow: TextOverflow.clip,
          //                             textAlign: TextAlign.center,
          //                             style: TextStyle(
          //                               fontWeight: FontWeight.w700,
          //                               fontSize: SizeConfig.cardTitleTextSize,
          //                               color: Colors.white,
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                       SizedBox(
          //                         height: 10,
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //               // Positioned(
          //               //     bottom: 0,
          //               //     right: 0,
          //               //     child: IconButton(
          //               //       onPressed: () {
          //               //         AppState.screenStack.add(ScreenItem.dialog);
          //               //         showDialog(
          //               //             barrierDismissible: false,
          //               //             context: context,
          //               //             builder: (ctx) => UpdateNameDialog());
          //               //       },
          //               //       icon: Icon(
          //               //         Icons.edit_outlined,
          //               //         color: Colors.white,
          //               //         size: SizeConfig.largeTextSize,
          //               //       ),
          //               //     ))
          //             ],
          //           ),
          //         ),
          //         SectionCard(
          //           baseProvider: baseProvider,
          //           title: "Personal Details",
          //           content: Container(
          //             child: Column(
          //               children: [
          //                 Row(
          //                   children: [
          //                     model.cardItem(
          //                         "Username",
          //                         (baseProvider.myUser.username != "" &&
          //                                     baseProvider.myUser.username != null
          //                                 ? "@${baseProvider.myUser.username.replaceAll('@', '.')}"
          //                                 : "unavailable") ??
          //                             "N/A"),
          //                     model.cardItem("Mobile Number",
          //                         "+91 ${baseProvider.myUser.mobile}" ?? ""),
          //                   ],
          //                 ),
          //                 Row(
          //                   children: [
          //                     model.cardItem(
          //                         "Email",
          //                         (baseProvider.myUser.email != ""
          //                                 ? baseProvider.myUser.email
          //                                 : "unavailable") ??
          //                             "N/A"),
          //                     model.cardItem(
          //                         (baseProvider.myUser.dob != ""
          //                                 ? "Date of Birth"
          //                                 : "Age") ??
          //                             "Date of Birth",
          //                         model.getDob()),
          //                   ],
          //                 ),
          //                 Row(
          //                   children: [
          //                     model.cardItem("Gender", model.getGender()),
          //                     Expanded(
          //                       child: ListTile(
          //                           title: Text(
          //                             "PAN",
          //                             style: TextStyle(
          //                                 fontWeight: FontWeight.w500,
          //                                 color: UiConstants.primaryColor
          //                                     .withOpacity(0.5),
          //                                 fontSize:
          //                                     SizeConfig.mediumTextSize * 0.8),
          //                           ),
          //                           subtitle: model.getPanContent(context)),
          //                     )
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         SectionCard(
          //           baseProvider: baseProvider,
          //           title: "Bank Details",
          //           content: Container(
          //             width: SizeConfig.screenWidth,
          //             child: Column(
          //               children: [
          //                 Row(
          //                   children: [
          //                     model.cardItem("Account Number",
          //                         model.getBankDetail()["number"]),
          //                   ],
          //                 ),
          //                 Row(
          //                   children: [
          //                     model.cardItem(
          //                         "Account Name", model.getBankDetail()["name"]),
          //                     model.cardItem(
          //                         "IFSC Code", model.getBankDetail()["ifsc"]),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         Card(
          //           color: Theme.of(context).scaffoldBackgroundColor,
          //           margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2.5),
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(12)),
          //           child: Container(
          //             padding: EdgeInsets.symmetric(
          //               horizontal: SizeConfig.blockSizeHorizontal * 2.5,
          //             ),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 ListTile(
          //                   title: Text(
          //                     "App Preferences",
          //                     style: TextStyle(
          //                         color: Colors.grey,
          //                         fontWeight: FontWeight.w600,
          //                         fontSize: SizeConfig.mediumTextSize * 1.2),
          //                   ),
          //                 ),
          //                 SizedBox(height: 8),
          //                 ListTile(
          //                   title: Text(
          //                     "App Lock",
          //                     style: TextStyle(
          //                       color: Colors.black,
          //                       fontSize: SizeConfig.mediumTextSize,
          //                     ),
          //                   ),
          //                   trailing: Switch.adaptive(
          //                       value: (baseProvider.myUser.userPreferences
          //                               .getPreference(Preferences.APPLOCK) ==
          //                           1),
          //                       onChanged: (val) async {
          //                         if (await BaseUtil.showNoInternetAlert())
          //                           return;
          //                         baseProvider.flipSecurityValue(val);
          //                       }),
          //                 ),
          //                 ListTile(
          //                   title: Text(
          //                     "Tambola Draw Notifications",
          //                     style: TextStyle(
          //                       color: Colors.black,
          //                       fontSize: SizeConfig.mediumTextSize,
          //                     ),
          //                   ),
          //                   trailing: fcmProvider.isTambolaNotificationLoading
          //                       ? CircularProgressIndicator()
          //                       : Switch.adaptive(
          //                           value: (baseProvider.myUser.userPreferences
          //                                   .getPreference(Preferences
          //                                       .TAMBOLANOTIFICATIONS) ==
          //                               1),
          //                           onChanged: (val) async {
          //                             if (await BaseUtil.showNoInternetAlert())
          //                               return;

          //                             fcmProvider
          //                                 .toggleTambolaDrawNotificationStatus(
          //                                     val);
          //                           }),
          //                 ),
          //                 SizedBox(height: 8),
          //               ],
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 5),
          //           child: TextButton(
          //             child: Text(
          //               "SIGN OUT",
          //               style: GoogleFonts.montserrat(
          //                 color: Colors.red,
          //                 fontSize: SizeConfig.largeTextSize,
          //                 fontWeight: FontWeight.w300,
          //               ),
          //             ),
          //             onPressed: () async {
          //               if (await BaseUtil.showNoInternetAlert()) return;
          //               AppState.screenStack.add(ScreenItem.dialog);
          //               showDialog(
          //                 context: context,
          //                 builder: (BuildContext dialogContext) => WillPopScope(
          //                     onWillPop: () {
          //                       AppState.backButtonDispatcher.didPopRoute();
          //                       return Future.value(true);
          //                     },
          //                     child: FelloConfirmationDialog(
          //                       title: 'Confirm',
          //                       body: 'Are you sure want to sign out?',
          //                       subtitle: '',
          //                       accept: 'Yes',
          //                       reject: 'No',
          //                       onAccept: () async {
          //                         Haptic.vibrate();
          //                         await model.signout();
          //                         baseProvider.signOut().then((flag) {
          //                           if (flag) {
          //                             //log.debug('Sign out process complete');
          //                             AppState.backButtonDispatcher.didPopRoute();
          //                             AppState.delegate.appState.currentAction =
          //                                 PageAction(
          //                                     state: PageState.replaceAll,
          //                                     page: SplashPageConfig);
          //                             BaseUtil.showPositiveAlert(
          //                                 'Signed out', 'Hope to see you soon');
          //                           } else {
          //                             AppState.backButtonDispatcher.didPopRoute();
          //                             BaseUtil.showNegativeAlert(
          //                               'Sign out failed',
          //                               'Couldn\'t signout. Please try again',
          //                             );
          //                             //log.error('Sign out process failed');
          //                           }
          //                         });
          //                       },
          //                       onReject: () {
          //                         Haptic.vibrate();
          //                         AppState.backButtonDispatcher.didPopRoute();
          //                       },
          //                     )
          //                     // ConfirmActionDialog(
          //                     //   title: 'Confirm',
          //                     //   description: 'Are you sure you want to sign out?',
          //                     //   buttonText: 'Yes',
          //                     //   confirmAction: () {
          //                     //     Haptic.vibrate();
          //                     //     baseProvider.signOut().then((flag) {
          //                     //       if (flag) {
          //                     //         //log.debug('Sign out process complete');
          //                     //         AppState.backButtonDispatcher.didPopRoute();
          //                     //         AppState.delegate.appState.currentAction =
          //                     //             PageAction(
          //                     //                 state: PageState.replaceAll,
          //                     //                 page: SplashPageConfig);
          //                     //         BaseUtil.showPositiveAlert('Signed out',
          //                     //             'Hope to see you soon', context);
          //                     //       } else {
          //                     //         AppState.backButtonDispatcher.didPopRoute();
          //                     //         BaseUtil.showNegativeAlert(
          //                     //             'Sign out failed',
          //                     //             'Couldn\'t signout. Please try again',
          //                     //             context);
          //                     //         //log.error('Sign out process failed');
          //                     //       }
          //                     //     });
          //                     //   },
          //                     //   cancelAction: () {
          //                     //     Haptic.vibrate();
          //                     //     AppState.backButtonDispatcher.didPopRoute();
          //                     //   },
          //                     // ),
          //                     ),
          //               );
          //             },
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
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
