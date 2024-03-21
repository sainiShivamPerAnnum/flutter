import 'package:felloapp/ui/keys/keys.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatefulWidget {
  final String title, description, buttonText, cancelBtnText;
  final Function confirmAction, cancelAction;
  final Widget? asset;
  final bool showSecondaryButton;
  const ConfirmationDialog({
    required this.title,
    required this.buttonText,
    required this.confirmAction,
    required this.cancelAction,
    super.key,
    this.description = '',
    this.showSecondaryButton = true,
    this.asset,
    this.cancelBtnText = 'Cancel',
  });

  @override
  State createState() => _FormDialogState();
}

class _FormDialogState extends State<ConfirmationDialog> {
  Log log = const Log('ConfirmationDialog');
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
      child: dialogContent(context),
    );
  }

  Container dialogContent(BuildContext context) {
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
          top: SizeConfig.padding32,
        ),
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
          color: UiConstants.kSecondaryBackgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: TextStyles.rajdhaniB.title3,
              textAlign: TextAlign.center,
            ),
            if (widget.asset != null)
              Padding(padding: EdgeInsets.zero, child: widget.asset),
            if (widget.description.isNotEmpty)
              Container(
                padding: EdgeInsets.only(
                  top: SizeConfig.padding12,
                ),
                width: SizeConfig.screenWidth! * 0.75,
                child: Text(
                  widget.description,
                  style: TextStyles.sourceSans.body2.colour(
                    UiConstants.kTextColor.withOpacity(0.60),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            isLoading
                ? Column(
                    children: [
                      const CircularProgressIndicator(
                        strokeWidth: 0.5,
                      ),
                      SizedBox(height: SizeConfig.padding16)
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.showSecondaryButton) ...[
                        Expanded(
                          child: AppNegativeBtn(
                            key: const Key('logoutCancelCTA'),
                            width: SizeConfig.screenWidth! * 0.40,
                            btnText: widget.cancelBtnText,
                            onPressed: () {
                              return widget.cancelAction();
                            },
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.padding10,
                        ),
                      ],
                      Expanded(
                        child: Center(
                          child: AppPositiveBtn(
                            key: const Key('logoutConfirmationCTA'),
                            // key: K.confirmationDialogCTAKey,
                            btnText: widget.buttonText,
                            width: !widget.showSecondaryButton
                                ? null
                                : SizeConfig.screenWidth! * 0.40,
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              return widget.confirmAction();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
