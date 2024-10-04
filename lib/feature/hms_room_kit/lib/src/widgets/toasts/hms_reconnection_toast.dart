///Package imports

///Project imports
import 'package:felloapp/feature/hms_room_kit/lib/src/layout_api/hms_theme_colors.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/toasts/hms_toast.dart';
import 'package:flutter/material.dart';

///[HMSReconnectionToast] renders the toast when a user loses network connection
///The screen is non-tappable during this toast
class HMSReconnectionToast extends StatelessWidget {
  const HMSReconnectionToast({super.key});

  @override
  Widget build(BuildContext context) {
    return HMSToast(
      leading: SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(
          strokeWidth: 1,
          color: HMSThemeColors.onSurfaceHighEmphasis,
        ),
      ),
      subtitle: HMSSubheadingText(
        text: "You lost your network connection.\nTrying to reconnect. ",
        textColor: HMSThemeColors.onSurfaceHighEmphasis,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        maxLines: 2,
      ),
    );
  }
}
