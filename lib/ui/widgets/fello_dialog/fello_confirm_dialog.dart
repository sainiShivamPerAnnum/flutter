import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_dialog.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloConfirmationDialog extends StatefulWidget {
  final Widget content;
  final Function onAccept;
  final Function onReject;
  final Color acceptColor;
  final Color rejectColor;
  final ValueChanged result;
  final bool showCrossIcon;
  final String title;
  final String asset;
  final String assetpng;
  final String subtitle;
  final String accept;
  final String reject;

  FelloConfirmationDialog({
    this.result,
    this.content,
    this.onAccept,
    this.onReject,
    this.asset,
    this.showCrossIcon,
    this.subtitle,
    this.title,
    this.accept,
    this.assetpng,
    this.acceptColor,
    this.rejectColor,
    this.reject,
  });

  @override
  _FelloConfirmationDialogState createState() =>
      _FelloConfirmationDialogState();
}

class _FelloConfirmationDialogState extends State<FelloConfirmationDialog> {
  bool showButtons = true;
  ValueChanged<bool> isBusy;
  @override
  Widget build(BuildContext context) {
    return FelloDialog(
      content: Column(
        children: [
          widget.content != null
              ? widget.content
              : Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    if (widget.asset != null)
                      SvgPicture.asset(
                        widget.asset,
                        height: SizeConfig.screenHeight * 0.16,
                      ),
                    if (widget.assetpng != null)
                      Image.asset(
                        widget.assetpng,
                        height: SizeConfig.screenHeight * 0.16,
                      ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.04,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.title,
                        style: TextStyles.title2.bold,
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding16),
                    Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyles.body2.colour(Colors.grey),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                  ],
                ),
          !showButtons
              ? Container(
                  alignment: Alignment.center,
                  height: SizeConfig.padding64,
                  child: Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: UiConstants.primaryColor,
                      backgroundColor: UiConstants.tertiarySolid,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      width: SizeConfig.screenWidth,
                      child: FelloButtonLg(
                        child: Text(
                          widget.accept,
                          style: TextStyles.body3.bold.colour(Colors.white),
                        ),
                        color: widget.acceptColor,
                        height: SizeConfig.padding54,
                        onPressed: () {
                          setState(() {
                            showButtons = false;
                          });
                          if (widget.result != null) widget.result(true);
                          if (widget.onAccept != null) widget.onAccept();
                        },
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding12),
                    Container(
                      width: SizeConfig.screenWidth,
                      child: FelloButtonLg(
                        child: Text(
                          widget.reject,
                          style: TextStyles.body3.bold,
                        ),
                        color: widget.rejectColor,
                        height: SizeConfig.padding54,
                        onPressed: () {
                          if (widget.reject != null) widget.onReject();
                        },
                      ),
                    ),
                  ],
                ),
        ],
      ),
      showCrossIcon: false,
    );
  }
}
