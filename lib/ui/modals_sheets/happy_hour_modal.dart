import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/analytics/mixpanel_analytics.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
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
  final bool isComingFromSave;
  const HappyHourModel(
      {Key? key,
      required this.model,
      required this.isAfterHappyHour,
      this.isComingFromSave = false})
      : super(key: key);
  @override
  State<HappyHourModel> createState() =>
      _HappyHourModalState(DateTime.parse(model.data!.endTime!));
}

class _HappyHourModalState extends TimerUtil<HappyHourModel> {
  _HappyHourModalState(final DateTime endTime) : super(endTime: endTime);
  late bool isHappyHourEnded;

  @override
  void initState() {
    isHappyHourEnded = timeRemaining.isNegative || timeRemaining.inSeconds == 0
        ? true
        : widget.isAfterHappyHour;
    super.initState();
  }

  String getTime(int index) {
    switch (index) {
      case 0:
        return isHappyHourEnded ? "00" : inHours;
      case 1:
        return isHappyHourEnded ? "00" : inMinutes;
      case 2:
        return isHappyHourEnded ? "00" : inSeconds;
      default:
        return "";
    }
  }

  @override
  void closeTimer() {
    isHappyHourEnded = true;
    super.closeTimer();
  }

  @override
  Widget buildBody(BuildContext context) {
    S locale = S.of(context);
    final data = widget.model.data!;
    return WillPopScope(
      onWillPop: () async {
        AppState.backButtonDispatcher!.didPopRoute();
        return Future.value(true);
      },
      child: SizedBox(
        height: SizeConfig.screenHeight! * 0.5,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: widget.isComingFromSave
                  ? SizeConfig.screenHeight! * 0.35
                  : SizeConfig.screenHeight! * 0.4,
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
                    height: SizeConfig.screenHeight! * .06,
                  ),
                  Text(
                    isHappyHourEnded ? locale.happyHourIsOver : data.title ?? '',
                    style: TextStyles.sourceSansSB.body0,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * .02,
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
                                    isHappyHourEnded
                                        ? Color(0xffF79780)
                                        : Colors.white),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                ":",
                                style: TextStyles.sourceSans.body1
                                    .colour(Color(0XFFBDBDBE)),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.03),
                  Flexible(
                    child: Text(
                        isHappyHourEnded
                            ? locale.missedHappyHour
                            : (data.bottomSheetHeading ?? ""),
                        textAlign: TextAlign.center,
                        style:
                            TextStyles.sourceSans.body3.colour(Colors.white)),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    isHappyHourEnded
                        ? locale.getHappyHourNotified
                        : data.bottomSheetSubHeading ?? '',
                    style: TextStyles.sourceSans.body3
                        .colour(Colors.white.withOpacity(0.6)),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * .03,
                  ),
                  if (!widget.isComingFromSave)
                    CustomSaveButton(
                      onTap: () {
                        if (!isHappyHourEnded) {
                          AppState.backButtonDispatcher!.didPopRoute();
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
                        } else {
                          AppState.backButtonDispatcher!
                              .didPopRoute()
                              .then((value) {
                            if (value)
                              BaseUtil.showPositiveAlert(
                                  locale.happyHourNotificationSetPrimary,
                                  locale.happyHourNotificationSetSecondary);
                          });
                          // locator<MixpanelAnalytics>()
                          // .track(eventName: "Happy Hour Notify");
                        }
                      },
                      title:
                          isHappyHourEnded ? locale.btnNotifyMe : data.ctaText ?? '',
                      width: SizeConfig.screenWidth! * 0.3,
                      height: SizeConfig.screenWidth! * 0.11,
                    )
                ],
              ),
            ),
            Positioned(
              bottom: widget.isComingFromSave
                  ? SizeConfig.screenHeight! * 0.3
                  : SizeConfig.screenHeight! * 0.35,
              child: SvgPicture.asset(
                Assets.sandTimer,
                height: 120,
                width: 120,
              ),
            )
          ],
        ),
      ),
    );
  }
}
