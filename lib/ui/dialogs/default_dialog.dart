import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  final Widget? content;
  const BaseDialog({required this.content});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.black.withOpacity(0),
            Colors.white.withOpacity(0.3),
          ],
        ),
      ),
      width: SizeConfig.screenWidth,
      child: Container(
          padding: EdgeInsets.only(
            bottom: SizeConfig.padding12,
            right: SizeConfig.padding12,
            left: SizeConfig.padding12,
            top: SizeConfig.padding24,
          ),
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
            color: UiConstants.kTambolaMidTextColor,
          ),
          child: content),
    );
  }
}
