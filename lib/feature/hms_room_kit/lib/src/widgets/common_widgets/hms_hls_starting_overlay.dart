///Package imports

///Project imports
import 'package:felloapp/feature/hms_room_kit/lib/src/layout_api/hms_theme_colors.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:flutter/material.dart';

///[HMSHLSStartingOverlay] renders the overlay UI while HLS is starting
class HMSHLSStartingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            HMSThemeColors.backgroundDim.withOpacity(1),
            HMSThemeColors.backgroundDim.withOpacity(0)
          ])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
            color: HMSThemeColors.primaryDefault,
          ),
          const SizedBox(
            height: 29,
          ),
          HMSSubtitleText(
            text: "Starting live stream...",
            textColor: HMSThemeColors.onSurfaceHighEmphasis,
            fontSize: 16,
            lineHeight: 24,
            letterSpacing: 0.50,
          )
        ],
      ),
    );
  }
}
