import 'dart:async';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/feature/live/bloc/live_bloc.dart';
import 'package:felloapp/feature/live/view_all_live.dart';
import 'package:felloapp/feature/live/widgets/header.dart';
import 'package:felloapp/feature/live/widgets/live_card.dart';
import 'package:felloapp/feature/shorts/src/bloc/preload_bloc.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:felloapp/feature/shorts/video_page.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveHomeView extends StatelessWidget {
  const LiveHomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LiveBloc(
        locator(),
      )..add(const LoadHomeData()),
      child: const _LiveHome(),
    );
  }
}

class _LiveHome extends StatefulWidget {
  const _LiveHome();

  @override
  State<_LiveHome> createState() => __LiveHomeState();
}

class __LiveHomeState extends State<_LiveHome> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: UiConstants.primaryColor,
      backgroundColor: Colors.black,
      onRefresh: () async {
        BlocProvider.of<LiveBloc>(
          context,
          listen: false,
        ).add(const LoadHomeData());
        return;
      },
      child: BlocBuilder<LiveBloc, LiveState>(
        builder: (context, state) {
          if (state is LoadingHomeData) {
            return const Center(
              child: FullScreenLoader(),
            );
          } else if (state is LiveHomeData) {
            final liveData = state.homeData;
            if (liveData == null) {
              return NewErrorPage(
                onTryAgain: () {
                  BlocProvider.of<LiveBloc>(
                    context,
                    listen: false,
                  ).add(
                    const LoadHomeData(),
                  );
                },
              );
            }
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.padding14),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TitleSubtitleContainer(
                          title: "Live",
                          zeroPadding: true,
                          largeFont: true,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.padding24,
                      ),
                      child: LiveHeader(
                        title: liveData.sections.live.title,
                        subtitle: liveData.sections.live.subtitle,
                        onViewAllPressed: () {
                          AppState.delegate!.appState.currentAction =
                              PageAction(
                            page: AllEventsPageConfig,
                            state: PageState.addWidget,
                            widget: ViewAllLive(
                              type: 'live',
                              advisorPast: null,
                              advisorUpcoming: null,
                              appBarTitle: liveData.sections.live.title,
                              liveList: liveData.live,
                              upcomingList: null,
                              recentList: null,
                            ),
                          );
                        },
                        showViewAll: liveData.live.length > 1,
                      ),
                    ),
                    buildLiveSection(liveData.live),
                    if (liveData.upcoming.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding24,
                        ),
                        child: LiveHeader(
                          title: liveData.sections.upcoming.title,
                          subtitle: liveData.sections.upcoming.subtitle,
                          onViewAllPressed: () {
                            AppState.delegate!.appState.currentAction =
                                PageAction(
                              page: AllEventsPageConfig,
                              state: PageState.addWidget,
                              widget: ViewAllLive(
                                type: 'upcoming',
                                advisorPast: null,
                                advisorUpcoming: null,
                                appBarTitle: liveData.sections.upcoming.title,
                                liveList: null,
                                upcomingList: liveData.upcoming,
                                recentList: null,
                              ),
                            );
                          },
                          showViewAll: liveData.upcoming.length > 1,
                        ),
                      ),
                    _buildUpcomingSection(liveData.upcoming),
                    if (liveData.recent.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding24,
                        ),
                        child: LiveHeader(
                          title: liveData.sections.recent.title,
                          subtitle: liveData.sections.recent.subtitle,
                          onViewAllPressed: () {
                            AppState.delegate!.appState.currentAction =
                                PageAction(
                              page: AllEventsPageConfig,
                              state: PageState.addWidget,
                              widget: ViewAllLive(
                                advisorPast: null,
                                advisorUpcoming: null,
                                type: 'recent',
                                appBarTitle: liveData.sections.recent.title,
                                liveList: null,
                                upcomingList: null,
                                recentList: liveData.recent,
                              ),
                            );
                          },
                          showViewAll: liveData.recent.length > 1,
                        ),
                      ),
                    buildRecentSection(liveData.recent, context),
                    SizedBox(height: SizeConfig.padding14),
                  ],
                ),
              ),
            );
          } else {
            return NewErrorPage(
              onTryAgain: () {
                BlocProvider.of<LiveBloc>(
                  context,
                  listen: false,
                ).add(
                  const LoadHomeData(),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildUpcomingSection(List<UpcomingStream> liveData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final live in liveData)
            Padding(
              padding: EdgeInsets.only(
                right: SizeConfig.padding8,
              ).copyWith(
                bottom: SizeConfig.padding8,
              ),
              child: LiveCardWidget(
                id: live.id,
                status: 'upcoming',
                title: live.title,
                subTitle: live.subtitle,
                advisorId: live.advisorId,
                author: live.author,
                startTime: live.startTime,
                category: live.categories.join(', '),
                bgImage: live.thumbnail,
                duration: live.startTime,
              ),
            ),
        ],
      ),
    );
  }
}

