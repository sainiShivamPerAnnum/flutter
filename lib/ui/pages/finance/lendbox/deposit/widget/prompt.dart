import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
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
                  ),
                ),
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
    required this.configuration,
    this.showMaturity = false,
    this.maturityTerm = 1,
    super.key,
  });

  final String amount;
  final bool showMaturity;
  final int maturityTerm;
  final LendboxAssetConfiguration configuration;

  String _getTitle(num interest) {
    return "$interest% Flo";
  }

  String _getSubTitle({required int maturityDuration, int terms = 1}) {
    return "Maturity in ${terms * maturityDuration} Months";
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,##0", "en_US");
    final amt = num.parse(amount);

    final interest = BaseUtil.calculateCompoundInterest(
      amount: amt,
      interestRate: configuration.interest,
      maturityDuration: configuration.maturityDuration,
      terms: maturityTerm,
    ).toInt();

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
                _getTitle(configuration.interest),
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
                header: 'Maturity Amount',
                sub: '₹${formatter.format(amt)}+',
                subTail: '₹${formatter.format(interest)}',
              ),
            ],
          ),
          if (showMaturity) ...[
            SizedBox(
              height: SizeConfig.padding16,
            ),
            Text(
              _getSubTitle(
                maturityDuration: configuration.maturityDuration,
                terms: maturityTerm,
              ),
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
