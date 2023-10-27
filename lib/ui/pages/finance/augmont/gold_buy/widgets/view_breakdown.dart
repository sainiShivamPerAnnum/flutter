import 'dart:typed_data';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/widget/prompt.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/assets.dart' as A;
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:upi_pay/upi_pay.dart';

import '../../../../../../util/locator.dart';

class GoldBreakdownView extends StatelessWidget {
  const GoldBreakdownView({
    required this.model,
    Key? key,
    this.showPsp = true,
    this.showBreakDown = true,
  }) : super(key: key);

  final GoldBuyViewModel model;
  final bool showPsp, showBreakDown;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        locator<AnalyticsService>().track(
            eventName: AnalyticsEvents.intentTransactionBackPressed,
            properties: {
              "goldBuyAmount": model.goldBuyAmount,
              "couponCode": model.appliedCoupon?.code ?? '',
              "skipMl": model.skipMl,
              "goldInGrams": model.goldAmountInGrams,
              "abTesting": AppConfig.getValue(AppConfigKey.payment_brief_view)
                  ? "with payment summary"
                  : "without payment summary"
            });
        return Future.value(true);
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: SizeConfig.padding28),
            if (showBreakDown)
              Column(
                children: [
                  if (showPsp)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: SizeConfig.padding10,
                      ),
                      child: Text(
                        "Payment Summary",
                        style:
                            TextStyles.sourceSansB.body0.colour(Colors.white),
                      ),
                    ),
                  if (showPsp)
                    Divider(
                      color: UiConstants.primaryColor,
                      height: SizeConfig.padding16,
                    ),
                  SizedBox(height: SizeConfig.padding12),
                  Row(
                    children: [
                      Text("Invested Amount",
                          style: TextStyles.sourceSans.body2),
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
                  Row(
                    children: [
                      Text(
                        "GST (${model.goldRates?.igstPercent}%)",
                        style: TextStyles.sourceSans.body2,
                      ),
                      const Spacer(),
                      Text(
                        "₹${((model.goldRates?.igstPercent)! / 100 * double.parse(model.goldAmountController?.text ?? '0')).toStringAsFixed(2)}",
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
                  Row(
                    children: [
                      Text("Digital Gold Amount",
                          style: TextStyles.sourceSans.body2),
                      const Spacer(),
                      Text(
                        "₹${(int.tryParse(model.goldAmountController?.text ?? '0')! - ((model.goldRates?.igstPercent)! / 100 * double.parse(model.goldAmountController?.text ?? '0'))).toStringAsFixed(2)}",
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
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
                    height: SizeConfig.padding24,
                  ),
                  if ((model.totalTickets ?? 0) > 0 && !showPsp) ...[
                    Divider(
                        color:
                            UiConstants.kLastUpdatedTextColor.withOpacity(0.5)),
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
                          width: SizeConfig.padding8,
                        ),
                        Text(
                          "Total Tickets",
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
                    if (model.showHappyHour &&
                        model.happyHourTickets != null) ...[
                      Row(
                        children: [
                          Text(
                            "Happy Hour Tickets",
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
                            "Lifetime Tickets",
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
                  ],
                  if (model.appliedCoupon != null) ...[
                    Divider(
                        color:
                            UiConstants.kLastUpdatedTextColor.withOpacity(0.5)),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
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
                  if (showBreakDown)
                    Divider(
                        color:
                            UiConstants.kLastUpdatedTextColor.withOpacity(0.5))
                ],
              ),
            if (showPsp && model.isIntentFlow)
              UpiAppsGridView(
                apps: model.appMetaList,
                onTap: (i) {
                  if (!model.isGoldBuyInProgress) {
                    Haptic.vibrate();
                    FocusScope.of(context).unfocus();

                    model.selectedUpiApplication = i == -1
                        ? ApplicationMeta.android(
                            UpiApplication.PhonePeSimulator,
                            Uint8List(10),
                            1,
                            1)
                        : model.appMetaList[i];

                    model.initiateBuy();
                  }

                  AppState.backButtonDispatcher?.didPopRoute();
                },
              ),
            if (!model.isIntentFlow)
              AppPositiveBtn(
                width: SizeConfig.screenWidth!,
                onPressed: () {
                  if (!model.isGoldBuyInProgress) {
                    FocusScope.of(context).unfocus();
                    model.initiateBuy();
                  }

                  AppState.backButtonDispatcher?.didPopRoute();
                },
                btnText:
                    model.status == 2 ? "Save" : 'unavailable'.toUpperCase(),
              ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
          ],
        ),
      ),
    );
  }
}

class UpiAppsGridView extends StatelessWidget {
  const UpiAppsGridView({
    required this.apps,
    required this.onTap,
    this.padTop = false,
    super.key,
  });

  final List<ApplicationMeta> apps;
  final Function onTap;
  final bool padTop;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        return Future.value(true);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: padTop ? SizeConfig.padding32 : SizeConfig.padding10,
              bottom: SizeConfig.padding32,
            ),
            child: Text(
              "Choose a UPI app",
              style: TextStyles.sourceSansB.body0.colour(Colors.white),
            ),
          ),
          apps.isEmpty
              ? (FlavorConfig.isDevelopment()
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.padding40,
                        horizontal: SizeConfig.pageHorizontalMargins,
                      ),
                      child: Column(
                        children: [
                          const Chip(
                            label: Text("Only for dev Purpose"),
                            backgroundColor: UiConstants.primaryColor,
                          ),
                          SizedBox(height: SizeConfig.padding6),
                          Text(
                            "No PSP Apps on this device found, Install Phonepe simulator app and then only continue",
                            textAlign: TextAlign.center,
                            style: TextStyles.body2.colour(Colors.white),
                          ),
                          SizedBox(height: SizeConfig.padding14),
                          MaterialButton(
                            onPressed: () {
                              onTap(-1);
                            },
                            color: Colors.white,
                            height: SizeConfig.padding54,
                            child: Text(
                              "CONTINUE",
                              style: TextStyles.rajdhaniB.body1
                                  .colour(Colors.black),
                            ),
                          )
                        ],
                      ))
                  : Padding(
                      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                      child: Text(
                        "No Upi Apps found on this device. Please install Google pay, Phonepe or Paytm to start your saving journey",
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSansB.body2.colour(Colors.red),
                      ),
                    ))
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    // mainAxisSpacing: 2,
                    // crossAxisSpacing: 2,
                  ),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: apps.length,
                  itemBuilder: (ctx, i) {
                    return GestureDetector(
                      onTap: () => onTap(i),
                      child: SizedBox(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: apps[i].iconImage(SizeConfig.padding48),
                            ),
                            SizedBox(height: SizeConfig.padding6),
                            Text(
                              apps[i].upiApplication.appName,
                              style: TextStyles.sourceSansM.body3
                                  .colour(Colors.white),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    );
                  }),
        ],
      ),
    );
  }
}

