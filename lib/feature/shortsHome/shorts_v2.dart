import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/shorts/src/bloc/preload_bloc.dart';
import 'package:felloapp/feature/shorts/video_page.dart';
import 'package:felloapp/feature/shortsHome/bloc/pagination_bloc.dart';
import 'package:felloapp/feature/shortsHome/bloc/shorts_home_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/bloc_pagination/pagination_bloc.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShortsNewPage extends StatelessWidget {
  const ShortsNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShortsHomeBloc(locator())..add(const LoadHomeData()),
      child: _ShortsScreen(),
    );
  }
}

class _ShortsScreen extends StatefulWidget {
  @override
  State<_ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<_ShortsScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: UiConstants.primaryColor,
      backgroundColor: Colors.black,
      onRefresh: () async {
        BlocProvider.of<ShortsHomeBloc>(
          context,
          listen: false,
        ).add(const LoadHomeData());
        return;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.padding14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleSubtitleContainer(
                        title: "Shorts",
                        zeroPadding: true,
                        largeFont: true,
                      ),
                      Text(
                        'Learn investing with quick and insightful shorts',
                        style: TextStyles.sourceSans.body3.colour(
                          UiConstants.kTextColor.withOpacity(.7),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: UiConstants.grey5,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            SizeConfig.roundness12,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.all(SizeConfig.padding10),
                      child: const Icon(
                        Icons.notifications,
                        color: UiConstants.kTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20.w),
              child: TextField(
                onSubmitted: (query) {
                  BlocProvider.of<ShortsHomeBloc>(context)
                      .add(SearchShorts(query));
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: UiConstants.kTextColor.withOpacity(.7),
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            BlocBuilder<ShortsHomeBloc, ShortsHomeState>(
              builder: (context, state) {
                return switch (state) {
                  LoadingShortsDetails() => const FullScreenLoader(),
                  ShortsHomeData() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Chips
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (final theme
                                          in state.shortsHome.allCategories)
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                BaseUtil.showPositiveAlert(
                                                    'Hello', 'hi');
                                              },
                                              child: Chip(
                                                label: Text(theme),
                                                backgroundColor:
                                                    Colors.grey[800],
                                                labelStyle: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: SizeConfig.padding12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        SizeConfig.roundness12,
                                      ),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(SizeConfig.padding10),
                                  child: const Icon(
                                    Icons.bookmark,
                                    color: UiConstants.kTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final theme = state.shortsHome.shorts[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(
                                    theme.themeName,
                                    style: TextStyles.sourceSansSB.body2,
                                  ),
                                ),
                                SizedBox(height: 14.h),
                                BlocProvider(
                                  create: (context) => ThemeVideosBloc(
                                    shortsRepo: locator(),
                                    theme: theme.theme,
                                    themeName: theme.themeName,
                                    total: theme.total,
                                    totalPages: theme.total,
                                    initialVideos: theme.videos,
                                  )..fetchFirstPage(),
                                  child: BlocBuilder<ThemeVideosBloc,
                                      PaginationState<dynamic, int, String>>(
                                    builder: (context, themeState) {
                                      final themeVideosBloc =
                                          context.read<ThemeVideosBloc>();
                                      return SizedBox(
                                        height: 275.h,
                                        child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          padding: EdgeInsets.only(left: 20.w),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: themeVideosBloc
                                              .state.entries.length,
                                          itemBuilder: (context, i) {
                                            if (themeState.entries.length - 1 ==
                                                    i &&
                                                !themeState.status
                                                    .isFetchingInitialPage &&
                                                !themeState.status
                                                    .isFetchingSuccessive) {
                                              themeVideosBloc.fetchNextPage();
                                            }
                                            if (themeState.status ==
                                                PaginationStatus
                                                    .fetchingInitialPage) {
                                              return const Center(
                                                child:
                                                    CupertinoActivityIndicator(),
                                              );
                                            }
                                            if (themeState.status ==
                                                PaginationStatus
                                                    .failedToLoadInitialPage) {
                                              return Center(
                                                child: Text(
                                                  'Error: ${themeState.error}',
                                                ),
                                              );
                                            }
                                            return GestureDetector(
                                              onTap: () async {
                                                final preloadBloc = BlocProvider
                                                    .of<PreloadBloc>(
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
                                                    normalizedCategories
                                                        .indexOf(
                                                  cate.trim().toLowerCase(),
                                                );
                                                preloadBloc.add(
                                                  PreloadEvent.updateThemes(
                                                    categories:
                                                        theme.categories,
                                                    theme: theme.theme,
                                                    index: normalizedIndex,
                                                    completer: themeCompleter,
                                                  ),
                                                );
                                                await themeCompleter.future;
                                                preloadBloc.add(
                                                  PreloadEvent
                                                      .getCategoryVideos(
                                                    initailVideo:
                                                        theme.videos[i],
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
                                                  color:
                                                      UiConstants.greyVarient,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
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
                                                                        .videos[
                                                                            i]
                                                                        .thumbnail,
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          buildPlayIcon(),
                                                          buildViewIndicator(
                                                            theme
                                                                .videos[i].views
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
                                                            theme.videos[i]
                                                                .title,
                                                            style: TextStyles
                                                                .sourceSansM
                                                                .body4,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          SizedBox(
                                                              height: 12.h),
                                                          Text(
                                                            theme.videos[i]
                                                                .categoryV1,
                                                            style: TextStyles
                                                                .sourceSans
                                                                .body6,
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
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 40.h),
                              ],
                            );
                          },
                          itemCount: state.shortsHome.shorts.length,
                        ),
                      ],
                    ),
                  LoadingShortsFailed() => NewErrorPage(
                      onTryAgain: () {
                        BlocProvider.of<ShortsHomeBloc>(
                          context,
                          listen: false,
                        ).add(const LoadHomeData());
                      },
                    )
                };
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlayIcon() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.padding8),
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
