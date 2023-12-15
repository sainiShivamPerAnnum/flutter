import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SaveCustomCard extends StatelessWidget {
  final String? title;
  final Function()? onCardTap;
  final Color? cardBgColor;
  final String? subtitle;
  final String? cardAssetName;
  final Function()? onTap;
  final InvestmentType investmentType;
  final List<String> chipText;
  final String? footerText;
  final Color? footerColor;

  const SaveCustomCard({
    required this.chipText,
    required this.investmentType,
    Key? key,
    this.title,
    this.onCardTap,
    this.cardBgColor,
    this.subtitle,
    this.cardAssetName,
    this.onTap,
    this.footerColor,
    this.footerText,
  }) : super(key: key);

  // final ValueKey? key;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        // height: SizeConfig.screenWidth! * 0.35,
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.pageHorizontalMargins,
          vertical: SizeConfig.padding10,
        ),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  cardAssetName!,
                  height: SizeConfig.screenWidth! * 0.2,
                  width: SizeConfig.screenWidth! * 0.2,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.padding20,
                        bottom: SizeConfig.padding16,
                        right: SizeConfig.padding20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    title!,
                                    style: TextStyles.rajdhaniSB.title5,
                                    key: ValueKey(title),
                                  ),
                                  Text(
                                    subtitle!,
                                    style:
                                        TextStyles.body3.colour(Colors.white54),
                                  )
                                ],
                              ),
                            ),
                            SvgPicture.asset(
                              Assets.chevRonRightArrow,
                              color: Colors.white,
                              width: SizeConfig.padding32,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: SizeConfig.padding2),
                    width: SizeConfig.screenWidth! * 0.32,
                    height: SizeConfig.padding32,
                    decoration: BoxDecoration(
                        color: (key ==
                                const ValueKey(Constants.ASSET_TYPE_AUGMONT))
                            ? const Color(0xff5567B7)
                            : const Color(0xff326D71),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness8)),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: List.generate(
                        chipText.length,
                        (index) => RotateAnimatedText(
                          chipText[index].toUpperCase(),
                          duration: const Duration(seconds: 2),
                          textStyle: TextStyles.sourceSansSB.body4
                              .colour(Colors.white)
                              .letterSpace(2),
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: onTap,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness5)),
                    child: Text(
                      "SAVE",
                      style: TextStyles.rajdhaniB.body2.colour(Colors.black),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: SizeConfig.padding16),
            if (footerText != null)
              Container(
                height: SizeConfig.padding32,
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  color: footerColor ?? UiConstants.kFloContainerColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(SizeConfig.roundness12),
                    bottomLeft: Radius.circular(SizeConfig.roundness12),
                  ),
                ),
                alignment: Alignment.center,
                child: footerText!.beautify(
                    alignment: TextAlign.center,
                    style: TextStyles.body4.colour(Colors.white)),
              )
          ],
        ),
      ),
    );
  }
}

class CustomSaveButton extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final double? width;
  final double? height;
  final Border? border;
  final Color? color;
  final bool showBorder;

  const CustomSaveButton(
      {Key? key,
      this.onTap,
      this.height,
      this.title,
      this.width,
      this.border,
      this.showBorder = true,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? SizeConfig.screenWidth! * 0.13,
      width: width ?? SizeConfig.screenWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
          color: color ?? UiConstants.kBackgroundDividerColor,
          border: showBorder ? border ?? Border.all() : null),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        child: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: onTap ?? () {},
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.grey.withOpacity(0.1), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Center(
              child: Text(
                (title ?? '').toUpperCase(),
                style: TextStyles.rajdhaniB.body1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
