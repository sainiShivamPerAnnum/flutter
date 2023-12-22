import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/campaigns/topSavers/top_savers_new.dart';
import 'package:felloapp/ui/pages/hometabs/my_account/share_price_screen.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/service_elements/user_service/user_fund_quantity_se.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

class RedeemSucessfulScreen extends HookWidget {
  const RedeemSucessfulScreen(
      {required this.subTitleWidget,
      required this.claimPrize,
      required this.choice,
      required this.dpUrl,
      required this.wonGrams,
      Key? key})
      : super(key: key);

  final Widget subTitleWidget;
  final double claimPrize;
  final PrizeClaimChoice choice;
  final String? dpUrl;
  final String wonGrams;

  @override
  Widget build(BuildContext context) {
    useEffect(() => BaseUtil.showFelloRatingSheet, []);
    S locale = S.of(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const NewSquareBackground(),
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
                Lottie.network(
                  Assets.goldDepostSuccessLottie,
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
                  locale.btnCongratulations,
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
                                    locale.redeemed,
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
                                    locale.digitalGoldText,
                                    style: TextStyles.rajdhaniSB.body2
                                        .colour(UiConstants.kTextColor3),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding14,
                                  ),
                                  Text(
                                    wonGrams,
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
                              locale.balanceText,
                              style: TextStyles.sourceSans.body2
                                  .colour(Colors.white),
                            ),
                            UserFundQuantitySE(
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
                        AppState.delegate!.appState.currentAction = PageAction(
                          state: PageState.addWidget,
                          widget: SharePriceScreen(
                            dpUrl: dpUrl,
                            choice: choice,
                            prizeAmount: claimPrize,
                          ),
                          page: SharePriceScreenPageConfig,
                        );
                      },
                      child: Text(
                        locale.btnShare,
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
                      AppState.backButtonDispatcher!.didPopRoute();
                    },
                    icon: const Icon(
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

Widget drawDottedLine({required int lenghtOfStripes}) {
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
