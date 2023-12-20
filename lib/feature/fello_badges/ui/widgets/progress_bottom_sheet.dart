import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/action_resolver.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'badge_progress_indicator.dart';

class ProgressBottomSheet extends StatelessWidget {
  const ProgressBottomSheet({
    required this.badgeInformation,
    super.key,
  });

  final BadgeLevelInformation badgeInformation;

  void _onTap() {
    final action = badgeInformation.ctaAction;
    if (action != null) {
      ActionResolver.instance.resolve(action);
    }

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.taskBottomSheetCTA,
      properties: {
        'task_heading': badgeInformation.title,
        'task_subheading': badgeInformation.bottomSheetText,
        'progress': badgeInformation.achieve,
        'progress_bar_text': badgeInformation.progressInfo,
        'current_level': locator<UserService>().baseUser!.superFelloLevel.name,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding16, horizontal: SizeConfig.padding52),
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
            width: SizeConfig.padding100,
            height: SizeConfig.padding4,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9).withOpacity(0.4),
              borderRadius: BorderRadius.circular(SizeConfig.padding4),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          SvgPicture.network(
            badgeInformation.badgeUrl,
            width: SizeConfig.padding132,
            height: SizeConfig.padding132,
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Text(
            badgeInformation.title,
            textAlign: TextAlign.center,
            style: TextStyles.rajdhaniSB.title4,
          ),
          SizedBox(
            height: SizeConfig.padding4,
          ),
          badgeInformation.bottomSheetText.beautify(
            style: TextStyles.sourceSans.body3.colour(
              const Color(0xFFBDBDBE),
            ),
            boldStyle: TextStyles.sourceSansSB.body3.colour(
              const Color(0xFFBDBDBE),
            ),
            alignment: TextAlign.center,
          ),

          SizedBox(
            height: SizeConfig.padding12,
          ),

          // Progress indicator.
          if (badgeInformation.isBadgeAchieved)
            Text(
              'You have completed this task!',
              style: TextStyles.sourceSans.body3.colour(
                UiConstants.teal3,
              ),
            )
          else ...[
            BadgeProgressIndicator(
              achieve: badgeInformation.achieve,
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            if (badgeInformation.progressInfo.isNotEmpty) ...[
              Text(
                badgeInformation.progressInfo,
                style: TextStyles.sourceSans.body3.copyWith(
                  color: UiConstants.peach2,
                ),
              ),
            ]
          ],
          SizedBox(
            height: SizeConfig.padding18,
          ),
          SecondaryButton(
            onPressed: _onTap,
            label: badgeInformation.bottomSheetCta,
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
        ],
      ),
    );
  }
}
