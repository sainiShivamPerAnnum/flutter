import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/savedShorts/saved_shorts.dart';
import 'package:felloapp/feature/shorts/src/bloc/preload_bloc.dart';
import 'package:felloapp/feature/shorts/video_page.dart';
import 'package:felloapp/feature/shortsHome/bloc/pagination_bloc.dart';
import 'package:felloapp/feature/shortsHome/bloc/shorts_home_bloc.dart';
import 'package:felloapp/feature/shortsHome/widgets/more_options_sheet.dart';
import 'package:felloapp/feature/shorts_notifications/shorts_notifications.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/bottom_nav_bar/bottom_nav_bar.dart';
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
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shorts',
                            style: TextStyles.sourceSansSB.body1,
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
                        onTap: () {
                          AppState.delegate!.appState.currentAction =
                              PageAction(
                            page: ShortsNotificationPageConfig,
                            state: PageState.addWidget,
                            widget: const ShortsNotificationPage(),
                          );
                        },
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
                            Icons.notifications_rounded,
                            color: UiConstants.kTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  SizedBox(
                    height: 38.h,
                    child: BlocBuilder<ShortsHomeBloc, ShortsHomeState>(
                      builder: (context, state) {
                        if (state is ShortsHomeData) {
                          _controller.text = state.query;
                        }
                        return TextField(
                          controller: _controller,
                          onSubmitted: (query) {
                            BlocProvider.of<ShortsHomeBloc>(context)
                                .add(SearchShorts(query));
                          },
                          textAlign: TextAlign.justify,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyles.sourceSans.body3
                                .colour(UiConstants.kTextColor.withOpacity(.7)),
                            filled: true,
                            fillColor: const Color(0xffD9D9D9).withOpacity(.04),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: const Color(0xffCACBCC).withOpacity(.07),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: const Color(0xffCACBCC).withOpacity(.07),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: const Color(0xffCACBCC).withOpacity(.07),
                              ),
                            ),
                            suffixIcon: (state is ShortsHomeData)
                                ? state.query != ""
                                    ? GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<ShortsHomeBloc>(
                                            context,
                                            listen: false,
                                          ).add(const LoadHomeData());
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: UiConstants.kTextColor
                                              .withOpacity(.7),
                                        ),
                                      )
                                    : Icon(
                                        Icons.search,
                                        color: UiConstants.kTextColor
                                            .withOpacity(.7),
                                      )
                                : Icon(
                                    Icons.search,
                                    color:
                                        UiConstants.kTextColor.withOpacity(.7),
                                  ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h,
                              horizontal: 16.w,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                ],
              ),
            ),
            BlocBuilder<ShortsHomeBloc, ShortsHomeState>(
              builder: (context, state) {
                return switch (state) {
                  LoadingShortsDetails() => const FullScreenLoader(),
                  ShortsHomeData() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.shortsHome.allCategories.isNotEmpty)
                          SizedBox(
                            height: 12.h,
                          ),
                        if (state.shortsHome.allCategories.isNotEmpty)
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
                                                  BlocProvider.of<
                                                      ShortsHomeBloc>(
                                                    context,
                                                  ).add(ApplyCategory(theme));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffD9D9D9)
                                                            .withOpacity(.1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                        6.r,
                                                      ),
                                                    ),
                                                    border: Border.all(
                                                      color: const Color(
                                                        0xffCACBCC,
                                                      ).withOpacity(.07),
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w,
                                                    vertical: 8.h,
                                                  ),
                                                  child: Text(
                                                    theme,
                                                    style: TextStyles
                                                        .sourceSansM.body4,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AppState.delegate!.appState.currentAction =
                                        PageAction(
                                      page: SavedShortsPageConfig,
                                      state: PageState.addWidget,
                                      widget: const SavedShortsPage(),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 12.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffD9D9D9)
                                          .withOpacity(.1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          6.r,
                                        ),
                                      ),
                                      border: Border.all(
                                        color: const Color(0xffCACBCC)
                                            .withOpacity(.07),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(8.r),
                                    child: const Icon(
                                      Icons.bookmark_border_rounded,
                                      color: UiConstants.kTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 8.h,
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        theme.themeName,
                                        style: TextStyles.sourceSansSB.body2,
                                      ),
                                      if (theme.isNotificationAllowed)
                                        GestureDetector(
                                          onTap: () {
                                            BlocProvider.of<ShortsHomeBloc>(
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
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4.r),
                                              ),
                                            ),
                                            padding: EdgeInsets.all(6.r),
                                            child: Icon(
                                              theme.isNotificationOn
                                                  ? Icons.check_rounded
                                                  : Icons.notifications_rounded,
                                              color: UiConstants.teal3,
                                              size: 12.r,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 14.h),
                                BlocProvider(
                                  create: (context) => ThemeVideosBloc(
                                    shortsRepo: locator(),
                                    theme: theme.theme,
                                    themeName: theme.themeName,
                                    total: theme.total,
                                    totalPages: theme.totalPages,
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
                                                          buildMoreIcon(
                                                            theme.videos[i].id,
                                                            theme.videos[i]
                                                                .isSaved,
                                                            theme.theme,
                                                            theme.videos[i]
                                                                .categoryV1,
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
                                                            height: 12.h,
                                                          ),
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
              isBarrierDismissible: false,
              addToScreenStack: true,
              backgroundColor: UiConstants.kBackgroundColor,
              hapticVibrate: true,
              content: MoreOptionsSheet(
                id: id,
                isSaved: isSaved,
                theme: theme,
                category: category,
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
