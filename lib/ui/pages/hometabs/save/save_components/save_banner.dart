import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/ui/modals_sheets/happy_hour_modal.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/draw_time_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/timer_utill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HappyHourBanner extends StatefulWidget {
  HappyHourBanner({Key? key, required this.model}) : super(key: key);
  final HappyHourCampign model;
  @override
  State<HappyHourBanner> createState() =>
      _HappyHourBannerState(endTime: DateTime.parse(model.data!.endTime!));
}

class _HappyHourBannerState extends TimerUtil<HappyHourBanner> {
  _HappyHourBannerState({required DateTime endTime}) : super(endTime: endTime);

  @override
  void closeTimer() {
    Provider.of<RootViewModel>(context, listen: false).setShowHappyHour(false);
    super.closeTimer();
  }

  String getDateTime() {
    String time = "";
    if (inHours != "00") {
      time = time + inHours + ":";
    }

    return time + inMinutes + ":" + inSeconds;
  }

  @override
  Widget buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator<BaseUtil>().openDepositOptionsModalSheet();
        locator<MixpanelAnalytics>().track(
                            eventName: "Happy Hour CTA Tapped ",
                            properties: {
                              "Reward": {
                                "asset": locator<HappyHourCampign>()
                                        .data
                                        ?.rewards
                                        ?.first
                                        .type ??
                                    "",
                                "amount": locator<HappyHourCampign>()
                                        .data
                                        ?.rewards
                                        ?.first
                                        .value ??
                                    "",
                                "timer": "$inHours:$inMinutes:$inSeconds"
                              }
                            });
      },
      child: SizedBox(
        height: SizeConfig.screenHeight! * 0.07,
        width: SizeConfig.screenWidth,
        child: Container(
          height: double.infinity,
          alignment: Alignment.centerLeft,
          color: Color(0xff495DB2),
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.sandTimer,
                height: 42,
                width: 42,
              ),
              SizedBox(
                width: 12,
              ),
              RichText(
                text: TextSpan(
                  text: "Happy Hour ending in ",
                  style: TextStyles.sourceSans.body3.colour(Colors.white),
                  children: [
                    TextSpan(
                        text: getDateTime(),
                        style:
                            TextStyles.sourceSansB.body3.colour(Colors.white)),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => locator<BaseUtil>().openDepositOptionsModalSheet(),
                child: Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
