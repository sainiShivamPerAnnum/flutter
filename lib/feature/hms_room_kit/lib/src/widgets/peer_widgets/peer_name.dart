///Project imports
import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/model/peer_track_node.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/hms_subheading_text.dart';

///Package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///[PeerName] is a widget that is used to render the name of the peer
class PeerName extends StatelessWidget {
  final double maxWidth;
  const PeerName({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: maxWidth - 80),
        child: Selector<PeerTrackNode, Tuple2<String, bool>>(
            selector: (_, peerTrackNode) =>
                Tuple2(peerTrackNode.peer.name, peerTrackNode.peer.isLocal),
            builder: (_, data, __) {
              return HMSSubheadingText(
                text: "${data.item1.trim()}${data.item2 ? " (You)" : ""}",
                textColor: HMSThemeColors.onSurfaceHighEmphasis,
                fontSize: 12,
              );
            }));
  }
}
