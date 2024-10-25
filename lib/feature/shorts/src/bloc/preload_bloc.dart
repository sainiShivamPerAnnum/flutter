import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:video_player/video_player.dart';

import '../core/constants.dart';
import '../service/comment_data.dart';
import '../service/shorts_repo.dart';
import '../service/video_data.dart';

part 'preload_bloc.freezed.dart';
part 'preload_event.dart';
part 'preload_state.dart';

@injectable
@prod
class PreloadBloc extends Bloc<PreloadEvent, PreloadState> {
  final repository = locator<ShortsRepo>();
  PreloadBloc() : super(PreloadState.initial()) {
    on(_mapEventToState);
  }

  Future<void> _mapEventToState(
    PreloadEvent event,
    Emitter<PreloadState> emit,
  ) async {
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
        final data = await repository.getVideos(
          page: 1,
        );
        final List<VideoData> urls = data.model ?? [];

        state.videos.addAll(urls);

        /// Initialize 1st video
        await _initializeControllerAtIndex(0, urls[0].id);

        /// Initialize 2nd video
        await _initializeControllerAtIndex(1, urls[1].id);

        emit(state.copyWith(reloadCounter: state.reloadCounter + 1));
      },
      // initialize: (e) async* {},
      onVideoIndexChanged: (e) async {
        /// Condition to fetch new videos
        final bool shouldFetch =
            (e.index + VideoPreloadConstants.kPreloadLimit) %
                        VideoPreloadConstants.kNextLimit ==
                    0 &&
                state.videos.length ==
                    e.index + VideoPreloadConstants.kPreloadLimit;

        if (shouldFetch) {
          final response = await repository.getVideos(
            page:(e.index + VideoPreloadConstants.preloadLimit) ~/ 10+1,
          );
          final List<VideoData> urls = response.model ?? [];
          add(PreloadEvent.updateUrls(urls));
        }

        /// Next / Prev video decider
        if (e.index > state.focusedIndex) {
          _playNext(e.index, state.videos[e.index].id);
        } else {
          _playPrevious(e.index, state.videos[e.index].id);
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
        // _initializeControllerAtIndex(
        //   state.focusedIndex + 1,
        //   state.videos[state.focusedIndex].id,
        // );

        emit(
          state.copyWith(
            reloadCounter: state.reloadCounter + 1,
            isLoading: false,
          ),
        );
        log('🚀🚀🚀 NEW VIDEOS ADDED');
      },
      addComment: (e) async {
        final UserService userService = locator<UserService>();
        final String uid = userService.baseUser!.uid ?? '';
        final String userName = (userService.baseUser!.kycName != null &&
                    userService.baseUser!.kycName!.isNotEmpty
                ? userService.baseUser!.kycName
                : userService.baseUser!.name) ??
            "N/A";
        unawaited(repository.addComment(e.videoId, uid, userName, e.comment));
        List<CommentData> currentComments =
            state.videoComments[e.videoId] ?? [];
        final newComment = CommentData(
          id: '',
          videoId: e.videoId,
          userId: uid,
          name: userName,
          comment: e.comment,
          createdAt: DateTime.now().toString(),
        );
        List<CommentData> updatedComments = List.from(currentComments)
          ..add(newComment);
        emit(
          state.copyWith(
            videoComments: {
              ...state.videoComments,
              e.videoId: updatedComments,
            },
          ),
        );
        log('🚀🚀🚀 Comment posted');
      },
      likeVideo: (e) async {
        final UserService userService = locator<UserService>();
        final String userName = (userService.baseUser!.kycName != null &&
                    userService.baseUser!.kycName!.isNotEmpty
                ? userService.baseUser!.kycName
                : userService.baseUser!.name) ??
            "N/A";

        emit(
          state.copyWith(
            videos: state.videos.map((video) {
              if (video.id == e.videoId) {
                unawaited(
                  repository.addLike(
                    !video.isVideoLikedByUser,
                    e.videoId,
                    userName,
                  ),
                );
                return video.copyWith(
                  isVideoLikedByUser: !video.isVideoLikedByUser,
                );
              } else {
                return video;
              }
            }).toList(),
          ),
        );
        log('🚀🚀🚀 Video liked');
      },
      addCommentToState: (e) {
        emit(
          state.copyWith(
            videoComments: {
              ...state.videoComments,
              e.videoId: e.comment,
            },
          ),
        );
        log('🚀🚀🚀 Comment added to state for video: ${e.videoId}');
      },
    );
  }

  void _playNext(int index, String videoId) {
    /// Stop [index - 1] controller
    _stopControllerAtIndex(index - 1);

    /// Dispose [index - 2] controller
    _disposeControllerAtIndex(index - 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index + 1] controller
    _initializeControllerAtIndex(index + 1, videoId);
  }

  void _playPrevious(int index, String videoId) {
    /// Stop [index + 1] controller
    _stopControllerAtIndex(index + 1);

    /// Dispose [index + 2] controller
    _disposeControllerAtIndex(index + 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index - 1] controller
    _initializeControllerAtIndex(index - 1, videoId);
  }

  Future _initializeControllerAtIndex(int index, String videoId) async {
    if (state.videos.length > index && index >= 0) {
      /// Create new controller
      final VideoPlayerController controller =
          VideoPlayerController.networkUrl(Uri.parse(state.videos[index].url));

      /// Add to [controllers] list
      state.controllers[index] = controller;

      /// Initialize
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(1);
      final comments = await repository.getComments(videoId);
      add(
        PreloadEvent.addCommentToState(
          videoId: videoId,
          comment: comments.model ?? [],
        ),
      );
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
