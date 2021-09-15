import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/tambola-global/prize_section.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      appBar: AppBar(
        backgroundColor: UiConstants.primaryColor,
        elevation: 2,
        shadowColor: Color(0xff0C9463).withOpacity(0.5),
        title: Text(
          "Walkthrough",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          InkWell(
            child: SvgPicture.asset("images/support-log.svg",
                height: kToolbarHeight * 0.6, color: Colors.white),
            onTap: () {
              HapticFeedback.vibrate();
              AppState.delegate.appState.currentAction =
                  PageAction(state: PageState.addPage, page: SupportPageConfig);
            },
          ),
          SizedBox(width: SizeConfig.blockSizeHorizontal)
        ],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 5, vertical: 10),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "The Daily Picks",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/Tambola/tranbg.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius:
                    BorderRadius.circular(SizeConfig.cardBorderRadius),
                gradient: LinearGradient(
                  colors: [Color(0xff34C3A7), Color(0xff4AB474)],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
              padding: EdgeInsets.all(SizeConfig.globalMargin),
              child: Column(
                children: [
                  Text(
                    "Today's Picks",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.largeTextSize,
                        fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        int.tryParse(BaseRemoteConfig.remoteConfig.getString(
                            BaseRemoteConfig.TAMBOLA_DAILY_PICK_COUNT)),
                        (index) => Random().nextInt(90),
                      )
                          .map(
                            (e) => Container(
                              height: SizeConfig.screenWidth * 0.12,
                              width: SizeConfig.screenWidth * 0.12,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  center: Alignment(-0.8, -0.6),
                                  colors: [Color(0xff515E63), Colors.black],
                                  radius: 1.0,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: SizeConfig.screenWidth * 0.09,
                                      width: SizeConfig.screenWidth * 0.09,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: SizeConfig.screenWidth * 0.12,
                                    width: SizeConfig.screenWidth * 0.12,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(8),
                                    child: FittedBox(
                                      child: Text(
                                        e.toString() ?? "-",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: SizeConfig.largeTextSize),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: SizeConfig.screenWidth * 0.12,
                                    width: SizeConfig.screenWidth * 0.12,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(8),
                                    child: FittedBox(
                                      child: Text(
                                        e.toString() ?? "-",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: SizeConfig.largeTextSize),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
            // Image.asset(
            //   "images/Tambola/w-picks.png",
            //   width: SizeConfig.screenWidth,
            // ),
            Column(children: generatePoints(dailyPicks)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Your tickets",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Image.asset(
              "images/Tambola/w-ticket.png",
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
            PrizeSection(),
            Column(children: generatePoints(prizes)),
          ],
        ),
      ),
    );
  }
}
