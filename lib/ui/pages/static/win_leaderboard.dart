import 'package:felloapp/ui/service_elements/leaderboards/referral_leaderboard.dart';
import 'package:felloapp/ui/service_elements/leaderboards/winners_leaderboard.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WinnersLeaderBoardSE extends StatefulWidget {
  @override
  State<WinnersLeaderBoardSE> createState() => _WinnersLeaderBoardSEState();
}

class _WinnersLeaderBoardSEState extends State<WinnersLeaderBoardSE> {
  int currentPage = 0;

  void switchPage(int index) {
    setState(() {
      currentPage = index;
    });
  }

  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      maxChildSize: 0.92,
      minChildSize: 0.2,
      builder: (BuildContext context, myscrollController) {
        return Container(
          child: Stack(
            children: [
              Transform.translate(
                offset: Offset(0, 20),
                child: Container(
                  color: Colors.white,
                ),
              ),
              NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                },
                child: SingleChildScrollView(
                  controller: myscrollController,
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: Offset(0, 1),
                        child: SvgPicture.asset(
                          Assets.clip,
                          width: SizeConfig.screenWidth,
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: SizeConfig.screenWidth,
                                color: Colors.white,
                                padding: EdgeInsets.only(
                                    bottom: SizeConfig.padding16,
                                    left: SizeConfig.pageHorizontalMargins),
                                child: Text(
                                  "Leaderboard",
                                  style: TextStyles.title3.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(
                              left: SizeConfig.pageHorizontalMargins,
                              bottom: SizeConfig.padding4,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                leaderboardChips(
                                  0,
                                  "Games",
                                ),
                                SizedBox(width: 16),
                                leaderboardChips(
                                  1,
                                  "Referrals",
                                ),
                              ],
                            ),
                          ),
                          currentPage == 0
                              ? WinnerboardView()
                              : ReferralLeaderboard(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget leaderboardChips(int page, String text) {
    return GestureDetector(
      onTap: () => switchPage(page),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding24, vertical: SizeConfig.padding12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: currentPage == page
              ? UiConstants.primaryColor
              : UiConstants.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(text,
            style: currentPage == page
                ? TextStyles.body3.bold.colour(Colors.white)
                : TextStyles.body3.colour(UiConstants.primaryColor)),
      ),
    );
  }
}
