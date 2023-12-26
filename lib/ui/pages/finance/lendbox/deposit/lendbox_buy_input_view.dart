import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/pages/finance/amount_input_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/widgets/view_breakdown.dart';
import 'package:felloapp/ui/pages/finance/banner_widget.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/widget/flo_coupon.dart';
import 'package:felloapp/ui/pages/finance/lendbox/lendbox_app_bar.dart';
import 'package:felloapp/ui/pages/finance/preferred_payment_option.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class LendboxBuyInputView extends StatefulWidget {
  final int? amount;
  final bool? skipMl;
  final LendboxBuyViewModel model;

  // final String floAssetType;

  const LendboxBuyInputView({
    required this.model,
    Key? key,
    this.amount,
    this.skipMl,
    // required this.floAssetType,
  }) : super(key: key);

  @override
  State<LendboxBuyInputView> createState() => _LendboxBuyInputViewState();
}

class _LendboxBuyInputViewState extends State<LendboxBuyInputView> {
  @override
  void initState() {
    locator<BackButtonActions>().isTransactionCancelled = true;
    AppState.type = InvestmentType.LENDBOXP2P;
    AppState.amt = (widget.model.buyAmount ?? 0) * 1.0;
    AppState.onTap = () async {
      await AppState.backButtonDispatcher!.didPopRoute();
      locator<AnalyticsService>()
          .track(eventName: AnalyticsEvents.saveInitiate, properties: {
        "investmentType": InvestmentType.AUGGOLD99.name,
      });
      if (widget.model.isIntentFlow) {
        unawaited(BaseUtil.openModalBottomSheet(
          isBarrierDismissible: true,
          addToScreenStack: true,
          content: FloBreakdownView(
            model: widget.model,
            showBreakDown: AppConfig.getValue(AppConfigKey.payment_brief_view),
          ),
          hapticVibrate: true,
          isScrollControlled: true,
        ));
      } else {
        {
          locator<AnalyticsService>()
              .track(eventName: AnalyticsEvents.saveInitiate, properties: {
            "investmentType": InvestmentType.LENDBOXP2P.name,
          });
          if ((widget.model.buyAmount ?? 0) < widget.model.minAmount) {
            BaseUtil.showNegativeAlert("Invalid Amount",
                "Please Enter Amount Greater than ${widget.model.minAmount}");
            return;
          }

          if (!widget.model.isBuyInProgress) {
            FocusScope.of(context).unfocus();
            await widget.model.initiateBuy();
          }
        }
      }
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final banner = widget.model.assetOptionsModel!.data.banner;
    bool canChangeMaturityDate =
        AppConfig.getValue(AppConfigKey.canChangePostMaturityPreference) ??
            false;
    log("floAssetType ${widget.model.floAssetType}");

    S locale = S.of(context);
    final AnalyticsService analyticsService = locator<AnalyticsService>();

    return PropertyChangeProvider<BankAndPanService,
        BankAndPanServiceProperties>(
      value: locator<BankAndPanService>(),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                // SizedBox(height: SizeConfig.fToolBarHeight / 2),
                LendBoxAppBar(
                  isOldUser: widget.model.isLendboxOldUser,
                  assetType: widget.model.floAssetType,
                  isEnabled: !widget.model.isBuyInProgress,
                  trackClosingEvent: () {
                    analyticsService.track(
                        eventName: AnalyticsEvents.savePageClosed,
                        properties: {
                          "Amount entered": widget.model.amountController!.text,
                          "Asset": widget.model.floAssetType,
                        });
                    if (locator<BackButtonActions>().isTransactionCancelled) {
                      if (AppState.delegate!.currentConfiguration!.key ==
                              'LendboxBuyViewPath' &&
                          (AppState.screenStack.last != ScreenItem.modalsheet ||
                              AppState.screenStack.last != ScreenItem.dialog) &&
                          !AppState.isRepeated) {
                        locator<BackButtonActions>()
                            .showWantToCloseTransactionBottomSheet(
                                double.parse(
                                        widget.model.amountController!.text)
                                    .round(),
                                InvestmentType.LENDBOXP2P, () {
                          widget.model.initiateBuy();
                          AppState.backButtonDispatcher!.didPopRoute();
                        });
                        AppState.isRepeated = true;
                        return;
                      } else {
                        AppState.backButtonDispatcher!.didPopRoute();
                      }
                    } else {
                      AppState.backButtonDispatcher!.didPopRoute();
                    }
                  },
                ),
                if (banner != null) ...[
                  SizedBox(height: SizeConfig.padding32),
                  BannerWidget(
                    model: banner,
                    happyHourCampign: locator.isRegistered<HappyHourCampign>()
                        ? locator()
                        : null,
                  ),
                ],

                if (widget.model.animationController != null)
                  AnimatedBuilder(
                      animation: widget.model.animationController!,
                      builder: (context, _) {
                        final sineValue = math.sin(3 *
                            2 *
                            math.pi *
                            widget.model.animationController!.value);
                        return Transform.translate(
                          offset: Offset(sineValue * 10, 0),
                          child: AmountInputView(
                            amountController: widget.model.amountController,
                            focusNode: widget.model.buyFieldNode,
                            chipAmounts: widget
                                .model.assetOptionsModel!.data.userOptions,
                            isEnabled: !widget.model.isBuyInProgress ||
                                !widget.model.forcedBuy,
                            maxAmount: widget.model.maxAmount,
                            maxAmountMsg: locale.maxAmountMessage(
                              widget.model.maxAmount,
                            ),
                            minAmount: widget.model.minAmount.toDouble(),
                            minAmountMsg:
                                "Minimum purchase amount is ₹ ${widget.model.minAmount.toInt()}",
                            notice: widget.model.buyNotice,
                            onAmountChange: (amount) {},
                            bestChipIndex: 2,
                            readOnly: widget.model.readOnly,
                            onTap: () => widget.model.showKeyBoard(),
                            model: widget.model,
                          ),
                        );
                      }),
                SizedBox(
                  height: SizeConfig.padding10,
                ),
                if (widget.model.showCoupons) ...[
                  Container(
                    height: 1,
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins,
                    ),
                    color: UiConstants.kModalSheetSecondaryBackgroundColor
                        .withOpacity(0.2),
                  ),
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
                  FloCouponWidget(
                    widget.model.couponList,
                    widget.model,
                    onTap: (coupon) {
                      widget.model.applyCoupon(coupon.code, false);
                    },
                  ),
                  SizedBox(height: SizeConfig.padding24),
                ],
                canChangeMaturityDate
                    ? MaturityDetailsWidget(model: widget.model)
                    : MaturityTextWidget(),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Selector<BankAndPanService, bool>(
                selector: (p0, p1) => p1.isKYCVerified,
                builder: (ctx, isKYCVerified, child) {
                  return (!isKYCVerified)
                      ? _kycWidget(widget.model, context)
                      : (widget.model.isBuyInProgress || widget.model.forcedBuy)
                          ? Container(
                              height: SizeConfig.screenWidth! * 0.1556,
                              alignment: Alignment.center,
                              width: SizeConfig.screenWidth! * 0.7,
                              child: const LinearProgressIndicator(
                                color: UiConstants.primaryColor,
                                backgroundColor:
                                    UiConstants.kDarkBackgroundColor,
                              ),
                            )
                          : FloBuyNavBar(
                              model: widget.model,
                              onTap: () {
                                locator<AnalyticsService>().track(
                                    eventName: AnalyticsEvents.saveInitiate,
                                    properties: {
                                      "investmentType":
                                          InvestmentType.LENDBOXP2P.name,
                                    });
                                if ((widget.model.buyAmount ?? 0) <
                                    widget.model.minAmount) {
                                  BaseUtil.showNegativeAlert("Invalid Amount",
                                      "Please Enter Amount Greater than ${widget.model.minAmount}");
                                  return;
                                }

                                if (!widget.model.isBuyInProgress) {
                                  FocusScope.of(context).unfocus();
                                  widget.model.initiateBuy();
                                }
                              },
                            );
                },
              )),
          CustomKeyboardSubmitButton(
            onSubmit: () => widget.model.buyFieldNode.unfocus(),
          ),
        ],
      ),
    );
  }

  Widget _kycWidget(LendboxBuyViewModel model, BuildContext context) {
    S locale = S.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              locale.kycIncomplete,
              style: TextStyles.sourceSans.body3.colour(
                UiConstants.kTextColor,
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          AppNegativeBtn(
            btnText: locale.completeKYCText,
            onPressed: model.navigateToKycScreen,
            width: SizeConfig.screenWidth,
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
        ],
      ),
    );
  }
}

