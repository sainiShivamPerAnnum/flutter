import 'package:felloapp/ui/pages/hometabs/play/play_components/stepper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class TitlesGames extends StatelessWidget {
  final Widget? icon, richText;
  final bool isLast;
  final bool startPaddingAvilable;
  final bool endPaddingAvailble;
  const TitlesGames({
    this.icon,
    this.richText,
    this.isLast = false,
    this.startPaddingAvilable = true,
    this.endPaddingAvailble = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        startPaddingAvilable
            ? SizedBox(width: SizeConfig.screenWidth! * 0.1)
            : const SizedBox.shrink(),
        Column(
          children: [
            SizedBox(width: SizeConfig.screenWidth! * 0),
            icon!,
            isLast
                ? SizedBox(height: SizeConfig.padding12)
                : const GameStepper(),
          ],
        ),
        SizedBox(
          width: SizeConfig.padding20,
        ),
        Flexible(child: richText!),
        // if (endPaddingAvailble)
        startPaddingAvilable
            ? SizedBox(width: SizeConfig.screenWidth! * 0.1)
            : const SizedBox.shrink(),
      ],
    );
  }
}
