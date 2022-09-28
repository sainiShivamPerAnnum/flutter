import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SellText extends StatelessWidget {
  final InvestmentType investmentType;

  const SellText({Key key, @required this.investmentType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = investmentType == InvestmentType.AUGGOLD99
        ? 'Sell your Digital Gold \nat current market rate'
        : 'Withdrawal your savings';
    final subTitle = "With every transaction, some tokens will be deducted.";
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.sourceSansSB.body2.colour(
              Colors.grey.withOpacity(0.8),
            ),
          ),
          SizedBox(height: SizeConfig.padding6),
          Text(
            subTitle,
            maxLines: 2,
            style:
                TextStyles.sourceSans.body4.colour(UiConstants.kBlogTitleColor),
          ),
        ],
      ),
    );
  }
}

class SellButton extends StatelessWidget {
  final Function onTap;
  final bool isActive;

  SellButton({Key key, @required this.onTap, @required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : () {},
      child: Container(
        height: SizeConfig.screenWidth * 0.12,
        width: SizeConfig.screenWidth * 0.29,
        margin: EdgeInsets.only(left: SizeConfig.padding24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
          border: Border.all(
            color:
                isActive ? Colors.white : UiConstants.kSecondaryBackgroundColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            'SELL',
            style: TextStyles.rajdhaniSB.body0.colour(
              isActive ? UiConstants.kTextColor : UiConstants.kTextColor2,
            ),
          ),
        ),
      ),
    );
  }
}

class AugmontDownCard extends StatelessWidget {
  const AugmontDownCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ongoingCard extends StatelessWidget {
  const ongoingCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class GoldLockedInCard extends StatelessWidget {
  const GoldLockedInCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SellActionButton extends StatelessWidget {
  final String title;
  final String iconData;
  final bool isCenter;
  final Function() onTap;

  const SellActionButton({
    Key key,
    this.title,
    this.iconData,
    this.onTap,
    this.isCenter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding24,
        vertical: SizeConfig.padding6,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: SizeConfig.screenWidth * 0.16,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness5),
            color: UiConstants.kDarkBackgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
            child: Row(
              mainAxisAlignment: this.isCenter
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyles.rajdhaniM.body1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SellCardInfoStrips extends StatelessWidget {
  final Widget leadingIcon;
  final String content;
  final Color backgroundColor;
  final Color textColor;

  const SellCardInfoStrips({
    Key key,
    this.leadingIcon,
    @required this.content,
    this.textColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding24,
        vertical: SizeConfig.padding6,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding20,
        vertical: SizeConfig.padding16,
      ),
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        color: backgroundColor ?? UiConstants.kSecondaryBackgroundColor,
      ),
      child: Row(
        children: [
          leadingIcon ??
              Padding(
                padding: EdgeInsets.only(right: SizeConfig.padding16),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: UiConstants.kTextColor,
                ),
              ),
          Expanded(
            child: Text(
              content,
              style: TextStyles.sourceSans.body4.colour(
                textColor ?? UiConstants.kTextColor2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