class FloBuyNavBar extends StatelessWidget {
  const FloBuyNavBar({
    required this.model,
    required this.onTap,
    super.key,
  });

  final LendboxBuyViewModel model;
  final Function onTap;

  String getTitle() {
    if (model.floAssetType == Constants.ASSET_TYPE_FLO_FELXI &&
        model.isLendboxOldUser) {
      return '10% Returns p.a.';
    } else if (model.floAssetType == Constants.ASSET_TYPE_FLO_FELXI &&
        !model.isLendboxOldUser) {
      return '8% Returns p.a.';
    }

    if (model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return "12% Returns p.a.";
    }
    if (model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return "10% Returns p.a.";
    }

    return "";
  }

  String getSubString() {
    final date = model.getMaturityTime(model.selectedOption);

    return switch (model.floAssetType) {
      Constants.ASSET_TYPE_FLO_FELXI => 'Lock-in till $date',
      Constants.ASSET_TYPE_FLO_FIXED_6 ||
      Constants.ASSET_TYPE_FLO_FIXED_3 =>
        'Maturity on $date',
      _ => ''
    };
  }

  void _openPaymentSheet({
    bool showBreakDown = true,
    bool showPsp = true,
    bool isBreakDown = false,
  }) {
    final amt = model.amountController?.text;
    final amtInNum = num.tryParse(amt ?? '');
    BaseUtil.openModalBottomSheet(
      isBarrierDismissible: true,
      addToScreenStack: true,
      backgroundColor: UiConstants.grey5,
      content: FloBreakdownView(
        model: model,
        showBreakDown: showBreakDown,
        showPaymentOption: showPsp,
        isBreakDown: isBreakDown,
        onSave: () => _onPressed(amtInNum),
      ),
      hapticVibrate: true,
      isScrollControlled: true,
    );
  }

