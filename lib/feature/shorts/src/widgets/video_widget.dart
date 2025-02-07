import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/feature/shorts/flutter_preload_videos.dart';
import 'package:felloapp/feature/shorts/src/service/comment_data.dart';
import 'package:felloapp/feature/shorts/src/widgets/expandable_widget.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_detection/keyboard_detection.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

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
  final bool commentsVisibility;
  final VoidCallback onShare;
  final VoidCallback onLike;
  final VoidCallback onBook;
  final VoidCallback onCommentToggle;
  final Function(String comment) onCommented;
  final Function(bool isKeyBoardOpen) updateKeyboardState;
  final bool isLikedByUser;
  final bool isKeyBoardOpen;
  final ReelContext currentContext;

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
    required this.commentsVisibility,
    required this.onCommentToggle,
    required this.currentContext,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
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

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollController.positions.isNotEmpty
            ? _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              )
            : null,
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
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: widget.controller.value.aspectRatio,
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: widget.controller.value.size.width,
                  height: widget.controller.value.size.height,
                  child: VideoPlayer(widget.controller),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    UiConstants.kTextColor4.withOpacity(.8),
                    UiConstants.kTextColor4.withOpacity(0),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
          ),
          if (widget.showUserName)
            Positioned(
              top: 10.h,
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
            child: Visibility(
              visible: !widget.isKeyBoardOpen,
              replacement: const SizedBox.shrink(),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: widget.isKeyBoardOpen ? 0 : 1,
                child: _buildIconColumn(
                  widget.onShare,
                  widget.onLike,
                  widget.onBook,
                  widget.onCommentToggle,
                  widget.isLikedByUser,
                  widget.commentsVisibility,
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            bottom: _iconPositionAnimation.value,
            left: 15.w,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              constraints: BoxConstraints(
                maxWidth: 240.w,
              ),
              height: (widget.comments == null ||
                      widget.comments!.isEmpty ||
                      !widget.commentsVisibility ||
                      widget.isKeyBoardOpen)
                  ? 0
                  : 130.h,
              child: _buildComments(_scrollController),
            ),
          ),
          Positioned(
            bottom: widget.isKeyBoardOpen &&
                    widget.currentContext != ReelContext.main
                ? 55.h
                : 70.h,
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
                ? widget.currentContext != ReelContext.main
                    ? MediaQuery.of(context).viewInsets.bottom
                    : MediaQuery.of(context).viewInsets.bottom - 50.h
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
                            _scrollToEnd();
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
                      child: VideoProgressIndicator(
                        widget.controller,
                        padding: EdgeInsets.zero,
                        colors: const VideoProgressColors(
                          playedColor: UiConstants.kTextColor,
                          backgroundColor: Colors.grey,
                        ),
                        allowScrubbing: true,
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
    final VoidCallback onToggleComment,
    final bool isLiked,
    final bool commentVisibility,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: AppImage(
                commentVisibility ? Assets.remove_comment : Assets.add_comment,
                color: Colors.white,
                height: 20.r,
                width: 20.r,
              ),
              onPressed: onToggleComment,
            ),
            Text(
              'Comments',
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
    return (widget.comments == null || widget.comments!.isEmpty)
        ? const SizedBox.shrink()
        : SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
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
                                      widget.comments![index].avatarId !=
                                          'CUSTOM'
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
                                padding: EdgeInsets.only(
                                  bottom: SizeConfig.padding2,
                                ),
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
                                              widget.comments![index].createdAt,
                                            ),
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
              ],
            ),
          );
  }
}
