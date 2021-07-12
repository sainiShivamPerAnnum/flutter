import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../base_util.dart';

class UserProfileDetails extends StatelessWidget {
  BaseUtil baseProvider;
  double picSize;
  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    picSize = SizeConfig.screenHeight / 4.8;
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight / 2.4,
                decoration: BoxDecoration(
                  gradient: new LinearGradient(colors: [
                    UiConstants.primaryColor.withGreen(200),
                    UiConstants.primaryColor,
                  ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
                ),
                child: Stack(
                  children: [
                    SafeArea(
                      child: Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenHeight / 2.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: kToolbarHeight),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.blockSizeHorizontal * 5),
                              height: picSize,
                              width: picSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 8),
                                boxShadow: [
                                  BoxShadow(
                                      color: UiConstants.primaryColor
                                          .withBlue(900)
                                          .withOpacity(0.5),
                                      offset: Offset(0, 10),
                                      blurRadius: 30,
                                      spreadRadius: 2)
                                ],
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
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 5,
                                  right: SizeConfig.blockSizeHorizontal * 5,
                                  top: 16,
                                  bottom: SizeConfig.blockSizeHorizontal * 5),
                              child: FittedBox(
                                child: Text(
                                  baseProvider.myUser.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: SizeConfig.cardTitleTextSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Container(
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
                    )
                  ],
                ),
              ),
              ProfileDetailsTile(
                color: Colors.pink,
                title: "Username",
                value: "@${baseProvider.myUser.username}" ?? "Not claimed yet",
                icon: Icons.alternate_email_rounded,
              ),
              ProfileDetailsTile(
                color: UiConstants.primaryColor,
                title: "Mobile No.",
                value: baseProvider.myUser.mobile,
                icon: Icons.phone,
              ),
              ProfileDetailsTile(
                color: Colors.amber,
                title: "Email",
                value: baseProvider.myUser.email,
                icon: Icons.email_rounded,
              ),
              ProfileDetailsTile(
                color: Colors.blue,
                title: "Date of Birth",
                value: baseProvider.myUser.dob,
                icon: Icons.calendar_today,
              ),
              ProfileDetailsTile(
                color: Colors.purple,
                title: "PAN",
                value: baseProvider.myUser.pan ?? "N/A",
                icon: Icons.air_sharp,
              ),
              ProfileDetailsTile(
                color: Colors.orange,
                title: "Gender",
                value: baseProvider.myUser.gender == 'M' ? "Male" : "Female",
                icon: baseProvider.myUser.gender == "M"
                    ? Icons.male
                    : Icons.female,
              ),
            ],
          ),
        ),
      ),
    );

    // Scaffold(
    //   body: Container(
    //     height: SizeConfig.screenHeight,
    //     width: SizeConfig.screenWidth,
    //     child: Stack(children: [
    //       Container(
    //         width: SizeConfig.screenWidth,
    //         height: SizeConfig.screenHeight,
    //         decoration: BoxDecoration(
    //           color: UiConstants.primaryColor,
    //           image: DecorationImage(
    //               image: baseProvider.myUserDpUrl != null
    //                   ? CachedNetworkImageProvider(baseProvider.myUserDpUrl)
    //                   : AssetImage("images/profile.png"),
    //               fit: BoxFit.cover),
    //         ),
    //         child: BackdropFilter(
    //           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    //           child: Container(
    //             decoration: BoxDecoration(
    //               // gradient: new LinearGradient(colors: [
    //               //   UiConstants.primaryColor.withOpacity(0.4),
    //               //   UiConstants.primaryColor.withGreen(980).withOpacity(0.6),
    //               // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    //               color: Colors.black.withOpacity(0.2),
    //             ),
    //             width: SizeConfig.screenWidth,
    //             child: Stack(
    //               children: [
    //                 SafeArea(
    //                   child: Container(
    //                     height: kToolbarHeight,
    //                     child: Row(
    //                       children: [
    //                         IconButton(
    //                           icon: Icon(
    //                             Icons.arrow_back_rounded,
    //                             color: Colors.white,
    //                             size: 30,
    //                           ),
    //                           onPressed: () =>
    //                               backButtonDispatcher.didPopRoute(),
    //                         ),
    //                         Spacer(),
    // Text(
    //   "My Profile",
    //   style: TextStyle(
    //     color: Colors.white,
    //     fontWeight: FontWeight.w700,
    //     fontSize: SizeConfig.cardTitleTextSize * 0.8,
    //   ),
    // ),
    //                         Spacer(),
    //                         SizedBox(width: 40)
    //                       ],
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         bottom: SizeConfig.blockSizeHorizontal * 5,
    //         child: Container(
    //           width: SizeConfig.screenWidth,
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Container(
    //                 padding: EdgeInsets.symmetric(
    //                     horizontal: SizeConfig.blockSizeHorizontal * 8),
    //                 decoration: BoxDecoration(
    //                   color: Theme.of(context).scaffoldBackgroundColor,
    //                   borderRadius: BorderRadius.circular(20),
    //                 ),
    //                 width: SizeConfig.screenWidth -
    //                     SizeConfig.blockSizeHorizontal * 10,
    //                 height: SizeConfig.screenHeight -
    //                     kToolbarHeight * 1.2 -
    //                     picSize,
    // child: ListView(
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Container(
    //           margin: EdgeInsets.only(
    //               left: SizeConfig.blockSizeHorizontal * 5,
    //               right: SizeConfig.blockSizeHorizontal * 5,
    //               top: picSize / 3.5,
    //               bottom: SizeConfig.blockSizeHorizontal * 5),
    //           child: FittedBox(
    //             child: Text(baseProvider.myUser.name,
    //                 style: TextStyle(
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: SizeConfig.cardTitleTextSize,
    //                   color: Colors.black45,
    //                 )),
    //           ),
    //         ),
    //       ],
    //     ),
    //     ProfileDetailsTile(
    //       color: Colors.pink,
    //       title: "Username",
    //       value: "@${baseProvider.myUser.username}" ??
    //           "Not claimed yet",
    //       icon: Icons.alternate_email_rounded,
    //     ),
    //     ProfileDetailsTile(
    //       color: UiConstants.primaryColor,
    //       title: "Mobile No.",
    //       value: baseProvider.myUser.mobile,
    //       icon: Icons.phone,
    //     ),
    //     ProfileDetailsTile(
    //       color: Colors.amber,
    //       title: "Email",
    //       value: baseProvider.myUser.email,
    //       icon: Icons.email_rounded,
    //     ),
    //     ProfileDetailsTile(
    //       color: Colors.blue,
    //       title: "Date of Birth",
    //       value: baseProvider.myUser.dob,
    //       icon: Icons.calendar_today,
    //     ),
    //     ProfileDetailsTile(
    //       color: Colors.purple,
    //       title: "PAN",
    //       value: baseProvider.myUser.pan ?? "N/A",
    //       icon: Icons.air_sharp,
    //     ),
    //     ProfileDetailsTile(
    //       color: Colors.orange,
    //       title: "Gender",
    //       value: baseProvider.myUser.gender == 'M'
    //           ? "Male"
    //           : "Female",
    //       icon: baseProvider.myUser.gender == "M"
    //           ? Icons.male
    //           : Icons.female,
    //     ),
    //   ],
    // ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    // Positioned(
    //   top: kToolbarHeight * 1.4,
    //   child: SafeArea(
    //     child: Container(
    //       width: SizeConfig.screenWidth,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Container(
    //             padding: EdgeInsets.symmetric(
    //                 horizontal: SizeConfig.blockSizeHorizontal * 5),
    //             height: picSize,
    //             width: picSize,
    //             decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               border: Border.all(color: Colors.white, width: 8),
    //               boxShadow: [
    //                 BoxShadow(
    //                     color: UiConstants.primaryColor
    //                         .withBlue(900)
    //                         .withOpacity(0.5),
    //                     offset: Offset(0, 10),
    //                     blurRadius: 30,
    //                     spreadRadius: 2)
    //               ],
    //               image: DecorationImage(
    //                   image: baseProvider.myUserDpUrl == null ||
    //                           baseProvider.myUserDpUrl == ""
    //                       ? AssetImage(
    //                           "images/profile.png",
    //                         )
    //                       : CachedNetworkImageProvider(
    //                           baseProvider.myUserDpUrl,
    //                         ),
    //                   fit: BoxFit.cover),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // )
    //     ]),
    //   ),
    // );
  }
}

class ProfileDetailsTile extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;

  ProfileDetailsTile({this.color, this.icon, this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeHorizontal * 3,
          horizontal: SizeConfig.blockSizeHorizontal * 5),
      leading: Container(
        height: SizeConfig.blockSizeHorizontal * 8,
        width: SizeConfig.blockSizeHorizontal * 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: UiConstants.primaryColor.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: UiConstants.primaryColor,
          size: SizeConfig.blockSizeHorizontal * 4,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: UiConstants.primaryColor,
          fontSize: SizeConfig.mediumTextSize,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Text(
        value,
        style: TextStyle(
            fontSize: SizeConfig.mediumTextSize * 1.2, color: Colors.black54),
      ),
    );
  }
}
