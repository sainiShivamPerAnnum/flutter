import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/power_play/leaderboard/prediction_leaderboard_view.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/power_play_bg.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompletedMatchDetailsView extends StatelessWidget {
  const CompletedMatchDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PowerPlayBackgroundUi(
      child: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Column(
          children: [
            const FAppBar(
              showAvatar: false,
              showCoinBar: false,
            ),
            SvgPicture.network(
              Assets.powerPlayMain,
              height: SizeConfig.screenWidth! * 0.2,
            ),
            const PowerPlayTotalWinWidget(),
            const WinTextWidget(),
            const CustomDivider(),
            MatchBriefDetailsWidget(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding40),
            ),
            const UserPredictionsButton(),
            Expanded(
              child: Container(
                width: SizeConfig.screenWidth,
                margin: EdgeInsets.only(
                  top: SizeConfig.pageHorizontalMargins,
                  right: SizeConfig.pageHorizontalMargins,
                  left: SizeConfig.pageHorizontalMargins,
                ),
                child: Column(children: [
                  Text(
                    "Correct Predictors of the Match",
                    style: TextStyles.sourceSansB.title5,
                  ),
                  SizedBox(height: SizeConfig.padding16),
                  Row(
                    children: [
                      SizedBox(
                        width: SizeConfig.screenWidth! * 0.13,
                        child: Text(
                          "#Rank",
                          style: TextStyles.sourceSans.body3
                              .colour(Colors.white38),
                        ),
                      ),
                      Text(
                        "Username",
                        style:
                            TextStyles.sourceSans.body3.colour(Colors.white38),
                      ),
                      const Spacer(),
                      Text(
                        "Prediction",
                        style:
                            TextStyles.sourceSans.body3.colour(Colors.white38),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: 4,
                      itemBuilder: (ctx, i) => Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.padding10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: SizeConfig.screenWidth! * 0.13,
                              child: Text(
                                "#$i",
                                style: TextStyles.sourceSansSB.body1,
                              ),
                            ),
                            Expanded(
                                child: Row(
                              children: [
                                CircleAvatar(
                                  radius: SizeConfig.iconSize1,
                                  backgroundColor: Colors.black,
                                ),
                                SizedBox(width: SizeConfig.padding10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "@qwertyuiop",
                                        style: TextStyles.sourceSans.body3,
                                      ),
                                      SizedBox(height: SizeConfig.padding2),
                                      Text(
                                        "won ₹120 worth of digital gold",
                                        style: TextStyles.sourceSans.body3,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                            SizedBox(width: SizeConfig.padding10),
                            Text(
                              "₹120 | 5:56 PM",
                              style: TextStyles.sourceSans.body3,
                            )
                          ],
                        ),
                      ),
                      separatorBuilder: (ctx, i) => (i == 3)
                          ? const SizedBox()
                          : const Divider(
                              color: Colors.white30,
                              thickness: 0.3,
                            ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "View All Winners",
                        style: TextStyles.sourceSans.body2.underline,
                      ))
                ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.pageHorizontalMargins,
                  right: SizeConfig.pageHorizontalMargins,
                  bottom: SizeConfig.pageHorizontalMargins),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                onPressed: () {},
                child: Center(
                  child: Text(
                    'INVITE FRIENDS',
                    style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserPredictionsButton extends StatelessWidget {
  const UserPredictionsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      padding: EdgeInsets.only(
        left: SizeConfig.pageHorizontalMargins,
        right: SizeConfig.padding12,
        top: SizeConfig.padding12,
        bottom: SizeConfig.padding12,
      ),
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Your Predictions (5)", style: TextStyles.sourceSans.body2),
          const Icon(
            Icons.navigate_next_rounded,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.white70,
      thickness: 0.3,
      indent: SizeConfig.pageHorizontalMargins,
      endIndent: SizeConfig.pageHorizontalMargins,
    );
  }
}

class WinTextWidget extends StatelessWidget {
  const WinTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        SizeConfig.pageHorizontalMargins,
      ),
      child: Column(
        children: [
          Text(
            "CONGRATULATIONS",
            style: TextStyles.sourceSansB.title4.letterSpace(1).copyWith(
              shadows: [
                BoxShadow(
                  color: const Color(0xffF79780),
                  offset: Offset(
                    0,
                    SizeConfig.padding4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.padding16),
          Text(
            "You won ₹192 in Digital Gold",
            textAlign: TextAlign.center,
            style:
                TextStyles.sourceSansB.title5.colour(UiConstants.primaryColor),
          )
        ],
      ),
    );
  }
}

class PowerPlayTotalWinWidget extends StatelessWidget {
  const PowerPlayTotalWinWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.black.withOpacity(0.7),
      ),
      child: Text(
        'Total Won From PowerPlay : ₹100',
        style: TextStyles.sourceSansSB.body2,
      ),
    );
  }
}
