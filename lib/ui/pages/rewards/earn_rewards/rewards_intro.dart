import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EarnRewardsIntro extends StatelessWidget {
  const EarnRewardsIntro({required this.gtService, super.key});
  final ScratchCardService gtService;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          SizedBox(
            height: SizeConfig.padding20,
          ),
          CachedNetworkImage(
              width: SizeConfig.screenWidth,
              fit: BoxFit.fill,
              placeholder: (context, placeholder) {
                return SizedBox(
                  height: SizeConfig.padding112,
                  child: const BlurHash(
                    hash: 'LdDb_^~T-nxaofWCR*a#9H9bIpWB',
                  ),
                );
              },
              imageUrl:
                  'https://ik.imagekit.io/9xfwtu0xm/rewards/rewards_2.png'),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          CachedNetworkImage(
              width: SizeConfig.screenWidth,
              fit: BoxFit.fill,
              placeholder: (context, placeholder) {
                return SizedBox(
                  height: SizeConfig.padding112,
                  child: const BlurHash(
                    hash: 'LC9%-Y4p~p4T-oRkxtM|4=\$xIqs,',
                  ),
                );
              },
              imageUrl:
                  'https://ik.imagekit.io/9xfwtu0xm/rewards/rewards_1.png'),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          Text(
            locale.howtoearn,
            style: TextStyles.sourceSansSB.body1,
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          CachedNetworkImage(
              height: SizeConfig.padding252,
              fit: BoxFit.fill,
              placeholder: (context, placeholder) {
                return SizedBox(
                  width: SizeConfig.screenWidth,
                  child: const BlurHash(
                    hash: 'L87MHEyC9atRc[W=EKa#VYR6NHae',
                  ),
                );
              },
              imageUrl: 'https://ik.imagekit.io/9xfwtu0xm/rewards/rewards.png'),
          SizedBox(
            height: SizeConfig.padding16,
          ),
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

class IntroQuickLinks extends StatelessWidget {
  const IntroQuickLinks({required this.gtService, super.key});
  final ScratchCardService gtService;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(
          gtService.allRewardsQuickLinks.length,
          (index) => GestureDetector(
            onTap: () {
              Haptic.vibrate();
              AppState.delegate!.parseRoute(Uri.parse(gtService
                  .allRewardsQuickLinks[index].cta![0].action!.payload!.url!));
            },
            child: EarnRewardsQuickLinks(
              image: gtService.allRewardsQuickLinks[index].imageUrl!,
              tickets:
                  gtService.allRewardsQuickLinks[index].rewardCount.toString(),
              title: gtService.allRewardsQuickLinks[index].title!,
              subTitle: gtService.allRewardsQuickLinks[index].subTitle!,
              endingSubtitle: gtService.allRewardsQuickLinks[index].rewardText!,
              rewardType: gtService.allRewardsQuickLinks[index].rewardType!,
            ),
          ),
        ),
      ],
    );
  }
}

class EarnRewardsQuickLinks extends StatelessWidget {
  const EarnRewardsQuickLinks(
      {required this.image,
      required this.title,
      required this.subTitle,
      required this.endingSubtitle,
      required this.tickets,
      required this.rewardType,
      super.key});
  final String image;
  final String title;
  final String subTitle;
  final String endingSubtitle;
  final String tickets;
  final String rewardType;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: SizeConfig.padding16),
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding18, horizontal: SizeConfig.padding16),
        decoration: BoxDecoration(
            color: UiConstants.kTambolaMidTextColor,
            border: Border.all(
                color: UiConstants.customBorderShadow.withOpacity(0.1),
                width: SizeConfig.padding1),
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.roundness12))),
        child: Row(
          children: [
            AppImage(
              image,
              height: SizeConfig.padding40,
            ),
            SizedBox(
              width: SizeConfig.padding16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: TextStyles.rajdhaniB.body1
                            .colour(UiConstants.kTextColor),
                      ),
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
                  subTitle,
                  style: TextStyles.sourceSans.body4
                      .colour(UiConstants.customSubtitle),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(endingSubtitle,
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kTextColor)),
                Row(
                  children: [
                    Text(tickets,
                        style: TextStyles.sourceSansSB.body2
                            .colour(UiConstants.kTextColor)),
                    if (rewardType == "ticket") ...[
                      SizedBox(
                        width: SizeConfig.padding8,
                      ),
                      SvgPicture.asset(
                        Assets.howToPlayAsset1Tambola,
                        height: SizeConfig.padding12,
                      )
                    ]
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
