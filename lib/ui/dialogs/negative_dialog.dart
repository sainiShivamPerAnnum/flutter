import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AppNegativeDialog extends StatelessWidget {
  const AppNegativeDialog({
    required this.btnText,
    required this.title,
    required this.btnAction,
    Key? key,
    this.subtitle,
  }) : super(key: key);
  final String? title, btnText, subtitle;
  final VoidCallback btnAction;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Wrap(children: [dialogContent(context)]),
      insetPadding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
    );
  }

  dialogContent(BuildContext context) {
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
      // height: SizeConfig.screenWidth * 0.4167,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
          // constraints: BoxConstraints(
          //   // maxHeight: SizeConfig.screenWidth * 0.4111,
          //   minHeight: SizeConfig.screenWidth * 0.4111,
          // ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
            color: UiConstants.kSecondaryBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.padding32,
              ),
              SizedBox(
                width: SizeConfig.screenWidth! -
                    SizeConfig.pageHorizontalMargins * 2,
                child: Text(
                  title!,
                  style: TextStyles.sourceSansSB.title4,
                  textAlign: TextAlign.center,
                ),
              ),
              if (subtitle != null)
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding12,
                      horizontal: SizeConfig.pageHorizontalMargins),
                  child: Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: TextStyles.sourceSans.body3.colour(Colors.white60),
                  ),
                ),
              SizedBox(
                height: SizeConfig.padding32,
              ),
              AppPositiveBtn(
                width: SizeConfig.screenWidth! * 0.8333,
                btnText: btnText,
                onPressed: () {
                  Haptic.vibrate();
                  AppState.backButtonDispatcher!.didPopRoute();
                  return btnAction();
                },
              ),
              SizedBox(
                height: SizeConfig.padding32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
