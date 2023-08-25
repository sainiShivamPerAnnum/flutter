import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OptionDecisionContainer extends StatelessWidget {
  final int optionIndex;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showRecomended;
  final String promoText;
  final Color? promoContainerColor;
  final String? recommendedText;
  final Color? promoTextBoldColor;
  final String? promotAsset;

  const OptionDecisionContainer({
    required this.optionIndex,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
    required this.promoText,
    Key? key,
    this.showRecomended = false,
    this.promoContainerColor,
    this.recommendedText,
    this.promoTextBoldColor,
    this.promotAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          if (showRecomended)
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding8,
                  vertical: SizeConfig.padding2,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff62E3C4),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.padding6),
                      topRight: Radius.circular(SizeConfig.padding6)),
                ),
                child: Text(recommendedText ?? 'Recommended',
                    textAlign: TextAlign.center,
                    style: TextStyles.sourceSansSB.body4
                        .colour(const Color(0xFF013B3F))),
              ),
            ),
          Container(
            margin: EdgeInsets.only(
              bottom: SizeConfig.padding16,
              left: SizeConfig.padding8,
              right: SizeConfig.padding8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  SizeConfig.padding8), // Set rounded corner
              border: Border.all(
                  color: isSelected
                      ? Colors.white // Change color when selected
                      : const Color(0xFFD3D3D3).withOpacity(0.6),
                  width: isSelected ? 1 : 0.6),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(SizeConfig.padding16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.padding8),
                      topRight: Radius.circular(SizeConfig.padding8),
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
                              color: isSelected
                                  ? UiConstants.kTabBorderColor
                                  : const Color(0xFFD3D3D3).withOpacity(0.6),
                              width: SizeConfig.border1,
                            ),
                            // color: isSelected ? Colors.white : null,
                          ),
                          child: Container(
                            margin: EdgeInsets.all(SizeConfig.padding4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? UiConstants.kTabBorderColor
                                  : null,
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
                            overflow: TextOverflow.ellipsis,
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
                Container(
                  width: SizeConfig.screenWidth,
                  // height: SizeConfig.padding22,
                  padding: EdgeInsets.symmetric(
                    // horizontal: SizeConfig.padding16,
                    vertical: SizeConfig.padding4,
                  ),
                  decoration: ShapeDecoration(
                    color:
                        promoContainerColor ?? Colors.white.withOpacity(0.12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.network(
                          promotAsset ??
                              'https://d37gtxigg82zaw.cloudfront.net/under25/tambola.svg',
                          height: SizeConfig.screenHeight! * 0.015,
                          width: SizeConfig.screenHeight! * 0.015,
                        ),
                        SizedBox(
                          width: SizeConfig.padding8,
                        ),
                        promoText.beautify(
                          boldStyle: TextStyles.sourceSansB.body4
                              .colour(promoTextBoldColor ?? Colors.white),
                          style:
                              TextStyles.sourceSans.body4.colour(Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
