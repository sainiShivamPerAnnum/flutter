import 'dart:math';

import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

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
    List<ListTile> ticketTiles = [];
    winningsmap.forEach((key, value) {
      ticketTiles.add(ListTile(
        leading: Text(
          "#$key",
          style: TextStyles.body3,
        ),
        trailing: Text(
          getValue(value),
          style: TextStyles.body3.bold
              .colour(colorList[Random().nextInt(colorList.length)]),
        ),
      ));
    });
    return ticketTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight / 2.5,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: UiConstants.scaffoldColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text("Winning Tickets",
                textAlign: TextAlign.center,
                style: TextStyles.body1.bold.letterSpace(2)),
          ),
          Divider(),
          Expanded(
            child: ListView(children: getWinningTicketTiles()),
          )
        ],
      ),
    );
  }
}
