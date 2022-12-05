import 'package:felloapp/core/enums/marketing_event_handler_enum.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
import 'package:felloapp/util/assets.dart';
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
    return PropertyChangeConsumer<MarketingEventHandlerService,
        MarketingEventsHandlerProperties>(
      properties: [MarketingEventsHandlerProperties.DailyAppCheckIn],
      builder: ((context, model, child) {
        getBgColor(int i) {
          if (i == model!.currentDay)
            return kCurrentDayBgColor;
          else if (i > model.currentDay)
            return kIncompleteDayBgColor;
          else
            return kCompletedDayBgColor;
        }

        getBorder(int i) {
          if (i == model!.currentDay)
            return kCurrentDayBorderStyle;
          else if (i > model.currentDay)
            return kIncompleteDayBorderStyle;
          else
            return kCompletedDayBorderStyle;
        }

        getTextColor(int i) {
          if (i == model!.currentDay)
            return kCurrentDayTextColor;
          else if (i > model.currentDay)
            return kIncompleteDayTextColor;
          else
            return kCompletedDayTextColor;
        }

        return WillPopScope(
          onWillPop: () async {
            AppState.screenStack.removeLast();
            return Future.value(true);
          },
          child: Transform.translate(
            offset: Offset(0, -SizeConfig.screenWidth! * 0.15),
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(Assets.giftGameAsset,
                      height: SizeConfig.screenWidth! * 0.35),
                  SizedBox(height: SizeConfig.padding10),
                  Text(
                    "Daily Bonus",
                    //model!.dailyAppCheckInEventData!.title
                    style: TextStyles.sourceSansB.title3.colour(Colors.white),
                  ),
                  SizedBox(height: SizeConfig.padding12),
                  Text(
                    "Open the app everyday for a week and win assured rewards",
                    textAlign: TextAlign.center,
                    style: TextStyles.body2.colour(Colors.white),
                    // model.dailyAppCheckInEventData!.subtitle
                  ),
                  SizedBox(height: SizeConfig.padding20),
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
                                  margin: EdgeInsets.all(SizeConfig.padding4),
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
                                          "Day",
                                          style: TextStyles.sourceSans.body4
                                              .colour(getTextColor(i)),
                                        ),
                                        Text(
                                          "${i + 1}",
                                          style: TextStyles.sourceSansB.body2
                                              .colour(getTextColor(i)),
                                        )
                                      ]),
                                ),
                              ),
                              if (i == 3 || i == 6)
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
                  if (!model!.isDailyAppBonusClaimed)
                    SvgPicture.asset(Assets.wohoo,
                        width: SizeConfig.screenWidth! * 0.6),
                  model.isDailyAppBonusClaimed
                      ? Padding(
                          padding: EdgeInsets.only(top: SizeConfig.padding24),
                          child: Text(
                            "Reward claimed for today, come back tomorrow for more.",
                            textAlign: TextAlign.center,
                            style: TextStyles.sourceSansB.body2
                                .colour(Colors.white),
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            text: "You have got a ",
                            style: TextStyles.body1.colour(Colors.white),
                            children: [
                              TextSpan(
                                  text: "Golden Ticket",
                                  style: TextStyles.sourceSansB.body1
                                      .colour(Colors.white))
                            ],
                          ),
                        ),
                  SizedBox(height: SizeConfig.padding54),
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
                              ? "Got it"
                              : "Claim Reward",
                          onTap: model.isDailyAppBonusClaimed
                              ? () =>
                                  AppState.backButtonDispatcher!.didPopRoute()
                              : () => model.claimDailyAppBonusReward(),
                        ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

Border kCurrentDayBorderStyle =
    Border.all(width: 1, color: UiConstants.kTextColor);
Border kCompletedDayBorderStyle =
    Border.all(width: 0, color: Colors.transparent);
Border kIncompleteDayBorderStyle =
    Border.all(width: 0, color: Colors.transparent);

Color kCurrentDayBgColor = Color(0xff2F3E81);
Color kCompletedDayBgColor = UiConstants.primaryColor;
Color kIncompleteDayBgColor = Color(0xff2F3E81);

Color kCurrentDayTextColor = UiConstants.kTextColor;
Color kCompletedDayTextColor = UiConstants.kTextColor;
Color kIncompleteDayTextColor = UiConstants.kTextColor2.withOpacity(0.5);
