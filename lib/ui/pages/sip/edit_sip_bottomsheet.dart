import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class EditSipBottomSheet extends StatefulWidget {
  const EditSipBottomSheet({super.key});

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
          top: SizeConfig.padding42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Edit SIP Options",
            style: TextStyles.sourceSansSB.body1.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          const Divider(
            thickness: 1,
            color: UiConstants.kProfileBorderColor,
          ),
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
                style: TextStyles.sourceSansSB.body2.colour(Colors.white),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          const Divider(
            thickness: 1,
            color: UiConstants.kProfileBorderColor,
          ),
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
                "Pause SIP",
                style: TextStyles.sourceSansSB.body2.colour(Colors.white),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          const Divider(
            thickness: 1,
            color: UiConstants.kProfileBorderColor,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.padding6, top: SizeConfig.padding22),
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
