import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/repository/lendbox_repo.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../../../util/constants.dart';

/// Available options after maturity period.
enum UserDecision {
  notDecided(lbMapping: 'NA', maturityTerm: 1),
  withdraw(lbMapping: '0', maturityTerm: 1),
  reInvest(lbMapping: '1', maturityTerm: 2),
  moveToFlexi(lbMapping: '2', maturityTerm: 1);

  /// The terms of maturity based on the the user decision.
  ///
  /// If user decides to reinvest amount in the same asset then it's equal to
  /// reinvest the amount with interest in same asset.
  final int maturityTerm;

  /// Mapping of the enum with lendbox provided options and decision.
  final String lbMapping;

  const UserDecision({
    required this.lbMapping,
    required this.maturityTerm,
  });
}

class ReInvestPrompt extends HookWidget {
  const ReInvestPrompt({
    required this.amount,
    required this.assetType,
    required this.model,
    super.key,
  });

  final String amount;
  final String assetType;
  final LendboxBuyViewModel model;

  void _onTap(UserDecision decision, LendboxBuyViewModel m,
      ValueNotifier<UserDecision> selectedOption) {
    m.selectedOption = selectedOption.value = decision;
  }

  bool _isSelected(UserDecision optionIndex, UserDecision selectedIndex) {
    return optionIndex == selectedIndex;
  }

  int _getMaturityDuration({int cycle = 1}) {
    int duration = assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 6 : 3;
    return duration * cycle;
  }

  String _getTitle({int cycle = 1}) {
    return '${_getMaturityDuration(cycle: cycle)} Months';
  }

  String _getSubTitle(UserDecision decision) {
    final maturity = model.assetOptionsModel!.data.maturityAt;
    if (maturity == null) return '';

    final date = switch (decision) {
      UserDecision.notDecided => maturity.notDecided,
      UserDecision.reInvest => maturity.reInvest,
      _ => maturity.notDecided,
    };

    return 'Maturity on $date';
  }

