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
  List<VideoData> get currentVideos => state.currentContext == ReelContext.main
      ? state.mainVideos
      : state.profileVideos;

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
      switchToProfileReels: (e) {
        emit(state.copyWith(currentContext: ReelContext.profile));
      },
      setLoading: (e) {
        emit(state.copyWith(isLoading: true));
      },
      updateKeyboardState: (e) {
        emit(state.copyWith(keyboardVisible: e.state));
      },
      initializeAtIndex: (e) async {
        await _initializeControllerAtIndex(e.index);
        emit(state.copyWith(focusedIndex: e.index));
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
        emit(state.copyWith(reloadCounter: state.reloadCounter + 1));
      },
      onVideoIndexChanged: (e) async {
        final bool shouldFetch =
            (e.index + VideoPreloadConstants.kPreloadLimit) %
                        VideoPreloadConstants.kNextLimit ==
                    0 &&
                currentVideos.length ==
                    e.index + VideoPreloadConstants.kPreloadLimit;

        if (shouldFetch) {
          final response = await repository.getVideos(
            page: (e.index + VideoPreloadConstants.preloadLimit) ~/ 10 + 1,
          );
          final List<VideoData> urls = response.model ?? [];
          add(PreloadEvent.updateUrls(urls));
        }

        if (e.index > state.focusedIndex) {
          _playNext(e.index);
        } else {
          _playPrevious(e.index);
        }

        emit(state.copyWith(focusedIndex: e.index));
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

  Future _initializeControllerAtIndex(int index) async {
    if (currentVideos.length > index && index >= 0) {
      final VideoPlayerController controller = VideoPlayerController.networkUrl(
        Uri.parse(currentVideos[index].url),
      );

      state.controllers[index] = controller;

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
      log('🚀🚀🚀 INITIALIZED $index');
    }
  }

  void _playControllerAtIndex(int index) {
    if (currentVideos.length > index && index >= 0) {
      final VideoPlayerController controller = state.controllers[index]!;
      controller.play();
      log('🚀🚀🚀 PLAYING $index');
    }
  }

  void _stopControllerAtIndex(int index) {
    if (currentVideos.length > index && index >= 0) {
      final VideoPlayerController controller = state.controllers[index]!;
      controller.pause();
      controller.seekTo(const Duration());
      log('🚀🚀🚀 STOPPED $index');
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (currentVideos.length > index && index >= 0) {
      final VideoPlayerController? controller = state.controllers[index];
      controller?.dispose();
      if (controller != null) {
        state.controllers.remove(index);
      }
      log('🚀🚀🚀 DISPOSED $index');
    }
  }
}
