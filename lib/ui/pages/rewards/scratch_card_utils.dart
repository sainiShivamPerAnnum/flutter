import 'dart:ui';

import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomRectTween extends RectTween {
  CustomRectTween({
    required Rect? begin,
    required Rect? end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin!.left, end!.left, elasticCurveValue)!,
      lerpDouble(begin!.top, end!.top, elasticCurveValue)!,
      lerpDouble(begin!.right, end!.right, elasticCurveValue)!,
      lerpDouble(begin!.bottom, end!.bottom, elasticCurveValue)!,
    );
  }
}

class ScratchCardGridItemCard extends StatelessWidget {
  final ScratchCard ticket;
  final TextStyle titleStyle, subtitleStyle, titleStyle2;
  final double width;

  const ScratchCardGridItemCard({
    required this.ticket,
    required this.titleStyle2,
    required this.subtitleStyle,
    required this.titleStyle,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      key: Key(ticket.gtId.toString()),
      tag: ticket.timestamp.toString(),
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin, end: end);
      },
      child: ticket.redeemedTimestamp == null ||
              ticket.redeemedTimestamp ==
                  TimestampModel(seconds: 0, nanoseconds: 0)
          ? UnRedeemedGoldenScratchCard(
              isLevelChange: ticket.isLevelChange ?? false,
              width: width,
            )
          : RedeemedGoldenScratchCard(
              ticket: ticket,
              width: width,
            ),
    );
  }
}

class UnRedeemedGoldenScratchCard extends StatelessWidget {
  final bool isLevelChange;
  final double width;

  const UnRedeemedGoldenScratchCard(
      {required this.isLevelChange, required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: width,
      width: width,
      child: SvgPicture.asset(
        isLevelChange
            ? Assets.levelUpUnRedeemedScratchCardBG
            : Assets.unredemmedScratchCardBG,
        width: double.maxFinite,
        height: double.maxFinite,
        fit: BoxFit.contain,
      ),
    );
  }
}

class RedeemedGoldenScratchCard extends StatelessWidget {
  final ScratchCard? ticket;

  // final TextStyle titleStyle, subtitleStyle, titleStyle2;
  final double width;

