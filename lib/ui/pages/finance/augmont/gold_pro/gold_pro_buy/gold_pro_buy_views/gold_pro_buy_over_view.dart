import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/widgets/view_breakdown.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_components/gold_balance_rows.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_views/gold_pro_buy_input_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/preferred_payment_option.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../gold_pro_buy_components/gold_pro_info_row.dart';

class GoldProBuyOverView extends StatelessWidget {
  const GoldProBuyOverView({
    required this.model,
    required this.txnService,
    super.key,
  });

  final GoldProBuyViewModel model;
  final AugmontTransactionService txnService;

  void _openPaymentSheet(
      {bool showBreakDown = true,
      bool showPsp = true,
      bool isBreakDown = false}) {
    final amt = model.totalGoldAmount;
    BaseUtil.openModalBottomSheet(
      isBarrierDismissible: true,
      addToScreenStack: true,
      isScrollControlled: true,
      backgroundColor: const Color(0xff1A1A1A),
      content: GoldProBreakdownView(
        model: model,
        showBreakDown: showBreakDown,
        showPaymentOption: true, //! change this back to var value
        isBreakDown: isBreakDown,
        onSave: () => _onPressed(amt),
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

    if (model.hasEnoughGoldBalanceForLease) {
      await model.initiateGoldProTransaction();
      return;
    }

    if (!model.isChecked) {
      BaseUtil.showNegativeAlert(
        "Please accept the terms and conditions",
        "to continue saving in ${Constants.ASSET_GOLD_STAKE}",
      );
      return;
    }

    if (amount >= Constants.mandatoryNetBankingThreshold) {
      _openPaymentSheet(
        showBreakDown: AppConfig.getValue(
          AppConfigKey.payment_brief_view,
        ),
      );
      return;
    }

    if (model.isIntentFlow && model.selectedUpiApplication != null) {
      await model.initiateGoldProTransaction();
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

  Widget _buildButtonLabel(
      {required bool hasEnoughBalance, required num amount}) {
    final style = TextStyles.rajdhaniB.body1.colour(
      Colors.white,
    );

    if (hasEnoughBalance) {
      return Text(
        'PROCEED',
        style: style,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(
            '₹ $amount',
            style: style,
          ),
          const Spacer(),
          Text(
            'SAVE',
            style: style,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final preferredOption = model.getPreferredUpiOption;
    final amt = model.totalGoldAmount;

    return Column(
      children: [
        AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (txnService.isGoldBuyInProgress) return;
              Haptic.vibrate();
              txnService.currentTransactionState = TransactionState.idle;
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Assets.digitalGoldBar,
                width: SizeConfig.padding54,
                height: SizeConfig.padding54,
              ),
              // SizedBox(width: SizeConfig.padding8),
              Text(
                Constants.ASSET_GOLD_STAKE,
                style: TextStyles.rajdhaniSB.title5,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight! * 0.03),
              Text(
                "You are investing",
                style: TextStyles.rajdhaniM.title4.colour(Colors.grey),
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.008),
              Text(
                "${model.totalGoldBalance}gms",
                style: TextStyles.rajdhaniB.title1.colour(Colors.white),
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.04),
              SizedBox(height: SizeConfig.screenHeight! * 0.02),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Expected Returns in 5Y',
                        style: TextStyles.rajdhaniB.body1,
                      ),
                      Text(
                        "₹${"${model.expectedGoldReturns.toInt()}".formatToIndianNumberSystem()}*",
                        style: TextStyles.rajdhaniB.title4,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'with Gold Pro',
                        style: TextStyles.sourceSans.body3.colour(
                          UiConstants.grey1,
                        ),
                      ),
                      Text(
                        '@ 15.5 % p.a',
                        style: TextStyles.sourceSans.body3.colour(
                          UiConstants.grey1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              GoldBalanceRow(
                lead: "Current Gold Balance",
                trail: model.currentGoldBalance,
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              GoldBalanceRow(
                lead: "Additional Gold to be added",
                trail: model.additionalGoldBalance,
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              PriceAdaptiveGoldProOverViewCard(model: model),
              const GoldProLeaseCompanyDetailsStrip(),
              SizedBox(height: SizeConfig.padding14),
              InfoRow(
                  text: "Auto Lease ",
                  child: CustomSwitch(
                    value: model.isAutoLeaseChecked,
                    onChanged: (val) {
                      model.isAutoLeaseChecked = val;
                    },
                  )

                  // Checkbox(
                  //   checkColor: UiConstants.teal3,
                  //   // side: MaterialStateBorderSide.resolveWith(
                  //   //   (states) => BorderSide(
                  //   //       width: 1.0,
                  //   //       color: model.isAutoLeaseChecked
                  //   //           ? UiConstants.kTextColor
                  //   //           : Colors.transparent),
                  //   // ),
                  //   // activeColor: UiConstants.kProfileBorderColor,
                  //   fillColor: MaterialStateProperty.all(
                  //       UiConstants.kProfileBorderColor),
                  //   value: model.isAutoLeaseChecked,
                  //   onChanged: (newValue) {
                  //     print("newValue:- $newValue");
                  //     model.isAutoLeaseChecked = newValue!;
                  //   },
                  // ),
                  ),
            ],
          ),
        ),
        const Spacer(),
        txnService.isGoldBuyInProgress
            ? Padding(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: const LinearProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!locator<UserService>()
                      .userPortfolio
                      .augmont
                      .fd
                      .isGoldProUser)
                    Padding(
                      padding: EdgeInsets.fromLTRB(SizeConfig.padding10,
                          SizeConfig.padding10, SizeConfig.padding10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: model.isChecked,
                            onChanged: (newValue) {
                              model.isChecked = newValue!;
                            },
                          ),
                          // SizedBox(width: SizeConfig.padding10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "I have read and agreed to the ",
                                  style: TextStyles.sourceSans.body3
                                      .colour(UiConstants.kTextColor2),
                                ),
                                TextSpan(
                                  text: "Terms and Conditions",
                                  style: TextStyles.sourceSans.body3.underline
                                      .colour(UiConstants.primaryColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = onTermsAndConditionsClicked,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins,
                      vertical: SizeConfig.padding16,
                    ),
                    decoration: const BoxDecoration(
                      color: UiConstants.grey5,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!model.hasEnoughGoldBalanceForLease)
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
                                        Constants.ASSET_GOLD_STAKE,
                                        style:
                                            TextStyles.rajdhaniB.body2.copyWith(
                                          color: UiConstants.kFAQsAnswerColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding10,
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
                              InkWell(
                                onTap: () => _openPaymentSheet(
                                  showPsp: false,
                                  isBreakDown: true,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Payment summary',
                                      style: TextStyles.sourceSansSB.body4
                                          .copyWith(
                                        height: 1,
                                        color: UiConstants.kFAQsAnswerColor,
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
                              )
                            ],
                          ),
                        if (!model.hasEnoughGoldBalanceForLease)
                          SizedBox(
                            height: SizeConfig.padding10,
                          ),
                        Row(
                          children: [
                            if (preferredOption != null &&
                                amt <= Constants.mandatoryNetBankingThreshold &&
                                model.isIntentFlow &&
                                !model.hasEnoughGoldBalanceForLease)
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
                              child: SizedBox(
                                height: SizeConfig.padding56,
                                child: ReactivePositiveAppButton(
                                  onPressed: () => _onPressed(amt),
                                  width: double.infinity,
                                  isDisabled: !model.isChecked,
                                  child: _buildButtonLabel(
                                    hasEnoughBalance:
                                        model.hasEnoughGoldBalanceForLease,
                                    amount: amt,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )
      ],
    );
  }

  void onTermsAndConditionsClicked() {
    Haptic.vibrate();
    BaseUtil.launchUrl('https://fello.in/policy/gold-pro-terms-of-use');
    locator<AnalyticsService>()
        .track(eventName: AnalyticsEvents.termsAndConditions);
  }
}

// class SwitchButton extends StatefulWidget {
//   const SwitchButton({super.key, required this.model});
//   final GoldProBuyViewModel model;

//   @override
//   State<SwitchButton> createState() => _SwitchButtonState();
// }

// class _SwitchButtonState extends State<SwitchButton> {
//   bool light = true;

//   @override
//   Widget build(BuildContext context) {
//     return Switch(
//       // This bool value toggles the switch.
//       value: widget.model.isAutoLeaseChecked,
//       activeColor: Colors.blue,
// //       focusColor: Colors.pink,
//       activeTrackColor: Colors.black,
//       // inactiveThumbImage: const AssetImage('assets/images/subtract_switch.png'),
//       onChanged: (bool value) {
//         // This is called when the user toggles the switch.
//         setState(() {
//           widget.model.isAutoLeaseChecked = value;
//         });
//       },
//     );
//   }
// }
