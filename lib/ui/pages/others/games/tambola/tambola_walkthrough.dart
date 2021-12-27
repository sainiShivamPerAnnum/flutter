//Project Imports

import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//Pub Imports
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Walkthrough extends StatelessWidget {
  const Walkthrough({Key key}) : super(key: key);

  static List<String> dailyPicks = [
    "Starting Monday, ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.TAMBOLA_DAILY_PICK_COUNT)} random numbers are picked everyday from 1 to 90 at 6pm."
  ];
  static const List<String> tambolatickets = [
    "Your Tambola tickets are refreshed every Monday. Each ticket comprises of 15 randomly placed numbers.",
    "Based on the daily picks, the numbers that match with your ticket get automatically crossed.",
  ];
  static const List<String> prizes = [
    "Sunday is final tally day. Once you open the game, your tickets are analysed for any winnings.",
    "If any of your tickets completes a certain category, you will be marked eligible for that reward!",
    "If more than 1 player wins that category, the prize money gets divided amongst the winners.",
  ];

  List<Widget> generatePoints(List<String> points) {
    return points
        .map(
          (e) => Container(
            width: SizeConfig.screenWidth,
            margin: EdgeInsets.symmetric(
                vertical: 10, horizontal: SizeConfig.blockSizeHorizontal * 3),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    e,
                    style: TextStyle(fontSize: SizeConfig.mediumTextSize),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeBackground(
        child: Column(
          children: [
            FelloAppBar(
              leading: FelloAppBarBackButton(),
              title: "Walkthrough",
              actions: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: InkWell(
                    child: SvgPicture.asset("images/support-log.svg",
                        width: SizeConfig.padding24, color: Colors.white),
                    onTap: () {
                      HapticFeedback.vibrate();
                      AppState.delegate.appState.currentAction = PageAction(
                          state: PageState.addPage, page: SupportPageConfig);
                    },
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeConfig.roundness40),
                        topRight: Radius.circular(SizeConfig.roundness40)),
                    color: Colors.white),
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.pageHorizontalMargins),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      child: Text(
                        "The Daily Picks",
                        style: GoogleFonts.montserrat(
                          fontSize: SizeConfig.title3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    PicksCardView(
                      isForDemo: true,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(children: generatePoints(dailyPicks)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding12),
                            child: Text(
                              "The Daily Picks",
                              style: GoogleFonts.montserrat(
                                fontSize: SizeConfig.title3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Image.asset(
                            Assets.tambolaWalkthrough,
                            width: SizeConfig.screenWidth,
                            fit: BoxFit.cover,
                          ),
                          Column(children: generatePoints(tambolatickets)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              "How to Win",
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Column(children: generatePoints(prizes)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
