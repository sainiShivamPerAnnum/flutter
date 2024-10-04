///Package imports

///Project imports
import 'package:felloapp/feature/hms_room_kit/lib/src/layout_api/hms_theme_colors.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/toasts/hms_toast.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/toasts/hms_toasts_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///[HMSRecordingErrorToast] renders the toast when recording fails to start
class HMSStreamingErrorToast extends StatelessWidget {
  final HMSException streamingError;
  final MeetingStore meetingStore;
  final Color? toastColor;
  final double? toastPosition;
  const HMSStreamingErrorToast(
      {super.key,
      required this.streamingError,
      required this.meetingStore,
      this.toastColor,
      this.toastPosition});

  @override
  Widget build(BuildContext context) {
    return HMSToast(
      toastColor: toastColor,
      toastPosition: toastPosition,
      leading: SvgPicture.asset(
        "packages/hms_room_kit/lib/src/assets/icons/recording_error.svg",
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
            HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
      ),
      subtitle: HMSSubheadingText(
        text: "Streaming failed to start",
        textColor: HMSThemeColors.onSurfaceHighEmphasis,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      cancelToastButton: IconButton(
        icon: Icon(
          Icons.close,
          color: HMSThemeColors.onSurfaceHighEmphasis,
          size: 24,
        ),
        onPressed: () {
          meetingStore.removeToast(HMSToastsType.streamingErrorToast);
        },
      ),
    );
  }
}
