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
    required PageController mainPageController,
    required Map<String, String> link,
    required bool shareLinkInProgress,
    required bool isShareAlreadyClicked,
    required Map<int, VideoPlayerController> profileControllers,
    required PageController profilePageController,
    required int focusedIndex,
    required int profileVideoIndex,
    required bool isLoading,
    required Map<String, List<CommentData>> videoComments,
    required ReelContext currentContext,
    required bool keyboardVisible,
    required bool showComments,
    String? errorMessage,
    VideoPlayerController? liveStreamController,
    PageController? livePageController,
  }) = _PreloadState;

  factory PreloadState.initial() => PreloadState(
        mainVideos: [],
        profileVideos: [],
        liveVideo: [],
        shareLinkInProgress: false,
        isShareAlreadyClicked: false,
        controllers: {},
        profileControllers: {},
        link: {},
        focusedIndex: 0,
        profileVideoIndex: 0,
        isLoading: false,
        videoComments: {},
        currentContext: ReelContext.main,
        keyboardVisible: false,
        showComments: true,
        liveStreamController: null,
        errorMessage: null,
        mainPageController: PageController(initialPage: 0,keepPage: true,),
        profilePageController: PageController(initialPage: 0,keepPage: true,),
        livePageController: null,
      );
}
