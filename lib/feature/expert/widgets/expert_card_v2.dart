import 'dart:async';
import 'dart:math';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/feature/shorts/src/bloc/preload_bloc.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:felloapp/feature/shorts/video_page.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpertCardV2 extends StatelessWidget {
  final UserInterestedAdvisor expert;
  final VoidCallback onBookCall;
  final VoidCallback onTap;
  final bool isFree;

  const ExpertCardV2({
    required this.expert,
    required this.onBookCall,
    required this.onTap,
    required this.isFree,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: UiConstants.greyVarient,
              borderRadius: expert.expertiseTags.isEmpty
                  ? BorderRadius.all(
                      Radius.circular(10.r),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r),
                    ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: expert.introVideos.isEmpty
                          ? null
                          : () async {
                              final preloadBloc =
                                  BlocProvider.of<PreloadBloc>(context);
                              final switchCompleter = Completer<void>();
                              final updateUrlsCompleter = Completer<void>();
                              final initializeCompleter = Completer<void>();

                              preloadBloc.add(
                                PreloadEvent.switchToProfileReels(
                                    completer: switchCompleter),
                              );
                              await switchCompleter.future;
                              preloadBloc.add(
                                PreloadEvent.updateUrls(
                                  expert.introVideos,
                                  completer: updateUrlsCompleter,
                                ),
                              );
                              await updateUrlsCompleter.future;
                              preloadBloc.add(
                                PreloadEvent.initializeAtIndex(
                                  index: 0,
                                  completer: initializeCompleter,
                                ),
                              );
                              await initializeCompleter.future;
                              preloadBloc.add(
                                const PreloadEvent.playVideoAtIndex(0),
                              );

                              AppState.delegate!.appState.currentAction =
                                  PageAction(
                                page: ProfileShortsPageConfig,
                                state: PageState.addWidget,
                                widget: BaseScaffold(
                                  appBar: FAppBar(
                                    backgroundColor: Colors.transparent,
                                    centerTitle: true,
                                    titleWidget: Text(
                                      'Introduction',
                                      style: TextStyles.rajdhaniSB.body1,
                                    ),
                                    leading: BackButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        AppState.backButtonDispatcher!
                                            .didPopRoute();
                                      },
                                    ),
                                    showAvatar: false,
                                    showCoinBar: false,
                                    action:
                                        BlocBuilder<PreloadBloc, PreloadState>(
                                      builder: (context, preloadState) {
                                        return Padding(
                                          padding: EdgeInsets.only(right: 10.w),
                                          child: GestureDetector(
                                            onTap: () {
                                              BlocProvider.of<PreloadBloc>(
                                                context,
                                                listen: false,
                                              ).add(
                                                const PreloadEvent
                                                    .toggleVolume(),
                                              );
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: SizedBox(
                                              height: 24.r,
                                              width: 24.r,
                                              child: Icon(
                                                !preloadState.muted
                                                    ? Icons.volume_up_rounded
                                                    : Icons.volume_off_rounded,
                                                size: 21.r,
                                                color: UiConstants.kTextColor,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  body: const ShortsVideoPage(
                                    categories: [],
                                  ),
                                ),
                              );
                            },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 54.w,
                            height: 54.h,
                            child: introVideosIndicator(
                              expert.introVideos,
                              context,
                            ),
                          ),
                          ClipOval(
                            child: SizedBox(
                              width: 50.w,
                              height: 50.h,
                              child: AppImage(
                                expert.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expert.name,
                            style: TextStyles.sourceSansSB.body2
                                .colour(UiConstants.kTextColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            expert.description,
                            style: TextStyles.sourceSans.body4.colour(
                              UiConstants.kTextColor.withOpacity(.75),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: UiConstants.grey6,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 134.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppImage(
                                  Assets.expertise,
                                  height: 12.r,
                                  width: 12.r,
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    expert.expertise,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.sourceSans3(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: UiConstants.kTextColor
                                          .withOpacity(.6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                AppImage(
                                  Assets.qualifications,
                                  height: 12.r,
                                  width: 12.r,
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    expert.qualifications,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.sourceSans3(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: UiConstants.kTextColor
                                          .withOpacity(.6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 40.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppImage(
                                Assets.experiencev2,
                                height: 12.r,
                                width: 12.r,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '${expert.experience} years',
                                style: GoogleFonts.sourceSans3(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: UiConstants.kTextColor.withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              AppImage(
                                Assets.rating,
                                height: 12.r,
                                width: 12.r,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                expert.rating.toStringAsFixed(1),
                                style: GoogleFonts.sourceSans3(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: UiConstants.kTextColor.withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: UiConstants.grey6,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (expert.originalPrice != '')
                                Text(
                                  expert.originalPrice,
                                  style: TextStyles.sourceSans.body3
                                      .colour(
                                        UiConstants.kTextColor.withOpacity(
                                          .6,
                                        ),
                                      )
                                      .copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor:
                                            UiConstants.kTextColor.withOpacity(
                                          .6,
                                        ),
                                      ),
                                ),
                              if (expert.originalPrice != '')
                                SizedBox(width: 4.w),
                              Text(
                                expert.rateNew,
                                style: TextStyles.sourceSansM.body3
                                    .colour(UiConstants.teal3),
                              ),
                              if (isFree && expert.isFree) SizedBox(width: 4.w),
                              if (isFree && expert.isFree)
                                Text(
                                  "Free",
                                  style: TextStyles.sourceSansSB.body3
                                      .colour(UiConstants.kTabBorderColor),
                                ),
                            ],
                          ),
                          GestureDetector(
                            onTap: onBookCall,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: UiConstants.kTextColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'Book a Call',
                                style: TextStyles.sourceSansSB.body4
                                    .colour(UiConstants.kTextColor4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (expert.expertiseTags.isNotEmpty)
            ExpertTagsComponent(
              expertiseTags: expert.expertiseTags,
            ),
        ],
      ),
    );
  }
}

Widget introVideosIndicator(
  List<VideoData> introVideos,
  BuildContext context,
) {
  if (introVideos.isEmpty) {
    return Container();
  }

  final int videoCount = introVideos.length;

  return CustomPaint(
    painter: StoryIndicatorPainter(
      storyCount: videoCount,
      watchedColor: Colors.grey.withOpacity(0.5),
      unwatchedColor: Theme.of(context).primaryColor,
      strokeWidth: 2.5,
      watchedStatuses:
          introVideos.map((video) => video.isVideoSeenByUser).toList(),
    ),
  );
}

class StoryIndicatorPainter extends CustomPainter {
  final int storyCount;
  final Color watchedColor;
  final Color unwatchedColor;
  final double strokeWidth;
  final List<bool> watchedStatuses;

  StoryIndicatorPainter({
    required this.storyCount,
    required this.watchedColor,
    required this.unwatchedColor,
    required this.strokeWidth,
    required this.watchedStatuses,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);

    if (storyCount == 1) {
      paint.color = watchedStatuses[0] ? watchedColor : unwatchedColor;
      canvas.drawCircle(center, radius, paint);
    } else {
      const double gapInRadians = 0.25;
      final double totalGapSpace = gapInRadians * storyCount;
      final double availableAngle = (2 * pi) - totalGapSpace;
      final double sweepAngle = availableAngle / storyCount;
      double currentAngle = 0;

      for (int i = 0; i < storyCount; i++) {
        paint.color = watchedStatuses[i] ? watchedColor : unwatchedColor;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          currentAngle,
          sweepAngle,
          false,
          paint,
        );
        currentAngle += sweepAngle + gapInRadians;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is StoryIndicatorPainter) {
      return oldDelegate.storyCount != storyCount ||
          oldDelegate.watchedColor != watchedColor ||
          oldDelegate.unwatchedColor != unwatchedColor ||
          oldDelegate.strokeWidth != strokeWidth ||
          !listEquals(oldDelegate.watchedStatuses, watchedStatuses);
    }
    return true;
  }
}

class ExpertTagsComponent extends StatelessWidget {
  final List<String> expertiseTags;

  const ExpertTagsComponent({required this.expertiseTags, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const maxVisibleTags = 3;
    bool showMore = false;

    if (expertiseTags.length > maxVisibleTags) {
      showMore = true;
    }

    List<String> visibleTags = expertiseTags.take(maxVisibleTags).toList();

    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: UiConstants.greyVarient.withOpacity(0.6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.r),
          bottomRight: Radius.circular(10.r),
        ),
      ),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 6.h,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'I can help with',
            style: GoogleFonts.sourceSans3(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xffA6A6AC),
            ),
          ),
          ...visibleTags.map((tag) => tagContainer(label: tag)),
          if (showMore)
            tagContainer(label: '+${expertiseTags.length - 3} more'),
        ],
      ),
    );
  }

  Widget tagContainer({required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xffA6A6AC).withOpacity(.11),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.sourceSans3(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xffA6A6AC),
        ),
      ),
    );
  }
}
