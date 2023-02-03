import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/extensions/investment_returns_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class TransactionCancelBottomSheet extends StatelessWidget {
  const TransactionCancelBottomSheet(
      {Key? key,
      required this.amt,
      required this.investMentType,
      required this.onContinue})
      : super(key: key);
  final int amt;
  final InvestmentType investMentType;
  final void Function() onContinue;

  @override
  Widget build(BuildContext context) {
    final isGold = investMentType == InvestmentType.AUGGOLD99;
    return WillPopScope(
      onWillPop: () {
        locator<BackButtonActions>().isTransactionCancelled = false;
        return AppState.backButtonDispatcher!.didPopRoute();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.padding24),
        height: SizeConfig.screenHeight! * 0.55,
        child: Column(
          children: [
            Text(
              "Are you sure you want go back?",
              style: TextStyles.rajdhaniB.title5.colour(Colors.white),
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Text(
              "Now is the right time to Save!",
              style: TextStyles.sourceSansSB.body2.colour(Color(0xffD9D9D9)),
            ),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.05,
            ),
            SizedBox(
              width: SizeConfig.screenWidth! * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(isGold
                          ? Assets.single_gold_brick
                          : Assets.cash_single),
                      SizedBox(
                        height: SizeConfig.padding28,
                      ),
                      Text(
                        "Invest Today",
                        style: TextStyles.sourceSans.body3
                            .colour(Color(0xff919193)),
                      ),
                      SizedBox(
                        height: SizeConfig.padding2,
                      ),
                      Text(
                        "₹ " + amt.toString(),
                        style:
                            TextStyles.sourceSansSB.body1.colour(Colors.white),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                          isGold ? Assets.tri_gold_brick : Assets.cash_bindle),
                      SizedBox(
                        height: SizeConfig.padding28,
                      ),
                      Text(
                        "In 1 Year",
                        style: TextStyles.sourceSans.body3
                            .colour(Color(0xff919193)),
                      ),
                      SizedBox(
                        height: SizeConfig.padding2,
                      ),
                      Text(
                        "₹ " + 12.getReturns(investMentType, amt, 0).toString(),
                        style:
                            TextStyles.sourceSansSB.body1.colour(Colors.white),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(isGold
                          ? Assets.multiple_gold_brick
                          : Assets.cash_with_coins),
                      SizedBox(
                        height: SizeConfig.padding28,
                      ),
                      Text(
                        "In 3 Years",
                        style: TextStyles.sourceSans.body3
                            .colour(Color(0xff919193)),
                      ),
                      SizedBox(
                        height: SizeConfig.padding2,
                      ),
                      Text(
                        "₹ " +
                            3.calculateCompoundInterest(
                              investMentType,
                              amt,
                            ),
                        style:
                            TextStyles.sourceSansSB.body1.colour(Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
                width: SizeConfig.screenWidth! * 0.8,
                child: AppPositiveBtn(
                  btnText: "Continue Saving",
                  onPressed: () => onContinue(),
                )),
            SizedBox(
              height: SizeConfig.padding10,
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            InkWell(
              onTap: () async {
                AppState.backButtonDispatcher!.didPopRoute().then(
                    (value) => AppState.backButtonDispatcher!.didPopRoute());
              },
              child: Text(
                "GO BACK ANYWAY",
                style: TextStyles.rajdhaniB.body2.colour(Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
