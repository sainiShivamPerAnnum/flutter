import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../../../base_util.dart';

class UserProfileDetails extends StatelessWidget {
  BaseUtil baseProvider;
  double picSize;
  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    picSize = SizeConfig.screenWidth / 2.4;
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        child: Stack(children: [
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight / 2,
            decoration: BoxDecoration(
              color: UiConstants.primaryColor,
              image: DecorationImage(
                  image: baseProvider.myUserDpUrl != null
                      ? CachedNetworkImageProvider(baseProvider.myUserDpUrl)
                      : AssetImage("images/profile.png"),
                  fit: BoxFit.cover),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(colors: [
                    UiConstants.primaryColor.withOpacity(0.4),
                    UiConstants.primaryColor.withGreen(980).withOpacity(0.8),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  //color: UiConstants.primaryColor.withOpacity(0.8),
                ),
                width: SizeConfig.screenWidth,
                child: Stack(
                  children: [
                    Container(
                      width: SizeConfig.screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(flex: 2),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 5),
                            height: picSize,
                            width: picSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 8),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: Text(
                              baseProvider.myUser.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: SizeConfig.cardTitleTextSize,
                              ),
                            ),
                          ),
                          baseProvider.myUser.username != null ||
                                  baseProvider.myUser.username == ""
                              ? Text(
                                  "@${baseProvider.myUser.username}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : SizedBox(),
                          Spacer(flex: 2)
                        ],
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
                                size: 30,
                              ),
                              onPressed: () =>
                                  backButtonDispatcher.didPopRoute(),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight / 1.8,
              child: ListView(
                children: [
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
                ],
              ),
            ),
          )
        ]),
      ),
    );
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
      contentPadding:
          EdgeInsets.symmetric(vertical: SizeConfig.blockSizeHorizontal * 2.5),
      leading: Container(
        height: SizeConfig.blockSizeHorizontal * 10,
        width: SizeConfig.blockSizeHorizontal * 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withOpacity(0.2),
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: SizeConfig.mediumTextSize,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Expanded(
        child: Text(
          value,
          style: TextStyle(fontSize: SizeConfig.mediumTextSize * 1.2),
        ),
      ),
    );
  }
}
