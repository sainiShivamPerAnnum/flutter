import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_dialog.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class ScoreRejectedDialog extends StatelessWidget {
  final String contentText;
  ScoreRejectedDialog({@required this.contentText});
  @override
  Widget build(BuildContext context) {
    return MoreInfoDialog(
      title: "Game Over",
      text: contentText ?? "Game Over",
    );
  }
}
