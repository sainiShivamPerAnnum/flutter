import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class TitleSubtitleContainer extends StatelessWidget {
  final String title;
  final String subTitle;

  const TitleSubtitleContainer({Key key, @required this.title, this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.padding24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.rajdhaniSB.title3),
          if (subTitle != null)
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.padding4),
              child: Text(
                subTitle,
                style: TextStyles.sourceSans.body4.colour(
                  UiConstants.kTextColor2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
