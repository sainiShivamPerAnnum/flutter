part of 'preload_bloc.dart';

enum ReelContext {
  main,
  profile,
}

@Freezed(makeCollectionsUnmodifiable: false)
class PreloadState with _$PreloadState {
  factory PreloadState({
    required List<VideoData> mainVideos,
    required List<VideoData> profileVideos,
    required Map<int, VideoPlayerController> controllers,
    required int focusedIndex,
    required int reloadCounter,
    required bool isLoading,
    required Map<String, List<CommentData>> videoComments,
    required ReelContext currentContext,
    required bool keyboardVisible,
  }) = _PreloadState;

  factory PreloadState.initial() => PreloadState(
        mainVideos: [],
        profileVideos: [],
        controllers: {},
        focusedIndex: 0,
        reloadCounter: 0,
        isLoading: false,
        videoComments: {},
        currentContext: ReelContext.main,
        keyboardVisible: false,
      );
}
