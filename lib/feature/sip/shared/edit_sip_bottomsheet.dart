import 'package:felloapp/core/model/subscription_models/subscription_status.dart';
import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class EditSipBottomSheet extends StatefulWidget {
  const EditSipBottomSheet({
    required this.state,
    required this.index,
    required this.model,
    required this.allowEdit,
    super.key,
    required this.frequency,
    required this.amount,
  });
  final AutosaveState state;
  final int index;
  final AutosaveCubit model;
  final bool allowEdit;
  final num amount;
  final String frequency;
  @override
  State<EditSipBottomSheet> createState() => _EditSipBottomSheetState();
}

class _EditSipBottomSheetState extends State<EditSipBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.padding24,
        right: SizeConfig.padding24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
          Text(
            "Edit SIP Options",
            style: TextStyles.sourceSansSB.body1.colour(UiConstants.kTextColor),
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Divider(
            thickness: 1,
            color: UiConstants.kProfileBorderColor.withOpacity(0.2),
          ),
          if (widget.allowEdit)
            InkWell(
              onTap: () async {
                return widget.model
                    .editSip(widget.amount, widget.frequency, widget.index);
              },
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
                  Row(
                    children: [
                      const AppImage(Assets.editIcon),
                      SizedBox(
                        width: SizeConfig.padding12,
                      ),
                      Text(
                        "Edit SIP",
                        style:
                            TextStyles.sourceSansSB.body2.colour(Colors.white),
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
                ],
              ),
            ),
          if (widget.allowEdit)
            Divider(
              thickness: 1,
              color: UiConstants.kProfileBorderColor.withOpacity(0.2),
            ),
          InkWell(
            onTap: () async {
              return widget.model.pauseResume(widget.index).then((value) {
                Future.delayed(Duration.zero,
                    () => AppState.backButtonDispatcher!.didPopRoute());
              });
            },
            child: Column(children: [
              SizedBox(
                height: SizeConfig.padding16,
              ),
              Row(
                children: [
                  const AppImage(Assets.pauseIcon),
                  SizedBox(
                    width: SizeConfig.padding12,
                  ),
                  Text(
                    widget.state.isPaused ? "Resume SIP" : "Pause SIP",
                    style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
            ]),
          ),
          Divider(
            thickness: 1,
            color: UiConstants.kProfileBorderColor.withOpacity(0.2),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.padding6,
                top: SizeConfig.padding22,
                bottom: SizeConfig.padding28),
            child: Row(
              children: [
                Container(
                  height: SizeConfig.padding4,
                  width: SizeConfig.padding4,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: UiConstants.teal3),
                ),
                SizedBox(
                  width: SizeConfig.padding6,
                ),
                Text("You can earn upto ₹50000 in 5 years from this SIP",
                    style: TextStyles.sourceSansSB.body3.colour(
                        UiConstants.kModalSheetMutedTextBackgroundColor))
              ],
            ),
          )
        ],
      ),
    );
  }
}
