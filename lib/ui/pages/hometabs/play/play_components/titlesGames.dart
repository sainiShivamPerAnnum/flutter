import 'package:felloapp/ui/pages/hometabs/play/play_components/stepper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class TitlesGames extends StatelessWidget {
  final Widget icon, richText;
  final bool isLast;
  final bool startPaddingAvilable;
  TitlesGames({
    this.icon,
    this.richText,
    this.isLast = false,
    this.startPaddingAvilable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        startPaddingAvilable
            ? SizedBox(width: SizeConfig.screenWidth * 0.16)
            : SizedBox.shrink(),
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
        Flexible(child: richText),
      ],
    );
  }
}
