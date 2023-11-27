import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerView extends StatefulWidget {
  const YoutubePlayerView({required this.url, super.key});

  final String url;

  @override
  State<YoutubePlayerView> createState() => _YoutubePlayerViewState();
}

class _YoutubePlayerViewState extends State<YoutubePlayerView> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.url.substring(widget.url.length - 11),
      autoPlay: true,
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: false,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (AppState.screenStack.last != ScreenItem.page) {
          AppState.screenStack.removeLast();
        }
        return Future.value(true);
      },
      child: SizedBox(
        height: SizeConfig.screenHeight! * 0.8,
        child: YoutubePlayer(
          // autoFullScreen: true,
          controller: _controller!,
          aspectRatio: 9 / 16,
        ),
      ),
    );
  }
}
