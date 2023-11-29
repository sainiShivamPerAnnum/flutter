import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/widgets/view_breakdown.dart';
import 'package:felloapp/ui/pages/finance/preferred_payment_option.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuyNavBar extends StatelessWidget {
  const BuyNavBar({
    required this.model,
    required this.onTap,
    super.key,
  });

  final GoldBuyViewModel model;
  final VoidCallback onTap;

  void _openPaymentSheet({
    bool showBreakDown = true,
    bool showPsp = true,
    bool isBreakDown = false,
  }) {
    final amt = model.goldAmountController?.text;
    final amtInNum = num.tryParse(amt ?? '');
    BaseUtil.openModalBottomSheet(
      isBarrierDismissible: true,
      addToScreenStack: true,
      isScrollControlled: true,
      backgroundColor: const Color(0xff1A1A1A),
      content: GoldBreakdownView(
        model: model,
        showBreakDown: showBreakDown,
        showPaymentOption: showPsp,
        isBreakDown: isBreakDown,
        onSave: () => _onPressed(amtInNum),
      ),
    );
  }

  /// Based on various conditions either opens relative payment gateway or opens
  /// [GoldBreakdownView].
  ///
  /// * If [amount] is greater than [Constants.mandatoryNetBankingThreshold]
  ///   then opens up [GoldBreakdownView] with net-banking configuration.
  /// * If BE provides payment mode as intent and preferred payment option is
  ///   not null then opens up relative psp directly or else opens up
  ///   [GoldBreakdownView] with psp payment mode configuration.
  Future<void> _onPressed(num? amount) async {
    if (amount == null) return;

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.saveInitiate,
      properties: {
        "investmentType": InvestmentType.AUGGOLD99.name,
      },
    );

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
    final amt = model.goldAmountController?.text;
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
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.goldWithoutShadow,
                        height: 16,
                      ),
                      SizedBox(
                        width: SizeConfig.padding8,
                      ),
                      Text(
                        'Digital Gold',
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
                    'Inc. (GST)',
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
                      _openPaymentSheet(
                        showPsp: false,
                        isBreakDown: true,
                      );
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
                    ),
                ],
              ),
            ],
          ),
          Divider(
            color: UiConstants.kFAQDividerColor.withOpacity(.2),
            thickness: .8,
            height: 24,
          ),
          if (model.status == 2)
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
                      onPressed: () => _onResetPaymentIntent(
                        preferredOption,
                      ),
                    ),
                  ),
                Expanded(
                  child: AppPositiveBtn(
                    height: SizeConfig.padding56,
                    width: double.infinity,
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
                            angle: pi / 2,
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
                )
              ],
            )
          else
            const AppNegativeBtn(
              btnText: 'Save',
            )
        ],
      ),
    );
  }
}
