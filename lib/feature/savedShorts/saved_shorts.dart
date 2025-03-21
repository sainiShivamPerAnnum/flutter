import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/shorts/shorts_home.dart';
import 'package:felloapp/feature/savedShorts/bloc/shorts_saved_bloc.dart';
import 'package:felloapp/feature/shorts/flutter_preload_videos.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:felloapp/feature/shortsHome/widgets/more_options_sheet.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/local_actions_state.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedShortsPage extends StatelessWidget {
  const SavedShortsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ShortsSavedBloc(locator())..add(const LoadSavedData()),
      child: _SavedShortsScreen(),
    );
  }
}

class _SavedShortsScreen extends StatefulWidget {
  @override
  State<_SavedShortsScreen> createState() => _SavedShortsScreenState();
}

class _SavedShortsScreenState extends State<_SavedShortsScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackgroundGrid: false,
      backgroundColor: UiConstants.bg,
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        color: UiConstants.primaryColor,
        backgroundColor: Colors.black,
        onRefresh: () async {
          BlocProvider.of<ShortsSavedBloc>(
            context,
            listen: false,
          ).add(const LoadSavedData());
          return;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Fixed header that stays at the top
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [UiConstants.bg, Color(0xff212B2D)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 6.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BackButton(
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.zero,
                                ),
                              ),
                              color: UiConstants.kTextColor,
                              onPressed: () {
                                AppState.backButtonDispatcher!.didPopRoute();
                              },
                            ),
                            Text(
                              'Saved',
                              style: TextStyles.sourceSansSB.body1,
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content that scrolls under the header
            SliverToBoxAdapter(
              child: BlocBuilder<ShortsSavedBloc, SavedShortsState>(
                builder: (context, state) {
                  return switch (state) {
                    LoadingSavedShortsDetails() => const FullScreenLoader(),
                    SavedShortsData() => state.shortsHome.isEmpty
                        ? _buildEmptyState()
                        : _buildVideosContent(state),
                    LoadingSavedShortsFailed() => NewErrorPage(
                        onTryAgain: () {
                          BlocProvider.of<ShortsSavedBloc>(
                            context,
                            listen: false,
                          ).add(const LoadSavedData());
                        },
                      ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: .8.sh,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImage(
              Assets.noSaved,
              height: 82.r,
              width: 82.r,
            ),
            SizedBox(height: 24.h),
            Text(
              'Nothing saved yet',
              style: TextStyles.sourceSansM.body0,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: 294.w,
              child: Text(
                'You can save shorts from advisors and across various topics',
                style:
                    TextStyles.sourceSans.body2.colour(UiConstants.kTextColor5),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosContent(SavedShortsData state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.shortsHome.length,
          itemBuilder: (context, themeIndex) {
            final theme = state.shortsHome[themeIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        theme.themeName,
                        style: TextStyles.sourceSansSB.body2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                // Horizontal list of videos
                SizedBox(
                  height: 275.h,
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 20.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: theme.videos.length,
                    itemBuilder: (context, videoIndex) {
                      return _buildVideoCard(
                        context,
                        theme,
                        theme.videos[videoIndex],
                        videoIndex,
                        state,
                      );
                    },
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildVideoCard(
    BuildContext context,
    SavedShorts theme,
    VideoData video,
    int index,
    SavedShortsData state,
  ) {
    return GestureDetector(
      onTap: () async {
        final preloadBloc = BlocProvider.of<PreloadBloc>(context);
        final switchCompleter = Completer<void>();
        final updateUrlsCompleter = Completer<void>();
        final initializeCompleter = Completer<void>();

        preloadBloc.add(
          PreloadEvent.switchToProfileReels(
            completer: switchCompleter,
          ),
        );
        await switchCompleter.future;

        List<VideoData> allVideos = [];
        for (final themeData in state.shortsHome) {
          allVideos.addAll(themeData.videos);
        }

        final clickedVideo = video;
        final clickedIndex = allVideos.indexOf(clickedVideo);

        preloadBloc.add(
          PreloadEvent.updateUrls(
            allVideos,
            completer: updateUrlsCompleter,
          ),
        );
        await updateUrlsCompleter.future;

        preloadBloc.add(
          PreloadEvent.initializeAtIndex(
            index: clickedIndex,
            completer: initializeCompleter,
          ),
        );
        await initializeCompleter.future;

        preloadBloc.add(
          PreloadEvent.playVideoAtIndex(
            clickedIndex,
          ),
        );

        AppState.delegate!.appState.currentAction = PageAction(
          page: ShortsPageConfig,
          state: PageState.addWidget,
          widget: const ShortsVideoPage(
            categories: [],
            showAppBar: true,
            title: 'Saved',
            showBottomNavigation: false,
          ),
        );
      },
      child: Container(
        width: 130.w,
        height: 275.h,
        decoration: BoxDecoration(
          color: UiConstants.greyVarient,
          borderRadius: BorderRadius.circular(8.r),
        ),
        margin: EdgeInsets.only(right: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 130.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              8.r,
                            ),
                            topRight: Radius.circular(
                              8.r,
                            ),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              theme.videos[index].thumbnail,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  buildMoreIcon(
                    theme.videos[index].id,
                    theme.videos[index].isSaved,
                    theme.theme,
                    theme.videos[index].categoryV1,
                  ),
                  buildPlayIcon(),
                  buildViewIndicator(video.views.toDouble()),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 14.h,
              ),
              decoration: BoxDecoration(
                color: UiConstants.greyVarient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.r),
                  bottomRight: Radius.circular(8.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: TextStyles.sourceSansM.body4,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    video.categoryV1,
                    style: TextStyles.sourceSans.body6,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMoreIcon(String id, bool isSaved, String theme, String category) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(top: 10.h, right: 8.w),
        child: GestureDetector(
          onTap: () {
            BaseUtil.openModalBottomSheet(
              isScrollControlled: true,
              enableDrag: false,
              isBarrierDismissible: true,
              addToScreenStack: true,
              backgroundColor: UiConstants.kBackgroundColor,
              hapticVibrate: true,
              content: MoreOptionsSheet(
                id: id,
                isSaved: LocalActionsState.getVideoSaved(
                  id,
                  isSaved,
                ),
                theme: theme,
                category: category,
                onSave: () {
                  BlocProvider.of<PreloadBloc>(
                    context,
                    listen: false,
                  ).add(
                    PreloadEvent.saveVideo(
                      isSaved: LocalActionsState.getVideoSaved(
                        id,
                        isSaved,
                      ),
                      videoId: id,
                      theme: theme,
                      category: category,
                    ),
                  );
                  BlocProvider.of<ShortsSavedBloc>(
                    context,
                    listen: false,
                  ).add(RemoveSaved(id));
                },
              ),
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 24.r,
            width: 24.r,
            alignment: Alignment.center,
            child: Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
              size: 18.r,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPlayIcon() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: UiConstants.kTextColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
          size: SizeConfig.iconSize5,
        ),
      ),
    );
  }

  Widget buildViewIndicator(double views) {
    return Positioned(
      bottom: SizeConfig.padding10,
      left: SizeConfig.padding10,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding8,
          vertical: SizeConfig.padding4,
        ),
        decoration: BoxDecoration(
          color: UiConstants.kTextColor4,
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        ),
        child: Row(
          children: [
            Icon(
              Icons.remove_red_eye,
              color: UiConstants.titleTextColor,
              size: SizeConfig.iconSize4,
            ),
            SizedBox(width: SizeConfig.padding4),
            Text(
              BaseUtil.formatShortNumber(views),
              style: TextStyles.sourceSansSB.body4.colour(
                UiConstants.titleTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
