import 'package:felloapp/base_util.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareInfoModalSheet extends StatelessWidget {
  const ShareInfoModalSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 5,
                    right: SizeConfig.blockSizeHorizontal * 5,
                    top: 16,
                    bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    // width: SizeConfig
                    //         .blockSizeHorizontal *
                    //     5),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          "How to make a successful Referral ",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: GoogleFonts.montserratAlternates(
                            fontWeight: FontWeight.w500,
                            color: UiConstants.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                    IconButton(
                      onPressed: () {
                        AppState.backButtonDispatcher.didPopRoute();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey,
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
                      bottom: 0,
                      right: -30,
                      child: Opacity(
                        opacity: 0.6,
                        child: Image.asset(
                          "images/share-bottomsheet.png",
                          width: SizeConfig.screenWidth * 0.45,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        referralTile(
                          "Share a personalised link with your friends and family.",
                          0,
                        ),
                        referralTile(
                            "Once they signup, both of you receive 10 tickets and ₹25.",
                            SizeConfig.screenWidth * 0.1),
                        referralTile(
                            "This balance gets unlocked for both once they make their first investment of atleast ₹100.",
                            SizeConfig.screenWidth * 0.2),
                        SizedBox(height: 20),
                        Container(
                          width: SizeConfig.screenWidth * 0.5,
                          height: SizeConfig.screenHeight * 0.1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Want to earn more with Fello?",
                                style:
                                    GoogleFonts.montserrat(color: Colors.grey),
                              ),
                              InkWell(
                                onTap: () async {
                                  String url = "https://fello.in/cfo";
                                  if (await canLaunch(url)) {
                                    BaseUtil.launchUrl(url);
                                  } else {
                                    AppState.backButtonDispatcher.didPopRoute();
                                  }
                                },
                                child: Text(
                                  "Visit our CFO page",
                                  style: GoogleFonts.montserrat(
                                    color: UiConstants.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
              style: GoogleFonts.montserrat(),
            ),
          ),
        ],
      ),
    );
  }
}
