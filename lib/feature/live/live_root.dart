import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/feature/live/bloc/live_bloc.dart';
import 'package:felloapp/feature/live/widgets/header.dart';
import 'package:felloapp/feature/live/widgets/live_card.dart';
import 'package:felloapp/feature/p2p_home/ui/shared/error_state.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
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
    return BlocBuilder<LiveBloc, LiveState>(
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
                    ),
                  ),
                  _buildLiveSection(liveData.live),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding24,
                    ),
                    child: LiveHeader(
                      title: liveData.sections.upcoming.title,
                      subtitle: liveData.sections.upcoming.subtitle,
                      onViewAllPressed: () {},
                    ),
                  ),
                  _buildUpcomingSection(liveData.upcoming),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding24,
                    ),
                    child: LiveHeader(
                      title: liveData.sections.recent.title,
                      subtitle: liveData.sections.recent.subtitle,
                      onViewAllPressed: () {},
                    ),
                  ),
                  _buildRecentSection(liveData.recent),
                  SizedBox(height: SizeConfig.padding14),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('Failed to load live data'),
          );
        }
      },
    );
  }

  Widget _buildUpcomingSection(List<UpcomingStream> liveData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final live in liveData)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding8,
              ).copyWith(bottom: 8),
              child: LiveCardWidget(
                status: 'upcoming',
                title: live.title,
                subTitle: live.subtitle,
                author: live.author,
                category: live.category,
                bgImage: live.thumbnail,
                duration: live.startTime,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLiveSection(List<LiveStream> liveData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final live in liveData)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding8,
              ).copyWith(bottom: 8),
              child: LiveCardWidget(
                status: 'live',
                title: live.title,
                subTitle: live.subtitle,
                author: live.author,
                category: live.category,
                bgImage: live.thumbnail,
                liveCount: live.liveCount,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentSection(List<RecentStream> recentData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final recent in recentData)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding8,
              ).copyWith(
                bottom: SizeConfig.padding8,
              ),
              child: LiveCardWidget(
                status: 'recent',
                title: recent.title,
                subTitle: recent.subtitle,
                author: recent.author,
                category: recent.category,
                bgImage: recent.thumbnail,
                liveCount:
                    recent.views, // Number of views instead of live count
                duration: recent.duration.toString(),
              ),
            ),
        ],
      ),
    );
  }
}
