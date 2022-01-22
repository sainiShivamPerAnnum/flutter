import 'package:felloapp/core/service/analytics/analytics_events.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'dart:developer';

import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/service_elements/leaderboards/referral_leaderboard.dart';
import 'package:felloapp/ui/service_elements/leaderboards/winners_leaderboard.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WinnersLeaderBoardSE extends StatelessWidget {
  final WinViewModel model;
  WinnersLeaderBoardSE({this.model});
  void switchPage(int index) {
    model.setCurrentPage = index;
  }

  final double maxScrollExtent = 0.88;
  final double minScrollExtent = 0.2;
  final double initialScrollExtent = 0.2;

  build(BuildContext context) {
    return SlidingUpPanel(
        minHeight: SizeConfig.safeScreenHeight * minScrollExtent,
        maxHeight: SizeConfig.safeScreenHeight * maxScrollExtent,
        controller: model.panelController,
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
            offset: Offset(0, -10),
          )
        ],
        color: Colors.transparent,
        panelBuilder: (myscrollController) {
          return Container(
            color: Colors.transparent,
            child: Column(
              children: [
                SvgPicture.asset(
                  Assets.clip,
                  width: SizeConfig.screenWidth,
                ),
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
                        "Game Winners",
                      ),
                      SizedBox(width: 16),
                      leaderboardChips(
                        1,
                        "Top Referrers",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: myscrollController,
                    child: model.getCurrentPage == 0
                        ? WinnerboardView()
                        : ReferralLeaderboard(),
                  ),
                )
              ],
            ),
          );
        });
  }

  leaderboardChips(int page, String text) {
    return GestureDetector(
      onTap: () => switchPage(page),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding24, vertical: SizeConfig.padding12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: model.getCurrentPage == page
              ? UiConstants.primaryColor
              : UiConstants.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(text,
            style: model.getCurrentPage == page
                ? TextStyles.body3.bold.colour(Colors.white)
                : TextStyles.body3.colour(UiConstants.primaryColor)),
      ),
    );
  }
}
