import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';

enum PlaybackState { pause, play, next, previous }

enum LoadState { loading, success, failure }

enum Direction { up, down, left, right }

class VerticalDragInfo {
  bool cancel = false;

  Direction? direction;

  void update(double primaryDelta) {
    Direction tmpDirection;

    tmpDirection = primaryDelta > 0 ? Direction.down : Direction.up;

    if (direction != null && tmpDirection != direction) {
      cancel = true;
    }

    direction = tmpDirection;
  }
}

class StoryController {
  final playbackNotifier = BehaviorSubject<PlaybackState>();

  void pause() {
    playbackNotifier.add(PlaybackState.pause);
  }

  void play() {
    playbackNotifier.add(PlaybackState.play);
  }

  void next() {
    playbackNotifier.add(PlaybackState.next);
  }

  void previous() {
    playbackNotifier.add(PlaybackState.previous);
  }

  void dispose() {
    playbackNotifier.close();
  }
}

class StoryItem {
  final Duration duration;
  bool shown;
  final Widget view;
  final Widget overlay;
  final String id;

  StoryItem(
    this.view, {
    required this.id,
    required this.duration,
    this.shown = false,
    this.overlay = const SizedBox.shrink(),
  });

  StoryItem.pageVideo(
    String url, {
    required StoryController controller,
    required this.id,
    this.duration = const Duration(seconds: 10),
    this.overlay = const SizedBox.shrink(),
    this.shown = false,
    Map<String, dynamic>? requestHeaders,
  }) : view = StoryVideo.url(
          url,
          storyController: controller,
          requestHeaders: requestHeaders,
        );
}

class StoryView extends StatefulWidget {
  final List<StoryItem?> storyItems;
  final VoidCallback? onComplete;
  final Function(Direction?)? onVerticalSwipeComplete;
  final ValueChanged<StoryItem>? onStoryShow;
  final bool repeat;
  final bool inline;
  final StoryController controller;
  final Color? indicatorColor;
  final Color? indicatorForegroundColor;
  final int initialIndex;

  const StoryView({
    required this.storyItems,
    required this.controller,
    super.key,
    this.onComplete,
    this.onStoryShow,
    this.repeat = false,
    this.inline = false,
    this.onVerticalSwipeComplete,
    this.indicatorColor,
    this.indicatorForegroundColor,
    this.initialIndex = 0,
  }) : assert(initialIndex <= storyItems.length - 1, 'Invalid entry index');

  @override
  State<StatefulWidget> createState() {
    return StoryViewState();
  }
}

