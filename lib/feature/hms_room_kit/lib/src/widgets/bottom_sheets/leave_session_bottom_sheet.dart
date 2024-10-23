///Project imports
import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/layout_api/hms_room_layout.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/bottom_sheets/end_service_bottom_sheet.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/leave_session_tile.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LeaveSessionBottomSheet extends StatefulWidget {
  const LeaveSessionBottomSheet({super.key});

  @override
  State<LeaveSessionBottomSheet> createState() =>
      _LeaveSessionBottomSheetState();
}

class _LeaveSessionBottomSheetState extends State<LeaveSessionBottomSheet> {
  ///Here we render bottom sheet with leave and end options

  @override
  Widget build(BuildContext context) {
    final meetingStore = context.read<MeetingStore>();
    return PopScope(
      onPopInvoked: (v) {
        if(v){
        // AppState.removeOverlay();
        }
      },
      child: ((meetingStore.localPeer?.role.permissions.endRoom ?? false) ||
              ((meetingStore.localPeer?.role.permissions.hlsStreaming ??
                      false) &&
                  meetingStore.hasHlsStarted))
          ? Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LeaveSessionTile(
                    tilePadding:
                        const EdgeInsets.only(top: 12.0, left: 18, right: 18),
                    leading: SvgPicture.asset(
                      "assets/hms/icons/exit_room.svg",
                      colorFilter: ColorFilter.mode(
                          HMSThemeColors.onSurfaceHighEmphasis,
                          BlendMode.srcIn),
                      semanticsLabel: "leave_room_button",
                    ),
                    title: "Leave",
                    titleColor: HMSThemeColors.onSurfaceHighEmphasis,
                    subTitle:
                        "Others will continue after you leave. You can join the session again.",
                    subTitleColor: HMSThemeColors.onSurfaceMediumEmphasis,
                    onTap: () => {
                      Navigator.pop(context),
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
                          value: meetingStore,
                          child: EndServiceBottomSheet(
                            onButtonPressed: () => {
                              meetingStore.leave(),
                            },
                            title: HMSTitleText(
                              text:
                                  "Leave ${HMSRoomLayout.peerType == PeerRoleType.conferencing ? "Session" : "Stream"}",
                              textColor: HMSThemeColors.alertErrorDefault,
                              letterSpacing: 0.15,
                              fontSize: 20,
                            ),
                            bottomSheetTitleIcon: SvgPicture.asset(
                              "assets/hms/icons/end_warning.svg",
                              height: 20,
                              width: 20,
                              colorFilter: ColorFilter.mode(
                                  HMSThemeColors.alertErrorDefault,
                                  BlendMode.srcIn),
                            ),
                            subTitle: HMSSubheadingText(
                              text:
                                  "Others will continue after you leave. You can join the session again.",
                              maxLines: 2,
                              textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                            ),
                            buttonText:
                                "Leave ${HMSRoomLayout.peerType == PeerRoleType.conferencing ? "Session" : "Stream"}",
                          ),
                        ),
                      )
                    },
                  ),
                  LeaveSessionTile(
                    tileColor: HMSThemeColors.alertErrorDim,
                    leading: SvgPicture.asset(
                      "assets/hms/icons/end.svg",
                      colorFilter: ColorFilter.mode(
                          HMSThemeColors.alertErrorBrighter, BlendMode.srcIn),
                      semanticsLabel: "leave_room_button",
                    ),
                    title: ((meetingStore
                                    .localPeer?.role.permissions.hlsStreaming ??
                                false) &&
                            meetingStore.hasHlsStarted)
                        ? "End Stream"
                        : "End Session",
                    titleColor: HMSThemeColors.alertErrorBrighter,
                    subTitle: ((meetingStore
                                    .localPeer?.role.permissions.hlsStreaming ??
                                false) &&
                            meetingStore.hasHlsStarted)
                        ? "The stream will end for everyone after they’ve watched it."
                        : "The session will end for everyone in the room immediately.",
                    subTitleColor: HMSThemeColors.alertErrorBright,
                    onTap: () => {
                      Navigator.pop(context),
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
                          value: meetingStore,
                          child: EndServiceBottomSheet(
                            onButtonPressed: () => {
                              if ((meetingStore.localPeer?.role.permissions
                                          .hlsStreaming ??
                                      false) &&
                                  meetingStore.hasHlsStarted)
                                {
                                  meetingStore.stopHLSStreaming(),
                                  meetingStore.leave(),
                                }
                              else
                                {
                                  meetingStore.endRoom(
                                      false, "Room Ended From Flutter"),
                                },
                            },
                            title: HMSTitleText(
                              text: ((meetingStore.localPeer?.role.permissions
                                              .hlsStreaming ??
                                          false) &&
                                      meetingStore.hasHlsStarted)
                                  ? "End Stream"
                                  : "End Session",
                              textColor: HMSThemeColors.alertErrorDefault,
                              letterSpacing: 0.15,
                              fontSize: 20,
                            ),
                            bottomSheetTitleIcon: SvgPicture.asset(
                              "assets/hms/icons/end_warning.svg",
                              height: 20,
                              width: 20,
                              colorFilter: ColorFilter.mode(
                                  HMSThemeColors.alertErrorDefault,
                                  BlendMode.srcIn),
                            ),
                            subTitle: HMSSubheadingText(
                              text: ((meetingStore.localPeer?.role.permissions
                                              .hlsStreaming ??
                                          false) &&
                                      meetingStore.hasHlsStarted)
                                  ? "The stream will end for everyone after they’ve watched it."
                                  : "The session will end for everyone in the room immediately.",
                              maxLines: 3,
                              textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                            ),
                            buttonText: ((meetingStore.localPeer?.role
                                            .permissions.hlsStreaming ??
                                        false) &&
                                    meetingStore.hasHlsStarted)
                                ? "End Stream"
                                : "End Session",
                          ),
                        ),
                      )
                    },
                  ),
                ],
              ),
            )
          : ChangeNotifierProvider.value(
              value: meetingStore,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding14,
                      horizontal: SizeConfig.padding20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Leave ${HMSRoomLayout.peerType == PeerRoleType.conferencing ? "Live Streaming" : "Stream"}",
                          style: TextStyles.sourceSansSB.body1,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: UiConstants.greyVarient,
                  ),
                  SizedBox(height: SizeConfig.padding18),
                  AppImage(Assets.exit_logo, height: SizeConfig.padding100),
                  Text(
                    'End Streaming',
                    style: TextStyles.sourceSansSB.title4,
                  ),
                  SizedBox(
                    height: SizeConfig.padding12,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding40),
                    child: Text(
                      'Leaving this session will end your current live stream and may cause you to miss out on valuable insights.',
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kTextColor5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding18,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding18),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // AppState.removeOverlay();
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: UiConstants.greyVarient,
                              padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness8),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyles.sourceSans.body3,
                            ),
                          ),
                        ),
                        SizedBox(width: SizeConfig.padding12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              meetingStore.leave();
                              // AppState.removeOverlay();
                              AppState.isInLiveStream = false;
                              AppState.backButtonDispatcher!.didPopRoute();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: UiConstants.kTextColor,
                              padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness8),
                              ),
                            ),
                            child: Text(
                              'Confirm',
                              style: TextStyles.sourceSans.body3.colour(
                                UiConstants.kTextColor4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding40),
                ],
              ),
            ),
    );
  }
}
