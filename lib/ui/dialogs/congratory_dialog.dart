import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AppCongratulatoryDialog extends StatelessWidget {
  const AppCongratulatoryDialog({
    Key key,
    @required this.title,
    this.description = '',
    @required this.buttonText,
    @required this.confirmAction,
  }) : super(key: key);

  final String title, description, buttonText;
  final Function confirmAction;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
      insetPadding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
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
      height: SizeConfig.screenWidth * 1.083,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
          constraints: BoxConstraints(
            maxHeight: SizeConfig.screenWidth * 1.0778,
            minHeight: SizeConfig.screenWidth * 1.0778,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
            color: UiConstants.kSecondaryBackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.padding32,
              ),
              // SvgPicture.asset(
              //   'assets/temp/congratulation_dialog_logo.svg',
              //   width: SizeConfig.screenWidth * 0.4778,
              //   height: SizeConfig.screenWidth * 0.4111,
              // ),
              Image.asset(
                'assets/temp/congratulation_dialog_logo.png',
                width: SizeConfig.screenWidth * 0.4778,
                height: SizeConfig.screenWidth * 0.4111,
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.5,
                child: Text(
                  title,
                  style: TextStyles.rajdhaniB.title2,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.4922,
                child: Text(
                  description,
                  style: TextStyles.sourceSans.body2.colour(
                    UiConstants.kTextColor.withOpacity(0.60),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: SizeConfig.padding54,
              ),
              AppPositiveBtn(
                btnText: buttonText,
                onPressed: () {
                  Haptic.vibrate();
                  AppState.backButtonDispatcher.didPopRoute();
                  return confirmAction();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
