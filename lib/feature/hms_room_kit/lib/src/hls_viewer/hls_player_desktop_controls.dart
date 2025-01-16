import 'package:felloapp/feature/hms_room_kit/lib/src/hls_viewer/hls_stream_description.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/bottom_sheets/chat_bottom_sheet.dart';

///Package imports
import 'package:flutter/material.dart';

///[HLSPlayerDesktopControls] is the desktop controls for the HLS Player
class HLSPlayerDesktopControls extends StatefulWidget {
  final Orientation orientation;
  const HLSPlayerDesktopControls({required this.orientation, Key? key})
      : super(key: key);

  @override
  State<HLSPlayerDesktopControls> createState() =>
      _HLSPlayerDesktopControlsState();
}

class _HLSPlayerDesktopControlsState extends State<HLSPlayerDesktopControls> {
  bool showDescription = false;

  ///[toggleDescription] toggles the visibility of description
  void toggleDescription() {
    setState(() {
      showDescription = !showDescription;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Renders HLS Stream Description and Chat Bottom Sheet
        widget.orientation == Orientation.portrait
            ? HLSStreamDescription(
                showDescription: showDescription,
                toggleDescription: toggleDescription,
              )
            : const SizedBox(),

        ///Renders Chat Bottom Sheet only if the description is not visible
        if (!showDescription)
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: ChatBottomSheet(
                isHLSChat: true,
              ),
            ),
          ),
      ],
    );
  }
}
