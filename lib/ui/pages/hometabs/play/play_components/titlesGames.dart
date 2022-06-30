import 'package:felloapp/ui/pages/hometabs/play/play_components/stepper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class TitlesGames extends StatelessWidget {
  final String greyText, whiteText, asset;
  final Widget icon;
  final bool isLast;
  TitlesGames({
    this.asset,
    this.greyText,
    this.icon,
    this.whiteText,
    this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: SizeConfig.screenWidth * 0.16),
        Column(
          children: [
            SizedBox(width: SizeConfig.screenWidth * 0),
            icon,
            if (!isLast) GameStepper(),
          ],
        ),
        SizedBox(
          width: SizeConfig.padding20,
        ),
        RichText(
          text: TextSpan(
            text: whiteText,
            style: TextStyles.sourceSans.body3,
            children: <TextSpan>[
              TextSpan(
                text: greyText,
                style: TextStyles.sourceSans.body3.colour(Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
