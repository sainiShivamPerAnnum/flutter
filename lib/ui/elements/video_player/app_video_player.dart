import 'package:flutter/material.dart';

import '../../pages/hometabs/save/stories/story_view/story_view.dart';

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
  @override
  Widget build(BuildContext context) {
    return AppCachedVideo(
        url: widget.link,
        showShimmer: widget.showShimmer,
        aspectRatio: widget.aspectRatio);
  }
}
