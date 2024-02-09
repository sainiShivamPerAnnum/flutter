import 'package:flutter/material.dart';

import '../../pages/hometabs/save/stories/story_view/story_view.dart';

class AppVideoPlayer extends StatelessWidget {
  const AppVideoPlayer(this.link,
      {Key? key, this.showShimmer = false, this.aspectRatio})
      : super(key: key);
  final String link;
  final bool showShimmer;
  final double? aspectRatio;
  @override
  Widget build(BuildContext context) {
    return AppCachedVideo(
        url: link, showShimmer: showShimmer, aspectRatio: aspectRatio);
  }
}
