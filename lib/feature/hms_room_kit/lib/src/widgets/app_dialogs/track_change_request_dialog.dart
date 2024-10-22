// Package imports
import 'package:felloapp/feature/hms_room_kit/lib/src/common/app_color.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/enums/meeting_mode.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
// Project imports
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_text_style.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_title_text.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class TrackChangeRequestDialog extends StatefulWidget {
  final HMSTrackChangeRequest trackChangeRequest;
  final MeetingStore meetingStore;
  final bool isAudioModeOn;
  const TrackChangeRequestDialog(
      {super.key,
      required this.trackChangeRequest,
      required this.meetingStore,
      this.isAudioModeOn = false});

  @override
  TrackChangeRequestDialogState createState() =>
      TrackChangeRequestDialogState();
}

class TrackChangeRequestDialogState extends State<TrackChangeRequestDialog> {
  @override
  Widget build(BuildContext context) {
    String message =
        "‘${widget.trackChangeRequest.requestBy.name}’ requested to ${(widget.trackChangeRequest.mute) ? "mute" : "unmute"} your ‘${(widget.trackChangeRequest.track.kind == HMSTrackKind.kHMSTrackKindAudio) ? "Audio’" : "Video’"}${(widget.isAudioModeOn) ? " and switch to video view" : ""}";
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
                if (widget.trackChangeRequest.track.kind ==
                        HMSTrackKind.kHMSTrackKindVideo &&
                    widget.isAudioModeOn) {
                  widget.meetingStore
                      .setMode(MeetingMode.activeSpeakerWithInset);
                }
                widget.meetingStore.changeTracks(widget.trackChangeRequest);
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }
}