  void _onPressed(num? amount) {
    if (amount == null) return;

    if (amount >= Constants.mandatoryNetBankingThreshold) {
      _openPaymentSheet(
        showBreakDown: AppConfig.getValue(
          AppConfigKey.payment_brief_view,
        ),
      );
      return;
    }

    if (model.isIntentFlow && model.selectedUpiApplication != null) {
      onTap();
    } else {
      _openPaymentSheet(
        showBreakDown: AppConfig.getValue(
          AppConfigKey.payment_brief_view,
        ),
      );
    }
  }

  void _showBreakDown() {
    _openPaymentSheet(
      showPsp: false,
      isBreakDown: true,
    );
    locator<AnalyticsService>()
        .track(eventName: AnalyticsEvents.viewBreakdownTapped, properties: {
      'Amount Filled': model.amountController?.text ?? '0',
      'Asset': model.floAssetType,
      'coupon': model.appliedCoupon
    });
  }

  void _onResetPaymentIntent(String? intent) {
    _openPaymentSheet(
      showBreakDown: AppConfig.getValue(
        AppConfigKey.payment_brief_view,
      ),
    );

    _trackChange(intent);
  }

  void _trackChange(String? intent) {
    if (intent == null) {
      return;
    }

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.editPreferredUpiOption,
      properties: {
        'current_upi': intent,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final couponCode = model.appliedCoupon?.code;
    final amt = model.amountController?.text;
    final amtInNum = num.tryParse(amt ?? '');
    final amount = amt != null && amt.isNotEmpty ? amt : '_ _';
    final isAmountIsValid = amt != null && amt.isNotEmpty;
    final preferredOption = model.getPreferredUpiOption;

    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding16,
        vertical: SizeConfig.padding16,
      ),
      decoration: const BoxDecoration(
        color: UiConstants.grey5,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.floWithoutShadow,
                        height: 16,
                      ),
                      SizedBox(
                        width: SizeConfig.padding8,
                      ),
                      Text(
                        getTitle(),
                        style: TextStyles.rajdhaniB.body2.copyWith(
                          color: UiConstants.kFAQsAnswerColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding4,
                  ),
                  Text(
                    getSubString(),
                    style: TextStyles.sourceSans.body3.copyWith(
                      color: UiConstants.kTextFieldTextColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (!isAmountIsValid) return;
                      _showBreakDown();
                    },
                    child: Row(
                      children: [
                        Text(
                          'Payment summary',
                          style: TextStyles.sourceSansSB.body4.copyWith(
                            height: 1,
                            color: UiConstants.kFAQsAnswerColor.withOpacity(
                              !isAmountIsValid ? .5 : 1,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.padding8,
                        ),
                        SvgPicture.asset(
                          Assets.arrow,
                          color: UiConstants.kFAQsAnswerColor,
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  if (couponCode != null)
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.padding4),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Assets.couponsAsset,
                            color: UiConstants.kTabBorderColor,
                            height: 12,
                          ),
                          SizedBox(
                            width: SizeConfig.padding6,
                          ),
                          Text(
                            couponCode,
                            style: TextStyles.rajdhani.body4.copyWith(
                              color: UiConstants.kTabBorderColor,
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ],
          ),
          Divider(
            color: UiConstants.kFAQDividerColor.withOpacity(.2),
            thickness: .8,
            height: 24,
          ),
          Row(
            children: [
              if (preferredOption != null &&
                  amtInNum != null &&
                  amtInNum <= Constants.mandatoryNetBankingThreshold &&
                  model.isIntentFlow)
                Padding(
                  padding: EdgeInsets.only(
                    right: SizeConfig.padding12,
                  ),
                  child: PreferredPaymentOption(
                    appUse: preferredOption.getAppUseByName(),
                    onPressed: () => _onResetPaymentIntent(preferredOption),
                  ),
                ),
              Expanded(
                child: AppPositiveBtn(
                  height: SizeConfig.padding56,
                  onPressed: () => _onPressed(amtInNum),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          '₹ $amount',
                          style: TextStyles.sourceSansSB.title4.colour(
                            Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'SAVE',
                          style: TextStyles.rajdhaniB.body1.colour(
                            Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.padding16,
                        ),
                        Transform.rotate(
                          angle: math.pi / 2,
                          child: SvgPicture.asset(
                            Assets.arrow,
                            color: Colors.white,
                            height: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MaturityDetailsWidget extends StatelessWidget {
  const MaturityDetailsWidget({
    required this.model,
    super.key,
  });

  final LendboxBuyViewModel model;

  @override
  Widget build(BuildContext context) {
    return Selector<BankAndPanService, bool>(
      selector: (p0, p1) => p1.isKYCVerified,
      builder: (ctx, isKYCVerified, child) {
        return isKYCVerified
            ? const SizedBox()
            : (model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6 ||
                    model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_3)
                ? GestureDetector(
                    onTap: () {
                      if (!model.isBuyInProgress) {
                        model.openReinvestBottomSheet();
                      }

                      model.analyticsService.track(
                          eventName: AnalyticsEvents.maturityChoiceTapped,
                          properties: {
                            'amount': model.buyAmount,
                            "asset": model.floAssetType,
                          });
                    },
                    child: Container(
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1,
                            color: UiConstants
                                .kModalSheetSecondaryBackgroundColor
                                .withOpacity(0.2),
                          ),
                          SizedBox(
                            height: SizeConfig.padding16,
                          ),
                          Text(
                            'Choose your maturity period',
                            style: TextStyles.sourceSansSB.body2,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: SizeConfig.padding16,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: UiConstants.grey2.withOpacity(.2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                model.showReinvestSubTitle(),
                                Text(
                                  "Change",
                                  style: TextStyles.sourceSans.body3
                                      .colour(UiConstants.kTabBorderColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox();
      },
    );
  }
}

class MaturityTextWidget extends StatelessWidget {
  const MaturityTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: UiConstants.kModalSheetSecondaryBackgroundColor
                .withOpacity(0.2),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          RichText(
            text: TextSpan(
              text: "Note: ",
              style: TextStyles.sourceSansSB.body3,
              children: [
                TextSpan(
                    text:
                        "Post maturity, the amount will be moved to 8% Flo which can be withdrawn anytime.",
                    style:
                        TextStyles.sourceSans.body3.colour(UiConstants.grey1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
