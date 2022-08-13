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
            )
          : RedeemedGoldenScratchCard(
              ticket: ticket,
              titleStyle: titleStyle,
              titleStyle2: titleStyle2,
              width: width,
              subtitleStyle: subtitleStyle,
            ),
    );
  }
}

class UnRedeemedGoldenScratchCard extends StatelessWidget {
  final GoldenTicket ticket;
  UnRedeemedGoldenScratchCard({@required this.ticket});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: SizeConfig.screenWidth * 0.6,
      width: SizeConfig.screenWidth * 0.6,
      child: SvgPicture.asset(
        Assets.unredemmedGoldenTicketBG,
        width: double.maxFinite,
        height: double.maxFinite,
        fit: BoxFit.contain,
      ),
    );
  }
}

class RedeemedGoldenScratchCard extends StatelessWidget {
  final GoldenTicket ticket;
  final TextStyle titleStyle, subtitleStyle, titleStyle2;
  final double width;
  RedeemedGoldenScratchCard(
      {@required this.ticket,
      @required this.titleStyle,
      @required this.subtitleStyle,
      @required this.titleStyle2,
      @required this.width});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        child: AnimatedContainer(
          height: SizeConfig.screenWidth * 0.6,
          width: SizeConfig.screenWidth * 0.6,
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
                  padding: EdgeInsets.only(left: SizeConfig.padding24),
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: getGTContent(
                          ticket, titleStyle, subtitleStyle, titleStyle2)),
                ),
              ),
            ],
          ),
        ),
      );
    });
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

  Widget getGTContent(GoldenTicket ticket, TextStyle titleStyle,
      TextStyle subtitleStyle, TextStyle titleStyle2) {
    if (ticket.isRewarding) {
      //CHECK FOR REWARDS
      if (ticket.rewardArr.length == 1) {
        //Has a single reward
        return Padding(
          padding: EdgeInsets.only(left: SizeConfig.padding12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              singleRewardWidget(ticket.rewardArr[0], titleStyle, titleStyle2),
              Text('Cashback!', style: TextStyles.body4)
            ],
          ),
        );
      } else if (ticket.rewardArr.length == 2) {
        //Both flc and cash
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            doubleRewardWidget(ticket.rewardArr, titleStyle, titleStyle2),
          ],
        );
      } else {
        //we ran out of predictions
        return Wrap(
          children: List.generate(
              ticket.rewardArr.length,
              (i) => Container(
                    padding: EdgeInsets.all(SizeConfig.padding2),
                    margin:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding4),
                    child: bulletTiles(
                        '${ticket.rewardArr[i].type}: ${ticket.rewardArr[i].value}'),
                  )),
        );
      }
    } else {
      //RETURN BLNT
      return Column(children: [
        Text("Oh no..", style: titleStyle.bold),
        SizedBox(height: SizeConfig.padding2),
        Text("Better Luck Next Time", style: subtitleStyle)
      ]);
    }
  }

  Widget singleRewardWidget(
      Reward reward, TextStyle textStyle, TextStyle titleStyle2) {
    if (reward.type == 'rupee') {
      return RichText(
        text: TextSpan(
          text: '₹ ',
          style: titleStyle2.colour(Colors.black),
          children: [TextSpan(text: "${reward.value}", style: textStyle.bold)],
        ),
      );
    } else if (reward.type == 'flc') {
      return RichText(
        text: TextSpan(
          style: titleStyle2.colour(Colors.black),
          children: [
            TextSpan(text: "${reward.value} ", style: textStyle.bold),
            TextSpan(
              text: reward.value > 1 ? "Tokens" : "Token",
            )
          ],
        ),
      );
    } else if (reward.type == 'gold') {
      return RichText(
        text: TextSpan(
          style: titleStyle2.colour(Colors.black),
          children: [
            TextSpan(
              text: "₹ ",
            ),
            TextSpan(text: "${reward.value} ", style: textStyle.bold),
            TextSpan(
                text: "wortsh of Gold",
                style: TextStyles.rajdhani
                    .colour(Colors.black)
                    .copyWith(fontSize: SizeConfig.padding10))
          ],
        ),
      );
    } else
      return RichText(
          text: TextSpan(style: textStyle, children: [
        TextSpan(
            text: "${reward.value}",
            style: textStyle.bold.colour(Colors.black)),
        TextSpan(
          text: "${reward.type}",
        )
      ]));
  }

  doubleRewardWidget(
      List<Reward> rewards, TextStyle textStyle, TextStyle titleStyle2) {
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
                    text: '₹ ',
                    style: titleStyle2.colour(Colors.black),
                    children: [
                      TextSpan(text: "$rupee", style: textStyle.bold),
                    ]),
              ),
              Text(' Cashback!', style: TextStyles.body4)
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
                    Assets.newTokenAsset,
                    width: SizeConfig.padding16,
                    height: SizeConfig.padding16,
                  ),
                  SizedBox(
                    width: SizeConfig.padding4,
                  ),
                  Text("$flc ", style: textStyle.bold),
                ],
              ),
              Text(' Tokens Won!', style: TextStyles.body4)
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
