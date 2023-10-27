import 'package:felloapp/core/enums/marketing_event_handler_enum.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/custom_card/custom_cards.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class DailyAppCheckInEventModalSheet extends StatelessWidget {
  const DailyAppCheckInEventModalSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return PropertyChangeProvider<MarketingEventHandlerService,
        MarketingEventsHandlerProperties>(
      value: locator<MarketingEventHandlerService>(),
      child: PropertyChangeConsumer<MarketingEventHandlerService,
          MarketingEventsHandlerProperties>(
        properties: const [MarketingEventsHandlerProperties.DailyAppCheckIn],
        builder: (context, model, child) {
          getBgColor(int i) {
            if (i == model!.currentDay) if (model.isDailyAppBonusClaimed) {
              return kCompletedDayBgColor;
            } else {
              return kCurrentDayBgColor;
            }
            else if (i > model.currentDay) {
              return kIncompleteDayBgColor;
            } else {
              return kCompletedDayBgColor;
            }
          }

          getBorder(int i) {
            if (i == model!.currentDay) if (model.isDailyAppBonusClaimed) {
              return kIncompleteDayBorderStyle;
            } else {
              return kCurrentDayBorderStyle;
            }
            else if (i > model.currentDay) {
              return kIncompleteDayBorderStyle;
            } else {
              return kCompletedDayBorderStyle;
            }
          }

          getTextColor(int i) {
            if (i == model!.currentDay) if (model.isDailyAppBonusClaimed) {
              return kCompletedDayTextColor;
            } else {
              return kCurrentDayTextColor;
            }
            else if (i > model.currentDay) {
              return kIncompleteDayTextColor;
            } else {
              return kCompletedDayTextColor;
            }
          }

          return WillPopScope(
            onWillPop: () async {
              AppState.backButtonDispatcher!.didPopRoute();
              return Future.value(true);
            },
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOutCirc,
              opacity: model!.showModalsheet ? 1 : 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(SizeConfig.roundness16),
                    topLeft: Radius.circular(SizeConfig.roundness16),
                  ),
                  color: UiConstants.kSaveDigitalGoldCardBg,
                ),
                child: Transform.translate(
                  offset: Offset(0, -SizeConfig.screenWidth! * 0.15),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(Assets.dailyAppBonusHero,
                            height: SizeConfig.screenWidth! * 0.3),
                        SizedBox(height: SizeConfig.padding10),
                        Text(
                          model.dailyAppCheckInEventData?.title ??
                              locale.dailyBonusText,
                          //model!.dailyAppCheckInEventData!.title
                          style: TextStyles.sourceSansB.title3
                              .colour(Colors.white),
                        ),
                        SizedBox(height: SizeConfig.padding12),
                        Text(
                          model.dailyAppCheckInEventData?.subtitle ??
                              locale.dailyBonusSubtitleText,
                          textAlign: TextAlign.center,
                          style: TextStyles.body2.colour(Colors.white),
                          // model.dailyAppCheckInEventData!.subtitle
                        ),
                        SizedBox(height: SizeConfig.padding20),
                        if (model
                            .dailyAppCheckInEventData!.showStreakBreakMessage)
                          Container(
                            margin:
                                EdgeInsets.only(bottom: SizeConfig.padding16),
                            child: Text(
                              model
                                  .dailyAppCheckInEventData!.streakBreakMessage,
                              textAlign: TextAlign.center,
                              style: TextStyles.body3.colour(Colors.red),
                            ),
                          ),
                        Row(
                          children: List.generate(
                            7,
                            (i) {
                              return Expanded(
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        margin:
                                            EdgeInsets.all(SizeConfig.padding4),
                                        height: SizeConfig.screenWidth! / 8,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                SizeConfig.roundness5),
                                            color: getBgColor(i),
                                            border: getBorder(i)),
                                        alignment: Alignment.center,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                locale.day,
                                                style: TextStyles
                                                    .sourceSans.body4
                                                    .colour(getTextColor(i)),
                                              ),
                                              Text(
                                                "${i + 1}",
                                                style: TextStyles
                                                    .sourceSansB.body2
                                                    .colour(getTextColor(i)),
                                              )
                                            ]),
                                      ),
                                    ),
                                    if (model.dailyAppCheckInEventData!
                                        .specialRewardPos
                                        .contains(i))
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: CircleAvatar(
                                          radius: SizeConfig.padding6,
                                          backgroundColor: Colors.yellow,
                                          child: Icon(
                                            Icons.star,
                                            color: UiConstants.kBackgroundColor,
                                            size: SizeConfig.padding10,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        if (!model.isDailyAppBonusClaimed)
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.padding14,
                                bottom: SizeConfig.padding6),
                            child: SvgPicture.asset(Assets.wohoo,
                                width: SizeConfig.screenWidth! * 0.6),
                          ),
                        if (model.isDailyAppBonusClaimed &&
                            model.currentDay == 6)
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.padding14,
                                bottom: SizeConfig.padding6),
                            child: SvgPicture.asset(Assets.dailyBonusCong,
                                width: SizeConfig.screenWidth! * 0.6),
                          ),
                        model.isDailyAppBonusClaimed
                            ? Padding(
                                padding:
                                    EdgeInsets.only(top: SizeConfig.padding24),
                                child: Text(
                                  model.dailyAppCheckInEventData
                                          ?.postClaimMessage ??
                                      locale.claimMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyles.sourceSansB.body2
                                      .colour(Colors.white),
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  text: locale.youWonA,
                                  style: TextStyles.body1.colour(Colors.white),
                                  children: [
                                    TextSpan(
                                        text: locale.scratchCard,
                                        style: TextStyles.sourceSansB.body1
                                            .colour(Colors.white))
                                  ],
                                ),
                              ),
                        SizedBox(height: SizeConfig.padding32),
                        model.isDailyAppBonusClaimInProgress
                            ? Container(
                                height: SizeConfig.screenWidth! * 0.13,
                                alignment: Alignment.center,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.black,
                                  color: kCurrentDayBgColor,
                                ),
                              )
                            : CustomSaveButton(
                                title: model.isDailyAppBonusClaimed
                                    ? locale.gotIt
                                    : locale.dayRerward(model.currentDay + 1),
                                onTap: model.isDailyAppBonusClaimed
                                    ? () => model.gotItTapped()
                                    : () => model.sudoClaimDailyReward(),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Border kCurrentDayBorderStyle =
    Border.all(width: 1, color: UiConstants.kTextColor);
Border kCompletedDayBorderStyle =
    Border.all(width: 0, color: Colors.transparent);
Border kIncompleteDayBorderStyle =
    Border.all(width: 0, color: Colors.transparent);

Color kCurrentDayBgColor = const Color(0xff2F3E81);
Color kCompletedDayBgColor = UiConstants.primaryColor;
Color kIncompleteDayBgColor = const Color(0xff2F3E81);

Color kCurrentDayTextColor = UiConstants.kTextColor;
Color kCompletedDayTextColor = UiConstants.kTextColor;
Color kIncompleteDayTextColor = UiConstants.kTextColor.withOpacity(0.7);
