part of 'preload_bloc.dart';

@freezed
class PreloadEvent with _$PreloadEvent {
  // const factory PreloadEvent.initialize() = _Initialize;
  const factory PreloadEvent.initializeLiveStream(
    VideoData video, {
    Completer<void>? completer,
  }) = _InitializeLiveStream;
  const factory PreloadEvent.disposeLiveStreamController() =
      _DisposeLiveStreamController;
  const factory PreloadEvent.disposeMainStreamController() =
      _DisposeMainStreamController;
  const factory PreloadEvent.toggleVolume() = _ToggleVolume;
  const factory PreloadEvent.getVideosFromApi() = _GetVideosFromApi;
  const factory PreloadEvent.getCategoryVideos({
    required VideoData? initailVideo,
    required int direction,
    Completer<void>? completer,
  }) = _GetCategoryVideos;
  const factory PreloadEvent.getThemeVideos({
    required VideoData? initailVideo,
    required String theme,
    Completer<void>? completer,
  }) = _GetThemeVideos;
  const factory PreloadEvent.setLoading() = _SetLoading;
  const factory PreloadEvent.updateUrls(
    List<VideoData> videos, {
    Completer<void>? completer,
  }) = _UpdateUrls;
  const factory PreloadEvent.onVideoIndexChanged(int index) =
      _OnVideoIndexChanged;
  const factory PreloadEvent.pauseVideoAtIndex(int index) = _PauseVideoAtIndex;
  const factory PreloadEvent.playVideoAtIndex(int index) = _PlayVideoAtIndex;
  const factory PreloadEvent.updateThemes({
    required String theme,
    required String initialTheme,
    required String initialThemeName,
    required List<String> categories,
    required int index,
    required List<String> allThemes,
    required List<String> allThemeNames,
    required String themeName,
    Completer<void>? completer,
  }) = _UpdateThemes;
  const factory PreloadEvent.updateConstants({
    int? preloadLimit,
    int? nextLimit,
    int? latency,
  }) = _UpdateConstants;

  const factory PreloadEvent.addComment({
    required String videoId,
    required String comment,
  }) = _AddComment;

  const factory PreloadEvent.updateThemeTransitions({
    required List<ThemeTransition> themeTransitions,
  }) = UpdateThemeTransitions;

  const factory PreloadEvent.updateViewCount({
    required String videoId,
    required String category,
  }) = _UpdateViewCount;
  const factory PreloadEvent.updateSeen({
    required String videoId,
  }) = _UpdateSeen;
  const factory PreloadEvent.reset() = _Reset;
  const factory PreloadEvent.onError() = _ErrorPage;

  const factory PreloadEvent.likeVideo({
    required bool isLiked,
    required String videoId,
  }) = _LikeVideo;
  const factory PreloadEvent.followAdvisor({
    required String advisorId,
    required bool isFollowed,
  }) = _FollowAdvisor;
  const factory PreloadEvent.saveVideo({
    required bool isSaved,
    required String videoId,
    required String theme,
    required String category,
  }) = _SaveVideo;
  const factory PreloadEvent.addInteraction({
    required InteractionType interaction,
    required String videoId,
    required String theme,
    required String category,
  }) = _AddInteraction;
  const factory PreloadEvent.toggleComments() = _ToggleComments;
  const factory PreloadEvent.addCommentToState({
    required String videoId,
    required List<CommentData> comment,
  }) = _AddCommentToState;
  const factory PreloadEvent.switchToMainReels() = _SwitchToMainReels;
  const factory PreloadEvent.switchToProfileReels({
    Completer<void>? completer,
  }) = _SwitchToProfileReels;
  const factory PreloadEvent.initializeAtIndex({
    required int index,
    Completer<void>? completer,
  }) = _InitializeAtIndex;
  const factory PreloadEvent.initializeFromDynamicLink({
    required String videoId,
    Completer<void>? completer,
  }) = _InitializeFromDynamicLink;
  const factory PreloadEvent.updateKeyboardState({required bool state}) =
      _UpdateKeyboardState;
  const factory PreloadEvent.disposeProfileControllers() =
      _DisposeProfileControllers;
  const factory PreloadEvent.generateDynamicLink({required String videoId}) =
      _GenerateDynamicLink;
  const factory PreloadEvent.updateLoading({
    required bool isLoading,
  }) = _UpdateLoading;
}
