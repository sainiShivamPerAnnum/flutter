import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class TitleSubtitleContainer extends StatelessWidget {
  final String title;
  final String? subTitle;
  final bool leadingPadding;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool zeroPadding;
  final EdgeInsets? padding;
  const TitleSubtitleContainer(
      {required this.title,
      Key? key,
      this.subTitle,
      this.titleStyle,
      this.subtitleStyle,
      this.padding,
      this.zeroPadding = false,
      this.leadingPadding = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: zeroPadding
          ? EdgeInsets.zero
          : padding ??
              EdgeInsets.only(
                  left: leadingPadding
                      ? SizeConfig.padding24
                      : SizeConfig.padding14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.sourceSansSB.title3.merge(titleStyle)),
          if (subTitle != null && subTitle!.isNotEmpty)
            Padding(
              padding: padding ?? EdgeInsets.only(top: SizeConfig.padding4),
              child: Text(
                subTitle!,
                style: TextStyles.sourceSans.body4
                    .colour(
                      UiConstants.kTextColor2,
                    )
                    .merge(subtitleStyle),
              ),
            ),
        ],
      ),
    );
  }
}
