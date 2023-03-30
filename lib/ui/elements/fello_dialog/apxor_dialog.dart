import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:flutter/material.dart';

class ApxorDialog extends StatelessWidget {
  Map<String, dynamic> dialogContent;
  ApxorDialog({super.key, required this.dialogContent});

  @override
  Widget build(BuildContext context) {
    return FelloInfoDialog(
      nPng: dialogContent["asset"],
      title: dialogContent["title"],
      subtitle: dialogContent["subtitle"],
      action: AppPositiveBtn(
          btnText: dialogContent["ctaText"],
          onPressed: () {
            AppState.backButtonDispatcher!.didPopRoute();
            AppState.delegate!
                .parseRoute(Uri.parse(dialogContent["ctaAction"]));
          }),
    );
  }
}
