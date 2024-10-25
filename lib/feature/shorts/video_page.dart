import 'dart:developer';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/expertDetails/expert_profile.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_detection/keyboard_detection.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

import 'src/bloc/preload_bloc.dart';
import 'src/service/comment_data.dart';
import 'src/widgets/expandable_widget.dart';

class ShortsVideoPage extends StatelessWidget {
  const ShortsVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (_, child) {
        return BlocBuilder<PreloadBloc, PreloadState>(
          builder: (context, state) {
            return PageView.builder(
              itemCount: state.videos.length,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) =>
                  BlocProvider.of<PreloadBloc>(context, listen: false)
                      .add(PreloadEvent.onVideoIndexChanged(index)),
              itemBuilder: (context, index) {
                // Is at end and isLoading
                final bool isLoading =
                    state.isLoading && index == state.videos.length - 1;

                return VideoWidget(
                  isLoading: isLoading,
                  controller: state.controllers[index]!,
                  userName: state.videos[index].author,
                  videoTitle: state.videos[index].title,
                  onShare: () => print('Share clicked'),
                  onLike: () {
                    BlocProvider.of<PreloadBloc>(
                      context,
                      listen: false,
                    ).add(
                      PreloadEvent.likeVideo(
                        videoId: state.videos[index].id,
                      ),
                    );
                  },
                  onCommented: (comment) {
                    BlocProvider.of<PreloadBloc>(
                      context,
                      listen: false,
                    ).add(
                      PreloadEvent.addComment(
                        videoId: state.videos[index].id,
                        comment: comment,
                      ),
                    );
                  },
                  onBook: () {
                    AppState.delegate!.appState.currentAction = PageAction(
                      page: ExpertDetailsPageConfig,
                      state: PageState.addWidget,
                      widget: ExpertsDetailsView(
                        advisorID: state.videos[index].author,
                      ),
                    );
                  },
                  showUserName: true,
                  showVideoTitle: true,
                  showShareButton: true,
                  showLikeButton: true,
                  showBookButton: true,
                  comments: state.videoComments[state.videos[index].id],
                  isLikedByUser: state.videos[index].isVideoLikedByUser,
                );
              },
            );
          },
        );
      },
    );
  }
}

class VideoWidget extends StatefulWidget {
  final bool isLoading;
  final VideoPlayerController controller;
  final String userName;
  final String videoTitle;
  final List<CommentData>? comments;
  final bool showUserName;
  final bool showVideoTitle;
  final bool showShareButton;
  final bool showLikeButton;
  final bool showBookButton;
  final VoidCallback onShare;
  final VoidCallback onLike;
  final VoidCallback onBook;
  final Function(String comment) onCommented;
  final bool isLikedByUser;

  const VideoWidget({
    required this.isLoading,
    required this.controller,
    required this.userName,
    required this.videoTitle,
    required this.isLikedByUser,
    required this.onCommented,
    required this.onShare,
    required this.onLike,
    required this.onBook,
    this.comments = const [],
    this.showUserName = true,
    this.showVideoTitle = true,
    this.showShareButton = true,
    this.showLikeButton = true,
    this.showBookButton = true,
    super.key,
  });

