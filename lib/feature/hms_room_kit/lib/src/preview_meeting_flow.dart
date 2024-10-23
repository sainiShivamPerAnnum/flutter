///Package imports

import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/hmssdk_interactor.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/layout_api/hms_room_layout.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting_screen_controller.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/preview/preview_store.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

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
  final UserService _userService = locator<UserService>();

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
      config: HMSConfig(
          metaData: _userService.baseUser!.avatarId,
          authToken: widget.tokenData,),
      localPeerNetworkQuality: null,
      options: widget.prebuiltOptions,
      tokenData: widget.tokenData,
      hmsSDKInteractor: widget.hmsSDKInteractor,
    );
  }
}
