import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/analytics/mixpanel_analytics.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/draw_time_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:felloapp/util/timer_utill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HappyHourModel extends StatefulWidget {
  final HappyHourCampign model;
  final bool isAfterHappyHour;
  const HappyHourModel(
      {Key? key, required this.model, required this.isAfterHappyHour})
      : super(key: key);
  @override
  State<HappyHourModel> createState() =>
      _HappyHourModalState(DateTime.parse(model.data!.endTime!));
}

class _HappyHourModalState extends TimerUtil<HappyHourModel> {
  _HappyHourModalState(final DateTime endTime) : super(endTime: endTime);

  String getTime(int index) {
    switch (index) {
      case 0:
        return widget.isAfterHappyHour ? "00" : inHours;
      case 1:
        return widget.isAfterHappyHour ? "00" : inMinutes;
      case 2:
        return widget.isAfterHappyHour ? "00" : inSeconds;
      default:
        return "";
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    final data = widget.model.data!;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: SizeConfig.screenHeight! * 0.45,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              color: UiConstants.kSaveDigitalGoldCardBg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  SizeConfig.roundness32,
                ),
              ),
              border: Border.all(color: Color(0xff93B5FE))),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight! * .1,
              ),
              Text(
                widget.isAfterHappyHour
                    ? "Happy Hour is over"
                    : data.title ?? '',
                style: TextStyles.sourceSansSB.body1,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => index % 2 == 0
                      ? Container(
                          height: SizeConfig.screenHeight! * 0.08,
                          width: SizeConfig.screenHeight! * 0.08,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff1F2C65).withOpacity(0.6),
                            boxShadow: [
                              BoxShadow(
                                blurStyle: BlurStyle.outer,
                                color: Color(0xff93B5FE).withOpacity(0.4),
                                // spreadRadius: 2,
                                offset: Offset(0, -1),
                              ),
                            ],
                          ),
                          child: Text(
                            getTime((index / 2).round()),
                            style: TextStyles.rajdhaniSB.title3.colour(
                                widget.isAfterHappyHour
                                    ? Color(0xffF79780)
                                    : Colors.white),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            ":",
                            style: TextStyles.sourceSans.body1
                                .colour(Color(0XFFBDBDBE)),
                          ),
                        ),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.03),
              Text(
                widget.isAfterHappyHour
                    ? "Missed out on the happy hour offer?"
                    : data.bottomSheetHeading ?? '',
                style: TextStyles.sourceSans.body3
                    .colour(Colors.white.withOpacity(.6)),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                widget.isAfterHappyHour
                    ? "Get notified when the next happy hour is live"
                    : data.bottomSheetSubHeading ?? '',
                style: TextStyles.sourceSans.body4
                    .colour(Colors.white.withOpacity(0.6)),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .03,
              ),
              CustomSaveButton(
                onTap: () {
                  if (!widget.isAfterHappyHour)
                    locator<BaseUtil>().openDepositOptionsModalSheet();
                  else {
                    BaseUtil.showPositiveAlert("We will notify",
                        "We will notify you before the next happy hour starts");
                    locator<MixpanelAnalytics>()
                        .track(eventName: "HappyHourNotify");
                  }
                },
                title:
                    widget.isAfterHappyHour ? "NOTIFY ME" : data.ctaText ?? '',
                color: Colors.black.withOpacity(0.5),
                showBorder: false,
                width: SizeConfig.screenWidth! * 0.3,
                height: SizeConfig.screenWidth! * 0.11,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SvgPicture.asset(
            Assets.sandTimer,
            height: 120,
            width: 120,
          ),
        )
      ],
    );
  }
}
