import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class ScoreRejectedDialog extends StatelessWidget {
  final String? contentText;
  ScoreRejectedDialog({required this.contentText});
  S locale = locator<S>();
  @override
  Widget build(BuildContext context) {
    return MoreInfoDialog(
      title: locale.gameOver,
      text: contentText ?? locale.gameOver,
    );
  }
}