  void _onProceed() {
    AppState.backButtonDispatcher?.didPopRoute();

    SystemChannels.textInput.invokeMethod('TextInput.hide');

    model.analyticsService.track(
      eventName: AnalyticsEvents.maturitySelectionContinueTapped,
      properties: {
        'Choice Tapped': _getSubTitle(
          model.selectedOption,
        ),
        "asset": model.floAssetType,
        "amount": model.buyAmount,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedOption = useState<UserDecision>(model.selectedOption);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),
      child: Column(
        children: [
          LendboxPaymentSummaryHeader(
            amount: amount,
            assetType: assetType,
            maturityTerm: selectedOption.value.maturityTerm,
            showMaturity: true,
            model: model,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Choose your Maturity Period",
                        style:
                            TextStyles.sourceSans.body2.copyWith(height: 1.2),
                      ),
                    ),
                    Tooltip(
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      triggerMode: TooltipTriggerMode.tap,
                      preferBelow: false,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness8),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins,
                          vertical: SizeConfig.pageHorizontalMargins),
                      showDuration: const Duration(seconds: 10),
                      message:
                          "Fello Flo Premium plans allow you to decide what happens to your money after maturity. You can choose what you want to do with your money while you invest. If you do not select a preference, we will contact you and confirm what you want to do with the corpus post maturity.",
                      child: const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.padding4),
                Text(
                  'After Maturity your investment is withdraw-able from 8% P2P Asset',
                  style: TextStyles.sourceSans.body3.colour(
                    UiConstants.grey1,
                  ),
                ),
                SizedBox(height: SizeConfig.padding20),
                OptionContainer<UserDecision>(
                  isRecommended: true,
                  value: UserDecision.reInvest,
                  title: _getTitle(cycle: UserDecision.reInvest.maturityTerm),
                  description: _getSubTitle(UserDecision.reInvest),
                  isSelected: (i) => _isSelected(i, selectedOption.value),
                  onTap: (i) => _onTap(i, model, selectedOption),
                ),
                SizedBox(height: SizeConfig.padding16),
                OptionContainer<UserDecision>(
                  value: UserDecision.notDecided,
                  title: _getTitle(cycle: UserDecision.notDecided.maturityTerm),
                  description: _getSubTitle(UserDecision.notDecided),
                  isSelected: (i) => _isSelected(i, selectedOption.value),
                  onTap: (i) => _onTap(i, model, selectedOption),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.padding24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MaterialButton(
                    height: SizeConfig.padding40,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.white,
                    onPressed: _onProceed,
                    child: Text(
                      'PROCEED',
                      style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OptionContainer<T> extends StatelessWidget {
  final T value;
  final String title;
  final String description;
  final bool Function(T) isSelected;
  final ValueChanged<T> onTap;
  final bool isRecommended;

  const OptionContainer({
    required this.value,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
    this.isRecommended = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selected = isSelected(value);
    return GestureDetector(
      onTap: () => onTap(value),
      child: Column(
        children: [
          if (isRecommended)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding8,
                vertical: SizeConfig.padding2,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(SizeConfig.roundness5),
                ),
                color: UiConstants.teal3,
              ),
              child: Text(
                'Recommended',
                style: TextStyles.sourceSansSB.body4.copyWith(
                  color: UiConstants.teal5,
                  fontSize: 10,
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.all(SizeConfig.padding16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness8),
              border: Border.all(
                color: selected
                    ? UiConstants.kTabBorderColor // Change color when selected
                    : const Color(0xFFD3D3D3).withOpacity(0.2),
                width: SizeConfig.border1,
              ),
            ),
            child: Row(
              children: [
                Container(
                    width: SizeConfig.padding24,
                    height: SizeConfig.padding24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? UiConstants.kTabBorderColor
                            : const Color(0xFFD3D3D3).withOpacity(0.2),
                        width: SizeConfig.border1,
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(SizeConfig.padding4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected ? UiConstants.kTabBorderColor : null,
                      ),
                    )),
                SizedBox(
                  width: SizeConfig.padding16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.rajdhaniB.body1,
                    ),
                    SizedBox(
                      height: SizeConfig.padding2,
                    ),
                    Text(
                      description,
                      style: TextStyles.sourceSans.body3
                          .colour(const Color(0xffA9C6D6)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InvestmentForeseenWidget extends StatelessWidget {
  const InvestmentForeseenWidget({
    required this.amount,
    required this.assetType,
    super.key,
  });

  final String amount;
  final String assetType;

  String getTitle() {
    if (assetType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return "in 12% Flo";
    }

    if (assetType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return "in 10% Flo";
    }
    return "";
  }

  String getSubTitle() {
    if (assetType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return "for 6 months";
    }

    if (assetType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return "for 3 months";
    }
    return "";
  }

  String calculateAmountAfter6Months(String amount) {
    int interest = assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 12 : 10;

    double principal = double.tryParse(amount) ?? 0.0;
    double rateOfInterest = interest / 100.0;
    int timeInMonths = assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 2 : 4;

    double amountAfterMonths =
        rateOfInterest / 365 * principal * (365 / timeInMonths);

    return (principal + amountAfterMonths).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // if (assetType == Constants.ASSET_TYPE_FLO_FELXI) {
    //   return const SizedBox.shrink();
    // }

    return Container(
      padding: EdgeInsets.all(SizeConfig.padding16),
      margin: EdgeInsets.only(bottom: SizeConfig.padding24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You Invest",
                style: TextStyles.rajdhaniSB.body3,
              ),
              Text(
                "₹${double.tryParse(amount)?.toStringAsFixed(2)}",
                style: TextStyles.sourceSansB.title5,
              )
            ],
          ),
          Column(
            children: [
              Text(
                getTitle(),
                style: TextStyles.rajdhaniB.body2
                    .colour(UiConstants.kTabBorderColor),
              ),
              Text(
                getSubTitle(),
                style: TextStyles.sourceSansB.body3,
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You get",
                style: TextStyles.rajdhaniSB.body3,
              ),
              Text(
                "₹${calculateAmountAfter6Months(amount)}",
                style: TextStyles.sourceSansB.title5,
              )
            ],
          )
        ],
      ),
    );
  }
}

class LendboxPaymentSummaryHeader extends StatelessWidget {
  const LendboxPaymentSummaryHeader({
    required this.amount,
    required this.assetType,
    required this.model,
    this.showMaturity = false,
    this.maturityTerm = 1,
    super.key,
  });

  final String amount;
  final String assetType;
  final bool showMaturity;
  final int maturityTerm;
  final LendboxBuyViewModel model;

  static final _durationMap = {
    Constants.ASSET_TYPE_FLO_FELXI : 12,
    Constants.ASSET_TYPE_FLO_FIXED_3 : 3,
    Constants.ASSET_TYPE_FLO_FIXED_6 : 6
  };

  static final _interestMap = {
    Constants.ASSET_TYPE_FLO_FELXI : 8,
    Constants.ASSET_TYPE_FLO_FIXED_3 : 10,
    Constants.ASSET_TYPE_FLO_FIXED_6 : 12
  };

  int get _maturityDuration {
    return _durationMap[assetType]!;
  }

  int get _interest {
    return _interestMap[assetType]!;
  }

  String _getTitle() {
    if (assetType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return "12% Flo";
    }

    if (assetType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return "10% Flo";
    }

    if (assetType == Constants.ASSET_TYPE_FLO_FELXI) {
      return "8% Flo";
    }

    return "";
  }

  String _getSubTitle({int terms = 1}) {
    return "Maturity in ${terms * _maturityDuration} Months";
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,##0", "en_US");
    final amt = num.parse(amount);
    final isFlexi = assetType == Constants.ASSET_TYPE_FLO_FELXI;
    final interest = model
        .calculateInterest(
          amount: amt,
          interestRate: _interest,
          maturityDuration: _maturityDuration,
          terms: maturityTerm,
        )
        .toInt();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.10),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(SizeConfig.padding16),
      margin: EdgeInsets.only(bottom: SizeConfig.padding24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.floWithoutShadow,
                height: 25,
              ),
              SizedBox(
                width: SizeConfig.padding12,
              ),
              Text(
                _getTitle(),
                style: TextStyles.rajdhaniSB.title5.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),

          SizedBox(
            height: SizeConfig.padding12,
          ),
          Row(
            children: [
              _AmountSectionView(
                header: 'Savings Amount',
                sub: '₹${formatter.format(amt)}',
              ),
              const Spacer(),
              _AmountSectionView(
                header: isFlexi ? "Savings (after 1 Year)": 'Maturity Amount',
                sub: '₹${formatter.format(amt)}+',
                subTail: "₹${formatter.format(interest)}",
              ),
            ],
          ),
          if (showMaturity) ...[
            SizedBox(
              height: SizeConfig.padding16,
            ),
            Text(
              _getSubTitle(terms: maturityTerm),
              style: TextStyles.rajdhaniSB.body3.copyWith(
                color: UiConstants.grey1,
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class _AmountSectionView extends StatelessWidget {
  const _AmountSectionView({
    required this.header,
    required this.sub,
    this.subTail,
  });

  final String header;
  final String sub;
  final String? subTail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyles.rajdhaniSB.body2.copyWith(
            color: UiConstants.kTextFieldTextColor,
            height: 20 / 16,
          ),
        ),
        Row(
          children: [
            Text(
              sub,
              style: TextStyles.sourceSansSB.title5.copyWith(
                height: 28 / 20,
              ),
            ),
            if (subTail != null)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  subTail!,
                  style: TextStyles.sourceSansSB.title5.copyWith(
                    height: 28 / 20,
                    color: UiConstants.teal3,
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }
}

class MaturityPrefModalSheet extends StatefulWidget {
  const MaturityPrefModalSheet({
    required this.amount,
    required this.assetType,
    required this.txnId,
    super.key,
    this.hasConfirmed = false,
  });

  final String amount;
  final String assetType;
  final String txnId;
  final bool hasConfirmed;

  @override
  State<MaturityPrefModalSheet> createState() => _MaturityPrefModalSheetState();
}

class _MaturityPrefModalSheetState extends State<MaturityPrefModalSheet> {
  String maturityPref = "NA";
  int _selectedOption = -1;
  bool _isLoading = false;
  bool isEnable = false;

  @override
  void initState() {
    super.initState();

    maturityAmount = calculateAmountAfterMaturity(widget.amount);
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  int get selectedOption => _selectedOption;

  set selectedOption(int value) {
    setState(() {
      _selectedOption = value;
      isEnable = true;
    });
  }

  String maturityAmount = "";

  String calculateAmountAfterMaturity(String amount) {
    int interest =
        widget.assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 12 : 10;

    double principal = double.tryParse(amount) ?? 0.0;
    double rateOfInterest = interest / 100.0;
    int timeInMonths =
        widget.assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 2 : 4;

    // 0.12 / 365 * amt * (365 / 2)
    //0.10 / 365 * amt * (365 / 4)

    double amountAfterMonths =
        rateOfInterest / 365 * principal * (365 / timeInMonths);

    return (principal + amountAfterMonths).toStringAsFixed(2);
  }

  String get subtitle =>
      "At the end of ${widget.assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 6 : 3} months (Maturity)";

  void _onTap(int index) {
    maturityPref = "$index";
    selectedOption = index;
  }

  bool _isSelected(int optionIndex) {
    return optionIndex == selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: SizeConfig.screenHeight! * 0.6,
      padding: EdgeInsets.all(SizeConfig.padding16),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            InvestmentForeseenWidget(
              amount: widget.amount,
              assetType: widget.assetType,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "What do you want to do ",
                      style: TextStyles.sourceSans.body2,
                      children: [
                        TextSpan(
                          text:
                              "after ${widget.assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 6 : 3} months?",
                          style: TextStyles.sourceSansB.body2,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 15,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.padding20,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding8,
                vertical: SizeConfig.padding2,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness5),
                  topRight: Radius.circular(SizeConfig.roundness5),
                ),
                color: UiConstants.kSnackBarPositiveContentColor,
              ),
              child: Text(
                'Recommended',
                style: TextStyles.sourceSansSB.body4,
              ),
            ),
            OptionContainer(
              value: 1,
              title:
                  'Re-invest ₹$maturityAmount in ${widget.assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? "12" : "10"}% Flo',
              description: subtitle,
              isSelected: _isSelected,
              onTap: _onTap,
            ),
            OptionContainer(
              value: 2,
              title:
                  "Move ₹$maturityAmount to ${widget.assetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? "10" : "8"}% Flo",
              description: subtitle,
              isSelected: _isSelected,
              onTap: _onTap,
            ),
            OptionContainer(
              value: 3,
              title: "Withdraw to Bank",
              description: subtitle,
              isSelected: _isSelected,
              onTap: (_) {
                maturityPref = "0";
                selectedOption = 3;
              },
            ),
            SizedBox(
              height: SizeConfig.padding8,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
              child: MaterialButton(
                height: SizeConfig.padding40,
                minWidth: SizeConfig.screenWidth!,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.white.withOpacity(isEnable ? 1 : 0.5),
                onPressed: () async {
                  if (selectedOption == -1) {
                    BaseUtil.showNegativeAlert("Please select an option",
                        "proceed by choosing an option");
                    return;
                  }

                  if (!isLoading) {
                    isLoading = true;

                    final LendboxMaturityService maturityService =
                        locator<LendboxMaturityService>();

                    bool? hasConfirmed = maturityService.filteredDeposits
                        ?.any((element) => element.txnId == widget.txnId);

                    final res = await locator<LendboxRepo>()
                        .updateUserInvestmentPreference(
                            widget.txnId, maturityPref,
                            hasConfirmed: hasConfirmed ?? false);
                    if (res.isSuccess()) {
                      unawaited(AppState.backButtonDispatcher!.didPopRoute());
                      locator<LendboxMaturityService>().init();
                      BaseUtil.showPositiveAlert(
                          "You preference recorded successfully",
                          "We'll contact you if required");
                    } else {
                      BaseUtil.showNegativeAlert(
                          res.errorMessage, "Please try again");
                    }
                  }
                },
                child: Center(
                  child: isLoading
                      ? SpinKitThreeBounce(
                          color: Colors.black,
                          size: SizeConfig.padding24,
                        )
                      : Text(
                          'Proceed'.toUpperCase(),
                          style:
                              TextStyles.rajdhaniB.body1.colour(Colors.black),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
