import 'dart:io';

import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  const AppVideoPlayer(
    this.link, {
    this.showShimmer = false,
    this.aspectRatio,
    this.requestHeaders,
    super.key,
  });

  final bool showShimmer;
  final double? aspectRatio;
  final Map<String, dynamic>? requestHeaders;
  final String link;

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late Stream<FileResponse> fileStream;

  @override
  void initState() {
    super.initState();

    fileStream = DefaultCacheManager().getFileStream(
      widget.link,
      headers: widget.requestHeaders as Map<String, String>?,
      withProgress: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fileStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else if (snapshot.hasData) {
          final data = snapshot.data;

          return (data is FileInfo)
              ? _VideoPlayer(
                  videoFile: data.file,
                  aspectRatio: widget.aspectRatio,
                )
              : const _ShimmerWidget();
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  const _VideoPlayer({required this.videoFile, this.aspectRatio});
  final File videoFile;
  final double? aspectRatio;
  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late final VideoPlayerController playerController;
  @override
  void initState() {
    super.initState();
    playerController = VideoPlayerController.file(widget.videoFile);
    playerController.initialize().then((_) {
      setState(() {
        playerController.setLooping(true);
        playerController.play();
      }); // to change aspect ratio once loaded.
    });
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      child: AspectRatio(
        aspectRatio: widget.aspectRatio ?? (playerController.value.aspectRatio),
        child: VideoPlayer(playerController),
      ),
    );
  }
}

class _ShimmerWidget extends StatelessWidget {
  const _ShimmerWidget();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: UiConstants.kUserRankBackgroundColor,
      highlightColor: Colors.grey.shade800,
      child: AspectRatio(
        aspectRatio: 1.4,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
          ),
        ),
      ),
    );
  }
}
