import 'dart:async';
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
import 'package:felloapp/ui/pages/finance/lendbox/deposit/widget/prompt.dart';
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

  const LendboxBuyInputView({
    required this.model,
    super.key,
    this.amount,
    this.skipMl,
  });

  @override
  State<LendboxBuyInputView> createState() => _LendboxBuyInputViewState();
}

String _getTitle(num interest) {
  return '$interest% P2P';
}

class _LendboxBuyInputViewState extends State<LendboxBuyInputView> {
  @override
  void initState() {
    locator<BackButtonActions>().isTransactionCancelled = true;
    AppState.type = InvestmentType.LENDBOXP2P;
    AppState.amt = (widget.model.buyAmount ?? 0) * 1.0;
    AppState.onTap = () async {
      await AppState.backButtonDispatcher!.didPopRoute();
      locator<AnalyticsService>().track(
        eventName: AnalyticsEvents.saveInitiate,
        properties: {
          "investmentType": InvestmentType.AUGGOLD99.name,
        },
      );
      if (widget.model.isIntentFlow) {
        unawaited(
          BaseUtil.openModalBottomSheet(
            isBarrierDismissible: true,
            addToScreenStack: true,
            content: FloBreakdownView(
              model: widget.model,
              showBreakDown:
                  AppConfig.getValue(AppConfigKey.payment_brief_view),
            ),
            hapticVibrate: true,
            isScrollControlled: true,
          ),
        );
      } else {
        {
          locator<AnalyticsService>().track(
            eventName: AnalyticsEvents.saveInitiate,
            properties: {
              "investmentType": InvestmentType.LENDBOXP2P.name,
            },
          );
          if ((widget.model.buyAmount ?? 0) < widget.model.minAmount) {
            BaseUtil.showNegativeAlert(
              "Invalid Amount",
              "Please Enter Amount Greater than ${widget.model.minAmount}",
            );
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

    final locale = S.of(context);
    final AnalyticsService analyticsService = locator<AnalyticsService>();

    return PropertyChangeProvider<BankAndPanService,
        BankAndPanServiceProperties>(
      value: locator<BankAndPanService>(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  LendBoxAppBar(
                    assetName: _getTitle(widget.model.config.interest),
                    isEnabled: !widget.model.isBuyInProgress,
                    trackClosingEvent: () {
                      analyticsService.track(
                        eventName: AnalyticsEvents.savePageClosed,
                        properties: {
                          "Amount entered": widget.model.amountController!.text,
                          "Asset": widget.model.floAssetType,
                        },
                      );
                      if (locator<BackButtonActions>().isTransactionCancelled) {
                        if (AppState.delegate!.currentConfiguration!.key ==
                                'LendboxBuyViewPath' &&
                            (AppState.screenStack.last !=
                                    ScreenItem.modalsheet ||
                                AppState.screenStack.last !=
                                    ScreenItem.dialog) &&
                            !AppState.isRepeated) {
                          locator<BackButtonActions>()
                              .showWantToCloseTransactionBottomSheet(
                                  double.parse(
                                    widget.model.amountController!.text,
                                  ).round(),
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
                        final sineValue = math.sin(
                          6 * math.pi * widget.model.animationController!.value,
                        );
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
                            minAmount: widget.model.minAmount.toDouble(),
                            maxAmountMsg: locale.maxAmountMessage(
                              widget.model.maxAmount,
                            ),
                            minAmountMsg: locale.minAmountMessage(
                              widget.model.minAmount,
                            ),
                            notice: widget.model.buyNotice,
                            bestChipIndex: 2,
                            readOnly: widget.model.readOnly,
                            onTap: () => widget.model.showKeyBoard(),
                            model: widget.model,
                          ),
                        );
                      },
                    ),
                  if (widget.model.showCoupons) ...[
                    Divider(
                      color: UiConstants.kModalSheetSecondaryBackgroundColor
                          .withOpacity(0.2),
                      height: SizeConfig.padding1,
                      indent: SizeConfig.pageHorizontalMargins,
                      endIndent: SizeConfig.pageHorizontalMargins,
                    ),
                    SizedBox(
                      height: SizeConfig.padding24,
                    ),
                    FloCouponWidget(
                      widget.model.couponList,
                      widget.model,
                      onTap: (coupon) => widget.model.applyCoupon(
                        coupon.code,
                        false,
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding24),
                  ],
                  Divider(
                    color: UiConstants.kModalSheetSecondaryBackgroundColor
                        .withOpacity(0.2),
                    indent: SizeConfig.pageHorizontalMargins,
                    endIndent: SizeConfig.pageHorizontalMargins,
                  ),
                  SizedBox(height: SizeConfig.padding24),
                  _ReInvestNudge(
                    initialValue: true,
                    onChange: (value) {
                      widget.model.selectedOption = value
                          ? UserDecision.reInvest
                          : UserDecision.moveToFlexi;
                    },
                  ),
                ],
              ),
            ),
          ),
          Selector<BankAndPanService, bool>(
            selector: (p0, p1) => p1.isKYCVerified,
            builder: (ctx, isKYCVerified, child) {
              final state = (
                isKYCVerified,
                widget.model.isBuyInProgress,
                widget.model.forcedBuy
              );

              return switch (state) {
                (false, _, _) => _kycWidget(widget.model, context),
                (_, true, _) || (_, _, true) => Container(
                    height: SizeConfig.screenWidth! * 0.1556,
                    alignment: Alignment.center,
                    width: SizeConfig.screenWidth! * 0.7,
                    child: const LinearProgressIndicator(
                      color: UiConstants.primaryColor,
                      backgroundColor: UiConstants.kDarkBackgroundColor,
                    ),
                  ),
                _ => FloBuyNavBar(
                    key: const ValueKey('save'),
                    model: widget.model,
                    onTap: () {
                      locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.saveInitiate,
                        properties: {
                          "investmentType": InvestmentType.LENDBOXP2P.name,
                        },
                      );
                      if ((widget.model.buyAmount ?? 0) <
                          widget.model.minAmount) {
                        BaseUtil.showNegativeAlert(
                          "Invalid Amount",
                          "Please Enter Amount Greater than ${widget.model.minAmount}",
                        );
                        return;
                      }

                      if (!widget.model.isBuyInProgress) {
                        FocusScope.of(context).unfocus();
                        widget.model.initiateBuy();
                      }
                    },
                  )
              };
            },
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

class _ReInvestNudge extends StatefulWidget {
  const _ReInvestNudge({
    required this.initialValue,
    required this.onChange,
  });

  final bool initialValue;
  final ValueChanged<bool> onChange;

  @override
  State<_ReInvestNudge> createState() => _ReInvestNudgeState();
}

class _ReInvestNudgeState extends State<_ReInvestNudge> {
  bool _value = true;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _onChanged(bool value) {
    setState(() {
      _value = value;
      widget.onChange(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Reinvest on Maturity',
                    style: TextStyles.sourceSans.body3.copyWith(
                      color: UiConstants.grey1,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.padding8,
                  ),
                  const Icon(
                    Icons.info_outline,
                    size: 14,
                    color: UiConstants.grey1,
                  ),
                ],
              ),
              CustomSwitch(
                initialValue: true,
                onChanged: _onChanged,
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          if (_value)
            Text.rich(
              TextSpan(
                style: TextStyles.sourceSans.body3.colour(
                  UiConstants.KGoldProSecondary,
                ),
                children: [
                  TextSpan(text: 'Extra '),
                  TextSpan(
                    text: '+ 0.25%',
                    style: TextStyles.sourceSansSB.body3.colour(
                      UiConstants.KGoldProSecondary,
                    ),
                  ),
                  TextSpan(text: ' on reinvestment')
                ],
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: SizeConfig.padding180,
                  child: Text.rich(
                    TextSpan(
                      style: TextStyles.sourceSans.body4.colour(
                        UiConstants.grey1,
                      ),
                      children: [
                        TextSpan(text: 'Withdraw-able after maturity from '),
                        TextSpan(
                          text: 'P2P Wallet',
                          style: TextStyles.sourceSansB.body4.colour(
                            UiConstants.grey1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.padding132,
                  child: Text.rich(
                    TextSpan(
                      style: TextStyles.sourceSans.body4.colour(
                        UiConstants.teal3,
                      ),
                      children: [
                        TextSpan(text: 'Switch On for '),
                        TextSpan(
                          text: '+0.25%',
                          style: TextStyles.sourceSansB.body4.colour(
                            UiConstants.teal3,
                          ),
                        ),
                        TextSpan(text: ' on reinvestment'),
                      ],
                    ),
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            )
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
  final VoidCallback onTap;

  String _getTitle(num interest) {
    return '$interest% P2P';
  }

  String _getSubString() {
    final date = model.getMaturityTime(model.selectedOption);
    return 'Lock-in till $date';
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
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.viewBreakdownTapped,
      properties: {
        'Amount Filled': model.amountController?.text ?? '0',
        'Asset': model.floAssetType,
        'coupon': model.appliedCoupon
      },
    );
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
                        _getTitle(model.config.interest),
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
                    _getSubString(),
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
                  Text(
                    model.config.assetName,
                    style: TextStyles.sourceSansB.body3,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     if (!isAmountIsValid) return;
                  //     _showBreakDown();
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         'Payment summary',
                  //         style: TextStyles.sourceSansSB.body4.copyWith(
                  //           height: 1,
                  //           color: UiConstants.kFAQsAnswerColor.withOpacity(
                  //             !isAmountIsValid ? .5 : 1,
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: SizeConfig.padding8,
                  //       ),
                  //       SvgPicture.asset(
                  //         Assets.arrow,
                  //         color: UiConstants.kFAQsAnswerColor,
                  //         height: 5,
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
