part of 'preload_bloc.dart';

enum ReelContext {
  main,
  profile,
  liveStream,
}

@Freezed(makeCollectionsUnmodifiable: false)
class PreloadState with _$PreloadState {
  factory PreloadState({
    required List<VideoData> mainVideos,
    required List<VideoData> profileVideos,
    required Map<int, VideoPlayerController> controllers,
    required Map<int, VideoPlayerController> profileControllers,
    required int focusedIndex,
    required int profileVideoIndex,
    required int reloadCounter,
    required bool isLoading,
    required Map<String, List<CommentData>> videoComments,
    required ReelContext currentContext,
    required bool keyboardVisible,
    required bool showComments,
  }) = _PreloadState;

  factory PreloadState.initial() => PreloadState(
        mainVideos: [],
        profileVideos: [],
        controllers: {},
        profileControllers: {},
        focusedIndex: 0,
        profileVideoIndex: 0,
        reloadCounter: 0,
        isLoading: false,
        videoComments: {},
        currentContext: ReelContext.main,
        keyboardVisible: false,
        showComments: true,
      );
}
