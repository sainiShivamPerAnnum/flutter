import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/shorts/src/core/analytics_manager.dart';
import 'package:felloapp/feature/shorts/src/core/interaction_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/local_actions_state.dart';
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
      reset: (e) {
        emit(PreloadState.initial());
      },
      updateThemes: (e) {
        emit(
          state.copyWith(
            categories: e.categories,
            theme: e.theme,
            currentCategoryIndex: e.index,
            allThemes: e.allThemes,
            themeName: e.themeName,
            allThemeNames: e.allThemeNames,
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
        _playControllerAtIndex(e.index, state.muted);
      },
      switchToMainReels: (e) {
        emit(state.copyWith(currentContext: ReelContext.main));
      },
      generateDynamicLink: (e) async {
        if (state.shareLinkInProgress) {
          return;
        }
        emit(
          state.copyWith(
            shareLinkInProgress: true,
            isShareAlreadyClicked: true,
          ),
        );
        Haptic.vibrate();
        String? url;
        if (await BaseUtil.showNoInternetAlert()) {
          emit(
            state.copyWith(
              shareLinkInProgress: false,
              isShareAlreadyClicked: false,
            ),
          );
          return;
        }

        try {
          if (state.link[e.videoId] != null) {
            url = state.link[e.videoId];
          } else {
            final databyId = await repository.dynamicLink(id: e.videoId);
            if (databyId.isSuccess()) {
              url = databyId.model;
              emit(
                state.copyWith(
                  link: {e.videoId.toString(): databyId.model ?? ''},
                ),
              );
            }
          }
          if (url == null) {
            BaseUtil.showNegativeAlert(
              'Generating link failed',
              'Please try after some time',
            );
            emit(
              state.copyWith(
                shareLinkInProgress: false,
                isShareAlreadyClicked: false,
              ),
            );
            return;
          }
          String shareMessage;
          if (state.currentContext == ReelContext.main) {
            shareMessage =
                "Hi,\nCheck out this quick finance tip from Fello: ${state.mainVideos[state.focusedIndex].description}\n👩‍💼 Connect with certified experts for more personalized advice.\n📽 Watch now: $url";
          } else if (state.currentContext == ReelContext.profile) {
            shareMessage =
                "Hi,\nCheck out this quick finance tip from Fello: ${state.profileVideos[state.profileVideoIndex].description}\n👩‍💼 Connect with certified experts for more personalized advice.\n📽 Watch now: $url";
          } else {
            shareMessage =
                "Hi,\nCheck out this quick finance tip from Fello: ${state.liveVideo[0].description}\n👩‍💼 Connect with certified experts for more personalized advice.\n📽 Watch now: $url";
          }
          await Share.share(shareMessage);
          _analyticsService.track(
            eventName: AnalyticsEvents.shortsShared,
            properties: {
              "shorts title": state.currentVideos.isNotEmpty &&
                      state.focusedIndex < state.currentVideos.length
                  ? state.currentVideos[state.focusedIndex].title
                  : 'Default Title',
              "shorts category": state.categories.isNotEmpty &&
                      state.currentCategoryIndex < state.categories.length
                  ? state.categories[state.currentCategoryIndex]
                  : 'Default Category',
              "shorts video list":
                  state.theme.isNotEmpty ? state.theme : 'Default Theme',
            },
          );
        } catch (error) {
          BaseUtil.showNegativeAlert(
            'Share failed',
            'An unexpected error occurred',
          );
        } finally {
          emit(
            state.copyWith(
              shareLinkInProgress: false,
              isShareAlreadyClicked: false,
            ),
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
          ),
        );
        final PageController pageController = PageController(
          initialPage: 0,
        );
        if (state.currentContext == ReelContext.main) {
          emit(
            state.copyWith(
              focusedIndex: 0,
              mainPageController: pageController,
            ),
          );
        } else {
          emit(
            state.copyWith(
              profileVideoIndex: 0,
              profilePageController: pageController,
            ),
          );
        }
        final databyId = await repository.getVideoById(videoId: e.videoId);
        e.completer?.complete();
        // final data = await repository.getVideos(page: 1);
        // final List<VideoData> urls = data.model ?? [];
        if (databyId.model != null) {
          state.mainVideos.add(databyId.model!);
        }
        // state.mainVideos.addAll(urls);
        /// Initialize 1st video
        await _initializeControllerAtIndex(0, state.muted);
        _playControllerAtIndex(0, state.muted);

        /// Initialize 2nd video
        await _initializeControllerAtIndex(1, state.muted);
      },
      updateViewCount: (e) {
        unawaited(
          repository.updateViewCount(
            e.videoId,
          ),
        );
        if (state.currentContext == ReelContext.main) {
          unawaited(
            repository.updateInteraction(
              videoId: e.videoId,
              theme: state.theme,
              category: state.categories[state.currentCategoryIndex],
              interaction: InteractionType.viewed,
            ),
          );
        }
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
            "shorts title": state.currentVideos.isNotEmpty &&
                    state.focusedIndex < state.currentVideos.length
                ? state.currentVideos[state.focusedIndex].title
                : 'Default Title',
            "shorts category": state.categories.isNotEmpty &&
                    state.currentCategoryIndex < state.categories.length
                ? state.categories[state.currentCategoryIndex]
                : 'Default Category',
            "shorts video list":
                state.theme.isNotEmpty ? state.theme : 'Default Theme',
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
        _playControllerAtIndex(0, state.muted);

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
        _playControllerAtIndex(0, state.muted);
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
          if (urls.length < 10) {
            final currentThemeIndex = state.allThemes.indexOf(state.theme);
            if (currentThemeIndex != -1 &&
                currentThemeIndex + 1 < state.allThemes.length &&
                state.currentCategoryIndex == 0) {
              final nextTheme = state.allThemes[currentThemeIndex + 1];
              final nextThemeName = state.allThemeNames[currentThemeIndex + 1];
              final nextResponse = state.currentCategoryIndex == 0
                  ? await repository.getVideosByTheme(
                      theme: nextTheme,
                      page: 1,
                    )
                  : await repository.getVideosByCategory(
                      category: state.categories[state.currentCategoryIndex],
                      theme: nextTheme,
                      page: 1,
                    );
              List<VideoData> nextThemeVideos =
                  nextResponse.model?.videos ?? [];
              videosToAdd.addAll(
                nextThemeVideos
                    .where((video) => video.id != state.initialVideo?.id)
                    .toList(),
              );
              add(
                PreloadEvent.updateThemes(
                  categories: state.categories,
                  theme: nextTheme,
                  index: state.currentCategoryIndex,
                  allThemes: state.allThemes,
                  allThemeNames: state.allThemeNames,
                  themeName: nextThemeName,
                ),
              );
            }
          }

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
          final followed = LocalActionsState.getAdvisorFollowed(
            e.advisorId,
            e.isFollowed,
          );
          unawaited(
            repository.followAdvisor(
              LocalActionsState.getAdvisorFollowed(
                e.advisorId,
                e.isFollowed,
              ),
              e.advisorId,
            ),
          );
          emit(
            state.copyWith(
              mainVideos: state.mainVideos.map((video) {
                if (video.advisorId == e.advisorId) {
                  return video.copyWith(
                    isFollowed: !followed,
                  );
                } else {
                  return video;
                }
              }).toList(),
            ),
          );
          LocalActionsState.setAdvisorFollowed(
            e.advisorId,
            !e.isFollowed,
          );
        } else if (state.currentContext == ReelContext.profile) {
          final followed = LocalActionsState.getAdvisorFollowed(
            e.advisorId,
            e.isFollowed,
          );
          unawaited(
            repository.followAdvisor(
              followed,
              e.advisorId,
            ),
          );
          emit(
            state.copyWith(
              profileVideos: state.profileVideos.map((video) {
                if (video.advisorId == e.advisorId) {
                  return video.copyWith(
                    isFollowed: !followed,
                  );
                } else {
                  return video;
                }
              }).toList(),
            ),
          );
          LocalActionsState.setAdvisorFollowed(
            e.advisorId,
            !e.isFollowed,
          );
        } else if (state.currentContext == ReelContext.liveStream) {
          final followed = LocalActionsState.getAdvisorFollowed(
            e.advisorId,
            e.isFollowed,
          );
          unawaited(
            repository.followAdvisor(
              followed,
              e.advisorId,
            ),
          );
          emit(
            state.copyWith(
              liveVideo: state.liveVideo.map((video) {
                if (video.advisorId == e.advisorId) {
                  return video.copyWith(
                    isFollowed: !followed,
                  );
                } else {
                  return video;
                }
              }).toList(),
            ),
          );
          LocalActionsState.setAdvisorFollowed(
            e.advisorId,
            !e.isFollowed,
          );
        }
        _analyticsService.track(
          eventName: AnalyticsEvents.shortsFollow,
          properties: {
            "expert name": state.mainVideos[state.focusedIndex].author,
            "shorts title": state.currentVideos.isNotEmpty &&
                    state.focusedIndex < state.currentVideos.length
                ? state.currentVideos[state.focusedIndex].title
                : 'Default Title',
            "shorts category": state.categories.isNotEmpty &&
                    state.currentCategoryIndex < state.categories.length
                ? state.categories[state.currentCategoryIndex]
                : 'Default Category',
            "shorts video list":
                state.theme.isNotEmpty ? state.theme : 'Default Theme',
          },
        );
      },
      saveVideo: (e) async {
        if (state.currentContext == ReelContext.main) {
          final videoExistsInMainList =
              state.mainVideos.any((video) => video.id == e.videoId);
          if (videoExistsInMainList) {
            final saved = LocalActionsState.getVideoSaved(
              e.videoId,
              e.isSaved,
            );
            final res = await repository.addSave(
              saved,
              e.videoId,
              e.theme,
              e.category,
            );
            if (res.isSuccess()) {
              emit(
                state.copyWith(
                  mainVideos: state.mainVideos.map((video) {
                    if (video.id == e.videoId) {
                      if ((AppState.delegate!.currentConfiguration?.path ??
                                  '') !=
                              '/shorts-internal' &&
                          AppState.screenStack.last == ScreenItem.dialog) {
                        AppState.backButtonDispatcher!.didPopRoute();
                        if (saved) {
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
                      }
                      return video.copyWith(
                        isSaved: !saved,
                      );
                    } else {
                      return video;
                    }
                  }).toList(),
                ),
              );
            }
          } else {
            final saved = LocalActionsState.getVideoSaved(
              e.videoId,
              e.isSaved,
            );
            final res = await repository.addSave(
              saved,
              e.videoId,
              e.theme,
              e.category,
            );
            if (res.isSuccess()) {
              await AppState.backButtonDispatcher!.didPopRoute();
              if (saved) {
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
            }
          }
        } else {
          final saved = LocalActionsState.getVideoSaved(
            e.videoId,
            e.isSaved,
          );
          final res = await repository.addSave(
            saved,
            e.videoId,
            e.theme,
            e.category,
          );
          if (res.isSuccess()) {
            await AppState.backButtonDispatcher!.didPopRoute();
            if (saved) {
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
          }
        }
        log('🚀🚀🚀 Video saved');
      },
      likeVideo: (e) async {
        _analyticsService.track(
          eventName: AnalyticsEvents.shortsLiked,
          properties: {
            "shorts title": state.currentVideos.isNotEmpty &&
                    state.focusedIndex < state.currentVideos.length
                ? state.currentVideos[state.focusedIndex].title
                : 'Default Title',
            "shorts category": state.categories.isNotEmpty &&
                    state.currentCategoryIndex < state.categories.length
                ? state.categories[state.currentCategoryIndex]
                : 'Default Category',
            "shorts video list":
                state.theme.isNotEmpty ? state.theme : 'Default Theme',
          },
        );
        final UserService userService = locator<UserService>();
        final String userName = (userService.baseUser!.kycName != null &&
                    userService.baseUser!.kycName!.isNotEmpty
                ? userService.baseUser!.kycName
                : userService.baseUser!.name) ??
            "N/A";
        final liked = LocalActionsState.getVideoLiked(
          e.videoId,
          e.isLiked,
        );
        await LocalActionsState.setVideoLiked(e.videoId, !liked);
        if (state.currentContext == ReelContext.main) {
          emit(
            state.copyWith(
              mainVideos: state.mainVideos.map((video) {
                if (video.id == e.videoId) {
                  unawaited(
                    repository.addLike(
                      liked,
                      e.videoId,
                      userName,
                    ),
                  );
                  return video.copyWith(
                    isVideoLikedByUser: !liked,
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
                      liked,
                      e.videoId,
                      userName,
                    ),
                  );
                  return video.copyWith(
                    isVideoLikedByUser: !liked,
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
                      liked,
                      e.videoId,
                      userName,
                    ),
                  );
                  return video.copyWith(
                    isVideoLikedByUser: !liked,
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
          if (state.livePageController != null &&
              state.livePageController!.hasClients) {
            state.livePageController!.dispose();
          }
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
        }
        if (state.mainPageController != null &&
            state.mainPageController.hasClients) {
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
    _playControllerAtIndex(index, muted);
    _initializeControllerAtIndex(index + 1, muted);
  }

  void _playPrevious(int index, bool muted) {
    _stopControllerAtIndex(index + 1);
    _disposeControllerAtIndex(index + 2);
    _playControllerAtIndex(index, muted);
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
      log('🚀🚀🚀 INITIALIZED $index for context ${state.currentContext}');
    }
  }

  void _addProgressListener(VideoPlayerController controller, String videoId) {
    late VoidCallback listener;

    listener = () {
      final duration = controller.value.duration;
      final position = controller.value.position;

      if (duration.inMilliseconds > 0 && position.inMilliseconds >= 3 * 1000) {
        // Remove this specific listener to prevent repeated events
        controller.removeListener(listener);

        // Dispatch the event that 3sec has been watched
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
          position.inMilliseconds >= duration.inMilliseconds * 0.50) {
        // Remove this specific listener to prevent repeated events
        controller.removeListener(listener);

        // Dispatch the event that 50% has been watched
        add(PreloadEvent.updateSeen(videoId: videoId));
        AnalyticsRetryManager.queueAnalyticsEvent(
          videoId: videoId,
          interaction: InteractionType.watched,
          theme: state.theme,
          category: state.categories[state.currentCategoryIndex],
        );
      }
    };

    // Add the listener to the controller
    controller.addListener(listener);
  }

  void _playControllerAtIndex(int index, bool muted) {
    if (state.currentVideos.length > index && index >= 0) {
      final controller = state.currentContext == ReelContext.main
          ? state.controllers[index]
          : state.profileControllers[index];
      if (controller?.value.volume == 0 && !muted) {
        controller?.setVolume(
          1.0,
        );
      } else if (controller?.value.volume == 1 && muted) {
        controller?.setVolume(
          0.0,
        );
      }
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
      // Only track analytics for main context
      if (state.currentContext == ReelContext.main && controller != null) {
        final currentVideo = state.mainVideos[index];
        trackAnalytics(
          controller,
          currentVideo.id,
          state.theme,
          state.categories[state.currentCategoryIndex],
        );
      }
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
    }
    if (state.profilePageController != null &&
        state.profilePageController.hasClients) {
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
    }
    if (state.mainPageController != null &&
        state.mainPageController.hasClients) {
      state.mainPageController.dispose();
    }
    state.controllers.clear(); // Clear the map after disposing all controllers

    // Stop and dispose all controllers in the profile feed
    for (final entry in state.profileControllers.entries) {
      final controller = entry.value;
      await controller.pause();
      await controller.seekTo(const Duration());
      await controller.dispose();
    }
    if (state.profilePageController != null &&
        state.profilePageController.hasClients) {
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
