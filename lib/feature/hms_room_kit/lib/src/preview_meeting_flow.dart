///Package imports

import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/hmssdk_interactor.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/layout_api/hms_room_layout.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting_screen_controller.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/preview/preview_store.dart';
import 'package:flutter/material.dart';

///[PreviewMeetingFlow] decides whether to render preview or meeting
class PreviewMeetingFlow extends StatefulWidget {
  final HMSPrebuiltOptions? prebuiltOptions;
  final HMSSDKInteractor hmsSDKInteractor;
  final String tokenData;
  const PreviewMeetingFlow({
    required this.prebuiltOptions,
    required this.hmsSDKInteractor,
    required this.tokenData,
    super.key,
  });

  @override
  State<PreviewMeetingFlow> createState() => _PreviewMeetingFlowState();
}

class _PreviewMeetingFlowState extends State<PreviewMeetingFlow> {
  late PreviewStore store;

  @override
  void initState() {
    super.initState();
    if (!HMSRoomLayout.skipPreview) {
      store = PreviewStore(hmsSDKInteractor: widget.hmsSDKInteractor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MeetingScreenController(
      user: widget.prebuiltOptions?.userName ??
          widget.prebuiltOptions?.userId ??
          "",
      localPeerNetworkQuality: null,
      options: widget.prebuiltOptions,
      tokenData: widget.tokenData,
      hmsSDKInteractor: widget.hmsSDKInteractor,
    );
  }
}
