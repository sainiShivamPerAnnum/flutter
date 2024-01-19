import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket_cost_info.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/rewards/earn_rewards/rewards_intro.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EarnRewardsDetails extends StatelessWidget {
  const EarnRewardsDetails({required this.gtService, super.key});
  final ScratchCardService gtService;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.padding32,
          ),
          GestureDetector(
              onTap: () {
                AppState.delegate!.parseRoute(Uri.parse("tambolaHome"));
              },
              child: const RewardsInfoCard()),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          IntroQuickLinks(
            gtService: gtService,
          ),
        ],
      ),
    );
  }
}

class RewardsInfoCard extends StatelessWidget {
  const RewardsInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Container(
      padding: EdgeInsets.all(SizeConfig.padding16),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                UiConstants.kSnackBarPositiveContentColor,
                UiConstants.kSnackBarPositiveContentColor.withOpacity(0.41),
              ]),
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConfig.roundness12))),
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
                            text: locale.earnRewards,
                            style: TextStyles.rajdhaniSB.body1
                                .colour(UiConstants.kTextColor)),
                        WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.chevron_right,
                              size: SizeConfig.iconSize0,
                              color: UiConstants.kTextColor,
                            )),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    locale.earnRewardsSub,
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTextColor.withOpacity(0.8)),
                  ),
                ],
              ),
              SvgPicture.asset(
                Assets.tambolaCardAsset,
                height: SizeConfig.padding52,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding25,
          ),
          Text(
            locale.earnRewardsConv,
            style: TextStyles.sourceSansB.body2,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
            child: const TambolaTicketInfo(),
          ),
          Text(
            locale.earnRewardsConvSub,
            style: TextStyles.sourceSans.body3
                .colour(UiConstants.kTextColor.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}
