import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_dialog.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class ScoreRejectedDialog extends StatelessWidget {
  final String contentText;
  ScoreRejectedDialog({this.contentText});
  @override
  Widget build(BuildContext context) {
    return FelloInfoDialog(
      showCrossIcon: false,
      title: "Game Over",
      subtitle: contentText ?? "Game Over",
      action: Container(
        width: SizeConfig.screenWidth,
        child: FelloButtonLg(
            child: Text(
              "OK",
              style: TextStyles.body2.bold.colour(Colors.white),
            ),
            onPressed: () {
              AppState.backButtonDispatcher.didPopRoute();
              // _gtService.showGoldenTicketAvailableDialog();
            }),
      ),
    );
  }
}
