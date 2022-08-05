import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlertSnackbar extends StatelessWidget {
  final String title;
  final String message;
  final Function() onTap;
  final int seconds;
  final Color alertColor;
  final String alertAssetColor;

  const AlertSnackbar(
      {Key key,
      this.title,
      this.message,
      this.onTap,
      this.seconds = 3,
      this.alertColor,
      this.alertAssetColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
        onVisible: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.all(5),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: seconds),
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
                    height: 32,
                    width: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: alertColor),
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(alertAssetColor))),
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
                    Text(
                      message,
                      style: TextStyles.body4.colour(UiConstants.textColor),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
