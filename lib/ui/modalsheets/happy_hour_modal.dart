import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/analytics/mixpanel_analytics.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/buttons/solid_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:felloapp/util/timer_utill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HappyHourModel extends StatefulWidget {
  final HappyHourCampign model;

  final bool isComingFromSave;
  const HappyHourModel({
    required this.model,
    super.key,
    this.isComingFromSave = false,
  });

  @override
  State<HappyHourModel> createState() => _HappyHourModalState(
      DateTime.parse(model.data!.endTime!),
      DateTime.parse(model.data!.startTime!));
}

enum ButtonType { save, notify }

class _HappyHourModalState extends TimerUtil<HappyHourModel> {
  _HappyHourModalState(final DateTime endTime, final DateTime startTime)
      : super(endTime: endTime, startTime: startTime);
  late bool isHappyHourEnded;
  late HappyHourType _happyHourType;
  @override
  void initState() {
    _happyHourType = widget.model.data!.happyHourType;
    isHappyHourEnded = timeRemaining.isNegative || timeRemaining.inSeconds == 0
        ? true
        : _happyHourType == HappyHourType.expired;

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
    final locale = S.of(context);

    final data = widget.model.data!;
    return WillPopScope(
      onWillPop: () async {
        await AppState.backButtonDispatcher!.didPopRoute();
        return Future.value(true);
      },
      child: SizedBox(
        height: widget.isComingFromSave
            ? SizeConfig.screenHeight! * 0.42
            : _happyHourType == HappyHourType.expired
                ? SizeConfig.screenHeight! * 0.32
                : SizeConfig.screenHeight! * 0.46,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: widget.isComingFromSave
                  ? SizeConfig.screenHeight! * 0.35
                  : _happyHourType == HappyHourType.expired
                      ? SizeConfig.screenHeight! * 0.25
                      : SizeConfig.screenHeight! * 0.39,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                color: data.bgColor!.toColor(),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    SizeConfig.roundness32,
                  ),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight! * .06,
                  ),
                  Text(
                    title,
                    style: TextStyles.sourceSansSB.body0,
                  ),
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    alignment: Alignment.center,
                    child: subtitle.beautify(
                      style: TextStyles.sourceSans.body2.colour(
                        Colors.white,
                      ),
                      alignment: TextAlign.center,
                      boldStyle: TextStyles.sourceSansSB.body2.colour(
                        const Color(0xffA5FCE7),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding4,
                  ),
                  if (_happyHourType != HappyHourType.expired) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      child: Text(
                        _happyHourType == HappyHourType.live
                            ? data.bottomSheetSubHeading!
                            : data.preBuzz!.heading,
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body3.colour(
                          Colors.white.withOpacity(.70),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (data.preBuzz!.luckyWinnersCount != 0 &&
                      _happyHourType != HappyHourType.expired) ...[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(Assets.happyhourPolygon),
                        Text(
                          data.preBuzz!.luckyWinnersCount.toString(),
                          style: TextStyles.rajdhaniB
                              .colour(const Color(0xff232326))
                              .title3,
                        ),
                      ],
                    )
                  ] else if (_happyHourType != HappyHourType.expired)
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
                                  color:
                                      const Color(0xff1F2C65).withOpacity(0.6),
                                  boxShadow: [
                                    BoxShadow(
                                      blurStyle: BlurStyle.outer,
                                      color: const Color(0xff93B5FE)
                                          .withOpacity(0.4),
                                      // spreadRadius: 2,
                                      offset: const Offset(0, -1),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  getTime((index / 2).round()),
                                  style: TextStyles.rajdhaniSB.title3.colour(
                                      isHappyHourEnded
                                          ? const Color(0xffF79780)
                                          : Colors.white),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  ":",
                                  style: TextStyles.sourceSans.body1
                                      .colour(const Color(0XFFBDBDBE)),
                                ),
                              ),
                      ),
                    ),
                  const Spacer(),
                  if (!widget.isComingFromSave)
                    type == ButtonType.save
                        ? SolidButton(
                            onPress: () {
                              AppState.backButtonDispatcher!.didPopRoute();
                              BaseUtil.openDepositOptionsModalSheet();
                              locator<MixpanelAnalytics>().track(
                                  eventName: "Happy Hour CTA Tapped ",
                                  properties: {
                                    "Reward": {
                                      "asset": widget.model.data?.rewards?.first
                                              .type ??
                                          "",
                                      "amount": widget.model.data?.rewards
                                              ?.first.value ??
                                          "",
                                      "timer": "$inHours:$inMinutes:$inSeconds"
                                    }
                                  });
                            },
                            title: data.ctaText ?? "SAVE",
                          )
                        : SolidButton(
                            onPress: () {
                              AppState.backButtonDispatcher!
                                  .didPopRoute()
                                  .then((value) {
                                if (value) {
                                  BaseUtil.showPositiveAlert(
                                      locale.happyHourNotificationSetPrimary,
                                      locale.happyHourNotificationSetSecondary);
                                }
                              });
                              locator<MixpanelAnalytics>().track(
                                  eventName: "Happy Hour Notify",
                                  properties: {
                                    "Clicked on":
                                        _happyHourType == HappyHourType.preBuzz
                                            ? "Prebuzz HH"
                                            : "After HH",
                                  });
                            },
                            title: locale.btnNotifyMe,
                          ),
                  SizedBox(
                    height: SizeConfig.padding12,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: widget.isComingFromSave
                  ? SizeConfig.screenHeight! * 0.30
                  : _happyHourType == HappyHourType.expired
                      ? SizeConfig.screenHeight! * 0.21
                      : SizeConfig.screenHeight! * 0.35,
              child: SvgPicture.asset(
                Assets.sandTimer,
                height: 90,
                width: 90,
              ),
            )
          ],
        ),
      ),
    );
  }

  ButtonType get type => _happyHourType == HappyHourType.live
      ? ButtonType.save
      : ButtonType.notify;

  String get title {
    final data = widget.model.data!;
    switch (_happyHourType) {
      case HappyHourType.preBuzz:
        return data.preBuzz!.title;
      case HappyHourType.live:
        return data.title!;

      default:
        return "Oh no! Happy hour is over";
    }
  }

  String get subtitle {
    final data = widget.model.data!;
    switch (_happyHourType) {
      case HappyHourType.preBuzz:
        return data.preBuzz!.subtitle;
      case HappyHourType.live:
        {
          final string = data.bottomSheetHeading!;
          final sa = string.replaceAll("*timer*", '*${getString}s*');
          return sa;
        }

      default:
        return "Get notified when the next happy hour is live";
    }
  }

  String get getString {
    String text = "";
    if (inHours != "00") {
      text = "$text$inHours:";
    }
    return "$text$inMinutes:$inSeconds";
  }
}
