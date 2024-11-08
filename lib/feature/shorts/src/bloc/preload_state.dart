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
    required List<VideoData> liveVideo,
    required Map<int, VideoPlayerController> controllers,
    required Map<int, VideoPlayerController> profileControllers,
    required int focusedIndex,
    required int profileVideoIndex,
    required bool isLoading,
    required Map<String, List<CommentData>> videoComments,
    required ReelContext currentContext,
    required bool keyboardVisible,
    required bool showComments,
    VideoPlayerController? liveStreamController,
  }) = _PreloadState;

  factory PreloadState.initial() => PreloadState(
        mainVideos: [],
        profileVideos: [],
        liveVideo:[],
        controllers: {},
        profileControllers: {},
        focusedIndex: 0,
        profileVideoIndex: 0,
        isLoading: false,
        videoComments: {},
        currentContext: ReelContext.main,
        keyboardVisible: false,
        showComments: true,
        liveStreamController: null, 
      );
}
