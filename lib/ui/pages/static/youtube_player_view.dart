import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerView extends StatefulWidget {
  const YoutubePlayerView({super.key, required this.url});
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UiConstants.kBackgroundColor,
        title: const Text("Youtube"),
      ),
      backgroundColor: Colors.black,
      body: YoutubePlayerScaffold(
        autoFullScreen: true,
        controller: _controller!,
        aspectRatio: 9 / 16,
        builder: (context, player) {
          return player;
        },
      ),
    );
  }
}
