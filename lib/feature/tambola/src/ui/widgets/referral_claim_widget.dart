import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReferralClaimWidget extends StatelessWidget {
  const ReferralClaimWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if ((BaseUtil.referrerUserId != null ||
            BaseUtil.manualReferralCode != null) &&
        locator<UserService>().userPortfolio.absolute.balance <= 0) {
      return GestureDetector(
        onTap: () {
          BaseUtil.openDepositOptionsModalSheet(amount: 1000, timer: 0);

          locator<AnalyticsService>().track(
            eventName: AnalyticsEvents.newReferClaimTapped,
          );
        },
        child: Container(
          margin: EdgeInsets.only(
              left: SizeConfig.padding20,
              right: SizeConfig.padding20,
              top: SizeConfig.padding18),
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding16, vertical: SizeConfig.padding10),
          height: SizeConfig.padding52,
          decoration: BoxDecoration(
            color: const Color(0xff323232),
            borderRadius: BorderRadius.circular(SizeConfig.padding12),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/svg/play_gift.svg',
                height: SizeConfig.padding32,
              ),
              SizedBox(width: SizeConfig.padding16),
              'Claim *₹${AppConfig.getValue(AppConfigKey.revamped_referrals_config)?['rewardValues']?['invest1k'] ?? 50}* referral bonus by saving'
                  .beautify(
                style: TextStyles.sourceSans.body2
                    .colour(Colors.white.withOpacity(0.8)),
                boldStyle: TextStyles.sourceSansB.body2.colour(
                  const Color(0xFFFFD979),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
