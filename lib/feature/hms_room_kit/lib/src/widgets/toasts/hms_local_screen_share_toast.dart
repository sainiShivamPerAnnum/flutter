///Package imports

///Project imports
import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/toasts/hms_toast.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/toasts/hms_toast_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///[HMSLocalScreenShareToast] is a toast that is shown when the user is sharing the screen
///It takes the following parameters:
///[meetingStore] is the meetingStore of the meeting
///[toastColor] is the color of the toast
///[toastPosition] is the position of the toast from the bottom
class HMSLocalScreenShareToast extends StatelessWidget {
  final MeetingStore meetingStore;
  final Color? toastColor;
  final double? toastPosition;

  const HMSLocalScreenShareToast(
      {super.key,
      required this.meetingStore,
      this.toastColor,
      this.toastPosition});

  @override
  Widget build(BuildContext context) {
    return HMSToast(
      toastColor: toastColor,
      toastPosition: toastPosition,
      leading: SvgPicture.asset(
        "assets/hms/icons/screen_share.svg",
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
            HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
      ),
      subtitle: HMSSubheadingText(
        text: "You are sharing your screen",
        textColor: HMSThemeColors.onSurfaceHighEmphasis,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      action: HMSToastButton(
        buttonTitle: "Stop",
        action: () {
          meetingStore.stopScreenShare();
        },
        buttonColor: HMSThemeColors.alertErrorDefault,
        textColor: HMSThemeColors.alertErrorBrighter,
      ),
    );
  }
}
