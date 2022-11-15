import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  final double bottomPad;
  const AppFooter({
    Key key,
    this.bottomPad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      alignment: Alignment.center,
      margin: EdgeInsets.only(
          left: SizeConfig.padding40,
          right: SizeConfig.padding40,
          top: SizeConfig.padding32,
          bottom: bottomPad ?? 0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          "images/fello-short-logo.png",
          color: UiConstants.kTextColor2,
          height: SizeConfig.padding26,
          width: SizeConfig.padding26,
          fit: BoxFit.contain,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'v${BaseUtil.packageInfo?.version ?? 0.0} (${BaseUtil.packageInfo?.buildNumber ?? 0.0})',
              style: TextStyles.rajdhaniB.body3.colour(UiConstants.kTextColor2),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Made with ',
                    style: TextStyles.body4.colour(UiConstants.kTextColor2),
                  ),
                  WidgetSpan(
                      child: Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.padding1),
                    child: Icon(
                      Icons.favorite,
                      color: UiConstants.kTextColor2,
                      size: SizeConfig.iconSize2,
                    ),
                  )),
                  TextSpan(
                    text: ' in India',
                    style: TextStyles.body4.colour(UiConstants.kTextColor2),
                  ),
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}
