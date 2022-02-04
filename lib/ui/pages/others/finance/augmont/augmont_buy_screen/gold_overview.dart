import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class GoldOverview extends StatelessWidget {
  final AugmontGoldBuyViewModel model;
  GoldOverview({this.model});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: model.navigateToGoldBalanceDetailsScreen,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [
                      UiConstants.tertiarySolid.withOpacity(0.2),
                      UiConstants.tertiaryLight.withOpacity(0.5)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness24),
                  border:
                      Border.all(width: 0.5, color: UiConstants.tertiarySolid),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding16,
                  horizontal: SizeConfig.pageHorizontalMargins,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Gold Balance",
                      style: TextStyles.body3,
                    ),
                    UserGoldQuantitySE(
                        style: TextStyles.title4.extraBold
                            .colour(UiConstants.tertiarySolid)),
                    Text(
                      "Tap to know more",
                      style: TextStyles.body4.italic.colour(Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 24),
          Expanded(
            child: InkWell(
              onTap: model.navigateToAboutGold,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [
                      UiConstants.primaryLight.withOpacity(0.5),
                      UiConstants.primaryColor.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness24),
                  border:
                      Border.all(width: 0.5, color: UiConstants.primaryColor),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding16,
                  horizontal: SizeConfig.pageHorizontalMargins,
                ),
                child: CurrentPriceWidget(
                  fetchGoldRates: model.fetchGoldRates,
                  goldprice: model.goldRates != null
                      ? model.goldRates.goldBuyPrice
                      : 0.0,
                  isFetching: model.isGoldRateFetching,
                  mini: true,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
