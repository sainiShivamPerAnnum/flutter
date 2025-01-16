import 'package:felloapp/feature/hms_room_kit/lib/src/hls_viewer/hls_player_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/layout_api/hms_theme_colors.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';

///Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///[HLSPlayerSeekbar] is the seekbar for the HLS Player
class HLSPlayerSeekbar extends StatefulWidget {
  const HLSPlayerSeekbar({super.key});

  @override
  State<HLSPlayerSeekbar> createState() => _HLSPlayerSeekbarState();
}

class _HLSPlayerSeekbarState extends State<HLSPlayerSeekbar> {
  int seekBarValue = 0;
  int minValue = 0, maxValue = 300;
  bool isInteracting = false;

  ///[_toggleIsInteracting] toggles the [isInteracting] variable
  void _toggleIsInteracting(bool value) {
    setState(() {
      isInteracting = value;
    });
  }

  @override
  void initState() {
    super.initState();
    maxValue = context.read<HLSPlayerStore>().rollingWindow.inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return (context
                .read<MeetingStore>()
                .hmsRoom
                ?.hmshlsStreamingState
                ?.variants[0]
                ?.playlistType ==
            HMSHLSPlaylistType.dvr)
        ? Selector<HLSPlayerStore, Tuple2<Duration, Duration>>(
            selector: (_, hlsPlayerStore) => Tuple2(
              hlsPlayerStore.timeFromLive,
              hlsPlayerStore.rollingWindow,
            ),
            builder: (_, data, __) {
              maxValue = data.item2.inSeconds;

              ///We only subtract the time from live from the rolling window if the time from live is greater than 0
              seekBarValue = maxValue > 0
                  ? maxValue -
                      (data.item1.inSeconds > 0 ? data.item1.inSeconds : 0)
                  : 0;
              minValue = 0;
              return (maxValue > 0 && seekBarValue > 0)
                  ? SliderTheme(
                      data: SliderThemeData(
                        trackHeight: isInteracting ? 6 : 4,
                        trackShape: const RoundedRectSliderTrackShape(),
                        inactiveTrackColor: HMSThemeColors.baseWhite,
                        activeTrackColor: HMSThemeColors.primaryDefault,
                        thumbColor: HMSThemeColors.primaryDefault,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: isInteracting ? 10 : 6,
                        ),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 0),
                      ),
                      child: Slider(
                        value: seekBarValue.toDouble(),
                        onChanged: (value) {},
                        onChangeEnd: (value) {
                          if (value > seekBarValue) {
                            HMSHLSPlayerController.seekForward(
                              seconds: (value - seekBarValue).toInt(),
                            );
                          } else {
                            HMSHLSPlayerController.seekBackward(
                              seconds: (seekBarValue - value).toInt(),
                            );
                          }
                          HMSHLSPlayerController.resume();
                          _toggleIsInteracting(false);
                        },
                        onChangeStart: (_) {
                          HMSHLSPlayerController.pause();
                          _toggleIsInteracting(true);
                        },
                        min: minValue.toDouble(),
                        max: maxValue.toDouble(),
                      ),
                    )
                  : const SizedBox();
            },
          )
        : const SizedBox();
  }
}
