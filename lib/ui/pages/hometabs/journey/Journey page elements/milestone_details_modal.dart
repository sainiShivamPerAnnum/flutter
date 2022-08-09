import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class JourneyMilestoneDetailsModalSheet extends StatelessWidget {
  final MilestoneModel milestone;

  JourneyMilestoneDetailsModalSheet({@required this.milestone});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        log("I am closing");
        AppState.screenStack.removeLast();
        return Future.value(true);
      },
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeConfig.roundness24),
                topLeft: Radius.circular(SizeConfig.roundness24)),
            color: Colors.black54),
        padding: EdgeInsets.only(top: SizeConfig.pageHorizontalMargins),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                // tileColor: Colors.grey.withOpacity(0.5),
                onTap: () {
                  Haptic.vibrate();
                  AppState.backButtonDispatcher.didPopRoute();
                  log(milestone.actionUri);
                  AppState.delegate.parseRoute(Uri.parse(milestone.actionUri));
                },
                leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: SizeConfig.avatarRadius * 2,
                    child: SourceAdaptiveAssetView(
                      asset: milestone.asset,
                      height: SizeConfig.avatarRadius * 1.6,
                      width: SizeConfig.avatarRadius * 1.6,
                    )),
                title: Text(
                  milestone.steps.first.title,
                  style: TextStyles.rajdhaniEB.title4.colour(Colors.white),
                ),
                subtitle: Text(
                  milestone.steps.first.subtitle,
                  style: TextStyles.body3.colour(Colors.white),
                ),
              ),
              Spacer(),
              AppPositiveBtn(
                  btnText: "Let's Go",
                  onPressed: () {
                    AppState.backButtonDispatcher.didPopRoute();
                    AppState.delegate
                        .parseRoute(Uri.parse(milestone.actionUri));
                  },
                  width: SizeConfig.screenWidth * 0.8),
              SizedBox(height: SizeConfig.padding16),
              AppNegativeBtn(
                  btnText: "SKIP",
                  onPressed: () {
                    AppState.backButtonDispatcher.didPopRoute();
                    BaseUtil.showPositiveAlert("You Skipped this level",
                        "Let's see what's on the next level");
                  },
                  width: SizeConfig.screenWidth * 0.8),
              SizedBox(
                  height: SizeConfig.viewInsets.bottom +
                      (SizeConfig.padding40 - SizeConfig.viewInsets.bottom)
                          .abs())
            ]),
      ),
    );
  }
}
