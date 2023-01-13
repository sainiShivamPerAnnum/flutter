import "dart:math" as math;

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/amount_chip.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/others/finance/banner_widget.dart';
import 'package:felloapp/ui/pages/others/finance/coupon_widget.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GoldBuyInputView extends StatelessWidget {
  // final int? amount;
  final bool? skipMl;
  final AugmontTransactionService augTxnService;
  final GoldBuyViewModel model;

  const GoldBuyInputView({
    Key? key,
    // this.amount,
    this.skipMl,
    required this.model,
    required this.augTxnService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AnalyticsService? _analyticsService = locator<AnalyticsService>();
S locale = locator<S>();
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: SizeConfig.padding16),
            RechargeModalSheetAppBar(
              txnService: augTxnService,
              trackCloseTapped: () {
                _analyticsService!.track(
                    eventName: AnalyticsEvents.savePageClosed,
                    properties: {
                      "Amount entered": model.goldAmountController!.text,
                      "Grams of gold": model.goldAmountInGrams,
                      "Asset": 'Gold',
                      "Coupon Applied": model.appliedCoupon != null
                          ? model.appliedCoupon!.code
                          : "Not Applied",
                    });
              },
            ),
            SizedBox(height: SizeConfig.padding24),
            if (model.assetOptionsModel != null)
              BannerWidget(
                model: model.assetOptionsModel!.data.banner,
                happyHourCampign:
                    locator.isRegistered<HappyHourCampign>() ? locator() : null,
              ),
            if (model.animationController != null)
              EnterAmountView(
                model: model,
                txnService: augTxnService,
              ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            if (model.showCoupons)
              CouponWidget(
                model.couponList,
                model,
                onTap: (coupon) {
                  model.applyCoupon(coupon.code, false);
                },
              ),
            Spacer(),
            augTxnService.isGoldBuyInProgress
                ? Container(
                    height: SizeConfig.screenWidth! * 0.1556,
                    alignment: Alignment.center,
                    width: SizeConfig.screenWidth! * 0.7,
                    child: LinearProgressIndicator(
                      color: UiConstants.primaryColor,
                      backgroundColor: UiConstants.kDarkBackgroundColor,
                    ),
                  )
                : AppPositiveBtn(
                    btnText: model.status == 2 ? locale.btnSave : locale.unavailable.toUpperCase(),
                    onPressed: () async {
                      if (!augTxnService.isGoldBuyInProgress) {
                        FocusScope.of(context).unfocus();
                        model.initiateBuy();
                      }
                    },
                    width: SizeConfig.screenWidth! * 0.813,
                  ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
          ],
        ),
        CustomKeyboardSubmitButton(
            onSubmit: () => model.buyFieldNode.unfocus()),
      ],
    );
  }
}

class RechargeModalSheetAppBar extends StatelessWidget {
  final AugmontTransactionService txnService;
  final Function? trackCloseTapped;
  RechargeModalSheetAppBar({required this.txnService, this.trackCloseTapped});
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return ListTile(
      leading: Container(
        width: SizeConfig.screenWidth! * 0.168,
        height: SizeConfig.screenWidth! * 0.168,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              UiConstants.primaryColor.withOpacity(0.4),
              UiConstants.primaryColor.withOpacity(0.2),
              UiConstants.primaryColor.withOpacity(0.04),
              Colors.transparent,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Image.asset(
            Assets.digitalGoldBar,
            width: SizeConfig.screenWidth! * 0.12,
            height: SizeConfig.screenWidth! * 0.12,
          ),
        ),
      ),
      title: Text(locale.digitalGoldText, style: TextStyles.rajdhaniSB.body2),
      subtitle: Text(
        locale.safestDigitalInvestment,
        style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
      ),
      trailing:
          txnService.isGoldBuyInProgress || txnService.isGoldSellInProgress
              ? SizedBox()
              : IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    if (trackCloseTapped != null) trackCloseTapped!();
                    AppState.backButtonDispatcher!.didPopRoute();
                  },
                ),
    );
  }
}

