part of 'preload_bloc.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class PreloadState with _$PreloadState {
  factory PreloadState({
    required List<VideoData> videos,
    required Map<int, VideoPlayerController> controllers,
    required int focusedIndex,
    required int reloadCounter,
    required bool isLoading,
  }) = _PreloadState;

  factory PreloadState.initial() => PreloadState(
        videos: [],
        controllers: {},
        focusedIndex: 0,
        reloadCounter: 0,
        isLoading: false,
      );
}
