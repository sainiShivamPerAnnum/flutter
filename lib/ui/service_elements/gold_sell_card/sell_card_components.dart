import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SellText extends StatelessWidget {
  final InvestmentType investmentType;

  const SellText({required this.investmentType, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    final title = investmentType == InvestmentType.AUGGOLD99
        ? "Sell Digital Gold"
        : locale.sellCardTitle2;
    const subTitle =
        'With every withdrawal, some tokens and tickets will be deducted.';
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.sourceSansSB.body1.colour(
              Colors.white,
            ),
          ),
          SizedBox(height: SizeConfig.padding6),
          Text(
            subTitle,
            // maxLines: 2,
            style: TextStyles.sourceSans.body4.colour(const Color(0xffc5cacd)),
          ),
        ],
      ),
    );
  }
}

class SellButton extends StatelessWidget {
  final Function onTap;
  final bool isActive;
  final String text;

  const SellButton(
      {required this.onTap,
      required this.isActive,
      required this.text,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return isActive
        ? GestureDetector(
            onTap: isActive ? onTap as void Function()? : () {},
            child: Container(
              height: SizeConfig.screenWidth! * 0.12,
              width: SizeConfig.screenWidth! * 0.29,
              margin: EdgeInsets.only(left: SizeConfig.padding24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyles.rajdhaniSB.body1.colour(
                    Colors.black,
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

class AugmontDownCard extends StatelessWidget {
  const AugmontDownCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ongoingCard extends StatelessWidget {
  const ongoingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class GoldLockedInCard extends StatelessWidget {
  const GoldLockedInCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SellActionButton extends StatelessWidget {
  final String? title;
  final String? iconData;
  final bool isCenter;
  final Function()? onTap;

  const SellActionButton({
    Key? key,
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
          height: SizeConfig.screenWidth! * 0.16,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(SizeConfig.roundness5),
            color: const Color(0xffd9d9d9).withOpacity(0.1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
            child: Row(
              mainAxisAlignment: isCenter
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: TextStyles.rajdhaniM.body1.colour(Colors.white),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SellCardInfoStrips extends StatelessWidget {
  final Widget? leadingIcon;
  final String? content;
  final Color? backgroundColor;
  final Color? textColor;

  const SellCardInfoStrips({
    required this.content,
    Key? key,
    this.leadingIcon,
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
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: UiConstants.kTextColor,
                ),
              ),
          Expanded(
            child: Text(
              content!,
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
