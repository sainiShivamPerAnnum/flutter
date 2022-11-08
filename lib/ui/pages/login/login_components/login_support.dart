import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class LoginFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding44, horizontal: SizeConfig.padding14),
      child: Container(
          height: SizeConfig.navBarHeight * 0.45,
          width: SizeConfig.navBarWidth * 0.28,
          decoration: BoxDecoration(
            color: UiConstants.kDarkBackgroundColor,
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.roundness112)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Support",
                style: TextStyles.body4.colour(UiConstants.kTextColor),
              ),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.padding8),
                child: Image.asset(
                  Assets.support,
                  color: UiConstants.kTextColor,
                  height: SizeConfig.iconSize2,
                  width: SizeConfig.iconSize2,
                ),
              )
            ],
          )),
    );
  }
}
