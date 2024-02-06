import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class PauseAutosaveModal extends StatefulWidget {
  final SubService? model;
  final String id;

  const PauseAutosaveModal({
    required this.id,
    super.key,
    this.model,
  });

  @override
  State<PauseAutosaveModal> createState() => _PauseAutosaveModalState();
}

class _PauseAutosaveModalState extends State<PauseAutosaveModal> {
  AutosavePauseOption? pauseValue;
  int pauseInt = 0;

  bool isPausing = false;

  @override
  Widget build(BuildContext context) {
    S locale = locator<S>();
    return Container(
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Wrap(
        children: [
          SizedBox(
            height: SizeConfig.padding14,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: UiConstants.kProfileBorderColor.withOpacity(0.4)),
              height: 5,
              width: 94,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding22,
          ),
          Text(locale.pauseAutoSave, style: TextStyles.sourceSansSB.body1),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          pauseOptionTile(
            text: "1 Week",
            radioValue: 1,
            option: AutosavePauseOption.ONE_WEEK,
          ),
          pauseOptionTile(
            text: "2 Weeks",
            radioValue: 2,
            option: AutosavePauseOption.TWO_WEEK,
          ),
          pauseOptionTile(
            text: "1 Month",
            radioValue: 3,
            option: AutosavePauseOption.ONE_MONTH,
          ),
          pauseOptionTile(
            text: "Forever",
            radioValue: 4,
            option: AutosavePauseOption.FOREVER,
          ),
          SizedBox(height: SizeConfig.pageHorizontalMargins / 2),
        ],
      ),
    );
  }

  Widget pauseOptionTile(
      {required String text,
      required int radioValue,
      required AutosavePauseOption option}) {
    final locale = locator<S>();
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        await BaseUtil.openDialog(
          addToScreenStack: true,
          isBarrierDismissible: false,
          hapticVibrate: true,
          content: ConfirmationDialog(
            title: locale.areYouSure,
            description: locale.loseAutoSave,
            cancelBtnText: locale.btnNo,
            cancelAction: () {
              AppState.backButtonDispatcher!.didPopRoute();
            },
            buttonText: locale.btnYes,
            confirmAction: () async {
              bool res =
                  await widget.model!.pauseSubscription(option, widget.id);
              if (res) {
                BaseUtil.showPositiveAlert(
                    locale.pauseSuccess, locale.pauseSuccessSub);
                await AppState.backButtonDispatcher!.didPopRoute().then((_) {});
              } else {
                BaseUtil.showNegativeAlert(locale.pauseFail, locale.tryAgain);
              }
            },
          ),
        ).then((value) {
          // Navigator.of(context).pop();
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            thickness: 1,
            color: UiConstants.kProfileBorderColor.withOpacity(0.2),
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),
          Text(
            text,
            style: TextStyles.sourceSans.body2,
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),
        ],
      ),
    );
  }
}
