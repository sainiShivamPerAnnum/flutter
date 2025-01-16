import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/layout_api/hms_room_layout.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/bottom_sheets/hls_app_utilities_bottom_sheet.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_embedded_button.dart';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

///[HLSHandRaiseMenu] is a widget that is used to render the hand raise menu in case of Viewer near realtime
class HLSHandRaiseMenu extends StatelessWidget {
  const HLSHandRaiseMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (HMSRoomLayout.isHandRaiseEnabled)
          Selector<MeetingStore, bool>(
            selector: (_, meetingStore) => meetingStore.isRaisedHand,
            builder: (_, isRaisedHand, __) {
              return HMSEmbeddedButton(
                onTap: () => {
                  context.read<MeetingStore>().toggleLocalPeerHandRaise(),
                },
                enabledBorderColor: HMSThemeColors.surfaceBrighter,
                offColor: HMSThemeColors.surfaceDefault,
                disabledBorderColor: HMSThemeColors.surfaceDefault,
                onColor: HMSThemeColors.surfaceBrighter,
                isActive: isRaisedHand,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    isRaisedHand
                        ? "assets/hms/icons/hand_off.svg"
                        : "assets/hms/icons/hand_outline.svg",
                    colorFilter: ColorFilter.mode(
                      HMSThemeColors.onSurfaceHighEmphasis,
                      BlendMode.srcIn,
                    ),
                    semanticsLabel: "hand_raise_button",
                  ),
                ),
              );
            },
          ),
        const SizedBox(
          width: 8,
        ),
        if (HMSRoomLayout.isParticipantsListEnabled ||
            Constant.prebuiltOptions?.userName == null)
          HMSEmbeddedButton(
            onTap: () async => {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: HMSThemeColors.surfaceDim,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                context: context,
                builder: (ctx) => ChangeNotifierProvider.value(
                  value: context.read<MeetingStore>(),
                  child: const HLSAppUtilitiesBottomSheet(),
                ),
              ),
            },
            enabledBorderColor: HMSThemeColors.surfaceDefault,
            onColor: HMSThemeColors.surfaceDefault,
            isActive: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "assets/hms/icons/menu.svg",
                colorFilter: ColorFilter.mode(
                  HMSThemeColors.onSurfaceHighEmphasis,
                  BlendMode.srcIn,
                ),
                semanticsLabel: "more_button",
              ),
            ),
          ),
      ],
    );
  }
}
