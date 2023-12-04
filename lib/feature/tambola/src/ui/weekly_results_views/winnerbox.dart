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

  const WinnerBox(
      {required this.winner,
      required this.tPrize,
      required this.isEligible,
      Key? key})
      : super(key: key);

  getWinningTicketTiles() {
    List<Color> colorList = [
      UiConstants.tertiarySolid,
      UiConstants.primaryColor,
      const Color(0xff11192B)
    ];
    List<Widget> ticketTiles = List.generate(
      winner.matchMap!.length,
      (index) => winner.matchMap![index].count > 0
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      winner.matchMap![index].displayName,
                      style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                    ),
                    Text(
                      winner.matchMap![index].count.toString(),
                      style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                    )
                  ],
                ),
                const Divider(
                  color: UiConstants.kFAQsAnswerColor,
                  thickness: 0.1,
                ),
              ],
            )
          : const SizedBox(),
    );

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
                    style: TextStyles.sourceSansB.body0
                        .colour(UiConstants.kGoldProPrimary),
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
