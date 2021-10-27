import 'package:felloapp/core/enums/winner_service_enum.dart';
import 'package:felloapp/core/service/winners_service.dart';
import 'package:felloapp/ui/elements/texts/marquee_text.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class WinnersMarqueeStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<WinnerService, WinnerServiceProperties>(
      properties: [WinnerServiceProperties.winLeaderboard],
      builder: (context, WModel, properties) {
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
            infoList: WModel.winners == null || WModel.winners.isEmpty
                ? [
                    "Shourya won ₹ 1000",
                    "Manish won ₹ 2000",
                    "Shreeyash won ₹ 1200"
                        "CJ won ₹ 800"
                  ]
                : List.generate(
                    WModel.winners.length,
                    (i) =>
                        "${WModel.winners[i].username} won ₹${WModel.winners[i].amount}"),
            showBullet: true,
            bulletColor: UiConstants.tertiarySolid,
          ),
        );
      },
    );
  }
}
