import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/top_savers_new.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RedeemSucessfulScreen extends StatelessWidget {
  RedeemSucessfulScreen(
      {this.subTitleWidget, this.claimPrize, this.onSharePressed, Key key})
      : super(key: key);

  final Widget subTitleWidget;
  final double claimPrize;
  final Function onSharePressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          NewSquareBackground(),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          //The Asset
          SafeArea(
            child: Column(
              children: [
                Image.asset(
                  Assets.redeemSucessfullAssetPNG,
                  height: SizeConfig.screenHeight * 0.55,
                  width: double.infinity,
                ),
              ],
            ),
          ),
          //The main content
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.pageHorizontalMargins),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Congratulations!',
                  style: TextStyles.rajdhaniEB.title1.colour(Colors.white),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding26),
                  child: subTitleWidget,
                ),
                SizedBox(
                  height: SizeConfig.pageHorizontalMargins,
                ),
                Container(
                  margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  decoration: BoxDecoration(
                    color: UiConstants.kModalSheetBackgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(SizeConfig.roundness16),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.padding10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Redeemed",
                                    style: TextStyles.rajdhaniSB.body2
                                        .colour(UiConstants.kTextColor3),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding14,
                                  ),
                                  Text(
                                    "₹ ${claimPrize.truncateToDecimalPlaces(1)}",
                                    style: TextStyles.sourceSansSB.title5
                                        .colour(Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.padding12,
                            ),
                            drawDottedLine(lenghtOfStripes: 18),
                            SizedBox(
                              width: SizeConfig.padding12,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Digital Gold",
                                    style: TextStyles.rajdhaniSB.body2
                                        .colour(UiConstants.kTextColor3),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding14,
                                  ),
                                  Text(
                                    "0.0045g",
                                    style: TextStyles.sourceSansSB.title5
                                        .colour(Colors.white),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding10,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins,
                            vertical: SizeConfig.padding12),
                        decoration: BoxDecoration(
                          color:
                              UiConstants.kModalSheetSecondaryBackgroundColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(SizeConfig.roundness16),
                            bottomRight:
                                Radius.circular(SizeConfig.roundness16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Balance",
                              style: TextStyles.sourceSans.body2
                                  .colour(Colors.white),
                            ),
                            UserGoldQuantitySE(
                              style: TextStyles.sourceSans.body1
                                  .colour(Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {
                        onSharePressed();
                      },
                      child: Text(
                        "SHARE",
                        style: TextStyles.sourceSans.bold.body2
                            .colour(UiConstants.kTabBorderColor),
                      )),
                )
              ],
            ),
          ),
          //Cross button
          SafeArea(
            child: SizedBox(
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      AppState.backButtonDispatcher.didPopRoute();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget drawDottedLine({int lenghtOfStripes}) {
  return Column(
    children: [
      for (int i = 0; i < lenghtOfStripes; i++)
        Container(
          width: SizeConfig.padding1,
          height: 5,
          decoration: BoxDecoration(
            color: i % 2 == 0 ? Colors.white : Colors.transparent,
          ),
        ),
    ],
  );
}
