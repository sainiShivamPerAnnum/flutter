import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomRectTween extends RectTween {
  CustomRectTween({
    @required Rect begin,
    @required Rect end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin.left, end.left, elasticCurveValue),
      lerpDouble(begin.top, end.top, elasticCurveValue),
      lerpDouble(begin.right, end.right, elasticCurveValue),
      lerpDouble(begin.bottom, end.bottom, elasticCurveValue),
    );
  }
}

class GoldenTicketGridItemCard extends StatelessWidget {
  final GoldenTicket ticket;
  final TextStyle titleStyle, subtitleStyle, titleStyle2;
  final double width;
  GoldenTicketGridItemCard({
    @required this.ticket,
    @required this.titleStyle,
    @required this.subtitleStyle,
    @required this.titleStyle2,
    @required this.width,
  });
  @override
  Widget build(BuildContext context) {
    return Hero(
      key: Key(ticket.timestamp.toString()),
      tag: ticket.timestamp.toString(),
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin, end: end);
      },
      child: ticket.redeemedTimestamp == null ||
              ticket.redeemedTimestamp ==
                  TimestampModel(seconds: 0, nanoseconds: 0)
          ? UnRedeemedGoldenScratchCard(
              ticket: ticket,
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
  final GoldenTicket ticket;
  final double width;
  UnRedeemedGoldenScratchCard({@required this.ticket, @required this.width});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: width,
      width: width,
      child: SvgPicture.asset(
        ticket.isLevelChange
            ? Assets.levelUpUnRedeemedGoldenTicketBG
            : Assets.unredemmedGoldenTicketBG,
        width: double.maxFinite,
        height: double.maxFinite,
        fit: BoxFit.contain,
      ),
    );
  }
}

class RedeemedGoldenScratchCard extends StatelessWidget {
  final GoldenTicket ticket;
  // final TextStyle titleStyle, subtitleStyle, titleStyle2;
  final double width;
  RedeemedGoldenScratchCard(
      {@required this.ticket,
      // @required this.titleStyle,
      // @required this.subtitleStyle,
      // @required this.titleStyle2,
      @required this.width});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        print("I rebuilded");
        return Container(
          child: AnimatedContainer(
            height: width,
            width: width,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
            padding: EdgeInsets.all(width * 0.04),
            child: Stack(
              children: [
                SvgPicture.asset(
                  getGTBackground(ticket),
                  width: double.maxFinite,
                  height: double.maxFinite,
                  fit: BoxFit.contain,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: (constraint.maxWidth >= SizeConfig.screenWidth * 0.5
                          ? SizeConfig.padding32
                          : 0),
                    ),
                    child: AnimatedScale(
                      scale:
                          (constraint.maxWidth >= SizeConfig.screenWidth * 0.5
                              ? 1
                              : 0.7),
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeIn,
                      child: Material(
                        color: Colors.transparent,
                        child: getGTContent(ticket, constraint.maxWidth),
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

  String getGTBackground(GoldenTicket ticket) {
    if (ticket.isRewarding) {
      //CHECK FOR REWARDS
      if (ticket.rewardArr.length == 1) {
        //Has a single reward

        if (ticket.rewardArr[0].type == 'flc')
          return Assets.gt_token;
        else
          return Assets.gt_cashback;
      } else if (ticket.rewardArr.length == 2) {
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

  Widget getGTContent(GoldenTicket ticket, double maxWidth) {
    if (ticket.isRewarding) {
      //CHECK FOR REWARDS
      if (ticket.rewardArr.length == 1) {
        //Has a single reward
        return singleRewardWidget(ticket.rewardArr[0], maxWidth);
      } else if (ticket.rewardArr.length == 2) {
        //Both flc and cash
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            doubleRewardWidget(ticket.rewardArr),
          ],
        );
      } else {
        //we ran out of predictions
        return Wrap(
          children: List.generate(
            ticket.rewardArr.length,
            (i) => Container(
              padding: EdgeInsets.all(SizeConfig.padding2),
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding4),
              child: bulletTiles(
                  '${ticket.rewardArr[i].type}: ${ticket.rewardArr[i].value}'),
            ),
          ),
        );
      }
    } else {
      //RETURN BLNT
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Oh no..",
            style: TextStyles.rajdhaniB.title2.colour(Colors.black)),
        SizedBox(height: SizeConfig.padding2),
        Text("Better Luck Next Time",
            style: TextStyles.body4.copyWith(fontSize: SizeConfig.padding12))
      ]);
    }
  }

  Widget singleRewardWidget(Reward reward, double maxWidth) {
    Widget rewardWidget;
    bool noPaddingRequired = false;
    if (reward.type == 'rupee' || reward.type == 'amt') {
      rewardWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: '₹ ${reward.value}',
              style: TextStyles.rajdhaniB.title2.colour(Colors.black),
            ),
          ),
          Text(' rewards won!',
              style: TextStyles.body4.copyWith(fontSize: SizeConfig.padding12))
        ],
      );
    } else if (reward.type == 'flc') {
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
            reward.value > 1 ? "Tokens won!" : "Token won!",
            style: TextStyles.body4.copyWith(fontSize: SizeConfig.padding12),
          )
        ],
      );
    } else if (reward.type == 'gold') {
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
                TextSpan(
                    text: "₹ ${reward.value}",
                    style: TextStyles.rajdhaniB.title2.colour(Colors.black)),
              ],
            ),
          ),
          Text(
            "worths of Gold",
            style: TextStyles.sourceSans.body4.colour(Colors.black),
          )
        ],
      );
    } else
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

    return Padding(
        padding: maxWidth == SizeConfig.screenWidth || noPaddingRequired
            ? EdgeInsets.zero
            : EdgeInsets.only(left: SizeConfig.padding16),
        child: rewardWidget);
  }

  doubleRewardWidget(
    List<Reward> rewards,
  ) {
    int rupee = rewards
            .firstWhere((e) => e.type == 'rupee' || e.type == 'amt',
                orElse: () => null)
            .value ??
        0;
    int flc =
        rewards.firstWhere((e) => e.type == 'flc', orElse: () => null).value ??
            0;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Cashback
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: '₹ $rupee',
                  style: TextStyles.rajdhaniSB.title4.colour(Colors.black),
                  // children: [
                  //   TextSpan(
                  //       text: "$rupee",
                  //       style: TextStyles.rajdhaniB
                  //           .colour(Colors.black)
                  //           .copyWith(fontSize: SizeConfig.padding20)),
                  // ],
                ),
              ),
              Text(
                ' reward won!',
                style: TextStyles.sourceSans.body4.colour(Colors.black),
              )
            ],
          ),
        ),

        SizedBox(
          height: SizeConfig.padding4,
        ),

        //flc tokens
        Container(
          child: Column(
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
                  Text("$flc ",
                      style: TextStyles.rajdhaniB.title2.colour(Colors.black)),
                ],
              ),
              Text(
                ' Tokens Won!',
                style: TextStyles.sourceSans.body4.colour(Colors.black),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget bulletTiles(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            Icons.brightness_1,
            size: 12,
            color: UiConstants.primaryColor,
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyles.body3,
          ),
        ],
      ),
    );
  }
}
