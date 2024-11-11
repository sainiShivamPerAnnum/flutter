import 'dart:async';
import 'dart:developer';
import 'dart:ui';

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
  List<VideoData> get currentVideos {
    switch (state.currentContext) {
      case ReelContext.main:
        return state.mainVideos;
      case ReelContext.profile:
        return state.profileVideos;
      case ReelContext.liveStream:
        return state.liveVideo;
      default:
        return [];
    }
  }

  Future<void> _mapEventToState(
    PreloadEvent event,
    Emitter<PreloadState> emit,
  ) async {
    await event.map(
      updateConstants: (e) {
        VideoPreloadConstants.updateConstants(
          preloadLimit: e.preloadLimit,
          nextLimit: e.nextLimit,
          latency: e.latency,
        );
      },
      pauseVideoAtIndex: (e) {
        _stopControllerAtIndex(e.index);
      },
      playVideoAtIndex: (e) {
        _playControllerAtIndex(e.index);
      },
      switchToMainReels: (e) {
        emit(state.copyWith(currentContext: ReelContext.main));
      },
      initializeFromDynamicLink: (e) async {
        await _stopAndDisposeAllControllers();
        emit(
          state.copyWith(
            currentContext: ReelContext.main,
            mainVideos: [],
            profileVideos: [],
            liveVideo: [],
            focusedIndex: 0,
            profileVideoIndex: 0,
          ),
        );
        final databyId = await repository.getVideoById(videoId: e.videoId);
        final data = await repository.getVideos(page: 1);
        final List<VideoData> urls = data.model ?? [];
        if (databyId.model != null) {
          state.mainVideos.add(databyId.model!);
        }
        state.mainVideos.addAll(urls);

        /// Initialize 1st video
        await _initializeControllerAtIndex(0);

        /// Initialize 2nd video
        await _initializeControllerAtIndex(1);
      },
      updateViewCount: (e) {
        unawaited(
          repository.updateViewCount(
            e.videoId,
          ),
        );
      },
      switchToProfileReels: (e) {
        emit(state.copyWith(currentContext: ReelContext.profile));
        e.completer?.complete();
      },
      setLoading: (e) {
        emit(state.copyWith(isLoading: true));
      },
      updateKeyboardState: (e) {
        emit(state.copyWith(keyboardVisible: e.state));
      },
      toggleComments: (e) {
        emit(state.copyWith(showComments: !state.showComments));
      },
      onError: (value) {
        emit(
          state.copyWith(
            errorMessage: "An error occurred while loading videos.",
          ),
        );
      },
      initializeAtIndex: (e) async {
        if (state.currentContext == ReelContext.main) {
          emit(state.copyWith(focusedIndex: e.index));
        } else {
          emit(state.copyWith(profileVideoIndex: e.index));
        }
        e.completer?.complete();
        await _initializeControllerAtIndex(e.index);
        final currentLength = state.currentContext == ReelContext.main
            ? state.mainVideos.length
            : state.profileVideos.length;
        if (e.index + 1 < currentLength) {
          await _initializeControllerAtIndex(e.index + 1);
        }
        if (e.index - 1 >= 0) {
          await _initializeControllerAtIndex(e.index - 1);
        }
      },
      getVideosFromApi: (e) async {
        final data = await repository.getVideos(page: 1);
        if (data.isSuccess()) {
          final List<VideoData> urls = data.model ?? [];

          if (state.currentContext == ReelContext.main) {
            state.mainVideos.addAll(urls);
          } else {
            state.profileVideos.addAll(urls);
          }

          /// Initialize 1st video
          await _initializeControllerAtIndex(0);

          /// Initialize 2nd video
          await _initializeControllerAtIndex(1);
        } else {
          emit(
            state.copyWith(
              errorMessage: "An error occurred while loading videos.",
            ),
          );
        }
      },
      onVideoIndexChanged: (e) async {
        final bool shouldFetch =
            (e.index + VideoPreloadConstants.kPreloadLimit) %
                        VideoPreloadConstants.kNextLimit ==
                    0 &&
                currentVideos.length ==
                    e.index + VideoPreloadConstants.kPreloadLimit &&
                state.currentContext == ReelContext.main;

        if (shouldFetch) {
          final response = await repository.getVideos(
            page: (e.index + VideoPreloadConstants.preloadLimit) ~/ 10 + 1,
          );
          final List<VideoData> urls = response.model ?? [];
          add(PreloadEvent.updateUrls(urls));
        }
        final index = state.currentContext == ReelContext.main
            ? state.focusedIndex
            : state.profileVideoIndex;
        if (e.index > index) {
          _playNext(e.index);
        } else {
          _playPrevious(e.index);
        }
        if (state.currentContext == ReelContext.main) {
          emit(state.copyWith(focusedIndex: e.index));
        } else {
          emit(state.copyWith(profileVideoIndex: e.index));
        }
      },
      updateUrls: (e) async {
        if (state.currentContext == ReelContext.main) {
          state.mainVideos.addAll(e.videos);
        } else {
          state.profileVideos.clear();
          state.profileVideos.addAll(e.videos);
        }
        emit(
          state.copyWith(
            isLoading: false,
          ),
        );
        e.completer?.complete();
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
        final String? avatarId = locator<UserService>().baseUser!.avatarId;
        final String? dpUrl = locator<UserService>().myUserDpUrl;
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
          avatarId: avatarId ?? 'AV1',
          dpUrl: dpUrl ?? '',
        );
        List<CommentData> updatedComments = List.from(currentComments)
          ..insert(0, newComment);
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
      disposeProfileControllers: (e) {
        _stopAndDisposeProfileControllers();
      },
      likeVideo: (e) async {
        final UserService userService = locator<UserService>();
        final String userName = (userService.baseUser!.kycName != null &&
                    userService.baseUser!.kycName!.isNotEmpty
                ? userService.baseUser!.kycName
                : userService.baseUser!.name) ??
            "N/A";
        if (state.currentContext == ReelContext.main) {
          emit(
            state.copyWith(
              mainVideos: state.mainVideos.map((video) {
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
        } else if (state.currentContext == ReelContext.profile) {
          emit(
            state.copyWith(
              profileVideos: state.profileVideos.map((video) {
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
        } else if (state.currentContext == ReelContext.liveStream) {
          emit(
            state.copyWith(
              liveVideo: state.liveVideo.map((video) {
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
        }
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
      initializeLiveStream: (e) async {
        emit(
          state.copyWith(
            currentContext: ReelContext.liveStream,
            liveVideo: [e.video],
          ),
        );
        e.completer?.complete();
        final VideoPlayerController controller =
            VideoPlayerController.networkUrl(
          Uri.parse(e.video.url),
        );
        emit(state.copyWith(liveStreamController: controller));
        await controller.initialize();
        await controller.setLooping(true);
        await controller.setVolume(1);
        await controller.play();
        final comments = await repository.getComments(e.video.id);
        add(
          PreloadEvent.addCommentToState(
            videoId: e.video.id,
            comment: comments.model ?? [],
          ),
        );
      },
      disposeLiveStreamController: (e) async {
        if (state.liveStreamController != null) {
          await state.liveStreamController!.dispose();
        }
      },
    );
  }

  void _playNext(int index) {
    _stopControllerAtIndex(index - 1);
    _disposeControllerAtIndex(index - 2);
    _playControllerAtIndex(index);
    _initializeControllerAtIndex(index + 1);
  }

  void _playPrevious(int index) {
    _stopControllerAtIndex(index + 1);
    _disposeControllerAtIndex(index + 2);
    _playControllerAtIndex(index);
    _initializeControllerAtIndex(index - 1);
  }

  Future<void> _initializeControllerAtIndex(int index) async {
    if (currentVideos.length > index && index >= 0) {
      final VideoPlayerController controller = VideoPlayerController.networkUrl(
        Uri.parse(currentVideos[index].url),
      );
      if (state.currentContext == ReelContext.main) {
        state.controllers[index] = controller;
      } else {
        state.profileControllers[index] = controller;
      }
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(1);
      final comments = await repository.getComments(currentVideos[index].id);
      add(
        PreloadEvent.addCommentToState(
          videoId: currentVideos[index].id,
          comment: comments.model ?? [],
        ),
      );
      _addProgressListener(controller, currentVideos[index].id);
      log('🚀🚀🚀 INITIALIZED $index for context ${state.currentContext}');
    }
  }

  void _addProgressListener(VideoPlayerController controller, String videoId) {
    late VoidCallback listener;

    listener = () {
      final duration = controller.value.duration;
      final position = controller.value.position;

      if (duration.inMilliseconds > 0 &&
          position.inMilliseconds >= duration.inMilliseconds * 0.25) {
        // Remove this specific listener to prevent repeated events
        controller.removeListener(listener);

        // Dispatch the event that 25% has been watched
        add(PreloadEvent.updateViewCount(videoId: videoId));
      }
    };

    // Add the listener to the controller
    controller.addListener(listener);
  }

  void _playControllerAtIndex(int index) {
    if (currentVideos.length > index && index >= 0) {
      final controller = state.currentContext == ReelContext.main
          ? state.controllers[index]
          : state.profileControllers[index];

      controller?.play();
      log('🚀🚀🚀 PLAYING $index for context ${state.currentContext}');
    }
  }

  void _stopControllerAtIndex(int index) {
    if (currentVideos.length > index && index >= 0) {
      final controller = state.currentContext == ReelContext.main
          ? state.controllers[index]
          : state.profileControllers[index];

      controller?.pause();
      controller?.seekTo(const Duration());
      log('🚀🚀🚀 STOPPED $index for context ${state.currentContext}');
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (currentVideos.length > index && index >= 0) {
      final controllersMap = state.currentContext == ReelContext.main
          ? state.controllers
          : state.profileControllers;

      final controller = controllersMap[index];
      controller?.removeListener(() {});
      controller?.dispose();
      if (controller != null) {
        controllersMap.remove(index);
      }
      log('🚀🚀🚀 DISPOSED $index for context ${state.currentContext}');
    }
  }

  Future<void> _stopAndDisposeProfileControllers() async {
    // Stop and dispose all controllers in the main feed
    // for (final entry in state.controllers.entries) {
    //   final controller = entry.value;
    //   controller.pause();
    //   controller.seekTo(const Duration()); // Reset to the beginning
    //   controller.dispose();
    // }
    // state.controllers.clear(); // Clear the map after disposing all controllers

    // Stop and dispose all controllers in the profile feed
    for (final entry in state.profileControllers.entries) {
      final controller = entry.value;
      await controller.pause();
      await controller.seekTo(const Duration());
      await controller.dispose();
    }
    state.profileControllers
        .clear(); // Clear the map after disposing all controllers
    log('🚀🚀🚀 All controllers stopped and disposed');
  }

  Future<void> _stopAndDisposeAllControllers() async {
    // Stop and dispose all controllers in the main feed
    for (final entry in state.controllers.entries) {
      final controller = entry.value;
      await controller.pause();
      await controller.seekTo(const Duration()); // Reset to the beginning
      await controller.dispose();
    }
    state.controllers.clear(); // Clear the map after disposing all controllers

    // Stop and dispose all controllers in the profile feed
    for (final entry in state.profileControllers.entries) {
      final controller = entry.value;
      await controller.pause();
      await controller.seekTo(const Duration());
      await controller.dispose();
    }
    state.profileControllers
        .clear(); // Clear the map after disposing all controllers
    if (state.liveStreamController != null) {
      final controller = state.liveStreamController!;
      await controller.pause();
      await controller.seekTo(const Duration());
      await controller.dispose();
    }
    log('🚀🚀🚀 All controllers stopped and disposed');
  }
}
