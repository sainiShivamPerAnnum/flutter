import 'package:felloapp/ui/pages/hometabs/play/play_components/stepper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class TitlesGames extends StatelessWidget {
  final Widget icon,richText;
  final bool isLast;
  TitlesGames({
    this.icon,
    this.richText,
    this.isLast = false,
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
        richText,
      ],
    );
  }
}
