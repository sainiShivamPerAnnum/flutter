///Package imports

///Project imports
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_navigation_visibility_controller.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/toasts/hms_toast_model.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/toasts/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///[MeetingToasts] widget returns toast to be displayed on meeting UI
///A separate widget is used to avoid rebuild of whole meeting ui when controls are hidden
class MeetingToasts extends StatelessWidget {
  final HMSToastModel toast;
  final int index;
  final int toastsCount;
  final MeetingStore meetingStore;

  const MeetingToasts({
    super.key,
    required this.toast,
    required this.index,
    required this.toastsCount,
    required this.meetingStore,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<MeetingNavigationVisibilityController, bool>(
      selector: (_, meetingNavigationVisibilityController) =>
          meetingNavigationVisibilityController.showControls,
      builder: (_, showControls, __) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          bottom: (showControls ? 28.0 : 10.0) + 8 * index,
          left: 5,
          child: ToastWidget(
              toast: toast,
              index: index,
              toastsCount: toastsCount,
              meetingStore: meetingStore),
        );
      },
    );
  }
}