  const RedeemedGoldenScratchCard(
      {required this.ticket, // @required this.titleStyle,
      // @required this.subtitleStyle,
      // @required this.titleStyle2,
      required this.width,
      super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SizedBox(
          child: AnimatedContainer(
            height: width,
            width: width,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            padding: EdgeInsets.all(width * 0.04),
            child: Stack(
              children: [
                SvgPicture.asset(
                  getGTBackground(ticket!),
                  width: double.maxFinite,
                  height: double.maxFinite,
                  fit: BoxFit.contain,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: constraint.maxWidth >= SizeConfig.screenWidth! * 0.5
                          ? SizeConfig.padding32
                          : 0,
                    ),
                    child: AnimatedScale(
                      scale:
                          constraint.maxWidth >= SizeConfig.screenWidth! * 0.5
                              ? 1
                              : 0.7,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeIn,
                      child: Material(
                        color: Colors.transparent,
                        child: getGTContent(ticket!, constraint.maxWidth),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String getGTBackground(ScratchCard ticket) {
    if (ticket.isRewarding!) {
      //CHECK FOR REWARDS
      if (ticket.rewardArr!.length == 1) {
        //Has a single reward

        if (ticket.rewardArr![0].type == 'flc') {
          return Assets.gt_token;
        } else {
          return Assets.gt_cashback;
        }
      } else if (ticket.rewardArr!.length == 2) {
        //Both flc and cash
        return Assets.gt_token_cashback;
      } else {
        //we ran out of predictions
        return Assets.gt_token_cashback;
      }
    } else {
      //RETURN BLNT
      return Assets.gt_none;
    }
  }

  Widget getGTContent(ScratchCard ticket, double maxWidth) {
    S locale = locator<S>();
    if (ticket.isRewarding!) {
      //CHECK FOR REWARDS
      if (ticket.rewardArr!.length == 1) {
        //Has a single reward
        return singleRewardWidget(ticket.rewardArr![0], maxWidth);
      } else if (ticket.rewardArr!.length == 2) {
        //Both flc and cash
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            doubleRewardWidget(ticket.rewardArr!),
          ],
        );
      } else {
        //we ran out of predictions
        return Wrap(
          children: List.generate(
            ticket.rewardArr!.length,
            (i) => Container(
              padding: EdgeInsets.all(SizeConfig.padding2),
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding4),
              child: bulletTiles(
                  '${ticket.rewardArr![i].type}: ${ticket.rewardArr![i].value}'),
            ),
          ),
        );
      }
    } else {
      //RETURN BLNT
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(locale.ohNo,
            style: TextStyles.rajdhaniB.title2.colour(Colors.black)),
        SizedBox(height: SizeConfig.padding2),
        Text(locale.betterLuckNextTime,
            style: TextStyles.body4.copyWith(fontSize: SizeConfig.padding12))
      ]);
    }
  }

  Widget singleRewardWidget(Reward reward, double maxWidth) {
    S locale = locator<S>();
    Widget rewardWidget;
    bool noPaddingRequired = false;
    if (reward.type == Constants.GT_REWARD_RUPEE ||
        reward.type == Constants.GT_REWARD_AMT) {
      rewardWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: '${reward.value} coins',
              style: TextStyles.rajdhaniB.title2.colour(Colors.black),
            ),
          ),
          Text(' ${locale.rewardWon}',
              style: TextStyles.body4.copyWith(fontSize: SizeConfig.padding12))
        ],
      );
    } else if (reward.type == Constants.GT_REWARD_FLC) {
      noPaddingRequired = true;
      rewardWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.token,
                width: SizeConfig.padding32,
                height: SizeConfig.padding32,
              ),
              SizedBox(
                width: SizeConfig.padding4,
              ),
              Text(
                "${reward.value} ",
                style: TextStyles.rajdhaniB.title2.colour(Colors.black),
              ),
            ],
          ),
          Text(
            reward.value! > 1 ? locale.tokensWon : locale.tokenWon,
            style: TextStyles.body4,
          )
        ],
      );
    } else if (reward.type == Constants.GT_REWARD_GOLD) {
      rewardWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.goldAsset,
            height: SizeConfig.padding64,
          ),
          RichText(
            text: TextSpan(
              style: TextStyles.rajdhani.bold
                  .colour(Colors.black)
                  .copyWith(fontSize: SizeConfig.padding20),
              children: [
                TextSpan(
                    text: " ₹ ${reward.value}",
                    style: TextStyles.rajdhaniB.title2.colour(Colors.black)),
              ],
            ),
          ),
          Text(
            "worth of Digital Gold",
            style: TextStyles.sourceSans.body4.colour(Colors.black),
          )
        ],
      );
    } else if (reward.type == Constants.GT_REWARD_TAMBOLA_TICKET) {
      rewardWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyles.rajdhani.bold
                  .colour(Colors.black)
                  .copyWith(fontSize: SizeConfig.padding20),
              children: [
                WidgetSpan(
                    child: SvgPicture.asset(
                  Assets.howToPlayAsset1Tambola,
                  width: SizeConfig.padding32,
                  height: SizeConfig.padding32,
                )),
                TextSpan(
                    text: " ${reward.value}",
                    style: TextStyles.rajdhaniB.title2.colour(Colors.black)),
              ],
            ),
          ),
          Text(
            reward.value! > 1 ? 'Tickets won' : 'Ticket won',
            style: TextStyles.sourceSans.body4.colour(Colors.black),
          )
        ],
      );
    } else {
      rewardWidget = RichText(
        text: TextSpan(
          style: TextStyles.sourceSans.body2,
          children: [
            TextSpan(
                text: "${reward.value}",
                style: TextStyles.rajdhaniB.title4.colour(Colors.black)),
            TextSpan(
              text: "${reward.type}",
            )
          ],
        ),
      );
    }

    return Padding(
        padding: maxWidth == SizeConfig.screenWidth || noPaddingRequired
            ? EdgeInsets.zero
            : EdgeInsets.only(left: SizeConfig.padding16),
        child: rewardWidget);
  }

  ListView doubleRewardWidget(
    List<Reward> rewards,
  ) {
    S locale = locator<S>();
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (ctx, i) {
          switch (rewards[i].type) {
            case Constants.GT_REWARD_RUPEE:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '₹ ${rewards[i].value}',
                      style: TextStyles.rajdhaniSB.title4.colour(Colors.black),
                    ),
                  ),
                  Text(
                    ' ${locale.rewardWon}',
                    style: TextStyles.sourceSans.body4.colour(Colors.black),
                  )
                ],
              );
            case Constants.GT_REWARD_AMT:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '₹ ${rewards[i].value}',
                      style: TextStyles.rajdhaniSB.title4.colour(Colors.black),
                    ),
                  ),
                  Text(
                    ' ${locale.rewardWon}',
                    style: TextStyles.sourceSans.body4.colour(Colors.black),
                  )
                ],
              );
            case Constants.GT_REWARD_FLC:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.token,
                        width: SizeConfig.padding24,
                        height: SizeConfig.padding24,
                      ),
                      SizedBox(
                        width: SizeConfig.padding4,
                      ),
                      Text("${rewards[i].value} ",
                          style:
                              TextStyles.rajdhaniB.title2.colour(Colors.black)),
                    ],
                  ),
                  Text(
                    ' ${locale.tokensWon}',
                    style: TextStyles.sourceSans.body4.colour(Colors.black),
                  )
                ],
              );
            case Constants.GT_REWARD_GOLD:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyles.rajdhani.bold
                          .colour(Colors.black)
                          .copyWith(fontSize: SizeConfig.padding20),
                      children: [
                        TextSpan(
                            text: "₹ ${rewards[i].value}",
                            style: TextStyles.rajdhaniB.title2
                                .colour(Colors.black)),
                      ],
                    ),
                  ),
                  Text(
                    locale.worthsOfGold,
                    style: TextStyles.sourceSans.body4.colour(Colors.black),
                  )
                ],
              );

            case Constants.GT_REWARD_TAMBOLA_TICKET:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyles.rajdhani.bold
                          .colour(Colors.black)
                          .copyWith(fontSize: SizeConfig.padding20),
                      children: [
                        WidgetSpan(
                            child: SvgPicture.asset(
                          Assets.howToPlayAsset1Tambola,
                          width: SizeConfig.padding32,
                          height: SizeConfig.padding32,
                        )),
                        TextSpan(
                            text: " ${rewards[i].value}",
                            style: TextStyles.rajdhaniB.title2
                                .colour(Colors.black)),
                      ],
                    ),
                  ),
                  Text(
                    rewards[i].value! > 1 ? 'Tickets won' : 'Ticket won',
                    style: TextStyles.sourceSans.body4.colour(Colors.black),
                  )
                ],
              );
            default:
              return const SizedBox();
          }
        },
        separatorBuilder: (ctx, i) {
          return SizedBox(height: i == 0 ? SizeConfig.padding8 : 0);
        },
        itemCount: rewards.length);
  }

  Widget bulletTiles(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(
            Icons.brightness_1,
            size: 12,
            color: UiConstants.primaryColor,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyles.body3,
          ),
        ],
      ),
    );
  }
}