Widget buildLiveSection(List<LiveStream> liveData) {
  return (liveData.isEmpty)
      ? Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding18,
            vertical: SizeConfig.padding12,
          ),
          decoration: BoxDecoration(
            color: UiConstants.greyVarient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Currently offline',
                      style: TextStyles.sourceSansSB.body6.colour(
                        UiConstants.kTabBorderColor,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding4,
                    ),
                    SizedBox(
                      child: Text(
                        'Our advisors are away right now. Browse recent streams or book a one-on-one call.',
                        style: TextStyles.sourceSansSB.body4.colour(
                          UiConstants.kTextColor,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  AppState.delegate!.parseRoute(Uri.parse("experts"));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding8,
                    vertical: SizeConfig.padding6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  ),
                ),
                child: Text(
                  'Book a Call',
                  style: TextStyles.sourceSansSB.body4.colour(
                    UiConstants.kTextColor4,
                  ),
                ),
              ),
            ],
          ),
        )
      : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final live in liveData)
                Padding(
                  padding: EdgeInsets.only(
                    right: SizeConfig.padding8,
                  ).copyWith(
                    bottom: SizeConfig.padding8,
                  ),
                  child: LiveCardWidget(
                    id: live.id,
                    status: 'live',
                    title: live.title,
                    subTitle: live.subtitle,
                    author: live.author,
                    category: live.categories.join(', '),
                    bgImage: live.thumbnail,
                    liveCount: live.liveCount,
                    advisorId: live.advisorId,
                    viewerCode: live.viewerCode,
                    isLiked: live.isEventLikedByUser,
                    startTime: live.startTime,
                  ),
                ),
            ],
          ),
        );
}

Widget buildRecentSection(List<VideoData> recentData, BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (final recent in recentData)
          Padding(
            padding: EdgeInsets.only(
              bottom: SizeConfig.padding8,
              right: SizeConfig.padding8,
            ),
            child: LiveCardWidget(
              id: recent.id,
              onTap: () async {
                final preloadBloc = BlocProvider.of<PreloadBloc>(context);
                final switchCompleter = Completer<void>();
                preloadBloc.add(
                  PreloadEvent.initializeLiveStream(
                    recent,
                    completer: switchCompleter,
                  ),
                );
                await switchCompleter.future;
                AppState.delegate!.appState.currentAction = PageAction(
                  page: ShortsPageConfig,
                  state: PageState.addWidget,
                  widget: BaseScaffold(
                    appBar: FAppBar(
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      titleWidget: Text(
                        recent.title,
                        style: TextStyles.rajdhaniSB.body1,
                      ),
                      leading: const BackButton(
                        color: Colors.white,
                      ),
                      showAvatar: false,
                      showCoinBar: false,
                    ),
                    body: WillPopScope(
                      onWillPop: () async {
                        await AppState.backButtonDispatcher!.didPopRoute();
                        return false;
                      },
                      child: const ShortsVideoPage(),
                    ),
                  ),
                );
              },
              status: 'recent',
              title: recent.title,
              startTime: recent.timeStamp,
              advisorId: recent.advisorId,
              subTitle: recent.subtitle,
              author: recent.author,
              category: (recent.category ?? []).join(', '),
              bgImage: recent.thumbnail,
              liveCount:
                  recent.viewCount, // Number of views instead of live count
              duration: recent.duration.toString(),
            ),
          ),
      ],
    ),
  );
}
