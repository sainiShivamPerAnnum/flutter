import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_dialog.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class FelloConfirmationDialog extends StatefulWidget {
  final Widget content;
  final Function onAccept;
  final Function onReject;
  final ValueChanged result;
  final bool showCrossIcon;
  final String title;
  final String subtitle;
  final String body;
  final String accept;
  final String reject;

  FelloConfirmationDialog(
      {this.result,
      this.content,
      this.onAccept,
      this.onReject,
      this.showCrossIcon,
      this.body,
      this.subtitle,
      this.title,
      this.accept,
      this.reject});

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
              : Container(
                  margin: EdgeInsets.all(SizeConfig.globalMargin * 2),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 4.0),
                        child: Text(
                          widget.title,
                          style: TextStyles.body1.bold
                              .colour(UiConstants.primaryColor),
                        ),
                      ),
                      Text(
                        widget.subtitle,
                        style: TextStyles.body2,
                      ),
                      SizedBox(height: 16),
                      Text(
                        widget.body,
                        style: TextStyles.body2
                            .colour(Colors.black54)
                            .letterSpace(4),
                      )
                    ],
                  ),
                ),
          !showButtons
              ? Container(
                  alignment: Alignment.center,
                  height: 60,
                  child: Container(
                    width: SizeConfig.largeTextSize,
                    height: SizeConfig.largeTextSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                )
              : IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          decoration: BoxDecoration(
                            color: UiConstants.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                          child: FelloButton(
                            action: (isBusy) {
                              setState(() {
                                showButtons = !isBusy;
                              });
                            },
                            onPressed: widget.onAccept,
                            onPressedAsync: () async {
                              await Future.delayed(
                                Duration(seconds: 3),
                              );
                            },
                            defaultButtonColor: UiConstants.primaryColor,
                            defaultButtonText: widget.accept ?? "Accept",
                            textStyle: TextStyles.body3.bold
                                .colour(UiConstants.primaryColor),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: FelloButton(
                            action: isBusy,
                            onPressedAsync: () async {
                              Future.delayed(Duration(seconds: 3));
                            },
                            onPressed: widget.onReject,
                            defaultButtonColor: Colors.black,
                            defaultButtonText: widget.reject ?? "Reject",
                            textStyle:
                                TextStyles.body3.bold.colour(Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      showCrossIcon: false,
    );
  }
}
