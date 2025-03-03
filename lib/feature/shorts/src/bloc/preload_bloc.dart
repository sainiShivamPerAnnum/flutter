import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/shorts/src/core/interaction_enum.dart';
import 'package:felloapp/feature/shortsHome/bloc/shorts_home_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';
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
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  PreloadBloc() : super(PreloadState.initial()) {
    on(_mapEventToState);
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
      updateThemes: (e) {
        emit(
          state.copyWith(
            categories: e.categories,
            theme: e.theme,
            currentCategoryIndex: e.index,
          ),
        );
        e.completer?.complete();
      },
      toggleVolume: (e) {
        final controller = state.currentController;
        if (controller != null && controller.value.isPlaying) {
          if (controller.value.volume == 0) {
            controller.setVolume(
              1.0,
            );
            emit(
              state.copyWith(
                muted: false,
              ),
            );
          } else {
            controller.setVolume(0.0);
            emit(
              state.copyWith(
                muted: true,
              ),
            );
          }
        }
      },
      updateLoading: (e) {
        emit(
          state.copyWith(isLoading: e.isLoading),
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
      generateDynamicLink: (e) async {
        if (state.shareLinkInProgress || state.isShareAlreadyClicked) {
          return;
        }
        Haptic.vibrate();
        String? url;
        emit(
          state.copyWith(
            shareLinkInProgress: true,
            isShareAlreadyClicked: true,
          ),
        );
        if (await BaseUtil.showNoInternetAlert()) return;
        if (state.link[e.videoId] != null) {
          url = state.link[e.videoId];
        } else {
          final databyId = await repository.dynamicLink(id: e.videoId);
          if (databyId.isSuccess()) {
            url = databyId.model;
            emit(
              state
                  .copyWith(link: {e.videoId.toString(): databyId.model ?? ''}),
            );
          }
        }
        emit(state.copyWith(shareLinkInProgress: false));
        if (url == null) {
          BaseUtil.showNegativeAlert(
            'Generating link failed',
            'Please try after some time',
          );
          emit(state.copyWith(isShareAlreadyClicked: false));
        } else {
          if (state.currentContext == ReelContext.main) {
            await Share.share(
              "Hi,\nCheck out this quick finance tip from Fello: ${state.mainVideos[state.focusedIndex].description}\n👩‍💼 Connect with certified experts for more personalized advice.\n📽 Watch now: $url",
            );
            emit(state.copyWith(isShareAlreadyClicked: false));
          } else if (state.currentContext == ReelContext.profile) {
            await Share.share(
              "Hi,\nCheck out this quick finance tip from Fello: ${state.profileVideos[state.profileVideoIndex].description}\n👩‍💼 Connect with certified experts for more personalized advice.\n📽 Watch now: $url",
            );
            emit(state.copyWith(isShareAlreadyClicked: false));
          } else {
            await Share.share(
              "Hi,\nCheck out this quick finance tip from Fello: ${state.liveVideo[0].description}\n👩‍💼 Connect with certified experts for more personalized advice.\n📽 Watch now: $url",
            );
            emit(state.copyWith(isShareAlreadyClicked: false));
          }
          _analyticsService.track(
            eventName: AnalyticsEvents.shortsShared,
            properties: {
              "shorts title": state.mainVideos[state.focusedIndex].title,
              "shorts category": state.categories[state.currentCategoryIndex],
              "shorts video list": state.theme,
            },
          );
        }
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
        await _initializeControllerAtIndex(0, state.muted);

        /// Initialize 2nd video
        await _initializeControllerAtIndex(1, state.muted);
        e.completer?.complete();
      },
      updateViewCount: (e) {
        unawaited(
          repository.updateViewCount(
            e.videoId,
          ),
        );
      },
      updateSeen: (e) {
        unawaited(
          repository.updateSeen(
            e.videoId,
          ),
        );
      },
      addInteraction: (e) {
        unawaited(
          repository.updateInteraction(
            videoId: e.videoId,
            theme: e.theme,
            category: e.category,
            interaction: e.interaction,
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
        _analyticsService.track(
          eventName: AnalyticsEvents.shortsComments,
          properties: {
            "expert name": state.mainVideos[state.focusedIndex].author,
            "shorts title": state.mainVideos[state.focusedIndex].title,
            "shorts category": state.categories[state.currentCategoryIndex],
            "shorts video list": state.theme,
          },
        );
      },
      onError: (value) {
        emit(
          state.copyWith(
            errorMessage: "An error occurred while loading videos.",
          ),
        );
      },
      initializeAtIndex: (e) async {
        final PageController pageController = PageController(
          initialPage: e.index,
        );
        if (state.currentContext == ReelContext.main) {
          emit(
            state.copyWith(
              focusedIndex: e.index,
              mainPageController: pageController,
            ),
          );
        } else {
          emit(
            state.copyWith(
              profileVideoIndex: e.index,
              profilePageController: pageController,
            ),
          );
        }
        e.completer?.complete();
        await _initializeControllerAtIndex(e.index, state.muted);
        final currentLength = state.currentContext == ReelContext.main
            ? state.mainVideos.length
            : state.profileVideos.length;
        if (e.index + 1 < currentLength) {
          await _initializeControllerAtIndex(e.index + 1, state.muted);
        }
        if (e.index - 1 >= 0) {
          await _initializeControllerAtIndex(e.index - 1, state.muted);
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
          await _initializeControllerAtIndex(0, state.muted);

          /// Initialize 2nd video
          await _initializeControllerAtIndex(1, state.muted);
        } else {
          emit(
            state.copyWith(
              errorMessage: "An error occurred while loading videos.",
            ),
          );
        }
      },
      getCategoryVideos: (e) async {
        final PageController pageController = PageController(
          initialPage: 0,
        );
        emit(
          state.copyWith(
            initialVideo: e.initailVideo,
            currentContext: ReelContext.main,
            mainVideos: [],
            focusedIndex: 0,
            isLoading: !state.isLoading,
            mainPageController: pageController,
          ),
        );
        int index;
        if (e.direction > 0) {
          index = (state.currentCategoryIndex - 1) % state.categories.length;
        } else if (e.direction < 0) {
          index = (state.currentCategoryIndex + 1 + state.categories.length) %
              state.categories.length;
        } else {
          index = state.currentCategoryIndex;
        }

        emit(
          state.copyWith(
            currentCategoryIndex: index,
          ),
        );
        _analyticsService.track(
          eventName: AnalyticsEvents.shortsHorizontalSwipe,
        );
        await _stopAndDisposeVideoControllers();
        e.completer?.complete();

        final data = index == 0
            ? await repository.getVideosByTheme(
                theme: state.theme,
              )
            : await repository.getVideosByCategory(
                category: state.categories[state.currentCategoryIndex],
                theme: state.theme,
              );
        if (!data.isSuccess()) {
          emit(
            state.copyWith(
              errorMessage: "An error occurred while loading videos.",
            ),
          );
          return;
        }

        final List<VideoData> urls = data.model?.videos ?? [];

        state.mainVideos.clear();

        if (e.initailVideo != null) {
          state.mainVideos.add(e.initailVideo!);
        }
        List<VideoData> videosToAdd =
            urls.where((video) => video.id != e.initailVideo?.id).toList();
        state.mainVideos.addAll(videosToAdd);
        await _initializeControllerAtIndex(0, state.muted);
        await _initializeControllerAtIndex(1, state.muted);
        _playControllerAtIndex(0);

        add(PreloadEvent.updateLoading(isLoading: !state.isLoading));
      },
      getThemeVideos: (e) async {
        final PageController pageController = PageController(
          initialPage: 0,
        );
        emit(
          state.copyWith(
            initialVideo: e.initailVideo,
            currentContext: ReelContext.main,
            mainVideos: [],
            focusedIndex: 0,
            isLoading: !state.isLoading,
            mainPageController: pageController,
          ),
        );
        emit(
          state.copyWith(
            currentCategoryIndex: 0,
          ),
        );
        await _stopAndDisposeVideoControllers();
        e.completer?.complete();

        final data = await repository.getVideosByTheme(
          theme: state.theme,
        );
        if (!data.isSuccess()) {
          emit(
            state.copyWith(
              errorMessage: "An error occurred while loading videos.",
            ),
          );
          return;
        }
        final List<VideoData> urls = data.model?.videos ?? [];
        state.mainVideos.clear();
        if (e.initailVideo != null) {
          state.mainVideos.add(e.initailVideo!);
        }
        List<VideoData> videosToAdd =
            urls.where((video) => video.id != e.initailVideo?.id).toList();
        state.mainVideos.addAll(videosToAdd);
        await _initializeControllerAtIndex(0, state.muted);
        await _initializeControllerAtIndex(1, state.muted);
        _playControllerAtIndex(0);
        add(PreloadEvent.updateLoading(isLoading: !state.isLoading));
      },
      onVideoIndexChanged: (e) async {
        final bool shouldFetch =
            (e.index + VideoPreloadConstants.kPreloadLimit) %
                        VideoPreloadConstants.kNextLimit ==
                    0 &&
                state.currentVideos.length ==
                    e.index + VideoPreloadConstants.kPreloadLimit &&
                state.currentContext == ReelContext.main;
        _analyticsService.track(
          eventName: AnalyticsEvents.shortsVerticalSwipe,
        );
        if (shouldFetch) {
          final response = state.currentCategoryIndex == 0
              ? await repository.getVideosByTheme(
                  theme: state.theme,
                  page:
                      (e.index + VideoPreloadConstants.preloadLimit) ~/ 10 + 1,
                )
              : await repository.getVideosByCategory(
                  category: state.categories[state.currentCategoryIndex],
                  theme: state.theme,
                  page:
                      (e.index + VideoPreloadConstants.preloadLimit) ~/ 10 + 1,
                );
          final List<VideoData> urls = response.model?.videos ?? [];
          List<VideoData> videosToAdd = urls
              .where((video) => video.id != state.initialVideo?.id)
              .toList();
          // if (urls.length < 10) {
          //   // If we reach the end of the list, start from the beginning
          //   final resetResponse = await repository.getVideosByCategory(
          //     category: state.categories[state.currentCategoryIndex],
          //     theme: state.theme,
          //     page: 1,
          //   );
          //   List<VideoData> resetUrls = resetResponse.model?.videos ?? [];
          //   if (resetUrls.isNotEmpty) {
          //     urls.addAll(resetUrls);
          //   }
          //   add(PreloadEvent.updateUrls(urls));
          // }
          // else {
          //   add(PreloadEvent.updateUrls(urls));
          // }
          add(PreloadEvent.updateUrls(videosToAdd));
        }
        final index = state.currentContext == ReelContext.main
            ? state.focusedIndex
            : state.profileVideoIndex;
        if (e.index > index) {
          _playNext(e.index, state.muted);
        } else {
          _playPrevious(e.index, state.muted);
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
        emit(
          state.copyWith(
            showComments: false,
          ),
        );
      },
      followAdvisor: (e) {
        if (state.currentContext == ReelContext.main) {
          emit(
            state.copyWith(
              mainVideos: state.mainVideos.map((video) {
                if (video.advisorId == e.advisorId) {
                  unawaited(
                    repository.followAdvisor(
                      video.isFollowed,
                      video.advisorId,
                    ),
                  );
                  return video.copyWith(
                    isFollowed: !video.isFollowed,
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
                if (video.advisorId == e.advisorId) {
                  unawaited(
                    repository.followAdvisor(
                      video.isFollowed,
                      video.advisorId,
                    ),
                  );
                  return video.copyWith(
                    isFollowed: !video.isFollowed,
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
                if (video.advisorId == e.advisorId) {
                  unawaited(
                    repository.followAdvisor(
                      video.isFollowed,
                      video.advisorId,
                    ),
                  );
                  return video.copyWith(
                    isFollowed: !video.isFollowed,
                  );
                } else {
                  return video;
                }
              }).toList(),
            ),
          );
        }
        _analyticsService.track(
          eventName: AnalyticsEvents.shortsFollow,
          properties: {
            "expert name": state.mainVideos[state.focusedIndex].author,
            "shorts title": state.mainVideos[state.focusedIndex].title,
            "shorts category": state.categories[state.currentCategoryIndex],
            "shorts video list": state.theme,
          },
        );
      },
      saveVideo: (e) async {
        if (state.currentContext == ReelContext.main) {
          final videoExistsInMainList =
              state.mainVideos.any((video) => video.id == e.videoId);
          if (videoExistsInMainList) {
            emit(
              state.copyWith(
                mainVideos: state.mainVideos.map((video) {
                  if (video.id == e.videoId) {
                    unawaited(
                      repository.addSave(
                        video.isSaved,
                        e.videoId,
                        e.theme,
                        e.category,
                      ),
                    );
                    Future.delayed(
                      const Duration(seconds: 1),
                      () => BlocProvider.of<ShortsHomeBloc>(
                        AppState.delegate!.navigatorKey.currentContext!,
                        listen: false,
                      ).add(
                        const RefreshHomeData(),
                      ),
                    );
                    return video.copyWith(
                      isSaved: !video.isSaved,
                    );
                  } else {
                    return video;
                  }
                }).toList(),
              ),
            );
          } else {
            final res = await repository.addSave(
              e.isSaved,
              e.videoId,
              e.theme,
              e.category,
            );
            if (res.isSuccess()) {
              if (e.isSaved) {
                BaseUtil.showPositiveAlert(
                  'Success! Short Unsaved',
                  'This short has been removed from your saved list. You can save it again anytime!',
                );
              } else {
                BaseUtil.showPositiveAlert(
                  'Success! Short Saved',
                  'This short has been added to your saved list. You can watch it later anytime!',
                );
              }
              BlocProvider.of<ShortsHomeBloc>(
                AppState.delegate!.navigatorKey.currentContext!,
                listen: false,
              ).add(
                const RefreshHomeData(),
              );
            }
          }
        } else {
          final res = await repository.addSave(
            e.isSaved,
            e.videoId,
            e.theme,
            e.category,
          );
          if (res.isSuccess()) {
            if (e.isSaved) {
              BaseUtil.showPositiveAlert(
                'Success! Short Unsaved',
                'This short has been removed from your saved list. You can save it again anytime!',
              );
            } else {
              BaseUtil.showPositiveAlert(
                'Success! Short Saved',
                'This short has been added to your saved list. You can watch it later anytime!',
              );
            }

            BlocProvider.of<ShortsHomeBloc>(
              AppState.delegate!.navigatorKey.currentContext!,
              listen: false,
            ).add(
              const RefreshHomeData(),
            );
          }
        }
        log('🚀🚀🚀 Video saved');
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
        _analyticsService.track(
          eventName: AnalyticsEvents.shortsLiked,
          properties: {
            "shorts title": state.mainVideos[state.focusedIndex].title,
            "shorts category": state.categories[state.currentCategoryIndex],
            "shorts video list": state.theme,
          },
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
        final PageController pageController = PageController();
        emit(
          state.copyWith(
            liveStreamController: controller,
            livePageController: pageController,
          ),
        );
        await controller.initialize();
        await controller.setLooping(true);
        await controller.setVolume(state.muted ? 0 : 1);
        await controller.play();
        add(PreloadEvent.updateLoading(isLoading: !state.isLoading));
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
          state.livePageController!.dispose();
        }
        emit(
          state.copyWith(
            showComments: false,
          ),
        );
      },
      disposeMainStreamController: (e) async {
        for (final entry in state.controllers.entries) {
          final controller = entry.value;
          await controller.pause();
          await controller.seekTo(const Duration());
          await controller.dispose();
          state.mainPageController.dispose();
        }
        state.controllers
            .clear(); // Clear the map after disposing all controllers
        emit(
          state.copyWith(
            showComments: false,
          ),
        );
        log('🚀🚀🚀 All controllers stopped and disposed');
      },
    );
  }

  void _playNext(int index, bool muted) {
    _stopControllerAtIndex(index - 1);
    _disposeControllerAtIndex(index - 2);
    _playControllerAtIndex(index);
    _initializeControllerAtIndex(index + 1, muted);
  }

  void _playPrevious(int index, bool muted) {
    _stopControllerAtIndex(index + 1);
    _disposeControllerAtIndex(index + 2);
    _playControllerAtIndex(index);
    _initializeControllerAtIndex(index - 1, muted);
  }

  Future<void> _initializeControllerAtIndex(int index, bool muted) async {
    if (state.currentVideos.length > index && index >= 0) {
      final VideoPlayerController controller = VideoPlayerController.networkUrl(
        Uri.parse(state.currentVideos[index].url),
      );
      if (state.currentContext == ReelContext.main) {
        state.controllers[index] = controller;
      } else {
        state.profileControllers[index] = controller;
      }
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(muted ? 0 : 1);
      add(PreloadEvent.updateLoading(isLoading: !state.isLoading));
      final comments =
          await repository.getComments(state.currentVideos[index].id);
      add(
        PreloadEvent.addCommentToState(
          videoId: state.currentVideos[index].id,
          comment: comments.model ?? [],
        ),
      );
      _addProgressListener(controller, state.currentVideos[index].id);
      _addSeenListener(controller, state.currentVideos[index].id);
      if (state.currentContext == ReelContext.main) {
        _addSkippedListener(
          controller,
          state.currentVideos[index].id,
          state.theme,
          state.categories[state.currentCategoryIndex],
        );
        _addViewedListener(
          controller,
          state.currentVideos[index].id,
          state.theme,
          state.categories[state.currentCategoryIndex],
        );
        _addWatchedListener(
          controller,
          state.currentVideos[index].id,
          state.theme,
          state.categories[state.currentCategoryIndex],
        );
      }
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

  void _addSeenListener(VideoPlayerController controller, String videoId) {
    late VoidCallback listener;

    listener = () {
      final duration = controller.value.duration;
      final position = controller.value.position;

      if (duration.inMilliseconds > 0 &&
          position.inMilliseconds >= duration.inMilliseconds * 0.90) {
        // Remove this specific listener to prevent repeated events
        controller.removeListener(listener);

        // Dispatch the event that 90% has been watched
        add(PreloadEvent.updateSeen(videoId: videoId));
      }
    };

    // Add the listener to the controller
    controller.addListener(listener);
  }

  void _addWatchedListener(
    VideoPlayerController controller,
    String videoId,
    String theme,
    String category,
  ) {
    late VoidCallback listener;

    listener = () {
      final duration = controller.value.duration;
      final position = controller.value.position;

      if (duration.inMilliseconds > 0 &&
          position.inMilliseconds >= duration.inMilliseconds * 0.60) {
        // Remove this specific listener to prevent repeated events
        controller.removeListener(listener);

        // Dispatch the event that 60% has been watched
        add(
          PreloadEvent.addInteraction(
            videoId: videoId,
            interaction: InteractionType.watched,
            theme: theme,
            category: category,
          ),
        );
      }
    };

    // Add the listener to the controller
    controller.addListener(listener);
  }

  void _addSkippedListener(
    VideoPlayerController controller,
    String videoId,
    String theme,
    String category,
  ) {
    late VoidCallback listener;

    listener = () {
      final duration = controller.value.duration;
      final position = controller.value.position;

      if (duration.inMilliseconds > 0 &&
          position.inMilliseconds >= duration.inMilliseconds * 0.05) {
        // Remove this specific listener to prevent repeated events
        controller.removeListener(listener);

        // Dispatch the event that 5% has been watched
        add(
          PreloadEvent.addInteraction(
            videoId: videoId,
            interaction: InteractionType.skipped,
            theme: theme,
            category: category,
          ),
        );
      }
    };

    // Add the listener to the controller
    controller.addListener(listener);
  }

  void _addViewedListener(
    VideoPlayerController controller,
    String videoId,
    String theme,
    String category,
  ) {
    late VoidCallback listener;

    listener = () {
      final duration = controller.value.duration;
      final position = controller.value.position;

      if (duration.inMilliseconds > 0 &&
          position.inMilliseconds >= duration.inMilliseconds * 0.10) {
        // Remove this specific listener to prevent repeated events
        controller.removeListener(listener);

        // Dispatch the event that 10% has been watched
        add(
          PreloadEvent.addInteraction(
            videoId: videoId,
            interaction: InteractionType.viewed,
            theme: theme,
            category: category,
          ),
        );
      }
    };

    // Add the listener to the controller
    controller.addListener(listener);
  }

  void _playControllerAtIndex(int index) {
    if (state.currentVideos.length > index && index >= 0) {
      final controller = state.currentContext == ReelContext.main
          ? state.controllers[index]
          : state.profileControllers[index];

      controller?.play();
      log('🚀🚀🚀 PLAYING $index for context ${state.currentContext}');
    }
  }

  void _stopControllerAtIndex(int index) {
    if (state.currentVideos.length > index && index >= 0) {
      final controller = state.currentContext == ReelContext.main
          ? state.controllers[index]
          : state.profileControllers[index];

      controller?.pause();
      controller?.seekTo(const Duration());
      log('🚀🚀🚀 STOPPED $index for context ${state.currentContext}');
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (state.currentVideos.length > index && index >= 0) {
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

  Future<void> _stopAndDisposeVideoControllers() async {
    final controllersCopy =
        Map<int, VideoPlayerController>.from(state.controllers);
    for (final entry in controllersCopy.entries) {
      final controller = entry.value;
      await controller.pause();
      await controller.seekTo(const Duration());
      await controller.dispose();
    }
    state.controllers.clear();
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
      state.profilePageController.dispose();
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
      state.mainPageController.dispose();
    }
    state.controllers.clear(); // Clear the map after disposing all controllers

    // Stop and dispose all controllers in the profile feed
    for (final entry in state.profileControllers.entries) {
      final controller = entry.value;
      await controller.pause();
      await controller.seekTo(const Duration());
      await controller.dispose();
      state.profilePageController.dispose();
    }
    state.profileControllers
        .clear(); // Clear the map after disposing all controllers
    if (state.liveStreamController != null) {
      final controller = state.liveStreamController!;
      await controller.pause();
      await controller.seekTo(const Duration());
      await controller.dispose();
      await state.liveStreamController?.dispose();
    }
    log('🚀🚀🚀 All controllers stopped and disposed');
  }
}
