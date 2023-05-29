import "dart:math" as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/pages/finance/amount_chip.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/banner_widget.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/shared/spotlight_controller.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/show_case_key.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:showcaseview/showcaseview.dart';

class GoldBuyInputView extends StatefulWidget {
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
  State<GoldBuyInputView> createState() => _GoldBuyInputViewState();
}

class _GoldBuyInputViewState extends State<GoldBuyInputView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SpotLightController.instance.userFlow = UserFlow.onAssetBuyPage;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AnalyticsService? _analyticsService = locator<AnalyticsService>();
    S locale = locator<S>();
    AppState.onTap = () {
      widget.model.initiateBuy();
      AppState.backButtonDispatcher!.didPopRoute();
    };
    AppState.type = InvestmentType.AUGGOLD99;
    AppState.amt =
        double.tryParse(widget.model.goldAmountController!.text) ?? 0;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            RechargeModalSheetAppBar(
              txnService: widget.augTxnService,
              trackCloseTapped: () {
                _analyticsService!.track(
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
            SizedBox(height: SizeConfig.padding24),
            if (widget.model.assetOptionsModel != null)
              BannerWidget(
                model: widget.model.assetOptionsModel!.data.banner,
                happyHourCampign: locator.isRegistered<HappyHourCampign>()
                    ? locator<HappyHourCampign>()
                    : null,
              ),
            if (widget.model.animationController != null)
              EnterAmountView(
                model: widget.model,
                txnService: widget.augTxnService,
              ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            if (widget.model.showCoupons)
              // Showcase(
              //   key: ShowCaseKeys.couponKey,
              //   description: 'You can apply a coupon to get extra gold!',
              //   child: CouponWidget(
              //     widget.model.couponList,
              //     widget.model,
              //     onTap: (coupon) {
              //       widget.model.applyCoupon(coupon.code, false);
              //     },
              //   ),
              // ),
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
                : Showcase(
                    key: ShowCaseKeys.saveNowGold,
                    description:
                        'Once done, tap on SAVE to make your first transaction',
                    child: AppPositiveBtn(
                      btnText: widget.model.status == 2
                          ? locale.btnSave
                          : locale.unavailable.toUpperCase(),
                      onPressed: () async {
                        if (!widget.augTxnService.isGoldBuyInProgress) {
                          FocusScope.of(context).unfocus();
                          widget.model.initiateBuy();
                        }
                      },
                      width: SizeConfig.screenWidth! * 0.813,
                    ),
                  ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
          ],
        ),
        CustomKeyboardSubmitButton(
            onSubmit: () => widget.model.buyFieldNode.unfocus()),
      ],
    );
  }
}

class RechargeModalSheetAppBar extends StatelessWidget {
  final AugmontTransactionService txnService;
  final Function? trackCloseTapped;

  const RechargeModalSheetAppBar({
    super.key,
    required this.txnService,
    this.trackCloseTapped,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: txnService.isGoldBuyInProgress
          ? const SizedBox()
          : IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => trackCloseTapped,
            ),
      title: Text(
        'Save with Fello',
        style: TextStyles.rajdhaniSB.title5,
      ),
    );
  }
}

class EnterAmountView extends StatelessWidget {
  const EnterAmountView(
      {Key? key, required this.model, required this.txnService})
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
              vertical: SizeConfig.padding16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (model.buyNotice != null && model.buyNotice!.isNotEmpty)
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
                      model.buyNotice!,
                      textAlign: TextAlign.center,
                      style: TextStyles.body3.light,
                    ),
                  ),
                Showcase(
                  key: ShowCaseKeys.goldInputKey,
                  description: 'Edit the amount you want to save',
                  child: AnimatedBuilder(
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
                                style: TextStyles.rajdhaniB.title50.colour(
                                    model.goldAmountController!.text == "0"
                                        ? UiConstants.kTextColor2
                                        : UiConstants.kTextColor),
                              ),
                              // SizedBox(width: SizeConfig.padding10),
                              AnimatedContainer(
                                duration: const Duration(seconds: 0),
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
                                  onChanged: model.onBuyValueChanged,
                                  onTap: model.showKeyBoard,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: const InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    // isCollapse: true,
                                    disabledBorder: InputBorder.none,
                                    isDense: true,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyles.rajdhaniB.title50.colour(
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
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        model.showHappyHourSubtitle(),
                        style: TextStyles.sourceSans.body4.bold
                            .colour(UiConstants.primaryColor),
                      ),
                      SizedBox(
                        width: SizeConfig.padding4,
                      ),
                      if (model.showInfoIcon)
                        GestureDetector(
                          onTap: () => locator<BaseUtil>().showHappyHourDialog(
                              locator<HappyHourCampign>(),
                              isComingFromSave: true),
                          child: const Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Color(0xff62E3C4),
                          ),
                        ),
                    ],
                  ),
                ),
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
                if (model.showMinCapText)
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
                    (index) => AmountChipV2(
                  index: index,
                  isActive: model.lastTappedChipIndex == index,
                  amt: model.assetOptionsModel!.data.userOptions[index].value,
                  onClick: model.onChipClick,
                  isBest: model.assetOptionsModel!.data.userOptions[index].best,
                ),
              ),
            ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Showcase(
            key: ShowCaseKeys.currentGoldRates,
            description: 'These are the current gold rates',
            child: Container(
              // width: SizeConfig.screenWidth! * 0.72,
              decoration: BoxDecoration(
                color: UiConstants.kArrowButtonBackgroundColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              ),
              // margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding64),
              height: SizeConfig.padding38,
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
              child: IntrinsicHeight(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  model.isGoldRateFetching
                      ? SpinKitThreeBounce(
                          size: SizeConfig.body2,
                          color: UiConstants.primaryColor,
                        )
                      : Text(
                          "₹ ${(model.goldRates != null ? model.goldRates!.goldBuyPrice : 0.0)?.toStringAsFixed(2)}/gm",
                          style: TextStyles.sourceSans.body4.colour(UiConstants
                              .kModalSheetMutedTextBackgroundColor
                              .withOpacity(0.8)),
                        ),
                  SizedBox(
                    width: SizeConfig.padding10,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                    child: Text(
                      "${model.goldAmountInGrams}${locale.gms}",
                      style: TextStyles.sourceSans.body3,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.padding20,
                  ),
                  VerticalDivider(
                    color: UiConstants.kModalSheetSecondaryBackgroundColor
                        .withOpacity(0.2),
                    width: 4,
                  ),
                  SizedBox(
                    width: SizeConfig.padding20,
                  ),
                  NewCurrentGoldPriceWidget(
                    fetchGoldRates: model.fetchGoldRates,
                    goldprice: model.goldRates != null
                        ? model.goldRates!.goldBuyPrice
                        : 0.0,
                    isFetching: model.isGoldRateFetching,
                    mini: true,
                  ),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
