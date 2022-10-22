import 'dart:math';

import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/service/notifier_services/prize_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WinnerBox extends StatelessWidget {
  final Map<String, int> winningsmap;
  final PrizesModel tPrize;

  WinnerBox({Key key, this.winningsmap, @required this.tPrize})
      : super(key: key);
  getValue(int val) {
    switch (val) {
      case 0:
        return "Corners";
        break;
      case 1:
        return "One Row";
        break;
      case 2:
        return "Two Rows";
        break;
      case 3:
        return "Full House";
        break;
    }
  }

  getTokenWonAmount(String title) {
    int flcAmount = 0;
    for (PrizesA e in tPrize.prizesA) {
      if (e.displayName == title) {
        flcAmount = e.flc;
      }
    }
    return flcAmount;
  }

  int totalFlcAmount = 0;

  getWinningTicketTiles() {
    List<Color> colorList = [
      UiConstants.tertiarySolid,
      UiConstants.primaryColor,
      Color(0xff11192B)
    ];
    List<Widget> ticketTiles = [];

    winningsmap.forEach((key, value) {
      totalFlcAmount = totalFlcAmount + getTokenWonAmount(getValue(value));
      ticketTiles.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getValue(value),
                style: TextStyles.sourceSansSB.body2.colour(Colors.white),
              ),
              Text(
                "#$key",
                style: TextStyles.sourceSansSB.body2.colour(Colors.white),
              )
            ],
          ),
          Divider(
            color: UiConstants.kFAQsAnswerColor,
            thickness: 0.1,
          ),
        ],
      ));
    });
    return ticketTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: UiConstants.kFAQsAnswerColor, width: 0.5),
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.roundness12)),
          ),
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding14, horizontal: SizeConfig.padding24),
          margin: EdgeInsets.only(bottom: SizeConfig.padding12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kFAQsAnswerColor),
                  ),
                  Text(
                    "Ticket No.",
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kFAQsAnswerColor),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: getWinningTicketTiles()),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding20,
        ),
      ],
    );
  }
}
