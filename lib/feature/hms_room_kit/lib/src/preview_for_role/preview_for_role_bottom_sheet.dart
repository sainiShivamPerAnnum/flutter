///Package imports

import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_embedded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///[PreviewForRoleBottomSheet] is the bottom sheet that is shown when the user is invited to join the stage
///This bottom sheet shows the audio, video and camera buttons and the join now and decline buttons
///The user can join the stage by clicking on the join now button
///The user can decline the invitation by clicking on the decline button
///
///This takes the following parameters:
///[meetingStore] - The meeting store that is used to access the meeting related data
///[roleChangeRequest] - The role change request that is used to accept the role change request
class PreviewForRoleBottomSheet extends StatefulWidget {
  final MeetingStore meetingStore;
  final HMSRoleChangeRequest? roleChangeRequest;
  const PreviewForRoleBottomSheet({
    required this.meetingStore,
    required this.roleChangeRequest,
    super.key,
  });

  @override
  State<PreviewForRoleBottomSheet> createState() =>
      _PreviewForRoleBottomSheetState();
}

class _PreviewForRoleBottomSheetState extends State<PreviewForRoleBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: HMSThemeColors.surfaceDim,
        ),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Column(
            children: [
              ///We show the title and the description of the bottom sheet
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HMSTitleText(
                    text: "You’re invited to join the stage",
                    textColor: HMSThemeColors.onSurfaceHighEmphasis,
                    fontSize: 20,
                    letterSpacing: 0.15,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HMSTitleText(
                    text: "Setup your audio and video before joining",
                    textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                    fontSize: 14,
                    lineHeight: 20,
                    letterSpacing: 0.25,
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ///We show the audio, video and camera buttons
                      ///The audio button is shown only if the local peer is not null and the preview for role audio track is not null
                      if (widget.meetingStore.localPeer != null &&
                          widget.meetingStore.previewForRoleAudioTrack != null)
                        Selector<MeetingStore, bool>(
                          selector: (_, meetingStore) => meetingStore.isMicOn,
                          builder: (_, isMicOn, __) {
                            return HMSEmbeddedButton(
                              onTap: () async =>
                                  widget.meetingStore.toggleMicMuteState(),
                              isActive: isMicOn,
                              onColor: HMSThemeColors.surfaceDim,
                              child: SvgPicture.asset(
                                isMicOn
                                    ? "assets/hms/icons/mic_state_on.svg"
                                    : "assets/hms/icons/mic_state_off.svg",
                                colorFilter: ColorFilter.mode(
                                  HMSThemeColors.onSurfaceHighEmphasis,
                                  BlendMode.srcIn,
                                ),
                                fit: BoxFit.scaleDown,
                                semanticsLabel: "audio_mute_button",
                              ),
                            );
                          },
                        ),
                      const SizedBox(
                        width: 16,
                      ),

                      ///The video button is shown only if the local peer is not null and the preview for role video track is not null
                      if (widget.meetingStore.localPeer != null &&
                          widget.meetingStore.previewForRoleVideoTrack != null)
                        Selector<MeetingStore, bool>(
                          selector: (_, meetingStore) => meetingStore.isVideoOn,
                          builder: (_, isVideoOn, __) {
                            return HMSEmbeddedButton(
                              onTap: () async =>
                                  widget.meetingStore.toggleCameraMuteState(),
                              isActive: isVideoOn,
                              onColor: HMSThemeColors.surfaceDim,
                              child: SvgPicture.asset(
                                isVideoOn
                                    ? "assets/hms/icons/cam_state_on.svg"
                                    : "assets/hms/icons/cam_state_off.svg",
                                colorFilter: ColorFilter.mode(
                                  HMSThemeColors.onSurfaceHighEmphasis,
                                  BlendMode.srcIn,
                                ),
                                fit: BoxFit.scaleDown,
                                semanticsLabel: "video_mute_button",
                              ),
                            );
                          },
                        ),
                      const SizedBox(
                        width: 16,
                      ),

                      ///The switch camera button is shown only if the local peer is not null and the preview for role video track is not null
                      if (widget.meetingStore.localPeer != null &&
                          widget.meetingStore.previewForRoleVideoTrack != null)
                        Selector<MeetingStore, bool>(
                          selector: (_, meetingStore) => meetingStore.isVideoOn,
                          builder: (_, isVideoOn, __) {
                            return HMSEmbeddedButton(
                              onTap: () async =>
                                  widget.meetingStore.switchCamera(),
                              isActive: true,
                              onColor: HMSThemeColors.surfaceDim,
                              child: SvgPicture.asset(
                                "assets/hms/icons/camera.svg",
                                colorFilter: ColorFilter.mode(
                                  isVideoOn
                                      ? HMSThemeColors.onSurfaceHighEmphasis
                                      : HMSThemeColors.onSurfaceLowEmphasis,
                                  BlendMode.srcIn,
                                ),
                                fit: BoxFit.scaleDown,
                                semanticsLabel: "switch_camera_button",
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),

              ///We show the join now and decline buttons
              ElevatedButton(
                style: ButtonStyle(
                  shadowColor: WidgetStateProperty.all(
                    HMSThemeColors.surfaceDim,
                  ),
                  backgroundColor: WidgetStateProperty.all(
                    HMSThemeColors.primaryDefault,
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  if (widget.roleChangeRequest != null) {
                    context
                        .read<MeetingStore>()
                        .acceptChangeRole(widget.roleChangeRequest!);
                  }
                },
                child: SizedBox(
                  height: 48,
                  child: Center(
                    child: HMSTitleText(
                      text: "Join Now",
                      textColor: HMSThemeColors.onPrimaryHighEmphasis,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shadowColor: WidgetStateProperty.all(
                    HMSThemeColors.surfaceDim,
                  ),
                  backgroundColor: WidgetStateProperty.all(
                    HMSThemeColors.surfaceDim,
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      side: BorderSide(
                        color: HMSThemeColors.secondaryDefault,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  context.read<MeetingStore>().cancelPreview();
                },
                child: SizedBox(
                  height: 48,
                  child: Center(
                    child: HMSTitleText(
                      text: "Decline",
                      textColor: HMSThemeColors.onSurfaceHighEmphasis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
