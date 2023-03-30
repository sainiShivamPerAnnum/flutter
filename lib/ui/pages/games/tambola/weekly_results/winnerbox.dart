import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WinnerBox extends StatelessWidget {
  final Map<String, int>? winningsmap;
  final PrizesModel? tPrize;

  WinnerBox({Key? key, this.winningsmap, required this.tPrize})
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
    int? flcAmount = 0;
    for (PrizesA e in tPrize!.prizesA!) {
      if (e.displayName == title) {
        return e.displayAmount;
      }
    }
    // return flcAmount;
  }

  int totalFlcAmount = 0;

  getWinningTicketTiles() {
    List<Color> colorList = [
      UiConstants.tertiarySolid,
      UiConstants.primaryColor,
      const Color(0xff11192B)
    ];
    List<Widget> ticketTiles = [];

    winningsmap!.forEach((key, value) {
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
                "₹${getTokenWonAmount(getValue(value))}",
                style: TextStyles.sourceSansSB.body2.colour(Colors.white),
              )
            ],
          ),
          const Divider(
            color: UiConstants.kFAQsAnswerColor,
            thickness: 0.1,
          ),
        ],
      ));
    });
    return ticketTiles;
  }

  String getToken() {
    int token = 0;
    winningsmap!.forEach((key, value) {
      for (PrizesA e in tPrize!.prizesA!) {
        if (e.displayName == getValue(value)) {
          token += e.flc ?? 0;
        }
      }
    });

    return token.toString();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
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
                    locale.category,
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kFAQsAnswerColor),
                  ),
                  Text(
                    locale.tTicketNo,
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
                  physics: const NeverScrollableScrollPhysics(),
                  children: getWinningTicketTiles()),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding20,
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff627F8E).withOpacity(0.4),
            // border: Border.all(color: UiConstants.kFAQsAnswerColor, width: 0.5),
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.roundness12)),
          ),
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding20, horizontal: SizeConfig.padding24),
          margin: EdgeInsets.only(bottom: SizeConfig.padding12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tokens Won',
                style: TextStyles.sourceSans.body3
                    .colour(const Color(0xffBDBDBE).withOpacity(0.7)),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/tokens.svg',
                    height: SizeConfig.padding28,
                    width: SizeConfig.padding28,
                  ),
                  Text(
                    getToken(),
                    style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
