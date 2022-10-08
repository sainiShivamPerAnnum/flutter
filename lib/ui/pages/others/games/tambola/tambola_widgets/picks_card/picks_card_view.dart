import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/tambola-global/weekly_picks.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/current_picks.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_vm.dart';
import 'package:felloapp/ui/widgets/helpers/height_adaptive_pageview.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class PicksCardView extends StatelessWidget {
  final TextStyle selectedTextStyle =
      TextStyles.sourceSansSB.body1.colour(UiConstants.titleTextColor);

  final TextStyle unselectedTextStyle = TextStyles.sourceSansSB.body1
      .colour(UiConstants.titleTextColor.withOpacity(0.6));

  @override
  Widget build(BuildContext context) {
    return BaseView<PicksCardViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(
            //         horizontal:
            //             SizeConfig.pageHorizontalMargins + SizeConfig.padding2),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               "Picks",
            //               style: TextStyles.rajdhaniSB.body0,
            //             ),
            //             Text(
            //               model.isShowingAllPicks
            //                   ? "Drawn everyday at 6pm"
            //                   : "Drawn at 6pm",
            //               style: TextStyles.sourceSans.body4
            //                   .colour(UiConstants.kTextColor2),
            //             ),
            //           ],
            //         ),
            //         TextButton(
            //           onPressed: () {
            //             model.onTap();
            //           },
            //           child: Padding(
            //             padding: EdgeInsets.only(
            //               right: SizeConfig.padding12,
            //               bottom: SizeConfig.padding12,
            //             ),
            //             child: Row(
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 Padding(
            //                   padding:
            //                       EdgeInsets.only(top: SizeConfig.padding2),
            //                   child: Text(
            //                     model.isShowingAllPicks ? "Weekly" : "Today",
            //                     style: TextStyles.rajdhaniSB.body2,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Container(
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                color: UiConstants.accentColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.roundness12),
                ),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 5,
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: Offset(4, 4),
                  )
                ],
              ),
              margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins,
              ),
              padding: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => model.switchTab(0),
                          child: Text(
                            "Today's Pick",
                            style: model.tabNo == 0
                                ? selectedTextStyle
                                : unselectedTextStyle, // TextStyles.sourceSansSB.body1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () => model.switchTab(1),
                          child: Text(
                            'Weekly Picks',
                            style: model.tabNo == 1
                                ? selectedTextStyle
                                : unselectedTextStyle, // style: TextStyles.sourceSansSB.body1,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: 5,
                        width: model.tabPosWidthFactor,
                      ),
                      Container(
                        color: UiConstants.kTabBorderColor,
                        height: 5,
                        width: SizeConfig.screenWidth / 2 -
                            SizeConfig.pageHorizontalMargins * 2,
                      )
                    ],
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInCubic,
                    height: model.tabNo == 0
                        ? SizeConfig.padding32
                        : SizeConfig.padding16,
                  ),
                  HeightAdaptivePageView(
                    controller: model.pageController,
                    onPageChanged: (int page) {
                      model.switchTab(page);
                    },
                    children: [
                      CurrentPicks(
                        isTambolaCard: false,
                        dailyPicksCount: model.dailyPicksCount,
                        todaysPicks: model.todaysPicks != null
                            ? model.todaysPicks
                            : List.generate(
                                model.dailyPicksCount, (index) => 0),
                      ),
                      model.weeklyDigits == null
                          ? Center(
                              child: Text(
                                'This week\'s picks are currently unavailable',
                                style: TextStyles.sourceSansSB.body2.colour(
                                    UiConstants.kWinnerPlayerLightPrimaryColor),
                              ),
                            )
                          : WeeklyPicks(
                              weeklyDraws: model.weeklyDigits,
                            )
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
