import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SafetyWidget extends StatelessWidget {
  const SafetyWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
                width: 0.4, color: UiConstants.kLastUpdatedTextColor),
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.roundness16))),
        margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        padding: EdgeInsets.all(SizeConfig.padding16),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/svg/safety_asset.svg",
              width: SizeConfig.screenWidth * 0.15,
            ),
            SizedBox(
              width: SizeConfig.padding14,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      "Games are played with Fello tokens",
                      style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
                    ),
                  ),
                  Text(
                    "Fello games do not use any money from your savings or investments",
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTextColor2),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
