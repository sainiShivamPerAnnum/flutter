import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
// import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/expertDetails/expert_profile.dart';
// import 'package:felloapp/feature/expertDetails/expert_profile.dart';
import 'package:felloapp/feature/shorts/flutter_preload_videos.dart';
import 'package:felloapp/feature/shorts/src/service/comment_data.dart';
import 'package:felloapp/feature/shorts/src/widgets/expandable_widget.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
// import 'package:felloapp/navigator/app_state.dart';
// import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_detection/keyboard_detection.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final bool isLoading;
  final VideoPlayerController controller;
  final String userName;
  final String expertProfileImage;
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
  final VoidCallback onSaved;
  final VoidCallback onFollow;
  final VoidCallback onCommentToggle;
  final Function(String comment) onCommented;
  final Function(bool isKeyBoardOpen) updateKeyboardState;
  final bool isLikedByUser;
  final bool isKeyBoardOpen;
  final ReelContext currentContext;
  final bool isFollowed;
  final bool isSaved;
  final String advisorImg;
  final int focusedIndex;

  const VideoWidget({
    required this.isLoading,
    required this.controller,
    required this.expertProfileImage,
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
    required this.isFollowed,
    required this.isSaved,
    required this.advisorImg,
    required this.onFollow,
    required this.onSaved,
    required this.focusedIndex,
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
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: widget.commentsVisibility ? .53.sh : 1.sh,
              child: Center(
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
            ),
          ),
          if (!widget.commentsVisibility)
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
          if (!widget.commentsVisibility)
            Positioned(
              bottom: 30.h,
              left: 10.w,
              child: Visibility(
                visible: !widget.isKeyBoardOpen,
                replacement: const SizedBox.shrink(),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: widget.isKeyBoardOpen ? 0 : 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.showUserName)
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 2.h,
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // BlocProvider.of<PreloadBloc>(
                                      //   context,
                                      //   listen: false,
                                      // ).add(
                                      //   PreloadEvent.pauseVideoAtIndex(
                                      //     widget.focusedIndex,
                                      //   ),
                                      // );
                                      locator<AnalyticsService>().track(
                                        eventName:
                                            AnalyticsEvents.shortsProfileClick,
                                      );
                                      AppState.backButtonDispatcher!
                                          .didPopRoute();
                                      AppState.delegate!.appState
                                          .currentAction = PageAction(
                                        page: ExpertDetailsPageConfig,
                                        state: PageState.addWidget,
                                        widget: ExpertsDetailsView(
                                          advisorID: widget.advisorId,
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: SizeConfig.padding16,
                                          backgroundImage: NetworkImage(
                                            widget.expertProfileImage,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Text(
                                          widget.userName,
                                          style: GoogleFonts.sourceSans3(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: widget.onFollow,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffA2A0A2)
                                            .withOpacity(.3),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4.r),
                                        ),
                                        border: Border.all(
                                          width: 1.h,
                                          color: const Color(0xffA6A6AC)
                                              .withOpacity(.2),
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 4.h,
                                      ),
                                      child: Text(
                                        widget.isFollowed
                                            ? 'Following'
                                            : 'Follow',
                                        style: GoogleFonts.sourceSans3(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(
                            height: 8.h,
                          ),
                          ExpandableWidget(
                            title: widget.videoTitle,
                            leadingIcon: Icons.info,
                            expandedText: widget.description,
                            backgroundColor: Colors.black45,
                            textColor: Colors.white,
                            onExpansionChanged: _toggleExpansion,
                          ),
                        ],
                      ),
                      _buildIconColumn(
                        widget.currentContext,
                        widget.onShare,
                        widget.onSaved,
                        widget.onLike,
                        widget.onBook,
                        widget.onCommentToggle,
                        widget.isSaved,
                        widget.isLikedByUser,
                        widget.commentsVisibility,
                      ),
                    ],
                  ),
                ),
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: widget.commentsVisibility ? .40.sh : 0,
            transform: Matrix4.translationValues(
              0,
              widget.commentsVisibility ? 0 : 50,
              0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff232326),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: _buildComments(_scrollController, widget.onCommentToggle),
          ),
        ],
      ),
    );
  }

  Widget _buildIconColumn(
    final ReelContext reelcontext,
    final VoidCallback onShare,
    final VoidCallback onSave,
    final VoidCallback onLike,
    final VoidCallback onBook,
    final VoidCallback onToggleComment,
    final bool isSaved,
    final bool isLiked,
    final bool commentVisibility,
  ) {
    Widget buildTouchTarget({
      required Widget child,
      required VoidCallback onTap,
      String? label,
    }) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
              SizedBox(
                height: 4.h,
              ),
              if (label != null)
                Text(
                  label,
                  style: GoogleFonts.sourceSans3(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.showBookButton)
          buildTouchTarget(
            onTap: onBook,
            label: 'Book a call',
            child: AppImage(
              Assets.book_call,
              color: Colors.white,
              height: 20.r,
              width: 20.r,
            ),
          ),
        if (widget.showBookButton)
          SizedBox(
            height: 18.h,
          ),
        if (widget.showLikeButton)
          Column(
            children: [
              reelcontext == ReelContext.main
                  ? buildTouchTarget(
                      onTap: onSave,
                      label: 'Save',
                      child: isSaved
                          ? AppImage(
                              Assets.video_save_filled,
                              color: Colors.white,
                              height: 20.r,
                              width: 20.r,
                            )
                          : AppImage(
                              Assets.video_save,
                              color: Colors.white,
                              height: 20.r,
                              width: 20.r,
                            ),
                    )
                  : buildTouchTarget(
                      onTap: onLike,
                      label: 'Like',
                      child: AppImage(
                        Assets.video_like,
                        color: isLiked ? Colors.red : Colors.white,
                        height: 20.r,
                        width: 20.r,
                      ),
                    ),
            ],
          ),
        if (widget.showLikeButton)
          SizedBox(
            height: 18.h,
          ),
        buildTouchTarget(
          onTap: onToggleComment,
          label: 'Comments',
          child: AppImage(
            Assets.add_comment,
            color: Colors.white,
            height: 20.r,
            width: 20.r,
          ),
        ),
        SizedBox(
          height: 18.h,
        ),
        if (widget.showShareButton)
          buildTouchTarget(
            onTap: onShare,
            label: 'Share',
            child: AppImage(
              Assets.video_share,
              color: Colors.white,
              height: 20.r,
              width: 20.r,
            ),
          ),
      ],
    );
  }

  Widget _buildComments(
    ScrollController scrollController,
    VoidCallback onCommentToggle,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding20,
          ).copyWith(
            top: SizeConfig.padding12,
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Comments',
                    style: TextStyles.sourceSansSB.body1,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onCommentToggle,
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      height: 24.r,
                      width: 24.r,
                      child: Icon(
                        Icons.close,
                        size: 18.r,
                        color: UiConstants.kTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: const Color(0xffA2A0A2).withOpacity(.3),
        ),
        if (widget.comments == null ||
            (widget.comments != null && widget.comments!.isEmpty))
          SizedBox(
            height: 152.h,
            child: Center(
              child: Text(
                'No comments yet',
                style:
                    TextStyles.sourceSans.body2.colour(UiConstants.kTextColor5),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
            ).copyWith(top: 10.h),
            child: widget.comments == null
                ? Center(
                    child: Text(
                      'No comments yet',
                      style: TextStyles.sourceSans.body2
                          .colour(UiConstants.kTextColor5),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: widget.comments?.length,
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
                                      child: widget.comments?[index].avatarId !=
                                                  '' &&
                                              widget.comments?[index]
                                                      .avatarId !=
                                                  'CUSTOM'
                                          ? ClipOval(
                                              child: SizedBox(
                                                width: 2 * SizeConfig.padding10,
                                                height:
                                                    2 * SizeConfig.padding10,
                                                child: AppImage(
                                                  "assets/vectors/userAvatars/${widget.comments?[index].avatarId}.svg",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : (widget.comments?[index].avatarId !=
                                                      '' &&
                                                  widget.comments?[index]
                                                          .avatarId ==
                                                      'CUSTOM' &&
                                                  widget.comments?[index]
                                                          .dpUrl !=
                                                      '')
                                              ? ClipOval(
                                                  child: SizedBox(
                                                    width: 2 *
                                                        SizeConfig.padding10,
                                                    height: 2 *
                                                        SizeConfig.padding10,
                                                    child: CachedNetworkImage(
                                                      imageUrl: widget
                                                              .comments?[index]
                                                              .dpUrl ??
                                                          '',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : ClipOval(
                                                  child: SizedBox(
                                                    width: 2 *
                                                        SizeConfig.padding10,
                                                    height: 2 *
                                                        SizeConfig.padding10,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  widget.comments?[index]
                                                          .name ??
                                                      '',
                                                  style: TextStyles
                                                      .sourceSansSB.body4,
                                                  maxLines: 1,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        SizeConfig.padding4,
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
                                                      widget.comments?[index]
                                                              .createdAt ??
                                                          DateTime.now()
                                                              .toString(),
                                                    ),
                                                  ),
                                                  style: TextStyles
                                                      .sourceSans.body4,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              widget.comments?[index].comment ??
                                                  '',
                                              style:
                                                  TextStyles.sourceSans.body4,
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
                  ),
          ),
        ),
        Divider(
          color: const Color(0xffA2A0A2).withOpacity(.3),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
          ).copyWith(top: 10.h, bottom: 20.h),
          child: Row(
            children: [
              PropertyChangeConsumer<UserService, UserServiceProperties>(
                properties: const [
                  UserServiceProperties.myUserDpUrl,
                  UserServiceProperties.myAvatarId,
                ],
                builder: (context, model, properties) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: UiConstants.primaryColor,
                        width: 2.r,
                      ),
                    ),
                    child: CircleAvatar(
                      key: const ValueKey(Constants.PROFILE),
                      radius: 16.r,
                      backgroundColor: Colors.black,
                      backgroundImage: (model!.avatarId != null &&
                              model.avatarId == 'CUSTOM' &&
                              model.myUserDpUrl != null &&
                              model.myUserDpUrl!.isNotEmpty)
                          ? CachedNetworkImageProvider(
                              model.myUserDpUrl!,
                            )
                          : const AssetImage(
                              Assets.profilePic,
                            ) as ImageProvider<Object>?,
                      child:
                          model.avatarId != null && model.avatarId != 'CUSTOM'
                              ? AppImage(
                                  "assets/vectors/userAvatars/${model.avatarId}.svg",
                                  fit: BoxFit.cover,
                                )
                              : const SizedBox(),
                    ),
                  );
                },
              ),
              SizedBox(
                width: 12.w,
              ),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  decoration: InputDecoration(
                    hintText: 'Leave your thoughts here',
                    hintStyle: const TextStyle(color: Color(0xffA2A0A2)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: const BorderSide(color: Color(0xff414145)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: const BorderSide(color: Color(0xff414145)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: const BorderSide(color: Color(0xff414145)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: const Color(0xffA6A6AC),
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
