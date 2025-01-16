///Project imports
// import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/model/peer_track_node.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/common_widgets/video_view.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/peer_widgets/rtc_stats_view.dart';
// import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/whiteboard_screenshare/whiteboard_screenshare_store.dart';

///Package imports
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///[ScreenshareTile] is a widget that is used to render the screenshare tile
///It is used to render the screenshare of the peer
class ScreenshareTile extends StatelessWidget {
  const ScreenshareTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoView(
          uid: context.read<PeerTrackNode>().uid,
          scaleType: ScaleType.SCALE_ASPECT_FIT,
        ),
        const RTCStatsView(isLocal: false),
      ],
    );
  }
}
