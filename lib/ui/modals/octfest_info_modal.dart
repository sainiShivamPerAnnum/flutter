import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class OctFestInfoModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: SizeConfig.pageHorizontalMargins,
                    right: SizeConfig.pageHorizontalMargins / 2,
                    top: 16,
                    bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Fello November Fest 🍺",
                      textAlign: TextAlign.center,
                      style: TextStyles.title3.bold
                          .colour(UiConstants.primaryColor),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      child: IconButton(
                        onPressed: () {
                          AppState.backButtonDispatcher.didPopRoute();
                        },
                        icon: Icon(
                          Icons.close,
                          size: SizeConfig.iconSize1,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 5,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 10,
                      child: Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenWidth * 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(
                                  -SizeConfig.blockSizeHorizontal * 5, 0),
                              child: Image.asset(
                                "images/beerInfoModal.png",
                                width: SizeConfig.screenWidth * 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        referralTile(
                          "This November, visit any of our partner FnB outlets and get a free beverage on us.",
                          0,
                        ),
                        referralTile(
                            "Make your first investment of ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.OCT_FEST_MIN_DEPOSIT)} or more and show the transaction to the outlet to avail the offer.",
                            SizeConfig.screenWidth * 0.1),
                        referralTile(
                            "This offer can only be availed once per user, using the outlet's download link.",
                            SizeConfig.screenWidth * 0.2),
                        SizedBox(height: SizeConfig.screenHeight * 0.2),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        )
      ],
    );
  }

  Widget referralTile(String title, double rightPad) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0, right: rightPad),
      child: Row(
        children: [
          Icon(
            Icons.brightness_1,
            size: 12,
            color: UiConstants.primaryColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyles.body4,
            ),
          ),
        ],
      ),
    );
  }
}
