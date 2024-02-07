import 'dart:async';
import 'dart:io';

import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import '../controller/story_controller.dart';
import '../utils.dart';

class VideoLoader {
  String url;

  File? videoFile;

  Map<String, dynamic>? requestHeaders;

  LoadState state = LoadState.loading;

  VideoLoader(this.url, {this.requestHeaders});

  void loadVideo(VoidCallback onComplete) {
    if (videoFile != null) {
      state = LoadState.success;
      onComplete();
    }

    final fileStream = DefaultCacheManager()
        .getFileStream(url, headers: requestHeaders as Map<String, String>?);

    fileStream.listen((fileResponse) {
      if (fileResponse is FileInfo) {
        if (videoFile == null) {
          state = LoadState.success;
          videoFile = fileResponse.file;
          onComplete();
        }
      }
    });
  }
}

class StoryVideo extends StatefulWidget {
  final StoryController? storyController;
  final VideoLoader videoLoader;

  StoryVideo(this.videoLoader, {this.storyController, Key? key})
      : super(key: key ?? UniqueKey());

  static StoryVideo url(String url,
      {StoryController? controller,
      Map<String, dynamic>? requestHeaders,
      Key? key}) {
    return StoryVideo(
      VideoLoader(url, requestHeaders: requestHeaders),
      storyController: controller,
      key: key,
    );
  }

  @override
  State<StatefulWidget> createState() {
    return StoryVideoState();
  }
}

class StoryVideoState extends State<StoryVideo> {
  Future<void>? playerLoader;

  StreamSubscription? _streamSubscription;

  VideoPlayerController? playerController;

  @override
  void initState() {
    super.initState();

    widget.storyController!.pause();

    widget.videoLoader.loadVideo(() {
      if (widget.videoLoader.state == LoadState.success) {
        playerController =
            VideoPlayerController.file(widget.videoLoader.videoFile!);

        playerController!.initialize().then((v) {
          setState(() {});
          widget.storyController!.play();
        });

        if (widget.storyController != null) {
          _streamSubscription =
              widget.storyController!.playbackNotifier.listen((playbackState) {
            if (playbackState == PlaybackState.pause) {
              playerController!.pause();
            } else {
              playerController!.play();
            }
          });
        }
      } else {
        setState(() {});
      }
    });
  }

  Widget _getContentView() {
    final locale = locator<S>();

    return switch (widget.videoLoader.state) {
      LoadState.success => Center(
          child: AspectRatio(
            aspectRatio: playerController!.value.aspectRatio,
            child: VideoPlayer(playerController!),
          ),
        ),
      LoadState.loading => Center(
          child: SizedBox.square(
            dimension: SizeConfig.padding70,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
        ),
      LoadState.failure => Center(
          child: Text(
            locale.someThingWentWrongError,
            style: TextStyles.rajdhaniSB.body1,
          ),
        )
    };
  }

  @override
  Widget build(BuildContext context) {
    return _getContentView();
  }

  @override
  void dispose() {
    playerController?.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }
}

class AppCachedVideo extends StatefulWidget {
  AppCachedVideo(
      {Key? key,
      this.showShimmer = false,
      this.aspectRatio,
      this.requestHeaders,
      required this.url})
      : super(key: key ?? UniqueKey());

  final bool showShimmer;
  final double? aspectRatio;
  final Map<String, dynamic>? requestHeaders;
  final String url;

  // static AppCachedVideo url(String url,
  //     {required bool showShimmer,
  //     double? aspectRatio,
  //     Map<String, dynamic>? requestHeaders,
  //     Key? key}) {
  //   return AppCachedVideo(
  //     VideoLoader(url, requestHeaders: requestHeaders),
  //     key: key,
  //     showShimmer: showShimmer,
  //     aspectRatio: aspectRatio,
  //   );
  // }

  @override
  State<AppCachedVideo> createState() => _AppCachedVideoState();
}

class _AppCachedVideoState extends State<AppCachedVideo> {
  late Stream<FileResponse> fileStream;

  @override
  void initState() {
    super.initState();

    fileStream = DefaultCacheManager().getFileStream(widget.url,
        headers: widget.requestHeaders as Map<String, String>?,
        withProgress: true);
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
  const _VideoPlayer({super.key, required this.videoFile, this.aspectRatio});
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
      playerController.setLooping(true);
      playerController.play();
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
  const _ShimmerWidget({super.key});

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
