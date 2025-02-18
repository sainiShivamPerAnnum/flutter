part of 'preload_bloc.dart';

enum ReelContext {
  main,
  profile,
  liveStream,
}

@Freezed(makeCollectionsUnmodifiable: false)
class PreloadState with _$PreloadState {
  factory PreloadState({
    required VideoData? initialVideo,
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
    required bool muted,
    required int currentCategoryIndex,
    required List<String> categories,
    required String theme,
    String? errorMessage,
    VideoPlayerController? liveStreamController,
    PageController? livePageController,
  }) = _PreloadState;
  const PreloadState._();

  factory PreloadState.initial() => PreloadState(
        initialVideo: null,
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
        showComments: false,
        liveStreamController: null,
        errorMessage: null,
        theme: '',
        mainPageController: PageController(
          initialPage: 0,
          keepPage: true,
        ),
        profilePageController: PageController(
          initialPage: 0,
          keepPage: true,
        ),
        livePageController: null,
        currentCategoryIndex: 0,
        categories: [],
        muted: false,
      );

  List<VideoData> get currentVideos {
    switch (currentContext) {
      case ReelContext.main:
        return mainVideos;
      case ReelContext.profile:
        return profileVideos;
      case ReelContext.liveStream:
        return liveVideo;
      default:
        return [];
    }
  }
}
