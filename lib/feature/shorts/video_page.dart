import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:felloapp/feature/shorts/src/widgets/all_viewed_sheet.dart';
import 'package:felloapp/feature/shorts/src/widgets/dot_indicator.dart';
import 'package:felloapp/feature/shorts/src/widgets/loadinng_shimmer.dart';
import 'package:felloapp/feature/shorts/src/widgets/video_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import 'src/bloc/preload_bloc.dart';

class ShortsVideoPage extends StatefulWidget {
  final List<String> categories;
  const ShortsVideoPage({
    required this.categories,
    super.key,
  });

  @override
  State<ShortsVideoPage> createState() => _ShortsVideoPageState();
}

class _ShortsVideoPageState extends State<ShortsVideoPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _swipeAnimationController;
  Animation<double>? _swipeAnimation;
  double _horizontalDrag = 0.0;
  final double swipeThreshold = 100.0;

  @override
  void initState() {
    super.initState();
    _swipeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _swipeAnimationController?.dispose();
    super.dispose();
  }

  void _animateSwipe({required double endOffset, VoidCallback? onCompleted}) {
    _swipeAnimation =
        Tween<double>(begin: _horizontalDrag, end: endOffset).animate(
      CurvedAnimation(
        parent: _swipeAnimationController!,
        curve: Curves.easeOut,
      ),
    )..addListener(() {
            setState(() {
              _horizontalDrag = _swipeAnimation!.value;
            });
          });
    _swipeAnimationController!.forward(from: 0).then((_) {
      _swipeAnimationController!.reset();
      if (onCompleted != null) {
        onCompleted();
      }
    });
  }

  void _onDragEnd() {
    if (_horizontalDrag.abs() > swipeThreshold) {
      final direction = _horizontalDrag > 0 ? 1 : -1;
      _animateSwipe(
        endOffset: direction * 500.0,
        onCompleted: () {
          final preloadBloc = BlocProvider.of<PreloadBloc>(context);
          preloadBloc.add(
            PreloadEvent.getCategoryVideos(
              initailVideo: null,
              direction: direction,
              completer: Completer<void>(),
            ),
          );
          setState(() {
            _horizontalDrag = 0;
          });
        },
      );
    } else {
      _animateSwipe(
        endOffset: 0.0,
        onCompleted: () {
          setState(() {
            _horizontalDrag = 0.0;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<PreloadBloc, PreloadState>(
        listenWhen: (previous, current) =>
            previous.currentContext != current.currentContext &&
            current.currentContext == ReelContext.main,
        listener: (context, state) {
          final mainPageController = state.mainPageController;
          final focusedIndex = state.focusedIndex;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mainPageController.jumpToPage(focusedIndex);
          });
        },
        child: BlocBuilder<PreloadBloc, PreloadState>(
          builder: (context, state) {
            final List<VideoData> videos = state.currentVideos;
            final Map<int, VideoPlayerController> activeControllers =
                state.currentContext == ReelContext.liveStream
                    ? {
                        0: state.liveStreamController!,
                      }
                    : state.currentContext == ReelContext.main
                        ? state.controllers
                        : state.profileControllers;
            final PageController pageController =
                state.currentContext == ReelContext.liveStream
                    ? state.livePageController!
                    : state.currentContext == ReelContext.main
                        ? state.mainPageController
                        : state.profilePageController;
            if (state.errorMessage != null) {
              return const NewErrorPage();
            }
            return KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) {
                if (event is KeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.audioVolumeUp ||
                      event.logicalKey == LogicalKeyboardKey.audioVolumeDown) {
                    if (state.muted) {
                      final preloadBloc =
                          BlocProvider.of<PreloadBloc>(context, listen: false);
                      preloadBloc.add(const PreloadEvent.toggleVolume());
                    }
                    return;
                  }
                }
              },
              child: Stack(
                children: [
                  if (!state.showComments) const ShimmerReelsButtons(),
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (widget.categories.isNotEmpty && !state.showComments) {
                        setState(() {
                          _horizontalDrag += details.delta.dx;
                        });
                      }
                    },
                    onVerticalDragEnd: (details) {
                      if (details.velocity.pixelsPerSecond.dy > 0) {
                        final currentPage = pageController.page ?? 0;
                        if (currentPage == state.mainVideos.length - 1 &&
                            state.currentContext == ReelContext.main) {
                          BaseUtil.openModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: true,
                            isBarrierDismissible: true,
                            addToScreenStack: false,
                            backgroundColor: UiConstants.kBackgroundColor,
                            hapticVibrate: true,
                            content: AllShortsViewed(
                              category:
                                  state.categories[state.currentCategoryIndex],
                            ),
                          );
                        }
                      }
                    },
                    onHorizontalDragEnd: (details) {
                      if (widget.categories.isNotEmpty && !state.showComments) {
                        _onDragEnd();
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _swipeAnimationController!,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_horizontalDrag, 0),
                          child: child,
                        );
                      },
                      child: AnimatedOpacity(
                        opacity: videos.isNotEmpty ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.decelerate,
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: videos.length,
                          physics: state.keyboardVisible || state.showComments
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          onPageChanged: (index) {
                            BlocProvider.of<PreloadBloc>(context, listen: false)
                                .add(PreloadEvent.onVideoIndexChanged(index));
                          },
                          itemBuilder: (context, index) {
                            final bool isLoading =
                                state.isLoading && index == videos.length - 1;
                            return activeControllers[index] == null
                                ? const ShimmerReelsButtons()
                                : VideoWidget(
                                    isLoading: isLoading,
                                    expertProfileImage: '',
                                    controller: activeControllers[index]!,
                                    userName: videos[index].author,
                                    videoTitle: videos[index].title,
                                    description: videos[index].description,
                                    advisorId: videos[index].advisorId,
                                    isKeyBoardOpen: state.keyboardVisible,
                                    commentsVisibility: state.showComments,
                                    currentContext: state.currentContext,
                                    isFollowed: videos[index].isFollowed,
                                    isSaved: videos[index].isSaved,
                                    advisorImg: videos[index].advisorImg,
                                    onFollow: () {
                                      BlocProvider.of<PreloadBloc>(
                                        context,
                                        listen: false,
                                      ).add(
                                        PreloadEvent.followAdvisor(
                                          advisorId: videos[index].advisorId,
                                        ),
                                      );
                                    },
                                    onSaved: () {
                                      BlocProvider.of<PreloadBloc>(
                                        context,
                                        listen: false,
                                      ).add(
                                        PreloadEvent.saveVideo(
                                          videoId: videos[index].id,
                                          theme: state.theme,
                                          category: state.categories[
                                              state.currentCategoryIndex],
                                          isSaved: videos[index].isSaved,
                                        ),
                                      );
                                    },
                                    onCommentToggle: () {
                                      FocusScope.of(context).unfocus();
                                      BlocProvider.of<PreloadBloc>(
                                        context,
                                        listen: false,
                                      ).add(
                                        const PreloadEvent.toggleComments(),
                                      );
                                    },
                                    updateKeyboardState: (isKeyBoardOpen) {
                                      BlocProvider.of<PreloadBloc>(
                                        context,
                                        listen: false,
                                      ).add(
                                        PreloadEvent.updateKeyboardState(
                                          state: isKeyBoardOpen,
                                        ),
                                      );
                                    },
                                    onShare: () async {
                                      FocusScope.of(context).unfocus();
                                      if (state.isShareAlreadyClicked ==
                                          false) {
                                        BlocProvider.of<PreloadBloc>(
                                          context,
                                          listen: false,
                                        ).add(
                                          PreloadEvent.generateDynamicLink(
                                            videoId: videos[index].id,
                                          ),
                                        );
                                      }
                                    },
                                    onLike: () {
                                      FocusScope.of(context).unfocus();
                                      BlocProvider.of<PreloadBloc>(
                                        context,
                                        listen: false,
                                      ).add(
                                        PreloadEvent.likeVideo(
                                          videoId: videos[index].id,
                                        ),
                                      );
                                    },
                                    onCommented: (comment) {
                                      BlocProvider.of<PreloadBloc>(
                                        context,
                                        listen: false,
                                      ).add(
                                        PreloadEvent.addComment(
                                          videoId: videos[index].id,
                                          comment: comment,
                                        ),
                                      );
                                    },
                                    onBook: () {
                                      FocusScope.of(context).unfocus();
                                      BaseUtil.openBookAdvisorSheet(
                                        advisorId: videos[index].advisorId,
                                        advisorName: videos[index].author,
                                        isEdit: false,
                                      );
                                      locator<AnalyticsService>().track(
                                        eventName:
                                            AnalyticsEvents.shortsBookaCall,
                                        properties: {
                                          "shorts title": state
                                              .mainVideos[state.focusedIndex]
                                              .title,
                                          "shorts category": state.categories[
                                              state.currentCategoryIndex],
                                          "shorts video list": state.theme,
                                        },
                                      );
                                    },
                                    showUserName: videos[index].author != "",
                                    showVideoTitle: true,
                                    showShareButton: true,
                                    showLikeButton: true,
                                    showBookButton:
                                        videos[index].advisorId != "",
                                    comments: state
                                        .videoComments[videos[index].id]
                                        ?.reversed
                                        .toList(),
                                    isLikedByUser:
                                        videos[index].isVideoLikedByUser,
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (state.categories.isNotEmpty)
                    DotIndicatorRow(
                      currentPage: state.currentCategoryIndex,
                      totalPages: widget.categories.length,
                      categoryName: state.categories.isEmpty
                          ? ''
                          : state.categories[state.currentCategoryIndex],
                      muted: state.muted,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
