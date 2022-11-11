import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

SnackBar alertSnackBar(
    {String title,
    String message,
    Function() onTap,
    final int seconds,
    Color alertColor,
    String alertAsset}) {
  return SnackBar(
      onVisible: onTap,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.all(5),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: seconds ?? 3),
      dismissDirection: DismissDirection.down,
      content: Container(
        height: SizeConfig.screenHeight * 0.08,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: UiConstants.kSnackBarBgColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.padding10),
          child: Row(
            children: [
              Container(
                  height: SizeConfig.screenHeight * 0.05,
                  width: SizeConfig.screenWidth * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: alertColor),
                  child: SizedBox(
                      height: SizeConfig.padding20,
                      width: SizeConfig.padding20,
                      child: SvgPicture.asset(alertAsset))),
              SizedBox(
                width: SizeConfig.screenWidth * 0.06,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.body3.colour(UiConstants.textColor),
                  ),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.6),
                    child: Text(
                      message,
                      style: TextStyles.body4.colour(UiConstants.textColor),
                      maxLines: 2,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ));
}
