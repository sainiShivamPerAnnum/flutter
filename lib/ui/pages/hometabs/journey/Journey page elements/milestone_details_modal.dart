import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/skip_milestone_modal.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum JOURNEY_MILESTONE_STATUS { COMPLETED, INCOMPLETE, ACTIVE }

class JourneyMilestoneDetailsModalSheet extends StatelessWidget {
  final MilestoneModel milestone;
  final JOURNEY_MILESTONE_STATUS status;
  final double scaleFactor = 2.5;
  final double pageHeight = SizeConfig.screenWidth * 2.165;
  JourneyMilestoneDetailsModalSheet(
      {@required this.milestone, @required this.status});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        log("Milestone details Modalsheet closed");
        AppState.screenStack.removeLast();
        return Future.value(true);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeConfig.roundness24),
                topLeft: Radius.circular(SizeConfig.roundness24)),
            color: UiConstants.gameCardColor),
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins * 2),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                width: SizeConfig.screenWidth,
                child: Stack(
                  children: [
                    if (milestone.shadow != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: SizeConfig.padding54,
                          alignment: Alignment.bottomCenter,
                          child: SourceAdaptiveAssetView(
                            asset: milestone.shadow.asset,
                            height: SizeConfig.screenWidth *
                                0.2 *
                                (milestone.shadow.asset.height /
                                    milestone.asset.height),
                            width: SizeConfig.screenWidth *
                                0.2 *
                                (milestone.shadow.asset.width /
                                    milestone.asset.width),
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: Offset(0, -SizeConfig.padding54),
                        child: SourceAdaptiveAssetView(
                          asset: milestone.asset,
                          height: SizeConfig.screenWidth * 0.2,
                          width: SizeConfig.screenWidth * 0.2,
                        ),
                      ),
                    ),
                    if (status == JOURNEY_MILESTONE_STATUS.COMPLETED)
                      Positioned(
                          bottom: SizeConfig.padding40,
                          left: SizeConfig.screenWidth / 2 -
                              SizeConfig.pageHorizontalMargins * 2,
                          child: MileStoneCheck())
                  ],
                ),
              ),
              Text(
                "Milestone ${milestone.index}",
                style: TextStyles.sourceSansL.body3,
              ),
              SizedBox(height: SizeConfig.padding4),
              Text(
                milestone.steps.first.title,
                style: TextStyles.rajdhaniSB.title4.colour(Colors.white),
              ),
              SizedBox(height: SizeConfig.padding12),
              Text(
                status == JOURNEY_MILESTONE_STATUS.COMPLETED
                    ? "Wohoo, you completed this milestone"
                    : milestone.steps.first.subtitle,
                style: TextStyles.body3.colour(Colors.grey.withOpacity(0.6)),
              ),
              SizedBox(height: SizeConfig.padding24),
              if (status == JOURNEY_MILESTONE_STATUS.COMPLETED)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.padding24),
                    Text(
                      "YOU WON",
                      style:
                          TextStyles.body3.colour(Colors.grey.withOpacity(0.6)),
                    ),
                    SizedBox(height: SizeConfig.padding4),
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              Assets.aFelloToken,
                              height: SizeConfig.padding20,
                              width: SizeConfig.padding20,
                            ),
                            SizedBox(width: SizeConfig.padding4),
                            Text(
                              "200",
                              style: TextStyles.rajdhaniSB.body1,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.padding24),
                  ],
                ),
              SizedBox(height: SizeConfig.padding24),
              status == JOURNEY_MILESTONE_STATUS.COMPLETED
                  ? SizedBox()
                  // AppPositiveBtn(
                  //     btnText: "Next Milestone",
                  //     onPressed: () {
                  //       AppState.backButtonDispatcher.didPopRoute();
                  //     },
                  //     width: SizeConfig.screenWidth)
                  : status == JOURNEY_MILESTONE_STATUS.ACTIVE
                      ? Column(
                          children: [
                            AppPositiveBtn(
                                btnText: "Let's Go",
                                onPressed: () {
                                  AppState.backButtonDispatcher.didPopRoute();
                                  AppState.delegate.parseRoute(
                                      Uri.parse(milestone.actionUri));
                                },
                                width: SizeConfig.screenWidth),
                            if (milestone.index != 2)
                              Container(
                                width: SizeConfig.screenWidth,
                                alignment: Alignment.center,
                                child: TextButton(
                                  child: Text(
                                    "SKIP MILESTONE",
                                    style: TextStyles.sourceSansL.body3
                                        .colour(Colors.white),
                                  ),
                                  onPressed: () {
                                    AppState.screenStack
                                        .add(ScreenItem.modalsheet);
                                    log("Current Screen Stack: ${AppState.screenStack}");
                                    return showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      isDismissible: true,
                                      enableDrag: false,
                                      useRootNavigator: true,
                                      context: context,
                                      builder: (ctx) {
                                        return SkipMilestoneModalSheet(
                                            milestone: milestone);
                                      },
                                    );
                                  },
                                ),
                              ),
                          ],
                        )
                      : SizedBox(),
              SizedBox(
                  height: SizeConfig.viewInsets.bottom +
                      (SizeConfig.padding24 - SizeConfig.viewInsets.bottom)
                          .abs())
            ]),
      ),
    );
  }
}
