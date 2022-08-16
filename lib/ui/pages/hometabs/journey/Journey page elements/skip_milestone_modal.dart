import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/modals_sheets/recharge_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SkipMilestoneModalSheet extends StatelessWidget {
  final MilestoneModel milestone;
  SkipMilestoneModalSheet({this.milestone});

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
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.pageHorizontalMargins * 0.5,
                  right: SizeConfig.pageHorizontalMargins * 0.5,
                ),
                width: SizeConfig.screenWidth,
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () =>
                        AppState.backButtonDispatcher.didPopRoute(),
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: SizeConfig.iconSize0,
                    )),
              ),
              Container(
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Skip Milestone?",
                      style: TextStyles.rajdhaniSB.title4.colour(Colors.white),
                    ),
                    SizedBox(height: SizeConfig.padding10),
                    Text(
                      "To skip this milestone and go one level ahead, save in any of the asset",
                      style:
                          TextStyles.body3.colour(Colors.grey.withOpacity(0.6)),
                    ),
                    SizedBox(height: SizeConfig.padding40),
                    Text(
                      "Amount of Invest",
                      style:
                          TextStyles.body3.colour(Colors.grey.withOpacity(0.6)),
                    ),
                    SizedBox(height: SizeConfig.padding6),
                    Text(
                      "₹ 250",
                      style: TextStyles.rajdhaniSB.title4.colour(Colors.white),
                    ),
                    SizedBox(height: SizeConfig.padding24),
                    AppPositiveBtn(
                        btnText: "Save Now",
                        onPressed: () {
                          AppState.backButtonDispatcher.didPopRoute();
                          AppState.backButtonDispatcher.didPopRoute();
                          return BaseUtil.openModalBottomSheet(
                            addToScreenStack: true,
                            enableDrag: false,
                            hapticVibrate: true,
                            isBarrierDismissable: false,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            content: RechargeModalSheet(
                              amount: 250,
                            ),
                          );
                        },
                        width: SizeConfig.screenWidth),
                    SizedBox(
                        height: SizeConfig.viewInsets.bottom +
                            (SizeConfig.padding24 -
                                    SizeConfig.viewInsets.bottom)
                                .abs())
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
