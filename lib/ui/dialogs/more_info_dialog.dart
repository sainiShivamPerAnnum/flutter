import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/default_dialog.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class MoreInfoDialog extends StatelessWidget {
  final String title;
  final String text;
  final String imagePath;
  final Size imageSize;

  MoreInfoDialog(
      {@required this.title,
      @required this.text,
      this.imagePath,
      this.imageSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BaseDialog(
          content: Padding(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyles.rajdhaniSB.title4,
                ),
                Divider(color: UiConstants.kTextColor2),
                SizedBox(
                  height: 5,
                ),
                if (imagePath != null && imagePath.isNotEmpty)
                  Image.asset(
                    imagePath,
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    width: SizeConfig.screenWidth * 0.8,
                    height: SizeConfig.screenHeight * 0.24,
                  ),
                SizedBox(height: SizeConfig.padding12),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyles.sourceSans.body2,
                ),
                SizedBox(height: SizeConfig.padding20),
                AppPositiveBtn(
                    btnText: "OK",
                    onPressed: () =>
                        AppState.backButtonDispatcher.didPopRoute())
              ],
            ),
          ),
        ),
      ],
    );
  }
}
