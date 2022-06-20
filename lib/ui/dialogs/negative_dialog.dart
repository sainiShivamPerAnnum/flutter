import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AppNegativeDialog extends StatelessWidget {
  const AppNegativeDialog({
    Key key,
    @required this.btnText,
    @required this.title,
    @required this.btnAction,
  }) : super(key: key);
  final String title, btnText;
  final VoidCallback btnAction;

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
      height: SizeConfig.screenWidth * 0.4167,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
          constraints: BoxConstraints(
            maxHeight: SizeConfig.screenWidth * 0.4111,
            minHeight: SizeConfig.screenWidth * 0.4111,
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
              SizedBox(
                width: SizeConfig.screenWidth * 0.5,
                child: Text(
                  title,
                  style: TextStyles.sourceSansSB.title4,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: SizeConfig.padding32,
              ),
              AppPositiveBtn(
                btnText: btnText,
                onPressed: () {
                  Haptic.vibrate();
                  AppState.backButtonDispatcher.didPopRoute();
                  return btnAction();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
