import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class PauseAutosaveModal extends StatefulWidget {
  final SubService? model;
  final String id;

  const PauseAutosaveModal({Key? key, this.model, required this.id})
      : super(key: key);

  @override
  State<PauseAutosaveModal> createState() => _PauseAutosaveModalState();
}

class _PauseAutosaveModalState extends State<PauseAutosaveModal> {
  AutosavePauseOption? pauseValue;
  int pauseInt = 0;
  setPauseValue(AutosavePauseOption value, int val) {
    setState(() {
      pauseValue = value;
      pauseInt = val;
    });
  }

  bool isPausing = false;

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Wrap(
        //shrinkWrap: true,
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(locale.pauseAutoSave, style: TextStyles.rajdhaniB.title3),
              const Spacer(),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: IconButton(
                  onPressed: () {
                    AppState.backButtonDispatcher!.didPopRoute();
                  },
                  icon: Icon(
                    Icons.close,
                    size: SizeConfig.iconSize1,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.padding16),
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
          Container(height: SizeConfig.padding16),
          ReactivePositiveAppButton(
            btnText: locale.btnPause.toUpperCase(),
            // child:
            // isPausing
            //     ? SpinKitThreeBounce(
            //         color: Colors.white,
            //         size: SizeConfig.padding16,
            //       )
            //     : Text(
            //         locale.btnPause.toUpperCase(),
            //         style: TextStyles.rajdhaniB.body1.bold.colour(Colors.white),
            //       ),
            onPressed: () async {
              if (pauseValue == null) {
                return BaseUtil.showNegativeAlert("No duration selected",
                    "Please select a duration to pause");
              }
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
                    await widget.model!
                        .pauseSubscription(pauseValue!, widget.id);
                    await AppState.backButtonDispatcher!.didPopRoute();
                  },
                ),
              );
            },
          ),
          SizedBox(height: SizeConfig.pageHorizontalMargins / 2),
        ],
      ),
    );
  }

  pauseOptionTile(
      {required String text,
      required int radioValue,
      required AutosavePauseOption option}) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setPauseValue(option, radioValue);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
        decoration: BoxDecoration(
            border: Border.all(
              width: pauseValue == radioValue ? 0.5 : 0,
              color: pauseValue == radioValue
                  ? UiConstants.primaryColor
                  : UiConstants.kTextColor2,
            ),
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            color: pauseValue == radioValue
                ? UiConstants.kTealTextColor.withOpacity(0.1)
                : Colors.transparent),
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding4,
        ),
        child: ListTile(
          title: Text(
            text,
            style: TextStyles.sourceSans.body2,
          ),
          trailing: Radio(
            value: radioValue,
            groupValue: pauseInt,
            onChanged: (dynamic value) {
              setPauseValue(option, radioValue);
            },
            activeColor: UiConstants.primaryColor,
          ),
        ),
      ),
    );
  }
}
