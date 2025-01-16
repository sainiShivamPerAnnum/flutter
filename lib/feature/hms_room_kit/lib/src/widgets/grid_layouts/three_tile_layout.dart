///Package imports

///Project imports
import 'package:felloapp/feature/hms_room_kit/lib/src/model/peer_track_node.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/grid_layouts/listenable_peer_widget.dart';
import 'package:flutter/cupertino.dart';

///This widget renders three tiles on a page
///The three tiles are rendered in a 3x1 grid
///The tiles look like this
/// ╔═══════╦═══════╗
/// ║   0   ║   1   ║
/// ╠═══════╬═══════╣
///     ║   2   ║
///     ╚═══════╝
class ThreeTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;
  const ThreeTileLayout(
      {super.key, required this.peerTracks, required this.startIndex});

  @override
  Widget build(BuildContext context) {
    ///Here we render three rows with one tile in each row
    ///The first row contains the tile with index [startIndex]
    ///The second row contains the tile with index [startIndex+1]
    ///The third row contains the tile with index [startIndex+2]
    return Column(
      children: [
        Expanded(
          child: Row(children: [
            Expanded(
              child: ListenablePeerWidget(
                  index: startIndex, peerTracks: peerTracks),
            ),
            const SizedBox(
              width: 2,
            ),
            Expanded(
              child: ListenablePeerWidget(
                  index: startIndex + 1, peerTracks: peerTracks),
            ),
          ]),
        ),
        const SizedBox(
          height: 2,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 5,
            ),
            child: ListenablePeerWidget(
              index: startIndex + 2,
              peerTracks: peerTracks,
            ),
          ),
        ),
      ],
    );
  }
}
