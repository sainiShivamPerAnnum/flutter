import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/alert_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BadgeUnlockDialog extends StatelessWidget {
  const BadgeUnlockDialog({super.key, this.unlockBadgeData});

  final AlertModel? unlockBadgeData;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        return true;
      },
      child: Dialog(
        backgroundColor: const Color(0xFF3C3C3C),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Colors.white.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        ),
        child: Container(
          width: SizeConfig.screenWidth! * 0.9,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding22, vertical: SizeConfig.padding28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.network(
                unlockBadgeData?.imageUrl ??
                    "https://d37gtxigg82zaw.cloudfront.net/revamped-referrals/rupee-coin.svg",
                height: SizeConfig.padding104,
                width: SizeConfig.padding188,
              ),
              SizedBox(height: SizeConfig.padding28),
              unlockBadgeData!.title!.beautify(
                style: TextStyles.rajdhaniSB.title4.colour(
                  Colors.white,
                ),
                alignment: TextAlign.center,
                boldStyle: TextStyles.rajdhaniSB.title4.colour(
                  const Color(0xFFFFD979),
                ),
              ),
              SizedBox(height: SizeConfig.padding8),
              Text(
                unlockBadgeData?.subtitle ?? "",
                style: TextStyles.sourceSans.body3.colour(
                  const Color(0xFFBDBDBE),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.padding36),
              AppPositiveBtn(
                btnText: unlockBadgeData?.ctaText ?? "Claim",
                onPressed: () {
                  locator<UserService>().referralFromNotification = true;
                  AppState.backButtonDispatcher?.didPopRoute();
                  AppState.delegate!
                      .parseRoute(Uri.parse(unlockBadgeData!.actionUri!));

                  locator<AnalyticsService>().track(
                    eventName:
                        AnalyticsEvents.claimRewardNowReferralAlertTapped,
                    properties: {
                      'reward amount': unlockBadgeData?.misc?.amount,
                      'User type': unlockBadgeData?.misc?.userType
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
