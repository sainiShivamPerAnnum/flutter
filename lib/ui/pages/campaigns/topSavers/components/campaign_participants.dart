import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/elements/helpers/height_adaptive_pageview.dart';
import 'package:felloapp/ui/pages/campaigns/topSavers/top_saver_vm.dart';
import 'package:felloapp/ui/pages/campaigns/topSavers/top_savers_new.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

final TextStyle selectedTextStyle =
    TextStyles.sourceSansSB.body1.colour(UiConstants.titleTextColor);

final TextStyle unselectedTextStyle = TextStyles.sourceSansSB.body1
    .colour(UiConstants.titleTextColor.withOpacity(0.6));

class CampaignParticipantsWidget extends StatelessWidget {
  final TopSaverViewModel model;
  CampaignParticipantsWidget({required this.model});
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return SliverToBoxAdapter(
        child: model.state == ViewState.Idle
            ? Container(
                margin: EdgeInsets.symmetric(vertical: SizeConfig.padding34),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => model.switchTab(0),
                            child: Text(
                              locale.leaderBoard,
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
                              locale.pastWinners,
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
                          width: SizeConfig.screenWidth! * 0.38,
                        )
                      ],
                    ),
                    HeightAdaptivePageView(
                      controller: model.pageController,
                      onPageChanged: (int page) {
                        model.switchTab(page);
                      },
                      children: [
                        //Current particiapnts
                        CurrentParticipantsLeaderBoard(
                          model: model,
                        ),

                        //Current particiapnts
                        PastWinnersLeaderBoard(
                          model: model,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : SizedBox.shrink());
  }
}