class StoryViewState extends State<StoryView> with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _currentAnimation;
  Timer? _nextDebounce;

  StreamSubscription<PlaybackState>? _playbackSubscription;

  VerticalDragInfo? verticalDragInfo;

  StoryItem? get _currentStory {
    return widget.storyItems.firstWhereOrNull((it) => !it!.shown);
  }

  ({Widget view, Widget overlay}) get _currentView {
    var item = widget.storyItems.firstWhereOrNull((it) => !it!.shown);
    item ??= widget.storyItems.last;
    return (
      view: item?.view ?? const SizedBox.shrink(),
      overlay: item?.overlay ?? const SizedBox.shrink()
    );
  }

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.initialIndex; i++) {
      widget.storyItems[i]?.shown = true;
    }

    final firstPage = widget.storyItems.firstWhereOrNull((it) => !it!.shown);
    if (firstPage == null) {
      for (final it2 in widget.storyItems) {
        it2!.shown = false;
      }
    } else {
      final lastShownPos = widget.storyItems.indexOf(firstPage);
      widget.storyItems.sublist(lastShownPos).forEach((it) {
        it!.shown = false;
      });
    }

    _playbackSubscription =
        widget.controller.playbackNotifier.listen((playbackStatus) {
      switch (playbackStatus) {
        case PlaybackState.play:
          _removeNextHold();
          _animationController?.forward();
          break;

        case PlaybackState.pause:
          _holdNext();
          _animationController?.stop(canceled: false);
          break;

        case PlaybackState.next:
          _removeNextHold();
          _goForward();
          break;

        case PlaybackState.previous:
          _removeNextHold();
          _goBack();
          break;
      }
    });

    _play();
  }

  @override
  void dispose() {
    _clearDebounce();

    _animationController?.dispose();
    _playbackSubscription?.cancel();

    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _play() {
    _animationController?.dispose();

    final storyItem = widget.storyItems.firstWhere((it) {
      return !it!.shown;
    })!;

    if (widget.onStoryShow != null) {
      widget.onStoryShow!(storyItem);
    }

    _animationController =
        AnimationController(duration: storyItem.duration, vsync: this);

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        storyItem.shown = true;
        if (widget.storyItems.last != storyItem) {
          _beginPlay();
        } else {
          _onComplete();
        }
      }
    });

    _currentAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController!);

    widget.controller.play();
  }

  void _beginPlay() {
    setState(() {});
    _play();
  }

  void _onComplete() {
    if (widget.onComplete != null) {
      widget.controller.pause();
      widget.onComplete!();
    }

    if (widget.repeat) {
      for (final it in widget.storyItems) {
        it!.shown = false;
      }

      _beginPlay();
    }
  }

  void _goBack() {
    _animationController!.stop();

    if (_currentStory == null) {
      widget.storyItems.last!.shown = false;
    }

    if (_currentStory == widget.storyItems.first) {
      _beginPlay();
    } else {
      _currentStory!.shown = false;
      int lastPos = widget.storyItems.indexOf(_currentStory);
      final previous = widget.storyItems[lastPos - 1]!;

      previous.shown = false;

      _beginPlay();
    }
  }

  void _goForward() {
    if (_currentStory != widget.storyItems.last) {
      _animationController!.stop();

      final last = _currentStory;

      if (last != null) {
        last.shown = true;
        if (last != widget.storyItems.last) {
          _beginPlay();
        }
      }
    } else {
      _animationController!
          .animateTo(1.0, duration: const Duration(milliseconds: 10));
    }
  }

  void _clearDebounce() {
    _nextDebounce?.cancel();
    _nextDebounce = null;
  }

  void _removeNextHold() {
    _nextDebounce?.cancel();
    _nextDebounce = null;
  }

  void _holdNext() {
    _nextDebounce?.cancel();
    _nextDebounce = Timer(const Duration(milliseconds: 500), () {});
  }

  void _onTapClose() {
    AppState.backButtonDispatcher!.didPopRoute();
  }

  @override
  Widget build(BuildContext context) {
    final (:view, :overlay) = _currentView;
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          view,
          Align(
              alignment: Alignment.centerRight,
              heightFactor: 1,
              child: GestureDetector(
                onTapDown: (details) {
                  widget.controller.pause();
                },
                onTapCancel: () {
                  widget.controller.play();
                },
                onTapUp: (details) {
                  if (_nextDebounce?.isActive == false) {
                    widget.controller.play();
                  } else {
                    widget.controller.next();
                  }
                },
                onVerticalDragStart: widget.onVerticalSwipeComplete == null
                    ? null
                    : (details) {
                        widget.controller.pause();
                      },
                onVerticalDragCancel: widget.onVerticalSwipeComplete == null
                    ? null
                    : () {
                        widget.controller.play();
                      },
                onVerticalDragUpdate: widget.onVerticalSwipeComplete == null
                    ? null
                    : (details) {
                        verticalDragInfo ??= VerticalDragInfo();

                        verticalDragInfo!.update(details.primaryDelta!);
                      },
                onVerticalDragEnd: widget.onVerticalSwipeComplete == null
                    ? null
                    : (details) {
                        widget.controller.play();

                        if (!verticalDragInfo!.cancel &&
                            widget.onVerticalSwipeComplete != null) {
                          widget.onVerticalSwipeComplete!(
                              verticalDragInfo!.direction);
                        }

                        verticalDragInfo = null;
                      },
              )),
          Align(
            alignment: Alignment.centerLeft,
            heightFactor: 1,
            child: SizedBox(
                width: 70,
                child: GestureDetector(onTap: () {
                  widget.controller.previous();
                })),
          ),
          SafeArea(
            minimum: EdgeInsets.only(
              left: SizeConfig.pageHorizontalMargins,
              right: SizeConfig.pageHorizontalMargins,
              top: MediaQuery.of(context).padding.top + SizeConfig.padding8,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CachedNetworkImage(
                      imageUrl: Assets.logoWhite,
                      width: SizeConfig.padding40,
                    ),
                    InkWell(
                      onTap: _onTapClose,
                      child: Container(
                        height: SizeConfig.padding24,
                        width: SizeConfig.padding24,
                        decoration: BoxDecoration(
                          color: const Color(0xff161719),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.roundness5,
                          ),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: SizeConfig.padding16,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding12,
                ),
                PageBar(
                  widget.storyItems
                      .map((it) => PageData(it!.duration, it.shown))
                      .toList(),
                  _currentAnimation,
                  key: UniqueKey(),
                  indicatorColor: widget.indicatorColor,
                  indicatorForegroundColor: widget.indicatorForegroundColor,
                ),
              ],
            ),
          ),
          overlay,
        ],
      ),
    );
  }
}

class PageData {
  Duration duration;
  bool shown;

  PageData(this.duration, this.shown);
}