class EnterAmountView extends StatelessWidget {
  EnterAmountView({Key? key, required this.model, required this.txnService})
      : super(key: key);
  final GoldBuyViewModel model;
  final AugmontTransactionService txnService;
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding12,
              vertical: SizeConfig.padding20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     TextButton(
                //       child: Text("One Time",
                //           style: TextStyles.sourceSansSB.body2),
                //       onPressed: () {},
                //     ),
                //     TextButton(
                //       child: Text("Auto SIP",
                //           style: TextStyles.sourceSans.body2
                //               .colour(UiConstants.kTextColor3)),
                //       onPressed: () {},
                //     ),
                //   ],
                // ),
                if (model!.buyNotice != null && model!.buyNotice!.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(bottom: SizeConfig.padding16),
                    decoration: BoxDecoration(
                      color: UiConstants.primaryLight,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness16),
                    ),
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.all(SizeConfig.padding16),
                    child: Text(
                      model!.buyNotice!,
                      textAlign: TextAlign.center,
                      style: TextStyles.body3.light,
                    ),
                  ),
                AnimatedBuilder(
                    animation: model.animationController!,
                    builder: (context, _) {
                      final sineValue = math.sin(
                          3 * 2 * math.pi * model.animationController!.value);
                      return Transform.translate(
                        offset: Offset(sineValue * 10, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "₹",
                              style: TextStyles.rajdhaniB.title0.colour(
                                  model.goldAmountController!.text == "0"
                                      ? UiConstants.kTextColor2
                                      : UiConstants.kTextColor),
                            ),
                            SizedBox(width: SizeConfig.padding10),
                            AnimatedContainer(
                              duration: Duration(seconds: 0),
                              curve: Curves.easeIn,
                              width: model.fieldWidth,
                              child: TextFormField(
                                autofocus: true,
                                readOnly: model.readOnly,
                                showCursor: true,
                                controller: model.goldAmountController,
                                focusNode: model.buyFieldNode,
                                enabled: !txnService.isGoldBuyInProgress &&
                                    !model.couponApplyInProgress,
                                validator: (val) {
                                  return null;
                                },
                                onChanged: (val) {
                                  model.onBuyValueChanged(val);
                                },
                                onTap: () {
                                  model.showKeyBoard();
                                },
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  // isCollapse: true,
                                  disabledBorder: InputBorder.none,
                                  isDense: true,
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyles.rajdhaniB.title68.colour(
                                  model.goldAmountController!.text == "0"
                                      ? UiConstants.kTextColor2
                                      : UiConstants.kTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                if (model.showMaxCapText)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                    child: Text(
                      locale.upto50000,
                      style: TextStyles.sourceSans.body4.bold
                          .colour(UiConstants.primaryColor),
                    ),
                  ),
                if (model!.showMinCapText)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                    child: Text(
                      locale.minPurchaseText,
                      style: TextStyles.sourceSans.body4.bold
                          .colour(Colors.red[400]),
                    ),
                  ),
              ],
            ),
          ),
          if (model.assetOptionsModel != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                model.assetOptionsModel!.data.userOptions.length,
                (index) => AmountChip(
                  index: index,
                  isActive: model.lastTappedChipIndex == index,
                  amt: model.assetOptionsModel!.data.userOptions[index].value,
                  onClick: model.onChipClick,
                  isBest: model.assetOptionsModel!.data.userOptions[index].best,
                ),
              ),
            ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Container(
            width: SizeConfig.screenWidth! * 0.72,
            decoration: BoxDecoration(
              color: UiConstants.darkPrimaryColor,
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            ),
            height: SizeConfig.padding64,
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
            child: IntrinsicHeight(
              child: Row(children: [
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                    child: Text(
                      "${model.goldAmountInGrams}"+ locale.gms,
                      style: TextStyles.sourceSansSB.body1,
                    ),
                  ),
                ),
                VerticalDivider(
                  color: UiConstants
                      .kRechargeModalSheetAmountSectionBackgroundColor,
                  width: 4,
                ),
                Expanded(
                  child: Center(
                    child: NewCurrentGoldPriceWidget(
                      fetchGoldRates: model.fetchGoldRates,
                      goldprice: model.goldRates != null
                          ? model.goldRates!.goldBuyPrice
                          : 0.0,
                      isFetching: model.isGoldRateFetching,
                      mini: true,
                    ),
                  ),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