class FloBreakdownView extends StatelessWidget {
  const FloBreakdownView({
    required this.model,
    this.showPsp = true,
    this.showBreakDown = true,
    Key? key,
  }) : super(key: key);

  final LendboxBuyViewModel model;
  final bool showPsp, showBreakDown;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        locator<AnalyticsService>().track(
            eventName: AnalyticsEvents.intentTransactionBackPressed,
            properties: {
              "floAssetType": model.floAssetType,
              "maturityPref": model.maturityPref,
              "couponCode": model.appliedCoupon?.code ?? '',
              "txnAmount": model.buyAmount,
              "skipMl": model.skipMl,
              "abTesting": AppConfig.getValue(AppConfigKey.payment_brief_view)
                  ? "with payment summary"
                  : "without payment summary"
            });
        return true;
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: SizeConfig.padding28),
            if (showBreakDown)
              Column(
                children: [
                  if (showPsp)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: SizeConfig.padding10,
                      ),
                      child: Text(
                        "Payment Summary",
                        style:
                            TextStyles.sourceSansB.body0.colour(Colors.white),
                      ),
                    ),
                  if (showPsp)
                    Divider(
                      color: UiConstants.primaryColor,
                      height: SizeConfig.padding16,
                    ),
                  if (showPsp) SizedBox(height: SizeConfig.padding16),
                  InvestmentForeseenWidget(
                    amount: model.amountController?.text ?? '0',
                    assetType: model.floAssetType,
                    isLendboxOldUser: model.isLendboxOldUser,
                    onChanged: (_) {},
                  ),
                  Row(
                    children: [
                      Text("Fello Flo Amount",
                          style: TextStyles.sourceSansSB.body1),
                      const Spacer(),
                      Text(
                        "₹${model.amountController?.text ?? '0'}",
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
                  Row(
                    children: [
                      Text(
                        "Investment date",
                        style: TextStyles.sourceSans.body2,
                      ),
                      const Spacer(),
                      Text(
                        // format today's date like this "3rd Mar 2023",
                        DateFormat('d MMM yyyy').format(DateTime.now()),
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
                        model.floAssetType == Constants.ASSET_TYPE_FLO_FELXI
                            ? "Lockin Period"
                            : "Maturity date",
                        style: TextStyles.sourceSans.body2,
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('d MMM, yyyy')
                            .format(model.assetOptionsModel!.data.maturityAt!),
                        style: TextStyles.sourceSansSB.body2,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  if ((model.totalTickets ?? 0) > 0 && !showPsp) ...[
                    Divider(
                        color:
                            UiConstants.kLastUpdatedTextColor.withOpacity(0.5)),
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
                          "Total Tickets",
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
                            "Happy Hour Tickets",
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
                            "Lifetime Tickets",
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
                  ],
                  if (model.appliedCoupon != null) ...[
                    Divider(
                        color:
                            UiConstants.kLastUpdatedTextColor.withOpacity(0.5)),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.ticketTilted,
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
                  if (showBreakDown)
                    Divider(
                        color:
                            UiConstants.kLastUpdatedTextColor.withOpacity(0.5)),
                ],
              ),
            if (showPsp && model.isIntentFlow)
              UpiAppsGridView(
                apps: model.appMetaList,
                onTap: (i) {
                  if ((model.buyAmount ?? 0) < model.minAmount) {
                    BaseUtil.showNegativeAlert("Invalid Amount",
                        "Please Enter Amount Greater than ${model.minAmount}");
                    return;
                  }

                  if (!model.isBuyInProgress) {
                    Haptic.vibrate();
                    FocusScope.of(context).unfocus();
                    model.selectedUpiApplication = i == -1
                        ? ApplicationMeta.android(
                            UpiApplication.PhonePeSimulator,
                            Uint8List(10),
                            1,
                            1)
                        : model.appMetaList[i];
                    model.initiateBuy();
                  }

                  AppState.backButtonDispatcher?.didPopRoute();
                },
              ),
            if (!model.isIntentFlow)
              AppPositiveBtn(
                width: SizeConfig.screenWidth!,
                onPressed: () async {
                  if ((model.buyAmount ?? 0) < model.minAmount) {
                    BaseUtil.showNegativeAlert("Invalid Amount",
                        "Please Enter Amount Greater than ${model.minAmount}");
                    return;
                  }

                  if (!model.isBuyInProgress) {
                    FocusScope.of(context).unfocus();
                    await model.initiateBuy();
                  }
                  AppState.backButtonDispatcher?.didPopRoute();
                },
                btnText: 'Save'.toUpperCase(),
              ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
          ],
        ),
      ),
    );
  }
}

