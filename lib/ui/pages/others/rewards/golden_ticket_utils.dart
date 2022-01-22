import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';

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
      child: ticket.redeemedTimestamp == null
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
          image: DecorationImage(
              image: AssetImage(Assets.gtCover), fit: BoxFit.cover),
        ),
        height: SizeConfig.screenWidth * 0.6,
        width: SizeConfig.screenWidth * 0.6,
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
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        ),
        child: AnimatedContainer(
          height: SizeConfig.screenWidth * 0.6,
          width: SizeConfig.screenWidth * 0.6,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          decoration: BoxDecoration(
            color: UiConstants.tertiaryLight,
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
          ),
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ticket.isRewarding ? Assets.gtWon : Assets.gtLose,
                height: width == SizeConfig.screenWidth * 0.6
                    ? width * 0.5
                    : width * 0.6,
              ),
              SizedBox(
                  height: width == SizeConfig.screenWidth * 0.6
                      ? width * 0.04
                      : width * 0.08),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: getGTContent(
                        ticket, titleStyle, subtitleStyle, titleStyle2)),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget getGTContent(GoldenTicket ticket, TextStyle titleStyle,
      TextStyle subtitleStyle, TextStyle titleStyle2) {
    if (ticket.isRewarding) {
      //CHECK FOR REWARDS
      if (ticket.rewardArr.length == 1) {
        //Has a single reward
        return Column(
          children: [
            singleRewardWidget(ticket.rewardArr[0], titleStyle, titleStyle2),
            SizedBox(height: SizeConfig.padding2),
            Text(
              "WON",
              style: subtitleStyle,
            )
          ],
        );
      } else if (ticket.rewardArr.length == 2) {
        //Both flc and cash
        return Column(
          children: [
            doubleRewardWidget(ticket.rewardArr, titleStyle, titleStyle2),
            SizedBox(height: SizeConfig.padding2),
            Text(
              "WON",
              style: subtitleStyle,
            )
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
            .firstWhere((e) => e.type == 'rupee', orElse: () => null)
            .value ??
        0;
    int flc =
        rewards.firstWhere((e) => e.type == 'flc', orElse: () => null).value ??
            0;
    return RichText(
      text: TextSpan(
          text: '₹ ',
          style: titleStyle2.colour(Colors.black),
          children: [
            TextSpan(text: "$rupee", style: textStyle.bold),
            TextSpan(text: " and "),
            TextSpan(text: "$flc ", style: textStyle.bold),
            TextSpan(text: flc > 1 ? "Tokens" : "Token")
          ]),
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
