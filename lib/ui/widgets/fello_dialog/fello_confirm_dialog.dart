import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_dialog.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class FelloConfirmationDialog extends StatefulWidget {
  final Widget content;
  final Function onAccept;
  final Function onReject;
  final ValueChanged result;
  final bool showCrossIcon;

  FelloConfirmationDialog({
    this.result,
    this.content,
    this.onAccept,
    this.onReject,
    this.showCrossIcon,
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
          widget.content,
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
                          child: DemoButton(
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
                            defaultButtonText: "Accept",
                            textStyle: TextStyle(
                                color: UiConstants.primaryColor,
                                fontSize: SizeConfig.mediumTextSize,
                                fontWeight: FontWeight.w700),
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
                          child: DemoButton(
                            action: isBusy,
                            onPressedAsync: () async {
                              Future.delayed(Duration(seconds: 3));
                            },
                            onPressed: widget.onReject,
                            defaultButtonColor: Colors.black,
                            defaultButtonText: "Reject",
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: SizeConfig.mediumTextSize,
                                fontWeight: FontWeight.w500),
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
