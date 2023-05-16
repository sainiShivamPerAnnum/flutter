import "dart:math" as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/pages/buy_flow/buy_vm.dart';
import 'package:felloapp/ui/pages/buy_flow/expanded_section.dart';
import 'package:felloapp/ui/pages/finance/amount_chip.dart';
import 'package:felloapp/ui/pages/finance/banner_widget.dart';
import 'package:felloapp/ui/pages/finance/coupon_widget.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/shared/spotlight_controller.dart';
import 'package:felloapp/util/assets.dart' as A;
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/show_case_key.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showcaseview/showcaseview.dart';

class BuyInputView extends StatefulWidget {
  final int? amount;
  final bool? skipMl;
  final AugmontTransactionService augTxnService;
  final BuyViewModel model;
  final InvestmentType? investmentType;

  const BuyInputView({
    Key? key,
    this.amount,
    this.skipMl,
    required this.model,
    required this.augTxnService,
    this.investmentType,
  }) : super(key: key);

  @override
  State<BuyInputView> createState() => _BuyInputViewState();
}

class _BuyInputViewState extends State<BuyInputView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SpotLightController.instance.userFlow = UserFlow.onAssetBuyPage;

      switch (widget.investmentType) {
        case InvestmentType.LENDBOXP2P:
          widget.model.selectedAsset = asset = Asset.flow;
          break;
        case InvestmentType.AUGGOLD99:
          widget.model.selectedAsset = asset = Asset.gold;
          break;
        default:
          widget.model.selectedAsset = asset = null;
          break;
      }
    });

    super.initState();
  }

  Asset? asset;

  @override
  Widget build(BuildContext context) {
    debugPrint('widget.investmentType => ${widget.investmentType}');

    final AnalyticsService? _analyticsService = locator<AnalyticsService>();
    S locale = locator<S>();
    AppState.onTap = () {
      widget.model.initiateBuy();
      AppState.backButtonDispatcher!.didPopRoute();
    };
    AppState.type = widget.investmentType;
    AppState.amt =
        double.tryParse(widget.model.goldAmountController!.text) ?? 0;
    return Stack(
      children: [
        SizedBox(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Column(
            children: [
              RechargeModalSheetAppBar(
                txnService: widget.augTxnService,
                trackCloseTapped: () {
                  _analyticsService!.track(
                      eventName: AnalyticsEvents.savePageClosed,
                      properties: {
                        "Amount entered":
                            widget.model.goldAmountController!.text,
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
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SizedBox(height: SizeConfig.padding16),

                      if (widget.model.assetOptionsModel != null)
                        BannerWidget(
                          model: widget.model.assetOptionsModel!.data.banner,
                          happyHourCampign:
                              locator.isRegistered<HappyHourCampign>()
                                  ? locator<HappyHourCampign>()
                                  : null,
                        ),
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

                      AssetDropDown(
                        asset: asset,
                      ),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                      if (widget.model.showCoupons)
                        Showcase(
                          key: ShowCaseKeys.couponKey,
                          description:
                              'You can apply a coupon to get extra gold!',
                          child: CouponWidget(
                            widget.model.couponList,
                            widget.model,
                            onTap: (coupon) {
                              widget.model.applyCoupon(coupon.code, false);
                            },
                          ),
                        ),

                      SizedBox(
                        height: SizeConfig.navBarHeight * 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: widget.augTxnService.isGoldBuyInProgress
              ? Container(
                  height: SizeConfig.screenWidth! * 0.1556,
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth! * 0.7,
                  child: const LinearProgressIndicator(
                    color: UiConstants.primaryColor,
                    backgroundColor: UiConstants.kDarkBackgroundColor,
                  ),
                )
              : BuyNavBar(
                  locale: locale,
                  augTxnService: widget.augTxnService,
                  model: widget.model,
                ),
        ),
        CustomKeyboardSubmitButton(
            onSubmit: () => widget.model.buyFieldNode.unfocus()),
      ],
    );
  }
}

class BuyNavBar extends StatelessWidget {
  const BuyNavBar({
    super.key,
    required this.locale,
    required this.augTxnService,
    required this.model,
  });

  final AugmontTransactionService augTxnService;
  final BuyViewModel model;
  final S locale;

  @override
  Widget build(BuildContext context) {
    return model.selectedAsset == null
        ? const SizedBox()
        : Showcase(
            key: ShowCaseKeys.saveNowGold,
            description:
                'Once done, tap on SAVE to make your first transaction',
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding32,
                vertical: SizeConfig.padding16,
              ),
              color: UiConstants.kArrowButtonBackgroundColor,
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹${model.goldAmountController?.text ?? '0'}",
                        style: TextStyles.sourceSansSB.title5
                            .copyWith(color: Colors.white),
                      ),
                      //
                      Text('in Digital Gold',
                          style: TextStyles.rajdhaniSB.body3
                              .colour(UiConstants.kTextFieldTextColor)),
                      SizedBox(
                        height: SizeConfig.padding4,
                      ),
                      GestureDetector(
                        onTap: () {
                          BaseUtil.openModalBottomSheet(
                            isBarrierDismissible: true,
                            backgroundColor: const Color(0xff1A1A1A),
                            content: ViewBreakdown(model: model),
                          );
                        },
                        child: Text(
                          'View Breakdown',
                          style: TextStyles.sourceSans.body3.copyWith(
                              color: UiConstants.kTextFieldTextColor,
                              decorationStyle: TextDecorationStyle.solid,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (model.appliedCoupon != null) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              A.Assets.ticketTilted,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              '${model.appliedCoupon?.code} coupon applied',
                              style: TextStyles.sourceSans.body3
                                  .colour(UiConstants.kTealTextColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.padding4,
                        )
                      ],
                      AppPositiveBtn(
                        width: SizeConfig.screenWidth! * 0.22,
                        height: SizeConfig.screenWidth! * 0.12,
                        onPressed: () {
                          if (!augTxnService.isGoldBuyInProgress) {
                            FocusScope.of(context).unfocus();
                            model.initiateBuy();
                          }
                        },
                        btnText: model.status == 2
                            ? locale.btnSave
                            : locale.unavailable.toUpperCase(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

class ViewBreakdown extends StatelessWidget {
  const ViewBreakdown({Key? key, required this.model}) : super(key: key);

  final BuyViewModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: SizeConfig.padding28,
          ),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding28,
          ),
          Row(
            children: [
              Text(
                  model.selectedAsset == Asset.gold
                      ? "Digital Gold Amount"
                      : "Fello Flo Amount",
                  style: TextStyles.sourceSansSB.body1),
              const Spacer(),
              Text(
                "₹${model.goldAmountController?.text ?? '0'}",
                style: TextStyles.sourceSansSB.body1,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          if (model.selectedAsset == Asset.gold) ...[
            Row(
              children: [
                Text(
                  "Grams of Gold",
                  style: TextStyles.sourceSans.body2,
                ),
                const Spacer(),
                Text(
                  "${model.goldAmountInGrams}gms",
                  style: TextStyles.sourceSansSB.body2,
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            Row(
              children: [
                Text(
                  "GST (${model.goldRates?.igstPercent})%",
                  style: TextStyles.sourceSans.body2,
                ),
                const Spacer(),
                Text(
                  "₹${(model.goldRates?.igstPercent)! / 100 * double.parse(model.goldAmountController?.text ?? '0')}",
                  style: TextStyles.sourceSansSB.body2,
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
          ],
          Container(
            height: 1,
            color: UiConstants.kLastUpdatedTextColor.withOpacity(0.5),
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Row(
            children: [
              SizedBox(
                height: SizeConfig.padding28,
                width: SizeConfig.padding28,
                child: SvgPicture.asset(
                  Assets.howToPlayAsset1Tambola,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                width: SizeConfig.padding4,
              ),
              Text(
                "Total Tambola Tickets",
                style: TextStyles.sourceSansSB.body1,
              ),
              const Spacer(),
              Text(
                "${model.totalTickets}",
                style: TextStyles.sourceSansSB.body1,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          if (model.showHappyHour) ...[
            Row(
              children: [
                Text(
                  "Happy Hour Tambola Tickets",
                  style: TextStyles.sourceSans.body2,
                ),
                const Spacer(),
                Text(
                  "${model.happyHourTickets}",
                  style: TextStyles.sourceSans.body2,
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            Row(
              children: [
                Text(
                  "Lifetime Tambola Tickets",
                  style: TextStyles.sourceSans.body2,
                ),
                const Spacer(),
                Text(
                  "${model.numberOfTambolaTickets}",
                  style: TextStyles.sourceSans.body2,
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
          ],
          Container(
            height: 1,
            color: UiConstants.kLastUpdatedTextColor.withOpacity(0.5),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          if (model.appliedCoupon != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  A.Assets.ticketTilted,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  '${model.appliedCoupon?.code} coupon applied',
                  style: TextStyles.sourceSans.body3
                      .colour(UiConstants.kTealTextColor),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding12,
            )
          ],
          AppPositiveBtn(
            width: SizeConfig.screenWidth!,
            onPressed: () {
              // if (!augTxnService.isGoldBuyInProgress) {
              //   FocusScope.of(context).unfocus();
              //   model.initiateBuy();
              // }
            },
            btnText: model.status == 2 ? 'Save' : 'Unavailable'.toUpperCase(),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
        ],
      ),
    );
  }
}

class RechargeModalSheetAppBar extends StatelessWidget {
  final AugmontTransactionService txnService;
  final Function? trackCloseTapped;

  const RechargeModalSheetAppBar(
      {Key? key, required this.txnService, this.trackCloseTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: txnService.isGoldBuyInProgress || txnService.isGoldSellInProgress
          ? const SizedBox()
          : IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                if (trackCloseTapped != null) trackCloseTapped!();
              },
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
  final BuyViewModel model;
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

          /// chips
          if (model.assetOptionsModel != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                model.assetOptionsModel!.data.userOptions.length,
                (index) => Column(
                  children: [
                    AmountChipV2(
                      index: index,
                      isActive: model.lastTappedChipIndex == index,
                      amt: model
                          .assetOptionsModel!.data.userOptions[index].value,
                      onClick: model.onChipClick,
                      isBest:
                          model.assetOptionsModel!.data.userOptions[index].best,
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(
            height: SizeConfig.padding16,
          ),

          /// gold rates
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

class AssetDropDown extends StatefulWidget {
  const AssetDropDown({Key? key, this.asset}) : super(key: key);

  final Asset? asset;

  @override
  State<AssetDropDown> createState() => _AssetDropDownState();
}

class _AssetDropDownState extends State<AssetDropDown> {
  bool isStrechedDropDown = false;
  int? groupValue;
  String title = 'Select your Investment option';
  bool titleChanged = false;

  String getAssets(Asset asset) {
    switch (asset) {
      case Asset.gold:
        return 'Gold';
      case Asset.flow:
        return 'Flow';
    }
  }

  String getTitle() {
    if (widget.asset == null) {
      return 'Select your Investment option';
    } else {
      titleChanged = true;
      return getAssets(widget.asset!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding16, vertical: SizeConfig.padding24),
        decoration: BoxDecoration(
          color: const Color(0xff627F8E).withOpacity(0.2),
          // border: Border.all(color: const Color(0xffbbbbbb)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //Investing in
                Text(
                  'Investing in',
                  style: TextStyles.rajdhaniSB.body2,
                ),
                const Spacer(),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding6, vertical: 0),
                    child: Text(
                      getTitle(),
                      style: titleChanged
                          ? TextStyles.sourceSansSB.body2
                          : TextStyles.sourceSans.body4,
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        isStrechedDropDown = !isStrechedDropDown;
                      });
                    },
                    child: Icon(
                      isStrechedDropDown
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Colors.white,
                    ))
              ],
            ),
            ExpandedSection(
              expand: isStrechedDropDown,
              child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  // controller: scrollController2,
                  shrinkWrap: true,
                  itemCount: Asset.values.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                        title: Text(
                          getAssets(Asset.values[index]),
                          style: TextStyles.sourceSansSB.body2,
                        ),
                        value: index,
                        groupValue: groupValue,
                        onChanged: (val) {
                          setState(() {
                            groupValue = val;
                            titleChanged = true;
                            title = getAssets(Asset.values[index]);
                            isStrechedDropDown = false;
                          });
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
