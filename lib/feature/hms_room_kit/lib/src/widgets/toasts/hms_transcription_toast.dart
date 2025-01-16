///Project imports
import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/toasts/hms_toast.dart';

///Package imports
import 'package:flutter/material.dart';

///[HMSTranscriptionToast] is a widget that displays the transcription toast
class HMSTranscriptionToast extends StatelessWidget {
  final String message;
  final MeetingStore meetingStore;
  const HMSTranscriptionToast(
      {Key? key, required this.message, required this.meetingStore});

  @override
  Widget build(BuildContext context) {
    return HMSToast(
        leading: SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: HMSThemeColors.onSurfaceHighEmphasis,
          ),
        ),
        subtitle: HMSSubheadingText(
          text: message,
          textColor: HMSThemeColors.onSurfaceHighEmphasis,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          textOverflow: TextOverflow.ellipsis,
          maxLines: 2,
        ));
  }
}
