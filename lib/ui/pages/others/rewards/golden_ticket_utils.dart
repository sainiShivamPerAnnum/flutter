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
  final TextStyle titleStyle;
  GoldenTicketGridItemCard({@required this.ticket, @required this.titleStyle});
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
          : RedeemedGoldenScratchCard(ticket: ticket, titleStyle: titleStyle),
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
              image: AssetImage("assets/images/gtbg.png"), fit: BoxFit.cover),
        ),
        height: SizeConfig.screenWidth * 0.6,
        width: SizeConfig.screenWidth * 0.6,
      ),
    );
  }
}

class RedeemedGoldenScratchCard extends StatelessWidget {
  final GoldenTicket ticket;
  final TextStyle titleStyle;
  RedeemedGoldenScratchCard({@required this.ticket, @required this.titleStyle});
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
          child: Stack(
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.6,
                height: SizeConfig.screenWidth * 0.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Spacer(flex: 1),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Image.asset(Assets.logoShortform,
                          color: UiConstants.tertiarySolid.withOpacity(0.1)),
                    ),
                    Spacer(flex: 7),
                  ],
                ),
              ),
              Container(
                width: SizeConfig.screenWidth * 0.6,
                height: SizeConfig.screenWidth * 0.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Spacer(flex: 2),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 3,
                      child: Image.asset(
                        Assets.felloRewards,
                        // width: SizeConfig.screenWidth * 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(getRewardText(ticket.rewardArr),
                              style: titleStyle),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  String getRewardText(List<Reward> rewards) {
    if (rewards == null || rewards.isEmpty) {
      return "Better Luck Next Time";
    } else if (rewards.length == 1) {
      if (rewards[0].type == "rupee")
        return "You've won ₹${rewards[0].value}";
      else if (rewards[0].type == "flc")
        return "You've won ${rewards[0].value} Fello tokens";
    } else {
      return "You've won ₹${rewards.firstWhere((e) => e.type == 'rupee').value ?? '0'} and ${rewards.firstWhere((e) => e.type == 'flc').value ?? '0'} Fello tokens";
    }
    return "";
  }
}
