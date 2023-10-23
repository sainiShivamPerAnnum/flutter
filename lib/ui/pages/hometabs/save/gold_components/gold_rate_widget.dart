import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/repository/clientComms_repo.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../architecture/base_view.dart';

class GoldRateWidget extends StatefulWidget {
  const GoldRateWidget({Key? key}) : super(key: key);

  @override
  State<GoldRateWidget> createState() => GoldRateWidgetState();
}

class GoldRateWidgetState extends State<GoldRateWidget> {
  bool switchValue =
      PreferenceHelper.getBool(PreferenceHelper.GOLD_PRICE_SUBSCRIBE);

  final _repo = locator<ClientCommsRepo>();

  void handleToggle(bool newValue) {
    setState(() {
      switchValue = newValue;
    });

    _repo.subscribeGoldPriceAlert(switchValue ? 1 : 0);

    PreferenceHelper.setBool(PreferenceHelper.GOLD_PRICE_SUBSCRIBE, newValue);

    if (switchValue) {
      BaseUtil.showPositiveAlert(
          'We will notify you when the gold prices change!',
          'Keep saving in Gold with Fello!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<GoldBuyViewModel>(onModelReady: (model) {
      model.fetchGoldRates();
    }, builder: (ctx, model, child) {
      return Container(
          width: SizeConfig.screenWidth,
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.padding16,
            horizontal: SizeConfig.pageHorizontalMargins,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding20,
            vertical: SizeConfig.padding20,
          ),
          decoration: BoxDecoration(
            // color: Colors.white.withOpacity(0.1),
            color: UiConstants.kArrowButtonBackgroundColor,
            borderRadius: BorderRadius.circular(SizeConfig.roundness16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Market Rate",
                    style: TextStyles.sourceSans.body3,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      model.isGoldRateFetching
                          ? SpinKitThreeBounce(
                              size: SizeConfig.body2,
                              color: Colors.white,
                            )
                          : Text(
                              "₹ ${(model.goldRates != null ? model.goldRates!.goldBuyPrice : 0.0)?.toStringAsFixed(2)}/gm",
                              style: TextStyles.sourceSansSB.body1
                                  .colour(Colors.white),
                            ),
                      NewCurrentGoldPriceWidget(
                        fetchGoldRates: model.fetchGoldRates,
                        goldprice: model.goldRates != null
                            ? model.goldRates!.goldBuyPrice
                            : 0.0,
                        isFetching: model.isGoldRateFetching,
                        mini: true,
                        textColor: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: SizeConfig.padding10),
              Row(
                children: [
                  Text(
                    "Get notified about gold price changes",
                    style: TextStyles.sourceSans.body4
                        .colour(const Color(0xffA9C6D6)),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: SizeConfig.padding14,
                  ),
                  AppSwitch(
                    onToggle: handleToggle,
                    value: switchValue,
                    isLoading: model.isGoldRateFetching,
                    height: SizeConfig.padding28,
                    width: SizeConfig.padding46,
                    toggleSize: SizeConfig.padding20,
                  ),
                ],
              )
            ],
          ));
    });
  }
}
