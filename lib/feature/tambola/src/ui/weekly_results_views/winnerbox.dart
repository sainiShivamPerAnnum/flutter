import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WinnerBox extends StatelessWidget {
  final Winners winner;
  final PrizesModel? tPrize;
  final bool isEligible;

  WinnerBox(
      {Key? key,
      required this.winner,
      required this.tPrize,
      required this.isEligible})
      : super(key: key);

  getWinningTicketTiles() {
    List<Color> colorList = [
      UiConstants.tertiarySolid,
      UiConstants.primaryColor,
      const Color(0xff11192B)
    ];
    List<Widget> ticketTiles = [
      if ((winner.matchMap?.fullHouse ?? 0) != 0)
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Full House",
                  style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                ),
                Text(
                  winner.matchMap!.fullHouse.toString(),
                  style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                )
              ],
            ),
            const Divider(
              color: UiConstants.kFAQsAnswerColor,
              thickness: 0.1,
            ),
          ],
        ),
      if ((winner.matchMap?.oneRow ?? 0) != 0)
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "One Row",
                  style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                ),
                Text(
                  winner.matchMap!.oneRow.toString(),
                  style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                )
              ],
            ),
            const Divider(
              color: UiConstants.kFAQsAnswerColor,
              thickness: 0.1,
            ),
          ],
        ),
      if ((winner.matchMap?.twoRows ?? 0) != 0)
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Two Rows",
                  style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                ),
                Text(
                  winner.matchMap!.twoRows.toString(),
                  style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                )
              ],
            ),
            const Divider(
              color: UiConstants.kFAQsAnswerColor,
              thickness: 0.1,
            ),
          ],
        ),
      if ((winner.matchMap?.corners ?? 0) != 0)
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Corners",
                  style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                ),
                Text(
                  winner.matchMap!.corners.toString(),
                  style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                )
              ],
            ),
            const Divider(
              color: UiConstants.kFAQsAnswerColor,
              thickness: 0.1,
            ),
          ],
        ),
    ];

    return ticketTiles;
  }

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
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
                    'Category',
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kFAQsAnswerColor),
                  ),
                  Text(
                    "Wins",
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
                'Rewards Won',
                style: TextStyles.sourceSans.body3.colour(Colors.white),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.moneyIcon,
                    height: SizeConfig.padding28,
                    width: SizeConfig.padding28,
                  ),
                  Text(
                    "₹ ${winner.amount}",
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
