import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_vm.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoldBalanceRow extends StatelessWidget {
  const GoldBalanceRow({
    required this.lead,
    required this.trail,
    this.isBold = false,
    super.key,
  });

  final String lead;
  final double trail;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lead,
          style: isBold
              ? TextStyles.rajdhaniM.body1
              : TextStyles.rajdhaniM.body2.colour(Colors.grey),
        ),
        Text(
          "${BaseUtil.digitPrecision(trail, 4, true)}gms",
          style: isBold
              ? TextStyles.sourceSansSB.title5.colour(Colors.white)
              : TextStyles.sourceSansSB.body2.colour(Colors.white70),
        )
      ],
    );
  }
}

class ExpectedGoldProReturnsRow extends StatelessWidget {
  const ExpectedGoldProReturnsRow({
    required this.model,
    super.key,
  });

  final GoldProBuyViewModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expected Returns in 5Y",
              style: TextStyles.rajdhaniB.body1.colour(Colors.white),
            ),
            SizedBox(height: SizeConfig.padding4),
            Text(
              "with ${Constants.ASSET_GOLD_STAKE}",
              style: TextStyles.rajdhaniM.body2.colour(Colors.grey),
            ),
          ],
        ),
        SizedBox(width: SizeConfig.padding20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: model.isGoldRateFetching
                              ? SizedBox(
                                  height: SizeConfig.padding48 -
                                      SizeConfig.padding2,
                                  child: SpinKitThreeBounce(
                                    color: UiConstants.kGoldProPrimary,
                                    size: SizeConfig.padding32,
                                  ),
                                )
                              : RichText(
                                  textAlign: TextAlign.end,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "₹" +
                                            "${model.expectedGoldReturns.toInt()}"
                                                .formatToIndianNumberSystem(),
                                        style: TextStyles.rajdhaniSB.title3
                                            .colour(
                                                UiConstants.kGoldProPrimary),
                                      ),
                                      WidgetSpan(
                                          child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: SizeConfig.padding12),
                                        child: Text(
                                          "*",
                                          style: TextStyles.rajdhaniB.body3
                                              .colour(
                                                  UiConstants.kGoldProPrimary),
                                        ),
                                      ))
                                    ],
                                  ),
                                )),
                    ),
                  ),
                ],
              ),
              Text(
                "with extra ${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% returns",
                style: TextStyles.sourceSans.body3
                    .colour(UiConstants.kGoldProPrimary),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class PriceAdaptiveGoldProOverViewCard extends StatelessWidget {
  const PriceAdaptiveGoldProOverViewCard({required this.model, super.key});

  final GoldProBuyViewModel model;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
      color: UiConstants.kBackgroundColor2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
      ),
      child: model.additionalGoldBalance != 0
          ? Row(
              children: [
                SvgPicture.asset(
                  Assets.goldAsset,
                  width: SizeConfig.padding70,
                ),
                // SizedBox(width: SizeConfig.padding10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Saving ${model.additionalGoldBalance}gms",
                      style: TextStyles.body2.colour(Colors.white),
                    ),
                    SizedBox(height: SizeConfig.padding4),
                    Text(
                      "in Digital Gold to lease",
                      style: TextStyles.body4.colour(Colors.grey),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${model.totalGoldAmount}",
                      style: TextStyles.sourceSansB.body1.colour(Colors.white),
                    ),
                    SizedBox(height: SizeConfig.padding4),
                    NewCurrentGoldPriceWidget(
                      fetchGoldRates: model.fetchGoldRates,
                      goldprice: model.goldRates != null
                          ? model.goldRates!.goldBuyPrice
                          : 0.0,
                      isFetching: model.isGoldRateFetching,
                      mini: true,
                      textColor: UiConstants.kDividerColor,
                    )
                  ],
                ),
                SizedBox(width: SizeConfig.padding16)
              ],
            )
          : ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SvgPicture.asset(
                Assets.goldAsset,
                width: SizeConfig.padding90,
              ),
              title: Text(
                "Saving ${model.totalGoldBalance}gms in ${Constants.ASSET_GOLD_STAKE}",
                style: TextStyles.body2.colour(Colors.white),
              ),
            ),
    );
  }
}
