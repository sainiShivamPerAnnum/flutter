import 'dart:developer';

import 'package:felloapp/ui/pages/static/app_widget.dart';

import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AppDefaultDialog extends StatefulWidget {
  final String title, description, buttonText, cancelBtnText;
  final Function confirmAction, cancelAction;
  final Widget asset;

  AppDefaultDialog({
    @required this.title,
    this.description = '',
    @required this.buttonText,
    @required this.confirmAction,
    @required this.cancelAction,
    this.asset,
    this.cancelBtnText = 'Cancel',
  });

  @override
  State createState() => _FormDialogState();
}

class _FormDialogState extends State<AppDefaultDialog> {
  Log log = new Log('AppDefaultDialog');
  bool isLoading = false;

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
      // height: widget.description == ''
      //     ? SizeConfig.screenWidth * 0.5278
      //     : SizeConfig.screenWidth * 0.5833,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding12,
          vertical: SizeConfig.padding12,
        ),
        // constraints: BoxConstraints(
        //   maxHeight: widget.description == ''
        //       ? SizeConfig.screenWidth * 0.5222
        //       : SizeConfig.screenWidth * 0.5778,
        //   minHeight: widget.description == ''
        //       ? SizeConfig.screenWidth * 0.5222
        //       : SizeConfig.screenWidth * 0.5778,
        // ),
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
          color: UiConstants.kSecondaryBackgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // SizedBox(
            //   height: widget.description == ''
            //       ? SizeConfig.padding40
            //       : SizeConfig.padding32,
            // ),
            SizedBox(
              width: SizeConfig.screenWidth * 0.5,
              child: Text(
                widget.title,
                style: widget.description == ''
                    ? TextStyles.sourceSansSB.body2
                    : TextStyles.sourceSansSB.title4,
                textAlign: TextAlign.center,
              ),
            ),
            if (widget.asset != null)
              SizedBox(
                height: SizeConfig.padding10,
              ),
            if (widget.asset != null) widget.asset,
            if (widget.description.isNotEmpty)
              SizedBox(
                height: SizeConfig.padding10,
              ),
            if (widget.description.isNotEmpty)
              SizedBox(
                width: SizeConfig.screenWidth * 0.4722,
                child: Text(
                  widget.description,
                  style: TextStyles.sourceSans.body4.colour(
                    UiConstants.kTextColor.withOpacity(0.60),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              height: SizeConfig.padding40,
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppNegativeBtn(
                        btnText: widget.cancelBtnText,
                        onPressed: () {
                          return widget.cancelAction();
                        },
                      ),
                      SizedBox(
                        width: SizeConfig.padding12,
                      ),
                      AppPositiveBtn(
                        btnText: widget.buttonText,
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          return widget.confirmAction();
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
