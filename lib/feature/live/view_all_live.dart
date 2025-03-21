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
import 'package:felloapp/ui/shared/marquee_text.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/enums/page_state_enum.dart';

class ViewAllLive extends StatefulWidget {
  const ViewAllLive({
    required this.type,
    required this.appBarTitle,
    required this.liveList,
    required this.upcomingList,
    required this.recentList,
    required this.advisorUpcoming,
    required this.advisorPast,
    required this.onNotify,
    required this.notificationState,
    required this.fromHome,
    super.key,
  });
  final Function(String id)? onNotify;
  final String appBarTitle;
  final String type;
  final List<LiveStream>? liveList;
  final List<UpcomingStream>? upcomingList;
  final List<VideoData>? recentList;
  final List<AdvisorCall>? advisorUpcoming;
  final List<AdvisorCall>? advisorPast;
  final Map<String, bool>? notificationState;
  final bool fromHome;

  @override
  State<ViewAllLive> createState() => _ViewAllLiveState();
}

class _ViewAllLiveState extends State<ViewAllLive> {
  Map<String, bool>? localnotificationState = {};
  @override
  void initState() {
    localnotificationState = widget.notificationState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackgroundGrid: false,
      backgroundColor: UiConstants.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(widget.appBarTitle, style: TextStyles.rajdhaniSB.body1),
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
              for (final LiveStream item in widget.liveList ?? [])
                Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.padding16),
                  child: LiveCardWidget(
                    id: item.id,
                    maxWidth: SizeConfig.padding350,
                    status: widget.type,
                    title: item.title,
                    subTitle: item.subtitle,
                    author: item.author,
                    category: item.categories.join(', '),
                    bgImage: item.thumbnail,
                    liveCount: item.liveCount,
                    advisorId: item.advisorId,
                    viewerCode: item.viewerCode,
                    fromHome: widget.fromHome,
                  ),
                ),
              for (final UpcomingStream item in widget.upcomingList ?? [])
                Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.padding16),
                  child: LiveCardWidget(
                    id: item.id,
                    fromHome: widget.fromHome,
                    maxWidth: SizeConfig.padding350,
                    status: widget.type,
                    title: item.title,
                    subTitle: item.subtitle,
                    author: item.author,
                    category: item.categories.join(', '),
                    startTime: item.startTime,
                    bgImage: item.thumbnail,
                    liveCount: null,
                    advisorId: item.advisorId,
                    viewerCode: item.viewerCode,
                    notifyOn: localnotificationState![item.id],
                    onNotify: () {
                      final updatedNotificationStatus =
                          Map<String, bool>.from(localnotificationState ?? {})
                            ..[item.id] = true;
                      if (widget.onNotify != null) {
                        widget.onNotify!(item.id);
                      }
                      setState(() {
                        localnotificationState = updatedNotificationStatus;
                      });
                    },
                  ),
                ),
              for (final VideoData item in widget.recentList ?? [])
                Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.padding16),
                  child: LiveCardWidget(
                    id: item.id,
                    fromHome: widget.fromHome,
                    maxWidth: SizeConfig.padding350,
                    status: widget.type,
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
                        page: LiveShortsPageConfig,
                        state: PageState.addWidget,
                        widget: BaseScaffold(
                          showBackgroundGrid: false,
                          backgroundColor: UiConstants.bg,
                          appBar: FAppBar(
                            backgroundColor: Colors.transparent,
                            centerTitle: true,
                            leadingPadding: false,
                            titleWidget: Expanded(
                              child: MarqueeText(
                                infoList: [item.title],
                                showBullet: false,
                                style: TextStyles.rajdhaniSB.body1,
                              ),
                            ),
                            leading: BackButton(
                              color: Colors.white,
                              onPressed: () {
                                AppState.backButtonDispatcher!.didPopRoute();
                              },
                            ),
                            showAvatar: false,
                            showCoinBar: false,
                            action: BlocBuilder<PreloadBloc, PreloadState>(
                              builder: (context, preloadState) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<PreloadBloc>(
                                        context,
                                        listen: false,
                                      ).add(
                                        const PreloadEvent.toggleVolume(),
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
                    title: item.title,
                    subTitle: item.subtitle,
                    advisorId: item.advisorId,
                    author: item.author,
                    category: (item.category ?? []).join(', '),
                    bgImage: item.thumbnail,
                    startTime: item.timeStamp,
                    duration: item.duration,
                    liveCount: item.views.toInt(),
                  ),
                ),
              for (final AdvisorCall call in widget.advisorUpcoming ?? [])
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
              for (final AdvisorCall call in widget.advisorPast ?? [])
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
