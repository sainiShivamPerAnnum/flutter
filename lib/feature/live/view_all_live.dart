import 'dart:async';

import 'package:felloapp/core/model/advisor/advisor_upcoming_call.dart';
import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/feature/advisor/advisor_components/call.dart';
import 'package:felloapp/feature/live/widgets/live_card.dart';
import 'package:felloapp/feature/shorts/src/bloc/preload_bloc.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:felloapp/feature/shorts/video_page.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/enums/page_state_enum.dart';

class ViewAllLive extends StatelessWidget {
  const ViewAllLive({
    required this.type,
    required this.appBarTitle,
    required this.liveList,
    required this.upcomingList,
    required this.recentList,
    required this.advisorUpcoming,
    required this.advisorPast,
    super.key,
  });
  final String appBarTitle;
  final String type;
  final List<LiveStream>? liveList;
  final List<UpcomingStream>? upcomingList;
  final List<VideoData>? recentList;
  final List<AdvisorCall>? advisorUpcoming;
  final List<AdvisorCall>? advisorPast;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackgroundGrid: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(appBarTitle, style: TextStyles.rajdhaniSB.body1),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: SizedBox(
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (final LiveStream item in liveList ?? [])
                Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.padding16),
                  child: LiveCardWidget(
                    id: item.id,
                    maxWidth: SizeConfig.padding350,
                    status: type,
                    title: item.title,
                    subTitle: item.subtitle,
                    author: item.author,
                    category: item.categories.join(', '),
                    bgImage: item.thumbnail,
                    liveCount: item.liveCount,
                    advisorCode: item.advisorCode,
                    viewerCode: item.viewerCode,
                  ),
                ),
              for (final UpcomingStream item in upcomingList ?? [])
                Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.padding16),
                  child: LiveCardWidget(
                    id: item.id,
                    maxWidth: SizeConfig.padding350,
                    status: type,
                    title: item.title,
                    subTitle: item.subtitle,
                    author: item.author,
                    category: item.categories.join(', '),
                    startTime: item.startTime,
                    bgImage: item.thumbnail,
                    liveCount: null,
                    advisorCode: item.advisorCode,
                    viewerCode: item.viewerCode,
                  ),
                ),
              for (final VideoData item in recentList ?? [])
                Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.padding16),
                  child: LiveCardWidget(
                    id: item.id,
                    maxWidth: SizeConfig.padding350,
                    status: type,
                    onTap: () async {
                      final preloadBloc = BlocProvider.of<PreloadBloc>(context);
                      final switchCompleter = Completer<void>();
                      preloadBloc.add(
                        PreloadEvent.initializeLiveStream(
                          item,
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
                              item.title,
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
                              await AppState.backButtonDispatcher!
                                  .didPopRoute();
                              return false;
                            },
                            child: const ShortsVideoPage(),
                          ),
                        ),
                      );
                    },
                    title: item.title,
                    subTitle: item.subtitle,
                    advisorCode: item.advisorId,
                    author: item.author,
                    category: (item.category ?? []).join(', '),
                    bgImage: item.thumbnail,
                    startTime: item.timeStamp,
                    duration: item.duration,
                    liveCount: item.viewCount,
                  ),
                ),
              for (final AdvisorCall call in advisorUpcoming ?? [])
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding20,
                  ),
                  child: callContainer(
                    call.userName ?? 'Unknown Title',
                    call.userName ?? 'Unknown Description',
                    call.scheduledOn.toString(),
                    call.duration,
                    'upcoming',
                    call.hostCode,
                    call.detailsQA,
                  ),
                ),
              for (final AdvisorCall call in advisorPast ?? [])
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding20,
                  ),
                  child: callContainer(
                    call.userName ?? 'Unknown Title',
                    call.userName ?? 'Unknown Description',
                    call.scheduledOn.toString(),
                    call.duration,
                    'past',
                    call.hostCode,
                    call.detailsQA,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
