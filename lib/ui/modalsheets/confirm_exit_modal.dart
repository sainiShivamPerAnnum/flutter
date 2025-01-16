import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../pages/static/app_widget.dart';

class ConfirmExitModal extends StatelessWidget {
  const ConfirmExitModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding20,
          ).copyWith(
            top: SizeConfig.padding14,
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Leaving already?',
                    style: TextStyles.sourceSansSB.body1,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      AppState.backButtonDispatcher!.didPopRoute();
                    },
                    child: Icon(
                      Icons.close,
                      size: SizeConfig.body1,
                      color: UiConstants.kTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          color: UiConstants.greyVarient,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Wait, Don’t Miss Out!",
                style: TextStyles.sourceSansM.body0.colour(Colors.white),
              ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              Text(
                "Leaving now means missing the chance to connect with certified financial advisors ready to help you achieve your goals.",
                textAlign: TextAlign.start,
                style: TextStyles.sourceSansM.body3.colour(
                  UiConstants.kTextColor5,
                ),
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              Row(
                children: [
                  AppImage(
                    Assets.tick,
                    height: SizeConfig.padding12,
                    width: SizeConfig.padding12,
                  ),
                  SizedBox(
                    width: SizeConfig.padding10,
                  ),
                  Text(
                    'First call FREE',
                    style: TextStyles.sourceSans.body3,
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              Row(
                children: [
                  AppImage(
                    Assets.tick,
                    height: SizeConfig.padding12,
                    width: SizeConfig.padding12,
                  ),
                  SizedBox(
                    width: SizeConfig.padding10,
                  ),
                  Text(
                    'SEBI- Registered and AMFI- Certfied experts',
                    style: TextStyles.sourceSans.body3,
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppImage(
                    Assets.experts,
                    width: SizeConfig.padding104,
                  ),
                  SizedBox(
                    width: SizeConfig.padding12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBar.builder(
                        initialRating: 5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        glow: false,
                        ignoreGestures: true,
                        itemSize: SizeConfig.body6,
                        unratedColor: Colors.grey,
                        itemPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding2),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: SizeConfig.body6,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      SizedBox(
                        height: SizeConfig.padding4,
                      ),
                      Text(
                        "Certified Experts You Can Trust",
                        style: TextStyles.sourceSansB.colour(
                          const Color(0xffd9d9d9).withOpacity(0.9),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
            ],
          ),
        ),
        const Divider(
          color: UiConstants.greyVarient,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding18)
              .copyWith(top: SizeConfig.padding18),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    locator<AnalyticsService>()
                        .track(eventName: "Signup Cancel - Exit Tapped");
                    SystemNavigator.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UiConstants.greyVarient,
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness8),
                    ),
                  ),
                  child: Text(
                    'Exit Anyway',
                    style: TextStyles.sourceSans.body3,
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.padding12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    locator<AnalyticsService>()
                        .track(eventName: "Signup Cancel - Continue Tapped");
                    AppState.backButtonDispatcher!.didPopRoute();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UiConstants.kTextColor,
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness8),
                    ),
                  ),
                  child: Text(
                    'Complete Sign-Up ',
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTextColor4),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: SizeConfig.padding40),
      ],
    );
  }
}
