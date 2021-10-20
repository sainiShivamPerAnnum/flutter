import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class WinningsContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool shadow;

  WinningsContainer({@required this.child, this.color, @required this.shadow});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color ?? UiConstants.primaryColor,
          borderRadius: BorderRadius.circular(SizeConfig.roundness32),
          boxShadow: [
            if (shadow)
              BoxShadow(
                blurRadius: 30,
                color: color != null
                    ? color.withOpacity(0.5)
                    : UiConstants.primaryColor.withOpacity(0.5),
                offset: Offset(
                  0,
                  SizeConfig.screenWidth * 0.1,
                ),
                spreadRadius: -30,
              )
          ]),
      height: SizeConfig.screenWidth * 0.3,
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.06,
            child: Image.asset(
              Assets.whiteRays,
              fit: BoxFit.cover,
              width: SizeConfig.screenWidth,
            ),
          ),
          child
        ],
      ),
    );
  }
}
