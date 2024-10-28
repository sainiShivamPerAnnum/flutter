import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
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

class ShortsVideoPage extends StatefulWidget {
  const ShortsVideoPage({super.key});

  @override
  State<ShortsVideoPage> createState() => _ShortsVideoPageState();
}

class _ShortsVideoPageState extends State<ShortsVideoPage> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (_, child) {
        return BlocBuilder<PreloadBloc, PreloadState>(
          builder: (context, state) {
            final List<VideoData> videos =
                BlocProvider.of<PreloadBloc>(context).currentVideos;
            return PageView.builder(
              itemCount: videos.length,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) =>
                  BlocProvider.of<PreloadBloc>(context, listen: false)
                      .add(PreloadEvent.onVideoIndexChanged(index)),
              itemBuilder: (context, index) {
                // Is at end and isLoading
                final bool isLoading =
                    state.isLoading && index == videos.length - 1;

                return state.controllers[index] == null
                    ? const FullScreenLoader()
                    : VideoWidget(
                        isLoading: isLoading,
                        controller: state.controllers[index]!,
                        userName: videos[index].author,
                        videoTitle: videos[index].title,
                        description: videos[index].description,
                        advisorId: videos[index].advisorId,
                        isKeyBoardOpen: state.keyboardVisible,
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
                        onShare: () => print('Share clicked'),
                        onLike: () {
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
                          BaseUtil.openBookAdvisorSheet(
                            advisorId: videos[index].advisorId,
                            advisorName: videos[index].author,
                            isEdit: false,
                          );
                        },
                        showUserName: true,
                        showVideoTitle: true,
                        showShareButton: true,
                        showLikeButton: true,
                        showBookButton: true,
                        comments: state.videoComments[videos[index].id],
                        isLikedByUser: videos[index].isVideoLikedByUser,
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
  final String description;
  final String advisorId;
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
  final Function(bool isKeyBoardOpen) updateKeyboardState;
  final bool isLikedByUser;
  final bool isKeyBoardOpen;

  const VideoWidget({
    required this.isLoading,
    required this.controller,
    required this.userName,
    required this.videoTitle,
    required this.isLikedByUser,
    required this.onCommented,
    required this.onShare,
    required this.onLike,
    required this.description,
    required this.advisorId,
    required this.onBook,
    required this.updateKeyboardState,
    this.comments = const [],
    this.showUserName = true,
    this.showVideoTitle = true,
    this.showShareButton = true,
    this.showLikeButton = true,
    this.showBookButton = true,
    this.isKeyBoardOpen = false,
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
            setState(() {});
          });
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _videoProgress = widget.controller.value.position.inSeconds /
              widget.controller.value.duration.inSeconds;
        });
      }
    });
    scrollToEnd();
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

  void scrollToEnd() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDetection(
      controller: KeyboardDetectionController(
        onChanged: (value) {
          widget.updateKeyboardState(value == KeyboardState.visible);
        },
      ),
      child: Stack(
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
          Positioned(
            bottom: _iconPositionAnimation.value,
            right: 10.w,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: widget.isKeyBoardOpen ? 0 : 1,
              child: _buildIconColumn(
                widget.onShare,
                widget.onLike,
                widget.onBook,
                widget.isLikedByUser,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            bottom: _iconPositionAnimation.value,
            left: 15.w,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: widget.isKeyBoardOpen ? 0 : 1,
              child: _buildComments(_scrollController),
            ),
          ),
          Positioned(
            bottom: 70.h,
            child: ExpandableWidget(
              title: widget.videoTitle,
              leadingIcon: Icons.info,
              expandedText: widget.description,
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              onExpansionChanged: _toggleExpansion,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            bottom: widget.isKeyBoardOpen
                ? MediaQuery.of(context).viewInsets.bottom - 50.h
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
                            scrollToEnd();
                            FocusScope.of(context).unfocus();
                          }
                        },
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  if (!widget.isKeyBoardOpen)
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      child: LinearProgressIndicator(
                        value: widget.controller.value.position.inSeconds / ~30,
                        backgroundColor: Colors.grey[800],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
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
    return SizedBox(
      width: 240.w,
      height: (widget.comments == null || widget.comments!.isEmpty) ? 0 : 130.h,
      child: (widget.comments == null || widget.comments!.isEmpty)
          ? const SizedBox.shrink()
          : ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.comments!.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: SizeConfig.padding10,
                          backgroundColor: Colors.black,
                          child: widget.comments![index].avatarId != '' &&
                                  widget.comments![index].avatarId != 'CUSTOM'
                              ? ClipOval(
                                  child: SizedBox(
                                    width: 2 * SizeConfig.padding10,
                                    height: 2 * SizeConfig.padding10,
                                    child: AppImage(
                                      "assets/vectors/userAvatars/${widget.comments![index].avatarId}.svg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : (widget.comments![index].avatarId != '' &&
                                      widget.comments![index].avatarId ==
                                          'CUSTOM' &&
                                      widget.comments![index].dpUrl != '')
                                  ? ClipOval(
                                      child: SizedBox(
                                        width: 2 * SizeConfig.padding10,
                                        height: 2 * SizeConfig.padding10,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              widget.comments![index].dpUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : ClipOval(
                                      child: SizedBox(
                                        width: 2 * SizeConfig.padding10,
                                        height: 2 * SizeConfig.padding10,
                                        child: Image.asset(
                                          Assets.profilePic,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                        ),
                        SizedBox(
                          width: SizeConfig.padding6,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: SizeConfig.padding2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.comments![index].name,
                                      style: TextStyles.sourceSansSB.body4,
                                      maxLines: 1,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.padding4,
                                      ),
                                      child: const Icon(
                                        Icons.circle,
                                        size: 4,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      timeago.format(
                                        DateTime.parse(
                                            widget.comments![index].createdAt),
                                      ),
                                      style: TextStyles.sourceSans.body4,
                                    ),
                                  ],
                                ),
                                Text(
                                  widget.comments![index].comment,
                                  style: TextStyles.sourceSans.body4,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
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
