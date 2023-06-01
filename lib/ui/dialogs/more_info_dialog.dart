import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/default_dialog.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class MoreInfoDialog extends StatelessWidget {
  final String title;
  final String text;
  final String? imagePath;
  final Size? imageSize;
  final Function? onPressed;
  final String? btnText;
  final Widget? asset;

  MoreInfoDialog({
    required this.title,
    required this.text,
    this.imagePath,
    this.onPressed,
    this.btnText,
    this.imageSize,
    this.asset,
  });

  S locale = locator<S>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (AppState.screenStack.last == ScreenItem.dialog) {
          AppState.screenStack.removeLast();
        }
        return Future.value(true);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BaseDialog(
            content: Padding(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (asset != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.pageHorizontalMargins,
                      ),
                      child: asset!,
                    ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyles.rajdhaniSB.title4,
                  ),
                  // Divider(color: UiConstants.kTextColor2),
                  const SizedBox(
                    height: 5,
                  ),

                  if (imagePath != null && imagePath!.isNotEmpty)
                    Image.asset(
                      imagePath!,
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      width: SizeConfig.screenWidth! * 0.8,
                      height: SizeConfig.screenHeight! * 0.24,
                    ),
                  SizedBox(height: SizeConfig.padding12),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyles.sourceSans.body2,
                  ),
                  SizedBox(height: SizeConfig.padding20),
                  AppPositiveBtn(
                      btnText: btnText ?? locale.btnOk.toUpperCase(),
                      onPressed: onPressed as void Function()? ??
                          (() => AppState.backButtonDispatcher!.didPopRoute()))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
