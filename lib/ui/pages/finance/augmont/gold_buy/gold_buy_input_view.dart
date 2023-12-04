import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/widgets/buy_app_bar.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/widgets/buy_nav_bar.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/widgets/enter_amount_view.dart';
import 'package:felloapp/ui/pages/finance/banner_widget.dart';
import 'package:felloapp/ui/pages/finance/coupon_widget.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

import 'widgets/view_breakdown.dart';

class GoldBuyInputView extends StatefulWidget {
  final bool? skipMl;
  final int? amount;
  final AugmontTransactionService augTxnService;
  final GoldBuyViewModel model;

  const GoldBuyInputView({
    required this.model,
    required this.augTxnService,
    super.key,
    this.skipMl,
    this.amount,
  });

  @override
  State<GoldBuyInputView> createState() => _GoldBuyInputViewState();
}

class _GoldBuyInputViewState extends State<GoldBuyInputView> {
  @override
  void initState() {
    super.initState();
    locator<BackButtonActions>().isTransactionCancelled = true;
    AppState.type = InvestmentType.AUGGOLD99;

    AppState.amt = widget.model.goldBuyAmount?.toDouble();
    AppState.onTap = () async {
      unawaited(AppState.backButtonDispatcher!.didPopRoute());

      locator<AnalyticsService>()
          .track(eventName: AnalyticsEvents.saveInitiate, properties: {
        "investmentType": InvestmentType.AUGGOLD99.name,
      });
      if (widget.model.isIntentFlow) {
        unawaited(BaseUtil.openModalBottomSheet(
          isBarrierDismissible: true,
          backgroundColor: const Color(0xff1A1A1A),
          addToScreenStack: true,
          isScrollControlled: true,
          content: GoldBreakdownView(
            model: widget.model,
            showBreakDown: AppConfig.getValue(AppConfigKey.payment_brief_view),
          ),
        ));
      } else {
        if (!widget.augTxnService.isGoldBuyInProgress) {
          await widget.model.initiateBuy();
        }
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    final AnalyticsService analyticsService = locator<AnalyticsService>();
    final banner = widget.model.assetOptionsModel!.data.banner;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: SizeConfig.fToolBarHeight / 2),
            RechargeModalSheetAppBar(
              txnService: widget.augTxnService,
              trackCloseTapped: () {
                analyticsService.track(
                    eventName: AnalyticsEvents.savePageClosed,
                    properties: {
                      "Amount entered": widget.model.goldAmountController!.text,
                      "Grams of gold": widget.model.goldAmountInGrams,
                      "Asset": 'Gold',
                      "Coupon Applied": widget.model.appliedCoupon != null
                          ? widget.model.appliedCoupon!.code
                          : "Not Applied",
                    });
                if (locator<BackButtonActions>().isTransactionCancelled) {
                  if (!AppState.isRepeated) {
                    locator<BackButtonActions>()
                        .showWantToCloseTransactionBottomSheet(
                            double.parse(
                                    widget.model.goldAmountController!.text)
                                .round(),
                            InvestmentType.AUGGOLD99, () {
                      widget.model.initiateBuy();
                      AppState.backButtonDispatcher!.didPopRoute();
                    });
                    AppState.isRepeated = true;
                  } else {
                    AppState.backButtonDispatcher!.didPopRoute();
                  }
                  return;
                } else {
                  AppState.backButtonDispatcher!.didPopRoute();
                }
              },
            ),
            if (banner != null) ...[
              SizedBox(height: SizeConfig.padding24),
              BannerWidget(
                model: banner,
                happyHourCampign: locator.isRegistered<HappyHourCampign>()
                    ? locator<HappyHourCampign>()
                    : null,
              ),
            ],
            if (widget.model.animationController != null)
              EnterAmountView(
                model: widget.model,
                txnService: widget.augTxnService,
              ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              color: UiConstants.kModalSheetSecondaryBackgroundColor
                  .withOpacity(0.2),
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            if (widget.model.showCoupons)
              CouponWidget(
                widget.model.couponList,
                widget.model,
                onTap: (coupon) {
                  widget.model.applyCoupon(coupon.code, false);
                },
              ),
            const Spacer(),
            widget.augTxnService.isGoldBuyInProgress
                ? Container(
                    height: SizeConfig.screenWidth! * 0.1556,
                    alignment: Alignment.center,
                    width: SizeConfig.screenWidth! * 0.7,
                    child: const LinearProgressIndicator(
                      color: UiConstants.primaryColor,
                      backgroundColor: UiConstants.kDarkBackgroundColor,
                    ),
                  )
                : widget.model.goldRates == null
                    ? const SizedBox()
                    : BuyNavBar(
                        model: widget.model,
                        onTap: () async {
                          if (!widget.augTxnService.isGoldBuyInProgress) {
                            FocusScope.of(context).unfocus();
                            await widget.model.initiateBuy();
                          }
                        },
                      ),
          ],
        ),
        CustomKeyboardSubmitButton(
            onSubmit: () => widget.model.buyFieldNode.unfocus()),
      ],
    );
  }
}