class PageBar extends StatefulWidget {
  final List<PageData> pages;
  final Animation<double>? animation;
  final Color? indicatorColor;
  final Color? indicatorForegroundColor;

  const PageBar(
    this.pages,
    this.animation, {
    this.indicatorColor,
    this.indicatorForegroundColor,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PageBarState();
  }
}

class PageBarState extends State<PageBar> {
  double spacing = 4;

  @override
  void initState() {
    super.initState();

    int count = widget.pages.length;
    spacing = (count > 15) ? 1 : ((count > 10) ? 2 : 4);

    widget.animation!.addListener(() {
      setState(() {});
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isPlaying(PageData page) {
    return widget.pages.firstWhereOrNull((it) => !it.shown) == page;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.pages.map((it) {
        return Expanded(
          child: Container(
            padding:
                EdgeInsets.only(right: widget.pages.last == it ? 0 : spacing),
            child: StoryProgressIndicator(
              isPlaying(it) ? widget.animation!.value : (it.shown ? 1 : 0),
              indicatorHeight: 4,
              indicatorColor: widget.indicatorColor,
              indicatorForegroundColor: widget.indicatorForegroundColor,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class VideoLoader {
  String url;

  File? videoFile;

  Map<String, dynamic>? requestHeaders;

  LoadState state = LoadState.loading;

  VideoLoader(this.url, {this.requestHeaders});

  void loadVideo(VoidCallback onComplete) {
    if (videoFile != null) {
      state = LoadState.success;
      onComplete();
    }

    final fileStream = DefaultCacheManager()
        .getFileStream(url, headers: requestHeaders as Map<String, String>?);

    fileStream.listen((fileResponse) {
      if (fileResponse is FileInfo) {
        if (videoFile == null) {
          state = LoadState.success;
          videoFile = fileResponse.file;
          onComplete();
        }
      }
    });
  }
}

class StoryVideo extends StatefulWidget {
  final StoryController? storyController;
  final VideoLoader videoLoader;

  const StoryVideo(
    this.videoLoader, {
    this.storyController,
    super.key,
  });

  StoryVideo.url(
    String url, {
    super.key,
    this.storyController,
    Map<String, dynamic>? requestHeaders,
  }) : videoLoader = VideoLoader(url, requestHeaders: requestHeaders);

  @override
  State<StatefulWidget> createState() {
    return StoryVideoState();
  }
}

class StoryVideoState extends State<StoryVideo> {
  Future<void>? playerLoader;

  StreamSubscription? _streamSubscription;

  VideoPlayerController? playerController;

  @override
  void initState() {
    super.initState();

    widget.storyController!.pause();

    widget.videoLoader.loadVideo(() {
      if (widget.videoLoader.state == LoadState.success) {
        playerController =
            VideoPlayerController.file(widget.videoLoader.videoFile!);

        playerController!.initialize().then((v) {
          setState(() {});
          widget.storyController!.play();
        });

        if (widget.storyController != null) {
          _streamSubscription =
              widget.storyController!.playbackNotifier.listen((playbackState) {
            if (playbackState == PlaybackState.pause) {
              playerController!.pause();
            } else {
              playerController!.play();
            }
          });
        }
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    playerController?.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  Widget getContentView() {
    if (widget.videoLoader.state == LoadState.success &&
        playerController!.value.isInitialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: playerController!.value.aspectRatio,
          child: VideoPlayer(playerController!),
        ),
      );
    }

    return widget.videoLoader.state == LoadState.loading
        ? const Center(
            child: SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
          )
        : const Center(
            child: Text(
            "Media failed to load.",
            style: TextStyle(
              color: Colors.white,
            ),
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: getContentView(),
    );
  }
}

class StoryProgressIndicator extends StatelessWidget {
  final double value;
  final double indicatorHeight;
  final Color? indicatorColor;
  final Color? indicatorForegroundColor;

  const StoryProgressIndicator(
    this.value, {
    super.key,
    this.indicatorHeight = 5,
    this.indicatorColor,
    this.indicatorForegroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromHeight(
        indicatorHeight,
      ),
      foregroundPainter: IndicatorOval(
        indicatorForegroundColor ?? Colors.white.withOpacity(0.8),
        value,
      ),
      painter: IndicatorOval(
        indicatorColor ?? Colors.white.withOpacity(0.4),
        1.0,
      ),
    );
  }
}

class IndicatorOval extends CustomPainter {
  final Color color;
  final double widthFactor;

  const IndicatorOval(
    this.color,
    this.widthFactor,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width * widthFactor, size.height),
        const Radius.circular(3),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant IndicatorOval oldDelegate) =>
      oldDelegate.color != color || oldDelegate.widthFactor != widthFactor;
}
