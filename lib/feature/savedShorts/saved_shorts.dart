import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/savedShorts/bloc/shorts_notification_bloc.dart';
import 'package:felloapp/feature/shorts/flutter_preload_videos.dart';
import 'package:felloapp/feature/shortsHome/widgets/more_options_sheet.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
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
          ShortsNotificationBloc(locator())..add(const LoadSavedData()),
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
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        color: UiConstants.primaryColor,
        backgroundColor: Colors.black,
        onRefresh: () async {
          BlocProvider.of<ShortsNotificationBloc>(
            context,
            listen: false,
          ).add(const LoadSavedData());
          return;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                        const BackButton(
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.zero,
                            ),
                          ),
                          color: UiConstants.kTextColor,
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
              BlocBuilder<ShortsNotificationBloc, SavedShortsState>(
                builder: (context, state) {
                  return switch (state) {
                    LoadingSavedShortsDetails() => const FullScreenLoader(),
                    SavedShortsData() => state.shortsHome.shorts.isEmpty
                        ? SizedBox(
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
                                  SizedBox(
                                    height: 24.h,
                                  ),
                                  Text(
                                    'Nothing saved yet',
                                    style: TextStyles.sourceSansM.body0,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  SizedBox(
                                    width: 294.w,
                                    child: Text(
                                      'You can save reels from advisors and across various topics',
                                      style: TextStyles.sourceSans.body2
                                          .colour(UiConstants.kTextColor5),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 8.h,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final theme = state.shortsHome.shorts[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              theme.themeName,
                                              style:
                                                  TextStyles.sourceSansSB.body2,
                                            ),
                                            if (theme.isNotificationAllowed)
                                              GestureDetector(
                                                onTap: () {
                                                  BlocProvider.of<
                                                      ShortsNotificationBloc>(
                                                    context,
                                                  ).add(
                                                    ToogleNotification(
                                                      theme.theme,
                                                      theme.isNotificationOn,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  height: 24.r,
                                                  width: 24.r,
                                                  decoration: BoxDecoration(
                                                    color: UiConstants.kblue2
                                                        .withOpacity(.4),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(4.r),
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(6.r),
                                                  child: Icon(
                                                    theme.isNotificationOn
                                                        ? Icons.check_rounded
                                                        : Icons
                                                            .notifications_rounded,
                                                    color: UiConstants.teal3,
                                                    size: 12.r,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 14.h),
                                      ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        padding: EdgeInsets.only(left: 20.w),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: theme.videos.length,
                                        itemBuilder: (context, i) {
                                          return GestureDetector(
                                            onTap: () async {
                                              final preloadBloc =
                                                  BlocProvider.of<PreloadBloc>(
                                                context,
                                              );
                                              final switchCompleter =
                                                  Completer<void>();
                                              final themeCompleter =
                                                  Completer<void>();
                                              final cate =
                                                  theme.videos[i].categoryV1;
                                              final normalizedCategories =
                                                  theme.categories
                                                      .map(
                                                        (category) => category
                                                            .trim()
                                                            .toLowerCase(),
                                                      )
                                                      .toList();
                                              final normalizedIndex =
                                                  normalizedCategories.indexOf(
                                                cate.trim().toLowerCase(),
                                              );
                                              preloadBloc.add(
                                                PreloadEvent.updateThemes(
                                                  categories: theme.categories,
                                                  theme: theme.theme,
                                                  index: normalizedIndex,
                                                  completer: themeCompleter,
                                                ),
                                              );
                                              await themeCompleter.future;
                                              preloadBloc.add(
                                                PreloadEvent.getCategoryVideos(
                                                  initailVideo: theme.videos[i],
                                                  direction: 0,
                                                  completer: switchCompleter,
                                                ),
                                              );
                                              await switchCompleter.future;
                                              AppState.delegate!.appState
                                                  .currentAction = PageAction(
                                                page: ShortsPageConfig,
                                                state: PageState.addWidget,
                                                widget: BaseScaffold(
                                                  bottomNavigationBar:
                                                      const BottomNavBar(),
                                                  body: WillPopScope(
                                                    onWillPop: () async {
                                                      await AppState
                                                          .backButtonDispatcher!
                                                          .didPopRoute();
                                                      preloadBloc.add(
                                                        PreloadEvent
                                                            .updateThemes(
                                                          categories: [],
                                                          theme: theme.theme,
                                                          index: 0,
                                                        ),
                                                      );
                                                      return false;
                                                    },
                                                    child: ShortsVideoPage(
                                                      categories:
                                                          theme.categories,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 130.w,
                                              height: 275.h,
                                              decoration: BoxDecoration(
                                                color: UiConstants.greyVarient,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  8.r,
                                                ),
                                              ),
                                              margin:
                                                  EdgeInsets.only(right: 8.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Stack(
                                                      children: [
                                                        Positioned.fill(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                  8.r,
                                                                ),
                                                                topRight: Radius
                                                                    .circular(
                                                                  8.r,
                                                                ),
                                                              ),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    NetworkImage(
                                                                  theme
                                                                      .videos[i]
                                                                      .thumbnail,
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        buildMoreIcon(
                                                          theme.videos[i].id,
                                                        ),
                                                        buildPlayIcon(),
                                                        buildViewIndicator(
                                                          theme.videos[i].views
                                                              .toDouble(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 14.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: UiConstants
                                                          .greyVarient,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                          8.r,
                                                        ),
                                                        bottomRight:
                                                            Radius.circular(
                                                          8.r,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          theme.videos[i].title,
                                                          style: TextStyles
                                                              .sourceSansM
                                                              .body4,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(
                                                          height: 12.h,
                                                        ),
                                                        Text(
                                                          theme.videos[i]
                                                              .categoryV1,
                                                          style: TextStyles
                                                              .sourceSans.body6,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 40.h),
                                    ],
                                  );
                                },
                                itemCount: state.shortsHome.shorts.length,
                              ),
                            ],
                          ),
                    LoadingSavedShortsFailed() => NewErrorPage(
                        onTryAgain: () {
                          BlocProvider.of<ShortsNotificationBloc>(
                            context,
                            listen: false,
                          ).add(const LoadSavedData());
                        },
                      )
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMoreIcon(String id) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(top: 10.h, right: 8.w),
        child: GestureDetector(
          onTap: () {
            BaseUtil.openModalBottomSheet(
              isScrollControlled: true,
              enableDrag: false,
              isBarrierDismissible: false,
              addToScreenStack: true,
              backgroundColor: UiConstants.kBackgroundColor,
              hapticVibrate: true,
              content: MoreOptionsSheet(id: id),
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
            SizedBox(
              width: SizeConfig.padding4,
            ),
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
