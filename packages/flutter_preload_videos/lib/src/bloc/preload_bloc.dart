import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_preload_videos/src/service/api_service.dart';
import 'package:flutter_preload_videos/src/service/isolate_service.dart';
import '../core/constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:video_player/video_player.dart';

part 'preload_bloc.freezed.dart';
part 'preload_event.dart';
part 'preload_state.dart';

@injectable
@prod
class PreloadBloc extends Bloc<PreloadEvent, PreloadState> {
  PreloadBloc() : super(PreloadState.initial()) {
    on(_mapEventToState);
  }

  void _mapEventToState(PreloadEvent event, Emitter<PreloadState> emit) async {
    await event.map(
      pauseVideoAtIndex: (e) {
        _stopControllerAtIndex(e.index);
      },
      playVideoAtIndex: (e) {
        _playControllerAtIndex(e.index);
      },
      setLoading: (e) {
        emit(state.copyWith(isLoading: true));
      },
      getVideosFromApi: (e) async {
        /// Fetch videos from api
        final videos = await ApiService.getVideos(id: state.focusedIndex);
        state.videos.addAll(videos);

        /// Initialize 1st video
        await _initializeControllerAtIndex(0);

        /// Initialize 2nd video
        await _initializeControllerAtIndex(1);

        emit(state.copyWith(reloadCounter: state.reloadCounter + 1));
      },
      // initialize: (e) async* {},
      onVideoIndexChanged: (e) {
        /// Condition to fetch new videos
        final bool shouldFetch = (e.index + VideoPreloadConstants.kPreloadLimit) % VideoPreloadConstants.kNextLimit == 0 &&
            state.videos.length == e.index + VideoPreloadConstants.kPreloadLimit;

        if (shouldFetch) {
          IsolateService.createIsolate(e.index,this);
        }

        /// Next / Prev video decider
        if (e.index > state.focusedIndex) {
          _playNext(e.index);
        } else {
          _playPrevious(e.index);
        }

        emit(state.copyWith(focusedIndex: e.index));
      },
      updateConstants: (e) {
        VideoPreloadConstants.updateConstants(
          preloadLimit: e.preloadLimit,
          nextLimit: e.nextLimit,
          latency: e.latency,
        );
      },
      updateUrls: (e) {
        /// Add new urls to current urls
        state.videos.addAll(e.videos);

        /// Initialize new url
        _initializeControllerAtIndex(state.focusedIndex + 1);

        emit(state.copyWith(
            reloadCounter: state.reloadCounter + 1, isLoading: false));
        log('🚀🚀🚀 NEW VIDEOS ADDED');
      },
    );
  }

  void _playNext(int index) {
    /// Stop [index - 1] controller
    _stopControllerAtIndex(index - 1);

    /// Dispose [index - 2] controller
    _disposeControllerAtIndex(index - 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index + 1] controller
    _initializeControllerAtIndex(index + 1);
  }

  void _playPrevious(int index) {
    /// Stop [index + 1] controller
    _stopControllerAtIndex(index + 1);

    /// Dispose [index + 2] controller
    _disposeControllerAtIndex(index + 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index - 1] controller
    _initializeControllerAtIndex(index - 1);
  }

  Future _initializeControllerAtIndex(int index) async {
    if (state.videos.length > index && index >= 0) {
      /// Create new controller
      final VideoPlayerController controller =
          VideoPlayerController.networkUrl(Uri.parse( state.videos[index].url));

      /// Add to [controllers] list
      state.controllers[index] = controller;

      /// Initialize
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(1);

      log('🚀🚀🚀 INITIALIZED $index');
    }
  }

  void _playControllerAtIndex(int index) {
    if (state.videos.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController controller = state.controllers[index]!;

      /// Play controller
      controller.play();

      log('🚀🚀🚀 PLAYING $index');
    }
  }

  void _stopControllerAtIndex(int index) {
    if (state.videos.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController controller = state.controllers[index]!;

      /// Pause
      controller.pause();

      /// Reset postiton to beginning
      controller.seekTo(const Duration());

      log('🚀🚀🚀 STOPPED $index');
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (state.videos.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController? controller = state.controllers[index];

      /// Dispose controller
      controller?.dispose();

      if (controller != null) {
        state.controllers.remove(controller);
      }

      log('🚀🚀🚀 DISPOSED $index');
    }
  }
}
