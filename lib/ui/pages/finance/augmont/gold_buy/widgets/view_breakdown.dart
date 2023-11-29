import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/bank_account_details_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/widget/prompt.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/assets.dart' as a;
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:upi_pay/upi_pay.dart';

import '../../../../../../util/locator.dart';

class GoldBreakdownView extends StatefulWidget {
  const GoldBreakdownView({
    required this.model,
    super.key,
    this.showPaymentOption = true,
    this.showBreakDown = true,
    this.isBreakDown = false,
    this.onSave,
  });

  final GoldBuyViewModel model;
  final bool showPaymentOption;
  final bool isBreakDown;
  final bool showBreakDown;
  final VoidCallback? onSave;

  @override
  State<GoldBreakdownView> createState() => _GoldBreakdownViewState();
}

class _GoldBreakdownViewState extends State<GoldBreakdownView> {
  bool _isNetbankingMandatory = false;

  @override
  void initState() {
    super.initState();
    final amount =
        num.tryParse(widget.model.goldAmountController?.text ?? '') ?? 0;
    _isNetbankingMandatory = amount >= Constants.mandatoryNetBankingThreshold;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.pageHorizontalMargins,
        SizeConfig.padding16,
        SizeConfig.pageHorizontalMargins,
        SizeConfig.padding12,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Payment summary',
            style: TextStyles.sourceSansSB.body1.colour(
              Colors.white,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          _PaymentSummaryHeader(
            amount: "₹${widget.model.goldAmountController?.text ?? '0'}",
          ),
          SizedBox(height: SizeConfig.padding20),
          if (widget.showBreakDown)
            Column(
              children: [
                _SummaryLine(
                  'GST (${widget.model.goldRates?.igstPercent}%)',
                  '₹${((widget.model.goldRates?.igstPercent)! / 100 * double.parse(widget.model.goldAmountController?.text ?? '0')).toStringAsFixed(2)}',
                ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                _SummaryLine(
                  'Digital Gold Amount',
                  "₹${(num.tryParse(widget.model.goldAmountController?.text ?? '0')! - ((widget.model.goldRates?.igstPercent)! / 100 * double.parse(widget.model.goldAmountController?.text ?? '0'))).toStringAsFixed(2)}",
                ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                _SummaryLine(
                  "Grams of Gold",
                  "${widget.model.goldAmountInGrams}gms",
                  overriddenStyle: TextStyles.sourceSans.body2.colour(
                    Colors.white,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                if ((widget.model.totalTickets ?? 0) > 0) ...[
                  Divider(
                    color: UiConstants.kLastUpdatedTextColor.withOpacity(0.5),
                  ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  Expandable(
                    header: Row(
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
                          "Tickets You Earn",
                          style: TextStyles.sourceSansSB.body1,
                        ),
                        const Spacer(),
                        Text(
                          "${widget.model.totalTickets}",
                          style: TextStyles.sourceSansSB.body1,
                        ),
                      ],
                    ),
                    body: widget.model.showHappyHour &&
                            widget.model.happyHourTickets != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Happy Hour Tickets",
                                    style: TextStyles.sourceSans.body2,
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${widget.model.happyHourTickets}",
                                    style: TextStyles.sourceSans.body3.copyWith(
                                      color: UiConstants.textGray70,
                                    ),
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
                                    "${widget.model.numberOfTambolaTickets}",
                                    style: TextStyles.sourceSans.body3.copyWith(
                                      color: UiConstants.textGray70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : null,
                  ),
                ],
                if (widget.model.appliedCoupon != null) ...[
                  SizedBox(
                    height: SizeConfig.padding12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        a.Assets.ticketTilted,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${widget.model.appliedCoupon?.code} coupon applied',
                        style: TextStyles.sourceSans.body3
                            .colour(UiConstants.kTealTextColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding8,
                  )
                ],
                if (widget.showBreakDown)
                  Divider(
                    color: UiConstants.kLastUpdatedTextColor.withOpacity(0.5),
                  )
              ],
            ),
          if (widget.showPaymentOption) ...[
            // Intent.
            if (widget.model.isIntentFlow && !_isNetbankingMandatory)
              UpiAppsGridView(
                apps: widget.model.appMetaList,
                onTap: (i) {
                  if (!widget.model.isGoldBuyInProgress) {
                    Haptic.vibrate();
                    FocusScope.of(context).unfocus();

                    widget.model.selectedUpiApplication = i == -1
                        ? ApplicationMeta.android(
                            UpiApplication.PhonePeSimulator,
                            Uint8List(10),
                            1,
                            1)
                        : widget.model.appMetaList[i];

                    widget.model.initiateBuy();
                  }

                  AppState.backButtonDispatcher?.didPopRoute();
                },
              ),

            // Razorpay.
            if (!widget.model.isIntentFlow && !_isNetbankingMandatory)
              AppPositiveBtn(
                width: SizeConfig.screenWidth!,
                onPressed: () {
                  if (!widget.model.isGoldBuyInProgress) {
                    FocusScope.of(context).unfocus();
                    widget.model.initiateBuy();
                  }

                  AppState.backButtonDispatcher?.didPopRoute();
                },
                btnText: widget.model.status == 2 ? "SAVE" : 'UNAVAILABLE',
              ),

            // Netbanking.
            if (_isNetbankingMandatory)
              NetBankingWidget(
                netbankingValidationMixin: widget.model,
                initiatePayment: widget.model.initiateBuy,
              ),
          ],
          if (widget.isBreakDown)
            AppPositiveBtn(
              width: SizeConfig.screenWidth!,
              onPressed: () {
                AppState.backButtonDispatcher!.didPopRoute();
                widget.onSave?.call();
              },
              btnText: widget.model.status == 2 ? "SAVE" : 'UNAVAILABLE',
            ),
        ],
      ),
    );
  }
}

class NetBankingWidget extends StatefulWidget {
  final VoidCallback? initiatePayment;
  final NetbankingValidationMixin netbankingValidationMixin;

  const NetBankingWidget({
    required this.netbankingValidationMixin,
    this.initiatePayment,
    super.key,
  });

  @override
  State<NetBankingWidget> createState() => _NetBankingWidgetState();
}

class _NetBankingWidgetState extends State<NetBankingWidget> {
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getAccountDetails();
  }

  Future<void> _getAccountDetails() async {
    await widget.netbankingValidationMixin.getAccDetailsWithNetbankingInfo();
    setState(() {
      _isLoading = false;
    });
  }

  void _onPressed(
    NetBankingStatus status,
    BankAvailability availability, {
    bool isBankDetailsAreMissing = false,
  }) {
    if (isBankDetailsAreMissing) {
      AppState.delegate!.parseRoute(
        Uri.parse('bankDetails?withNetBankingValidation=true'),
      );
    }

    switch (status) {
      case NetBankingStatus.SUPPORTED:
        switch (availability) {
          case BankAvailability.AVAILABLE:
          case BankAvailability.DEGRADED:
            AppState.backButtonDispatcher!.didPopRoute();
            widget.initiatePayment?.call();
            break;

          case BankAvailability.UNAVAILABLE:
            BaseUtil.showNegativeAlert(
              'Bank Server is not responding at the moment',
              'Please try again in some time',
            );
            AppState.backButtonDispatcher!.didPopRoute();
            break;
        }
        break;

      case NetBankingStatus.UN_SUPPORTED:
        AppState.delegate!.parseRoute(
          Uri.parse('bankDetails?withNetBankingValidation=true'),
        );
        break;
    }

    _sendEvent(
      bankAccountSupported: status.isSupported,
    );
  }

  void _sendEvent({bool bankAccountSupported = false}) {
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.payWithNetBanking,
      properties: {
        'bank_account_support': bankAccountSupported,
      },
    );
  }

  String _getLabel(
    NetBankingStatus status,
    BankAvailability availability, {
    bool isBankDetailsAreMissing = false,
  }) {
    if (isBankDetailsAreMissing) {
      return 'Add Bank Account';
    }

    switch (status) {
      case NetBankingStatus.SUPPORTED:
        switch (availability) {
          case BankAvailability.AVAILABLE:
          case BankAvailability.DEGRADED:
            return 'PAY with Net Banking';

          case BankAvailability.UNAVAILABLE:
            return 'SAVE';
        }

      case NetBankingStatus.UN_SUPPORTED:
        return 'Change Bank Account';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<BankAndPanService, BankAccountDetailsModel?>(
      selector: (ctx, service) => service.activeBankAccountDetails,
      builder: (context, details, child) {
        if (_isLoading) {
          return Shimmer.fromColors(
            baseColor: UiConstants.kTambolaMidTextColor,
            highlightColor: Colors.grey.shade800,
            direction: ShimmerDirection.ttb,
            child: AspectRatio(
              aspectRatio: 4.27,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(
                    SizeConfig.roundness8,
                  ),
                ),
              ),
            ),
          );
        }

        if (details == null && !_isLoading) {
          return Column(
            children: [
              Text(
                'Payments are under maintenance at the moment \nWe will notify you once we are back',
                style: TextStyles.sourceSans.body3.copyWith(
                  color: UiConstants.kPeachTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              SizedBox(
                height: SizeConfig.padding50,
                child: ReactivePositiveAppButton(
                  onPressed: () {},
                  isDisabled: true,
                  btnText: 'SAVE',
                ),
              )
            ],
          );
        }

        if (details == null) return const SizedBox.shrink();
        final message = details.message;
        final obscureCount = details.account.length - 4;
        final isDetailsNotValid = !details.isDetailsAreValid;
        return Column(
          children: [
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Text(
              'Pay by Net Banking',
              style: TextStyles.sourceSansSB.body1,
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Text(
              'Net Banking applicable for investments of ₹1L+',
              style: TextStyles.sourceSans.body2.colour(UiConstants.grey1),
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding14,
                horizontal: SizeConfig.padding12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: UiConstants.bg,
              ),
              child: Column(
                children: [
                  if (isDetailsNotValid)
                    Align(
                      child: Text(
                        'Add Bank Account to continue with Net Banking',
                        style: TextStyles.sourceSans.body3,
                      ),
                    )
                  else
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            SizeConfig.padding12,
                          ),
                          child: Container(
                            height: SizeConfig.padding24,
                            width: SizeConfig.padding24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: UiConstants.textGray50,
                                width: .75,
                              ),
                            ),
                            child: Image.network(
                              details.logo,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.padding8,
                        ),
                        Text(
                          details.bankName,
                          style: TextStyles.sourceSansSB.body2,
                        ),
                        const Spacer(),
                        Text(
                          '*' * obscureCount +
                              details.account.substring(
                                obscureCount,
                              ),
                          style: TextStyles.sourceSans.body3.colour(
                            UiConstants.textGray70,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (message != null && message.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.padding18),
                child: Text(
                  message,
                  style: TextStyles.sourceSans.body3.colour(
                    UiConstants.kPeachTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              height: SizeConfig.padding18,
            ),
            AppPositiveBtn(
              height: SizeConfig.padding50,
              onPressed: () => _onPressed(
                details.netBankingStatus,
                details.availability,
                isBankDetailsAreMissing: isDetailsNotValid,
              ),
              btnText: _getLabel(
                details.netBankingStatus,
                details.availability,
                isBankDetailsAreMissing: isDetailsNotValid,
              ),
            )
          ],
        );
      },
    );
  }
}

class _PaymentSummaryHeader extends StatelessWidget {
  const _PaymentSummaryHeader({
    required this.amount,
  });

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.10),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.goldWithoutShadow,
                height: 25,
              ),
              SizedBox(
                width: SizeConfig.padding12,
              ),
              Text(
                'Digital Gold',
                style: TextStyles.rajdhaniSB.title5.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text(
                "Savings Amount",
                style: TextStyles.rajdhaniSB.body2.colour(
                  UiConstants.kTextFieldTextColor,
                ),
              ),
              const Spacer(),
              Text(
                amount,
                style: TextStyles.sourceSansSB.title5,
              )
            ],
          )
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine(
    this.k,
    this.value, {
    this.overriddenStyle,
  });

  final String k;
  final String value;
  final TextStyle? overriddenStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(k, style: TextStyles.sourceSans.body2),
        const Spacer(),
        Text(
          value,
          style: overriddenStyle ?? TextStyles.sourceSansSB.body1,
        ),
      ],
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
              style: TextStyles.sourceSansB.title3.colour(
                Colors.white,
              ),
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

class FloBreakdownView extends StatefulWidget {
  const FloBreakdownView({
    required this.model,
    super.key,
    this.showPaymentOption = true,
    this.showBreakDown = true,
    this.isBreakDown = false,
    this.onSave,
  });

  final LendboxBuyViewModel model;
  final bool showPaymentOption;
  final bool showBreakDown;
  final bool isBreakDown;
  final VoidCallback? onSave;

  @override
  State<FloBreakdownView> createState() => _FloBreakdownViewState();
}

class _FloBreakdownViewState extends State<FloBreakdownView> {
  bool _isNetbankingMandatory = false;

  @override
  void initState() {
    super.initState();
    final amount = num.tryParse(widget.model.amountController?.text ?? '') ?? 0;
    _isNetbankingMandatory = amount >= Constants.mandatoryNetBankingThreshold;
  }

  @override
  Widget build(BuildContext context) {
    final maturityDuration =
        widget.model.floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 6 : 3;
    final terms = widget.model.selectedOption.maturityTerm;
    final months = maturityDuration * terms;
    final currentDateTime = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        locator<AnalyticsService>().track(
            eventName: AnalyticsEvents.intentTransactionBackPressed,
            properties: {
              "floAssetType": widget.model.floAssetType,
              "maturityPref": widget.model.selectedOption.lbMapping,
              "couponCode": widget.model.appliedCoupon?.code ?? '',
              "txnAmount": widget.model.buyAmount,
              "skipMl": widget.model.skipMl,
              "abTesting": AppConfig.getValue(AppConfigKey.payment_brief_view)
                  ? "with payment summary"
                  : "without payment summary"
            });
        return true;
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          SizeConfig.pageHorizontalMargins,
          SizeConfig.padding16,
          SizeConfig.pageHorizontalMargins,
          SizeConfig.padding12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Payment summary',
              style: TextStyles.sourceSansSB.body1.colour(
                Colors.white,
              ),
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            if (widget.showBreakDown)
              Column(
                children: [
                  LendboxPaymentSummaryHeader(
                    amount: widget.model.amountController?.text ?? '0',
                    assetType: widget.model.floAssetType,
                    maturityTerm: widget.model.selectedOption.maturityTerm,
                    showMaturity: true,
                    model: widget.model,
                  ),
                  Row(
                    children: [
                      Text(
                        "Saving date",
                        style: TextStyles.sourceSans.body2,
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('d MMM yyyy').format(currentDateTime),
                        style: TextStyles.sourceSansSB.body3.colour(
                          UiConstants.textGray70,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.model.floAssetType ==
                                Constants.ASSET_TYPE_FLO_FELXI
                            ? "Lockin Until"
                            : "Maturity date",
                        style: TextStyles.sourceSans.body2,
                      ),
                      const Spacer(),
                      Text(
                        widget.model
                            .getMaturityTime(widget.model.selectedOption),
                        style: TextStyles.sourceSansSB.body2,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding12,
                  ),
                  if ((widget.model.totalTickets ?? 0) > 0 &&
                      !widget.showPaymentOption) ...[
                    Divider(
                        color:
                            UiConstants.kLastUpdatedTextColor.withOpacity(0.5)),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    Expandable(
                      header: Row(
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
                            "Tickets You Earn",
                            style: TextStyles.sourceSansSB.body1,
                          ),
                          const Spacer(),
                          Text(
                            "${widget.model.totalTickets}",
                            style: TextStyles.sourceSansSB.body1,
                          ),
                        ],
                      ),
                      body: widget.model.showHappyHour
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Happy Hour Tickets",
                                      style: TextStyles.sourceSans.body2,
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${widget.model.happyHourTickets}",
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
                                      "${widget.model.numberOfTambolaTickets}",
                                      style: TextStyles.sourceSans.body2,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : null,
                    ),
                  ],
                  if (widget.model.appliedCoupon != null) ...[
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
                          '${widget.model.appliedCoupon?.code} coupon applied',
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kTealTextColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.padding12,
                    )
                  ],
                  if (widget.showBreakDown)
                    Divider(
                        color:
                            UiConstants.kLastUpdatedTextColor.withOpacity(0.5)),
                ],
              ),
            if (widget.showPaymentOption) ...[
              if (widget.model.isIntentFlow && !_isNetbankingMandatory)
                UpiAppsGridView(
                  apps: widget.model.appMetaList,
                  onTap: (i) {
                    if ((widget.model.buyAmount ?? 0) <
                        widget.model.minAmount) {
                      BaseUtil.showNegativeAlert("Invalid Amount",
                          "Please Enter Amount Greater than ${widget.model.minAmount}");
                      return;
                    }

                    if (!widget.model.isBuyInProgress) {
                      Haptic.vibrate();
                      FocusScope.of(context).unfocus();
                      widget.model.selectedUpiApplication = i == -1
                          ? ApplicationMeta.android(
                              UpiApplication.PhonePeSimulator,
                              Uint8List(10),
                              1,
                              1)
                          : widget.model.appMetaList[i];
                      widget.model.initiateBuy();
                    }

                    AppState.backButtonDispatcher?.didPopRoute();
                  },
                ),
              if (!widget.model.isIntentFlow && !_isNetbankingMandatory)
                AppPositiveBtn(
                  width: SizeConfig.screenWidth!,
                  onPressed: () {
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

                    AppState.backButtonDispatcher?.didPopRoute();
                  },
                  btnText: 'Save'.toUpperCase(),
                ),
              if (_isNetbankingMandatory)
                NetBankingWidget(
                  netbankingValidationMixin: widget.model,
                  initiatePayment: widget.model.initiateBuy,
                ),
            ],
            if (widget.isBreakDown)
              AppPositiveBtn(
                width: SizeConfig.screenWidth!,
                btnText: 'Save'.toUpperCase(),
                onPressed: () {
                  if ((widget.model.buyAmount ?? 0) < widget.model.minAmount) {
                    BaseUtil.showNegativeAlert(
                      "Invalid Amount",
                      "Please Enter Amount Greater than ${widget.model.minAmount}",
                    );
                    return;
                  }

                  AppState.backButtonDispatcher?.didPopRoute();

                  if (!widget.model.isBuyInProgress) {
                    FocusScope.of(context).unfocus();
                    widget.onSave?.call();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class GoldProBreakdownView extends StatefulWidget {
  const GoldProBreakdownView({
    required this.model,
    super.key,
    this.showPaymentOption = true,
    this.showBreakDown = true,
    this.isBreakDown = false,
    this.onSave,
  });

  final GoldProBuyViewModel model;
  final bool showPaymentOption, showBreakDown;
  final bool isBreakDown;
  final VoidCallback? onSave;

  @override
  State<GoldProBreakdownView> createState() => _GoldProBreakdownViewState();
}

class _GoldProBreakdownViewState extends State<GoldProBreakdownView> {
  bool _isNetbankingMandatory = false;

  @override
  void initState() {
    super.initState();

    _isNetbankingMandatory =
        widget.model.totalGoldAmount >= Constants.mandatoryNetBankingThreshold;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        locator<AnalyticsService>().track(
            eventName: AnalyticsEvents.intentTransactionBackPressed,
            properties: {
              "goldBuyAmount": widget.model.totalGoldAmount,
              "goldInGrams": widget.model.totalGoldBalance,
              "abTesting": AppConfig.getValue(AppConfigKey.payment_brief_view)
                  ? "with payment summary"
                  : "without payment summary"
            });
        return Future.value(true);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          SizeConfig.pageHorizontalMargins,
          SizeConfig.padding16,
          SizeConfig.pageHorizontalMargins,
          SizeConfig.padding12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Payment summary',
              style: TextStyles.sourceSansSB.body1.colour(
                Colors.white,
              ),
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            _PaymentSummaryHeader(
              amount: "₹${widget.model.totalGoldAmount}",
            ),
            SizedBox(height: SizeConfig.padding20),
            Column(
              children: [
                _SummaryLine(
                  "GST (${widget.model.goldRates?.igstPercent}%)",
                  "₹${((widget.model.goldRates?.igstPercent)! / 100 * double.parse(widget.model.totalGoldAmount.toString())).toStringAsFixed(2)}",
                ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                _SummaryLine(
                  "Current Gold Balance",
                  '${widget.model.currentGoldBalance} gms',
                ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                _SummaryLine(
                  "Additional Gold Required",
                  '${widget.model.additionalGoldBalance} gms',
                ),
              ],
            ),
            if (widget.showPaymentOption) ...[
              // Intent.
              if (widget.model.isIntentFlow && !_isNetbankingMandatory) ...[
                const Divider(
                  color: UiConstants.grey2,
                  height: 40,
                  thickness: .5,
                ),
                UpiAppsGridView(
                  apps: widget.model.appMetaList,
                  onTap: (i) {
                    Haptic.vibrate();
                    FocusScope.of(context).unfocus();
                    widget.model.selectedUpiApplication = i == -1
                        ? ApplicationMeta.android(
                            UpiApplication.PhonePeSimulator,
                            Uint8List(10),
                            1,
                            1)
                        : widget.model.appMetaList[i];
                    AppState.backButtonDispatcher?.didPopRoute();
                    widget.model.initiateGoldProTransaction();
                  },
                ),
              ],

              // For razorpay.
              if (!widget.model.isIntentFlow && !_isNetbankingMandatory)
                AppPositiveBtn(
                  width: SizeConfig.screenWidth!,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    widget.model.initiateGoldProTransaction();
                    AppState.backButtonDispatcher?.didPopRoute();
                  },
                  btnText: 'Save'.toUpperCase(),
                ),

              // If net banking is mandatory.
              if (_isNetbankingMandatory)
                NetBankingWidget(
                  initiatePayment: widget.model.initiateGoldProTransaction,
                  netbankingValidationMixin: widget.model,
                ),
            ],
            if (widget.isBreakDown)
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.padding16,
                ),
                child: AppPositiveBtn(
                  width: SizeConfig.screenWidth!,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    AppState.backButtonDispatcher?.didPopRoute();
                    widget.onSave?.call();
                  },
                  btnText: 'Save'.toUpperCase(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
