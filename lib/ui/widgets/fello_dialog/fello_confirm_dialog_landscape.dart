import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloConfirmationLandScapeDialog extends StatefulWidget {
  final Widget content;
  final Function onAccept;
  final Function onReject;
  final Color acceptColor;
  final Color rejectColor;
  final ValueChanged result;
  final bool showCrossIcon;
  final String title;
  final String asset;
  final String subtitle;
  final String accept;
  final String reject;
  final bool inLandScape;

  FelloConfirmationLandScapeDialog(
      {this.result,
      this.content,
      this.onAccept,
      this.onReject,
      this.asset,
      this.showCrossIcon,
      this.subtitle,
      this.title,
      this.accept,
      this.acceptColor,
      this.rejectColor,
      this.reject,
      this.inLandScape = true});

  @override
  _FelloConfirmationDialogState createState() =>
      _FelloConfirmationDialogState();
}

class _FelloConfirmationDialogState
    extends State<FelloConfirmationLandScapeDialog> {
  bool showButtons = true;
  ValueChanged<bool> isBusy;
  @override
  Widget build(BuildContext context) {
    return FelloDialog(
      content: widget.inLandScape
          ? RotatedBox(
              quarterTurns: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.content != null
                      ? widget.content
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              widget.asset,
                              height: SizeConfig.screenWidth * 0.1,
                            ),
                            SizedBox(height: SizeConfig.padding8),
                            Text(
                              widget.title,
                              style: TextStyles.title1.bold,
                            ),
                            SizedBox(height: SizeConfig.padding8),
                            Text(
                              widget.subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyles.body1.colour(Colors.grey),
                            ),
                            SizedBox(height: SizeConfig.padding16),
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
                              width: SizeConfig.screenWidth * 0.8,
                              child: FelloButtonLg(
                                child: Text(
                                  widget.accept,
                                  style: TextStyles.body3.bold
                                      .colour(Colors.white),
                                ),
                                color: widget.acceptColor,
                                height: SizeConfig.padding54,
                                onPressed: () {
                                  setState(() {
                                    showButtons = false;
                                  });
                                  if (widget.result != null)
                                    widget.result(true);
                                  if (widget.onAccept != null)
                                    widget.onAccept();
                                },
                              ),
                            ),
                            SizedBox(height: SizeConfig.padding12),
                            Container(
                              width: SizeConfig.screenWidth * 0.8,
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
            )
          : Container(),
      showCrossIcon: false,
    );
  }
}
