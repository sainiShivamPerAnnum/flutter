///Package imports

import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:flutter/material.dart';

///[HMSButton] is a button based on HMS theme colors
class HMSButton extends StatelessWidget {
  final double width;
  final Color? shadowColor;
  final Function() onPressed;
  final Widget childWidget;
  final Color? buttonBackgroundColor;
  const HMSButton(
      {super.key,
      required this.width,
      this.shadowColor,
      required this.onPressed,
      required this.childWidget,
      this.buttonBackgroundColor});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  buttonBackgroundColor ?? HMSThemeColors.primaryDefault),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ))),
          onPressed: onPressed,
          child: childWidget,
        ));
  }
}
