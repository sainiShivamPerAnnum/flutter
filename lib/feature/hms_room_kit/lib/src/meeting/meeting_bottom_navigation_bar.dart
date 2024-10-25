import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/common/utility_components.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/enums/meeting_mode.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/layout_api/hms_room_layout.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/one_on_one_chat.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/bottom_sheets/app_utilities_bottom_sheet.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/bottom_sheets/chat_only_bottom_sheet.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/chat_widgets/overlay_chat_component.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/meeting_modes/one_to_one_mode.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/tab_widgets/chat_participants_tab_bar.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/styles/styles.dart';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///This renders the meeting bottom navigation bar
///It contains the leave, mic, camera, chat and menu buttons
///The mic and camera buttons are only rendered if the local peer has the
///permission to publish audio and video respectively
class MeetingBottomNavigationBar extends StatefulWidget {
  const MeetingBottomNavigationBar({super.key});

  @override
  State<MeetingBottomNavigationBar> createState() =>
      _MeetingBottomNavigationBarState();
}

class _MeetingBottomNavigationBarState
    extends State<MeetingBottomNavigationBar> {
  bool showControls = false;
  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, Tuple2<String?, MeetingMode>>(
      selector: (p0, meetingStore) => Tuple2(
        meetingStore.localPeer?.role.name,
        meetingStore.meetingMode,
      ),
      builder: (_, value, __) {
        showControls = value.item1 != 'viewer-realtime';
        return Column(
          children: [
            if (value.item2 != MeetingMode.activeSpeakerWithInset)
              OverlayChatComponent(role: value.item1),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(top: !showControls ? 5 : 0, bottom: 8.0),
              height: showControls ? SizeConfig.padding80 : 0,
              child: showControls
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ///Leave Button
                        GestureDetector(
                          onTap: () async =>
                              {await UtilityComponents.onBackPressed(context)},
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: UiConstants.kSnackBarNegativeContentColor,
                            ),
                            padding: EdgeInsets.all(SizeConfig.padding18),
                            child: const Icon(Icons.call_end),
                          ),
                        ),

                        ///Microphone button
                        ///This button is only rendered if the local peer has the permission to
                        ///publish audio
                        if (Provider.of<MeetingStore>(context)
                                .localPeer
                                ?.role
                                .publishSettings
                                ?.allowed
                                .contains("audio") ??
                            false)
                          Selector<MeetingStore, bool>(
                            selector: (_, meetingStore) => meetingStore.isMicOn,
                            builder: (_, isMicOn, __) {
                              return GestureDetector(
                                onTap: () => {
                                  context
                                      .read<MeetingStore>()
                                      .toggleMicMuteState(),
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: UiConstants.greyVarient,
                                  ),
                                  padding: EdgeInsets.all(SizeConfig.padding18),
                                  child: SvgPicture.asset(
                                    isMicOn
                                        ? "assets/hms/icons/mic_state_on.svg"
                                        : "assets/hms/icons/mic_state_off.svg",
                                    colorFilter: ColorFilter.mode(
                                      HMSThemeColors.onSurfaceHighEmphasis,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                        ///publish video
                        if (Provider.of<MeetingStore>(context)
                                .localPeer
                                ?.role
                                .publishSettings
                                ?.allowed
                                .contains("video") ??
                            false)
                          Selector<MeetingStore, Tuple2<bool, bool>>(
                            selector: (_, meetingStore) => Tuple2(
                              meetingStore.isVideoOn,
                              meetingStore.meetingMode == MeetingMode.audio,
                            ),
                            builder: (_, data, __) {
                              return GestureDetector(
                                onTap: () => {
                                  (data.item2)
                                      ? null
                                      : context
                                          .read<MeetingStore>()
                                          .toggleCameraMuteState(),
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: UiConstants.greyVarient,
                                  ),
                                  padding: EdgeInsets.all(SizeConfig.padding18),
                                  child: SvgPicture.asset(
                                    data.item1
                                        ? "assets/hms/icons/cam_state_on.svg"
                                        : "assets/hms/icons/cam_state_off.svg",
                                    colorFilter: ColorFilter.mode(
                                      HMSThemeColors.onSurfaceHighEmphasis,
                                      BlendMode.srcIn,
                                    ),
                                    semanticsLabel: "video_mute_button",
                                  ),
                                ),
                              );
                            },
                          ),

                        ///Chat Button todo test everwhere
                        // if (HMSRoomLayout.chatData != null &&
                        //     value.item1 == 'broadcaster')
                        Selector<MeetingStore, Tuple2>(
                            selector: (_, meetingStore) => Tuple2(
                                meetingStore.isNewMessageReceived,
                                meetingStore.isOverlayChatOpened),
                            builder: (_, chatState, __) {
                              return GestureDetector(
                                onTap: () => {
                                  if (value.item2 ==
                                      MeetingMode.activeSpeakerWithInset)
                                    {
                                      AppState.delegate!.appState
                                          .currentAction = PageAction(
                                        page: MeetingChatPageConfig,
                                        state: PageState.addWidget,
                                        widget: ChangeNotifierProvider.value(
                                          value: context.read<MeetingStore>(),
                                          child: const OneOnOneChat(),
                                        ),
                                      )
                                    }
                                  else if (HMSRoomLayout.chatData?.isOverlay ??
                                      false)
                                    {
                                      context
                                          .read<MeetingStore>()
                                          .toggleChatOverlay()
                                    }
                                  else
                                    {
                                      context
                                          .read<MeetingStore>()
                                          .setNewMessageFalse(),
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor:
                                            HMSThemeColors.surfaceDim,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                        context: context,
                                        builder: (ctx) =>
                                            ChangeNotifierProvider.value(
                                          value: context.read<MeetingStore>(),
                                          child: HMSRoomLayout
                                                  .isParticipantsListEnabled
                                              ? const ChatParticipantsTabBar(
                                                  tabIndex: 0,
                                                )
                                              : const ChatOnlyBottomSheet(),
                                        ),
                                      )
                                    }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: UiConstants.greyVarient,
                                  ),
                                  padding: EdgeInsets.all(SizeConfig.padding18),
                                  child: chatState.item1 && !chatState.item2
                                      ? Badge(
                                          backgroundColor:
                                              HMSThemeColors.primaryDefault,
                                          child: SvgPicture.asset(
                                            "assets/hms/icons/message_badge_on.svg",
                                            semanticsLabel: "chat_button",
                                            colorFilter: ColorFilter.mode(
                                                HMSThemeColors
                                                    .onSurfaceHighEmphasis,
                                                BlendMode.srcIn),
                                          ),
                                        )
                                      : SvgPicture.asset(
                                          "assets/hms/icons/message_badge_off.svg",
                                          colorFilter: ColorFilter.mode(
                                              HMSThemeColors
                                                  .onSurfaceHighEmphasis,
                                              BlendMode.srcIn),
                                          semanticsLabel: "chat_button",
                                        ),
                                ),
                              );
                            }),

                        ///Menu Button
                        GestureDetector(
                          onTap: () async => {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: HMSThemeColors.surfaceDim,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                              ),
                              context: context,
                              builder: (ctx) => ChangeNotifierProvider.value(
                                  value: context.read<MeetingStore>(),
                                  child: const AppUtilitiesBottomSheet()),
                            )
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: UiConstants.greyVarient,
                            ),
                            padding: EdgeInsets.all(SizeConfig.padding18),
                            child: SvgPicture.asset("assets/hms/icons/menu.svg",
                                colorFilter: ColorFilter.mode(
                                    HMSThemeColors.onSurfaceHighEmphasis,
                                    BlendMode.srcIn),
                                semanticsLabel: "more_button"),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}
