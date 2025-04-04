///Package imports

import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/hls_viewer/hls_player_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/hls_viewer/hls_viewer_page.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/hmssdk_interactor.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/layout_api/hms_room_layout.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_page.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_loader.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///[MeetingScreenController] is the controller for the meeting screen
///It is used to join the room
class MeetingScreenController extends StatefulWidget {
  ///[user] is the name of the user joining the room
  final String user;

  ///[localPeerNetworkQuality] is the network quality of the local peer
  final int? localPeerNetworkQuality;

  ///[isRoomMute] is the mute status of the room when the user joins
  ///If it's false then user can listen to the audio of the room
  ///If it's true then user can't listen to the audio of the room
  final bool isRoomMute;

  ///[showStats] is the flag to show the stats of the room
  final bool showStats;

  ///[mirrorCamera] is the flag to mirror the camera
  ///Generally set to true for local peer
  ///and false to other peers
  final bool mirrorCamera;

  ///[role] is the role of the user joining the room
  final HMSRole? role;

  ///[config] is the config of the room
  ///For more details checkout the [HMSConfig] class
  final HMSConfig? config;

  ///[options] are the prebuilt options
  final HMSPrebuiltOptions? options;

  ///[tokenData] is the auth token for the room
  final String? tokenData;

  ///[currentAudioDeviceMode] is the current audio device mode
  final HMSAudioDevice currentAudioDeviceMode;

  ///[hmsSDKInteractor] is used to interact with the SDK
  final HMSSDKInteractor hmsSDKInteractor;

  final bool isNoiseCancellationEnabled;
  final String advisorId;
  final String advisorImage;
  final String title;
  final String description;
  final bool isLiked;
  final String eventId;
  final String advisorName;
  final int initialViewCount;
  // final String id;

  const MeetingScreenController({
    required this.user,
    required this.localPeerNetworkQuality,
    required this.hmsSDKInteractor,
    required this.advisorId,
    required this.title,
    required this.description,
    required this.isLiked,
    required this.eventId,
    required this.advisorName,
    required this.advisorImage,
    required this.initialViewCount,
    Key? key,
    this.isRoomMute = false,
    this.showStats = false,
    this.mirrorCamera = true,
    this.role,
    this.config,
    this.currentAudioDeviceMode = HMSAudioDevice.AUTOMATIC,
    this.options,
    this.tokenData,
    this.isNoiseCancellationEnabled = false,
  }) : super(key: key);

  @override
  State<MeetingScreenController> createState() =>
      _MeetingScreenControllerState();
}

class _MeetingScreenControllerState extends State<MeetingScreenController> {
  HLSPlayerStore? _hlsPlayerStore;
  bool showLoader = false;
  late MeetingStore _meetingStore;

  void _recreateMeetingStore() {
    // Unregister the existing MeetingStore instance
    if (locator.isRegistered<MeetingStore>()) {
      locator.unregister<MeetingStore>();
    }
    // Register a new MeetingStore instance
    locator.registerLazySingleton<MeetingStore>(
      () => MeetingStore(hmsSDKInteractor: locator<HMSSDKInteractor>()),
    );
    // Access the new instance
    _meetingStore = locator<MeetingStore>();
  }

  @override
  void initState() {
    super.initState();

    ///Here we create an instance of meeting store, set initial settings and join meeting.
    _recreateMeetingStore();
    _setInitValues();
    _joinMeeting();
    _setHLSPlayerStore();
  }

  ///This function joins the room only if the name is not empty
  Future<void> _joinMeeting() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (mounted) {
      setState(() {
        showLoader = true;
      });
    }

    ///We join the room here
    await _meetingStore.join(
      widget.user,
      widget.tokenData,
      widget.config?.metaData,
    );
    setState(() {
      showLoader = false;
    });
  }

  ///This function sets the HLSPlayerStore if the role is hls-viewer
  void _setHLSPlayerStore() {
    _hlsPlayerStore ??= HLSPlayerStore();
  }

  ///This function sets the initial values of the meeting
  Future<void> _setInitValues() async {
    _meetingStore.setSettings();
    _meetingStore.setDefaults(
      widget.advisorId,
      widget.title,
      widget.description,
      widget.isLiked,
      widget.eventId,
      widget.advisorName,
      widget.advisorImage,
      widget.initialViewCount,
    );
  }

  void setScreenRotation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (HMSRoomLayout
              .roleLayoutData?.screens?.conferencing?.hlsLiveStreaming !=
          null) {
        _meetingStore.allowScreenRotation(true);
      } else {
        _meetingStore.allowScreenRotation(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoader
        ? const HMSLoader()
        : ListenableProvider.value(
            value: _meetingStore,
            child: Selector<MeetingStore, String?>(
              selector: (_, meetingStore) => meetingStore.localPeer?.role.name,
              builder: (_, data, __) {
                setScreenRotation();
                return (HMSRoomLayout.roleLayoutData?.screens?.conferencing
                            ?.hlsLiveStreaming !=
                        null)
                    ? ListenableProvider.value(
                        value: _hlsPlayerStore,
                        child: const HLSViewerPage(),
                      )
                    : MeetingPage(
                        isRoomMute: widget.isRoomMute,
                        currentAudioDeviceMode: widget.currentAudioDeviceMode,
                        isNoiseCancellationEnabled:
                            widget.isNoiseCancellationEnabled,
                      );
              },
            ),
          );
  }
}
