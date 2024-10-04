// Package imports
import 'package:felloapp/feature/hms_room_kit/lib/src/common/app_color.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_text_style.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_title_text.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

// Project imports

class RoleChangeRequestDialog extends StatefulWidget {
  final HMSRoleChangeRequest roleChangeRequest;
  final MeetingStore meetingStore;
  const RoleChangeRequestDialog(
      {super.key, required this.roleChangeRequest, required this.meetingStore});

  @override
  RoleChangeRequestDialogState createState() => RoleChangeRequestDialogState();
}

class RoleChangeRequestDialogState extends State<RoleChangeRequestDialog> {
  @override
  Widget build(BuildContext context) {
    String message =
        "‘${widget.roleChangeRequest.suggestedBy?.name ?? "Anonymus"}’ requested to change your role to ‘${widget.roleChangeRequest.suggestedRole.name}’";
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      actionsPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      backgroundColor: themeBottomSheetColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: HMSTextStyle.setTextStyle(
              color: iconColor,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(themeSurfaceColor),
                  backgroundColor:
                      MaterialStateProperty.all(themeBottomSheetColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: popupButtonBorderColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
                child:
                    HMSTitleText(text: 'Reject', textColor: themeDefaultColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(themeSurfaceColor),
                  backgroundColor: MaterialStateProperty.all(errorColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: errorColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
                child: HMSTitleText(
                  text: 'Accept',
                  textColor: themeDefaultColor,
                ),
              ),
              onPressed: () {
                widget.meetingStore.acceptChangeRole(widget.roleChangeRequest);
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }
}
