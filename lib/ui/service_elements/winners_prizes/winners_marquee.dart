import 'package:felloapp/core/enums/winner_service_enum.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/ui/elements/texts/marquee_text.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class WinnersMarqueeStrip extends StatelessWidget {
  final String type;
  final List<dynamic> winners;
  WinnersMarqueeStrip({this.type, this.winners});
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<WinnerService, WinnerServiceProperties>(
      properties: [WinnerServiceProperties.topWinners],
      builder: (context, wModel, properties) {
        return Container(
          width: SizeConfig.screenWidth,
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          height: SizeConfig.padding54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness16),
            color: UiConstants.tertiaryLight.withOpacity(0.5),
          ),
          child: MarqueeText(
            infoList: winners ??
                _getMarqueeText(
                  getTextArray(wModel),
                  winners: wModel.winners,
                ),
            showBullet: true,
            bulletColor: UiConstants.tertiarySolid,
          ),
        );
      },
    );
  }

  List<String> getTextArray(WinnerService wModel) {
    switch (type) {
      case Constants.BUG_BOUNTY:
        return wModel.bugBountyWinners;
      case Constants.NEW_FELLO_UI:
        return wModel.newFelloWinners;
      default:
        return wModel.topWinners;
    }
  }
}

List<String> _getMarqueeText(List<String> topWinners, {List<Winners> winners}) {
  if (topWinners != null && topWinners.isNotEmpty)
    return List.generate(topWinners.length, (i) => topWinners[i]);
  else if (winners != null && winners.isNotEmpty)
    return List.generate(
        winners.length,
        (i) =>
            "${winners[i].username.replaceAll('@', '.')} won ₹${winners[i].amount}");
  else
    return [
      "shravan25 won ₹ 1000",
      "thenewhulk won ₹ 2000",
      "paytmking won ₹ 1200",
      "rohitdabest won ₹ 800"
    ];
}
