import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferEarnCard extends StatelessWidget {
  const ReferEarnCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final S locale = locator<S>();

    return Consumer<ReferralService>(
      builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            Haptic.vibrate();

            AppState.delegate!.appState.currentAction = PageAction(
              state: PageState.addPage,
              page: ReferralDetailsPageConfig,
            );

            locator<AnalyticsService>().track(
              eventName: AnalyticsEvents.referTappedFromAccount,
              properties: {
                'referral code': model.refCode,
              },
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding24,
              vertical: SizeConfig.padding24,
            ),
            decoration: ShapeDecoration(
              color: const Color(0xFF6052A9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0xFF222226),
                  blurRadius: 20,
                  offset: Offset(0, 14),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Refer ',
                                style: TextStyles.rajdhaniB.title1
                                    .colour(Colors.white),
                              ),
                              TextSpan(
                                text: "& Earn",
                                // "${(AppConfig.getValue(AppConfigKey.revamped_referrals_config)?['rewardValues']?['invest1k'] ?? 50) + (AppConfig.getValue(AppConfigKey.revamped_referrals_config)?['rewardValues']?['invest10kflo12'] ?? 450)}\n",
                                style: TextStyles.rajdhaniB.title1.colour(
                                  const Color(0xFFFFD979),
                                ),
                              ),
                              // TextSpan(
                              //   text: 'per Referral',
                              //   style:
                              //       TextStyles.rajdhaniB.title3.colour(Colors.white),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.padding6,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth! * 0.44,
                          child:
                              'Earn *₹${(AppConfig.getValue(AppConfigKey.revamped_referrals_config)?['rewardValues']?['invest1k'] ?? 50) + (AppConfig.getValue(AppConfigKey.revamped_referrals_config)?['rewardValues']?['invest10kflo12'] ?? 450)}* when your friend saves in 12% Flo'
                                  .beautify(
                            style: TextStyles.sourceSans.body2
                                .colour(Colors.white.withOpacity(0.8)),
                            boldStyle: TextStyles.sourceSansB.body2.colour(
                              const Color(0xFFFFD979),
                            ),
                          ),
                        )
                      ],
                    ),
                    SvgPicture.network(
                        'https://d37gtxigg82zaw.cloudfront.net/revamped-referrals/icon.svg',
                        height: SizeConfig.padding80),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding22,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding12,
                          vertical: SizeConfig.padding6),
                      decoration: BoxDecoration(
                        color: UiConstants.kArrowButtonBackgroundColor,
                        borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig.roundness8)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            model.refCode,
                            style: TextStyles.rajdhaniEB.title2
                                .colour(Colors.white),
                          ),
                          SizedBox(
                            width: SizeConfig.padding24,
                          ),
                          GestureDetector(
                            onTap: () {
                              model.copyReferCode();
                            },
                            child: Row(
                              children: [
                                Text(locale.copy,
                                    style: TextStyles.sourceSans.body3.colour(
                                        UiConstants.kTextColor3
                                            .withOpacity(0.7))),
                                SizedBox(
                                  width: SizeConfig.padding6,
                                ),
                                Icon(
                                  Icons.copy,
                                  color:
                                      UiConstants.kTextColor3.withOpacity(0.7),
                                  size: SizeConfig.padding24,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.padding20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final referralService = locator<ReferralService>();

                        String message = (referralService.shareMsg ??
                                'Hey I am gifting you ₹${AppConfig.getValue(AppConfigKey.referralBonus)} and ${AppConfig.getValue(AppConfigKey.referralBonus)} gaming tokens. Lets start saving and playing together! Share this code: *${referralService.refCode}* with your friends.\n') +
                            (referralService.referralShortLink ?? "");

                        if (!await canLaunchUrl(
                          Uri.parse('https://wa.me/?text=$message'),
                        )) {
                          BaseUtil.showNegativeAlert('Whatsapp not installed',
                              'Please install whatsapp to share referral link');
                          return;
                        }

                        await launchUrl(
                          Uri.parse('https://wa.me/?text=$message'),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Container(
                        width: SizeConfig.padding54,
                        height: SizeConfig.padding48,
                        padding: EdgeInsets.all(SizeConfig.padding16),
                        decoration: BoxDecoration(
                          color: UiConstants.kArrowButtonBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          'assets/vectors/whatsapp.svg',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
