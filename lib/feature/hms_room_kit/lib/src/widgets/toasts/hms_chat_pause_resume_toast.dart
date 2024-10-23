//Dart imports
import 'dart:math' as math;

//Project imports
import 'package:felloapp/feature/hms_room_kit/lib/src/layout_api/hms_theme_colors.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/toasts/hms_toast.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/toasts/hms_toasts_type.dart';
//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HMSChatPauseResumeToast extends StatelessWidget {
  final bool isChatEnabled;
  final String userName;
  final MeetingStore meetingStore;

  const HMSChatPauseResumeToast(
      {Key? key,
      required this.isChatEnabled,
      required this.userName,
      required this.meetingStore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HMSToast(
      leading: SvgPicture.asset(
        "assets/hms/icons/${isChatEnabled ? "message_badge_on" : "message_badge_off"}.svg",
        height: 24,
        width: 24,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HMSSubheadingText(
            text: "Chat ${isChatEnabled ? "resumed" : "paused"}",
            textColor: HMSThemeColors.onSurfaceHighEmphasis,
            lineHeight: 20,
            letterSpacing: 0.1,
            fontWeight: FontWeight.w400,
          ),
          HMSSubtitleText(
            text:
                "Chat has been ${isChatEnabled ? "resumed" : "paused"} by ${userName.substring(0, math.min(10, userName.length))}",
            textColor: HMSThemeColors.onSurfaceMediumEmphasis,
          )
        ],
      ),
      cancelToastButton: IconButton(
        icon: Icon(
          Icons.close,
          color: HMSThemeColors.onSurfaceHighEmphasis,
          size: 24,
        ),
        onPressed: () {
          meetingStore.removeToast(HMSToastsType.chatPauseResumeToast);
        },
      ),
    );
  }
}
