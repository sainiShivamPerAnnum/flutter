import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  const AppVideoPlayer(this.link,
      {Key? key, this.showShimmer = false, this.aspectRatio})
      : super(key: key);
  final String link;
  final bool showShimmer;
  final double? aspectRatio;
  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.link)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller?.setLooping(true);
        _controller?.play();
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller?.value.isInitialized ?? false
        ? ClipRRect(
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            child: AspectRatio(
              aspectRatio: widget.aspectRatio ?? _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          )
        : widget.showShimmer
            ? Shimmer.fromColors(
                baseColor: UiConstants.kUserRankBackgroundColor,
                highlightColor: Colors.grey.shade800,
                child: AspectRatio(
                  aspectRatio: 1.4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                  ),
                ),
              )
            : Container();
  }
}
