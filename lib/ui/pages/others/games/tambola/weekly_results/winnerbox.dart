import 'dart:math';

import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WinnerBox extends StatelessWidget {
  final Map<String, int> winningsmap;

  const WinnerBox({Key key, this.winningsmap}) : super(key: key);
  getValue(int val) {
    switch (val) {
      case 0:
        return "Corners";
        break;
      case 1:
        return "Top Row";
        break;
      case 2:
        return "Middle Row";
        break;
      case 3:
        return "Bottom Row";
        break;
      case 4:
        return "Full House";
        break;
    }
  }

  getWinningTicketTiles() {
    List<Color> colorList = [
      UiConstants.tertiarySolid,
      UiConstants.primaryColor,
      Color(0xff11192B)
    ];
    List<Widget> ticketTiles = [];
    winningsmap.forEach((key, value) {
      ticketTiles.add(Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border:
                  Border.all(color: UiConstants.kFAQsAnswerColor, width: 0.5),
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConfig.roundness12)),
            ),
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding14,
                horizontal: SizeConfig.padding24),
            margin: EdgeInsets.only(bottom: SizeConfig.padding12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Category",
                      style: TextStyles.sourceSans.body4
                          .colour(UiConstants.kFAQsAnswerColor),
                    ),
                    SizedBox(
                      height: SizeConfig.padding10,
                    ),
                    Text(
                      getValue(value),
                      style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                    )
                  ],
                ),
                Container(
                  width: 0.5,
                  height: SizeConfig.screenWidth * 0.15,
                  color: UiConstants.kFAQsAnswerColor,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CashPrize",
                      style: TextStyles.sourceSans.body4
                          .colour(UiConstants.kFAQsAnswerColor),
                    ),
                    SizedBox(
                      height: SizeConfig.padding10,
                    ),
                    Text(
                      "₹ 25,000", //TODO
                      style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding20,
                horizontal: SizeConfig.padding24),
            decoration: BoxDecoration(
              color: UiConstants.gameCardColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConfig.roundness12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tokens Won",
                  style: TextStyles.sourceSans.body4
                      .colour(UiConstants.kFAQsAnswerColor),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.token,
                      width: SizeConfig.padding16,
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    Text(
                      "100", //TODO
                      style: TextStyles.sourceSansSB.body3.colour(Colors.white),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
        ],
      ));
    });
    return ticketTiles;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: getWinningTicketTiles());
  }
}