  @override
  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _iconPositionAnimation;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  double _videoProgress = 0;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _iconPositionAnimation =
        Tween<double>(begin: 120.h, end: 210.h).animate(_animationController)
          ..addListener(() {
            // setState(() {});
          });
    widget.controller.addListener(() {
      if (mounted) {
        // setState(() {
          _videoProgress = widget.controller.value.position.inSeconds /
              widget.controller.value.duration.inSeconds;
        // });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _commentController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(child: VideoPlayer(widget.controller)),
        if (widget.showUserName)
          Positioned(
            top: 15.h,
            left: 20.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                color: Colors.black45,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 12.sp,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    widget.userName,
                    style: GoogleFonts.sourceSans3(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (!_isKeyboardVisible)
          Positioned(
            bottom: _iconPositionAnimation.value,
            right: 10.w,
            child: _buildIconColumn(
              widget.onShare,
              widget.onLike,
              widget.onBook,
              widget.isLikedByUser,
            ),
          ),
        if (!_isKeyboardVisible)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            bottom: _iconPositionAnimation.value,
            left: 15.w,
            child: _buildComments(_scrollController),
          ),
        if (!_isKeyboardVisible)
          Positioned(
            bottom: 70.h,
            child: ExpandableWidget(
              title: widget.videoTitle,
              leadingIcon: Icons.info,
              expandedText:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ",
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              onExpansionChanged: _toggleExpansion,
            ),
          ),
        Positioned(
          bottom: _isKeyboardVisible
              ? MediaQuery.of(context).viewInsets.bottom
              : 10.h,
          child: SizedBox(
            width: .95.sw,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _commentController,
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  decoration: InputDecoration(
                    hintText: 'Add a comment',
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                      onPressed: () {
                        if (_commentController.text.trim() != '') {
                          widget.onCommented(_commentController.text.trim());
                          _commentController.clear();
                        }
                      },
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
                  ),
                  onSubmitted: (val) {
                    // if (_commentController.text.trim() != '') {
                    //   widget.onCommented(_commentController.text.trim());
                    //   _commentController.clear();
                    // }
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                if (!_isKeyboardVisible)
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    child: LinearProgressIndicator(
                      value: _videoProgress,
                      backgroundColor: Colors.grey[800],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: AnimatedCrossFade(
            alignment: Alignment.center,
            sizeCurve: Curves.decelerate,
            duration: const Duration(milliseconds: 400),
            firstChild: const Padding(
              padding: EdgeInsets.all(10.0),
              child: CupertinoActivityIndicator(
                color: Colors.white,
                radius: 8,
              ),
            ),
            secondChild: const SizedBox(),
            crossFadeState: widget.isLoading
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
        ),
      ],
    );
  }

  Widget _buildIconColumn(
    final VoidCallback onShare,
    final VoidCallback onLike,
    final VoidCallback onBook,
    final bool isLiked,
  ) {
    return Column(
      children: [
        if (widget.showShareButton)
          Column(
            children: [
              IconButton(
                icon: AppImage(
                  Assets.video_share,
                  color: Colors.white,
                  height: 20.r,
                  width: 20.r,
                ),
                onPressed: onShare,
              ),
              Text(
                'Share',
                style: GoogleFonts.sourceSans3(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        if (widget.showLikeButton)
          Column(
            children: [
              IconButton(
                icon: AppImage(
                  Assets.video_like,
                  color: isLiked ? Colors.red : Colors.white,
                  height: 20.r,
                  width: 20.r,
                ),
                onPressed: onLike,
              ),
              Text(
                'Like',
                style: GoogleFonts.sourceSans3(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        if (widget.showBookButton)
          Column(
            children: [
              IconButton(
                icon: AppImage(
                  Assets.book_call,
                  color: Colors.white,
                  height: 20.r,
                  width: 20.r,
                ),
                onPressed: onBook,
              ),
              Text(
                'Book a call',
                style: GoogleFonts.sourceSans3(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildComments(ScrollController scrollController) {
    void scrollToEnd() {
      if (scrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => scrollController.jumpTo(
            scrollController.position.maxScrollExtent,
          ),
        );
      }
    }

    scrollToEnd();
    return SizedBox(
      width: 240.w,
      height: (widget.comments == null || widget.comments!.isEmpty) ? 0 : 130.h,
      child: (widget.comments == null || widget.comments!.isEmpty)
          ? const SizedBox.shrink()
          : ListView.builder(
              // reverse: true,
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.comments!.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10.r,
                          backgroundImage:
                              NetworkImage(widget.comments![index].videoId),
                          backgroundColor: Colors.green,
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.comments![index].name,
                                  style: GoogleFonts.sourceSans3(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  child: Icon(
                                    Icons.circle,
                                    size: 4.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  timeago.format(
                                    DateTime.parse(
                                      widget.comments![index].createdAt,
                                    ),
                                  ),
                                  style: GoogleFonts.sourceSans3(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.comments![index].comment,
                              style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                );
              },
            ),
    );
  }
}
