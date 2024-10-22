///Package imports

///Project imports
import 'package:felloapp/feature/hms_room_kit/lib/src/layout_api/hms_theme_colors.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/model/peer_track_node.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///[ScreenshareTileName] is a widget that is used to render the name of the peer when it's a screenshare tile
class ScreenshareTileName extends StatelessWidget {
  final double maxWidth;
  const ScreenshareTileName({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, Tuple2<String, bool>>(
        selector: (_, peerTrackNode) =>
            Tuple2(peerTrackNode.peer.name, peerTrackNode.peer.isLocal),
        builder: (_, data, __) {
          return Container(
              constraints: BoxConstraints(maxWidth: maxWidth - 80),
              child: HMSSubheadingText(
                text: "${data.item1.trim()}'s Screen",
                textColor: HMSThemeColors.onSurfaceHighEmphasis,
              ));
        });
  }
}
