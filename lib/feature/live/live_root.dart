import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/feature/live/bloc/live_bloc.dart';
import 'package:felloapp/feature/live/widgets/header.dart';
import 'package:felloapp/feature/live/widgets/live_card.dart';
import 'package:felloapp/feature/p2p_home/ui/shared/error_state.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
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
              return const ErrorPage();
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
                        onViewAllPressed: () {},
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
                          onViewAllPressed: () {},
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
                          onViewAllPressed: () {},
                          showViewAll: liveData.recent.length > 1,
                        ),
                      ),
                    buildRecentSection(liveData.recent),
                    SizedBox(height: SizeConfig.padding14),
                  ],
                ),
              ),
            );
          } else {
            return const ErrorPage();
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
                status: 'upcoming',
                title: live.title,
                subTitle: live.subtitle,
                author: live.author,
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
                onPressed: () {},
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
                    status: 'live',
                    title: live.title,
                    subTitle: live.subtitle,
                    author: live.author,
                    category: live.categories.join(', '),
                    bgImage: live.thumbnail,
                    liveCount: live.liveCount,
                    advisorCode: live.advisorCode,
                    viewerCode: live.viewerCode,
                  ),
                ),
            ],
          ),
        );
}

Widget buildRecentSection(List<RecentStream> recentData) {
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
              status: 'recent',
              title: recent.title,
              subTitle: recent.subtitle,
              author: recent.author,
              category: recent.categories.join(', '),
              bgImage: recent.thumbnail,
              liveCount: recent.views, // Number of views instead of live count
              duration: recent.duration.toString(),
            ),
          ),
      ],
    ),
  );
}