class GoldProBreakdownView extends StatelessWidget {
  const GoldProBreakdownView({
    required this.model,
    Key? key,
    this.showPsp = true,
    this.showBreakDown = true,
  }) : super(key: key);

  final GoldProBuyViewModel model;
  final bool showPsp, showBreakDown;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        locator<AnalyticsService>().track(
            eventName: AnalyticsEvents.intentTransactionBackPressed,
            properties: {
              "goldBuyAmount": model.totalGoldAmount,
              "goldInGrams": model.totalGoldBalance,
              "abTesting": AppConfig.getValue(AppConfigKey.payment_brief_view)
                  ? "with payment summary"
                  : "without payment summary"
            });
        return Future.value(true);
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: SizeConfig.padding28),
            if (showBreakDown)
              Column(
                children: [
                  if (showPsp)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: SizeConfig.padding10,
                      ),
                      child: Text(
                        "Payment Summary",
                        style:
                            TextStyles.sourceSansB.body0.colour(Colors.white),
                      ),
                    ),
                  if (showPsp)
                    Divider(
                      color: UiConstants.primaryColor,
                      height: SizeConfig.padding16,
                    ),
                  SizedBox(height: SizeConfig.padding12),
                  Row(
                    children: [
                      Text("Invested Amount",
                          style: TextStyles.sourceSans.body2),
                      const Spacer(),
                      Text(
                        "₹${model.totalGoldAmount}",
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
                  Row(
                    children: [
                      Text(
                        "GST (${model.goldRates?.igstPercent}%)",
                        style: TextStyles.sourceSans.body2,
                      ),
                      const Spacer(),
                      Text(
                        "₹${((model.goldRates?.igstPercent)! / 100 * double.parse(model.totalGoldAmount.toString())).toStringAsFixed(2)}",
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
                  Row(
                    children: [
                      Text("Digital Gold Amount",
                          style: TextStyles.sourceSans.body2),
                      const Spacer(),
                      Text(
                        "₹${(model.totalGoldAmount - ((model.goldRates?.igstPercent)! / 100 * model.totalGoldAmount)).toStringAsFixed(2)}",
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
                  Row(
                    children: [
                      Text(
                        "Grams of Gold for Lease",
                        style: TextStyles.sourceSans.body2
                            .colour(UiConstants.kGoldProPrimary),
                      ),
                      const Spacer(),
                      Text(
                        "${model.totalGoldBalance}gms",
                        style: TextStyles.sourceSansSB.body2
                            .colour(UiConstants.kGoldProPrimary),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  // if ((model.totalTickets ?? 0) > 0 && !showPsp) ...[
                  //   Divider(
                  //       color:
                  //           UiConstants.kLastUpdatedTextColor.withOpacity(0.5)),
                  //   SizedBox(
                  //     height: SizeConfig.padding24,
                  //   ),
                  //   Row(
                  //     children: [
                  //       SizedBox(
                  //         height: SizeConfig.padding28,
                  //         width: SizeConfig.padding28,
                  //         child: SvgPicture.asset(
                  //           Assets.howToPlayAsset1Tambola,
                  //           fit: BoxFit.contain,
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: SizeConfig.padding8,
                  //       ),
                  //       Text(
                  //         "Total Tickets",
                  //         style: TextStyles.sourceSansSB.body1,
                  //       ),
                  //       const Spacer(),
                  //       Text(
                  //         "${model.totalTickets}",
                  //         style: TextStyles.sourceSansSB.body1,
                  //       ),
                  //     ],
                  //   ),
                  //   SizedBox(
                  //     height: SizeConfig.padding24,
                  //   ),
                  //   if (model.showHappyHour &&
                  //       model.happyHourTickets != null) ...[
                  //     Row(
                  //       children: [
                  //         Text(
                  //           "Happy Hour Tickets",
                  //           style: TextStyles.sourceSans.body2,
                  //         ),
                  //         const Spacer(),
                  //         Text(
                  //           "${model.happyHourTickets}",
                  //           style: TextStyles.sourceSans.body2,
                  //         ),
                  //       ],
                  //     ),
                  // SizedBox(
                  //   height: SizeConfig.padding24,
                  // ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "Lifetime Tickets",
                  //       style: TextStyles.sourceSans.body2,
                  //     ),
                  //     const Spacer(),
                  //     Text(
                  //       "${model.numberOfTambolaTickets}",
                  //       style: TextStyles.sourceSans.body2,
                  //     ),
                  //   ],
                  // ),
                  //     SizedBox(
                  //       height: SizeConfig.padding24,
                  //     ),
                  //   ],
                  // ],
                  // if (model.appliedCoupon != null) ...[
                  //   Divider(
                  //       color:
                  //           UiConstants.kLastUpdatedTextColor.withOpacity(0.5)),
                  //   SizedBox(
                  //     height: SizeConfig.padding12,
                  //   ),
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       SvgPicture.asset(
                  //         A.Assets.ticketTilted,
                  //       ),
                  //       const SizedBox(
                  //         width: 8,
                  //       ),
                  //       Text(
                  //         '${model.appliedCoupon?.code} coupon applied',
                  //         style: TextStyles.sourceSans.body3
                  //             .colour(UiConstants.kTealTextColor),
                  //       ),
                  //     ],
                  //   ),
                  //   SizedBox(
                  //     height: SizeConfig.padding12,
                  //   )
                  // ],
                  // if (showBreakDown)
                  //   Divider(
                  //       color:
                  //           UiConstants.kLastUpdatedTextColor.withOpacity(0.5))
                ],
              ),
            // if (showPsp && model.isIntentFlow)
            //   UpiAppsGridView(
            //     apps: model.appMetaList,
            //     onTap: (i) {
            //       if (!model.isGoldBuyInProgress) {
            //         Haptic.vibrate();
            //         FocusScope.of(context).unfocus();

            //         model.selectedUpiApplication = i == -1
            //             ? ApplicationMeta.android(
            //                 UpiApplication.PhonePeSimulator,
            //                 Uint8List(10),
            //                 1,
            //                 1)
            //             : model.appMetaList[i];

            //         model.initiateBuy();
            //       }

            //       AppState.backButtonDispatcher?.didPopRoute();
            //     },
            //   ),
            // if (!model.isIntentFlow)
            AppPositiveBtn(
                width: SizeConfig.screenWidth!,
                onPressed: () {
                  AppState.backButtonDispatcher?.didPopRoute();
                },
                btnText: "OK"),
            SizedBox(
              height: SizeConfig.padding24,
            ),
          ],
        ),
      ),
    );
  }
}
