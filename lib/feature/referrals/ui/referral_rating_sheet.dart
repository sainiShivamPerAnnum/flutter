import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/userProfile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReferralRatingSheet extends StatelessWidget {
  const ReferralRatingSheet({
    super.key,
  });

  String get title => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.revamped_referrals_config)['hero']['subtitle'];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        return true;
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding24,
          vertical: SizeConfig.padding16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff39393C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.padding16),
            topRight: Radius.circular(SizeConfig.padding16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: SizeConfig.padding90 + SizeConfig.padding6,
              height: SizeConfig.padding4,
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(SizeConfig.padding4),
              ),
            ),
            SizedBox(
              height: SizeConfig.padding26,
            ),
            Text('Enjoying Fello?',
                textAlign: TextAlign.center,
                style: TextStyles.rajdhaniSB.title4.colour(Colors.white)),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Text(
              'Invite your friends and create your community on Fello!',
              textAlign: TextAlign.center,
              style: TextStyles.sourceSans.body0.colour(
                Colors.white.withOpacity(0.8),
              ),
            ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            SvgPicture.network(
              Assets.peopleGroup,
              height: SizeConfig.padding76,
              width: SizeConfig.padding116,
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: SizeConfig.padding6,
                  height: SizeConfig.padding6,
                  // margin: EdgeInsets.only(
                  //     top: SizeConfig.padding8),
                  decoration: const ShapeDecoration(
                    color: Color(0xFF61E3C4),
                    shape: OvalBorder(),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.padding4,
                ),
                Text(
                  title,
                  style: TextStyles.body3.colour(Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            AppPositiveBtn(
              btnText: "",
              height: SizeConfig.padding56,
              onPressed: () {
                if (locator<ReferralDetailsViewModel>().isShareAlreadyClicked ==
                    false) {
                  locator<ReferralService>().shareLink();
                }

                locator<AnalyticsService>().track(
                  eventName: AnalyticsEvents.inviteFriendsTapped,
                  properties: {
                    'Amount': null,
                    "Current Balance":
                        locator<UserService>().userPortfolio.absolute.balance,
                    "tt": AnalyticsProperties.getTambolaTicketCount(),
                  },
                );
              },
              child: Text(
                'INVITE & EARN ₹500 PER REFERRAL',
                textAlign: TextAlign.center,
                style: TextStyles.rajdhaniB.body0.colour(Colors.white),
              ),
            ),
            SizedBox(
              height: SizeConfig.padding14,
            ),
          ],
        ),
      ),
    );
  }
}
