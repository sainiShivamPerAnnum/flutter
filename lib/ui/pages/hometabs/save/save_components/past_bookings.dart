import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/bookings/upcoming_booking.dart';
import 'package:felloapp/core/repository/save_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/expertDetails/expert_profile.dart';
import 'package:felloapp/feature/shorts/flutter_preload_videos.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PastBookingsComponent extends StatelessWidget {
  const PastBookingsComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SaveViewModel, List<Booking>>(
      selector: (_, model) => model.pastBookings,
      builder: (_, pastBookings, __) {
        return pastBookings.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleSubtitleContainer(
                    title: "Past Scheduled Calls",
                    leadingPadding: true,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.padding20),
                    child: Container(
                      height: SizeConfig.screenHeight! * 0.277,
                      margin: EdgeInsets.only(
                        top: SizeConfig.padding10,
                      ),
                      child: ListView.builder(
                        itemCount: pastBookings.length,
                        scrollDirection: Axis.horizontal,
                        physics: pastBookings.length > 1
                            ? const AlwaysScrollableScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: SizeConfig.padding16,
                            right: SizeConfig.padding18,
                          ),
                          child: PastScheduleCard(
                            booking: pastBookings[index],
                            width: pastBookings.length > 1
                                ? SizeConfig.padding325
                                : SizeConfig.padding350,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class PastScheduleCard extends StatelessWidget {
  final Booking booking;
  final double width;

  const PastScheduleCard({
    required this.booking,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: UiConstants.greyVarient,
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConfig.roundness8),
        ),
      ),
      padding: EdgeInsets.only(
        left: SizeConfig.padding16,
        top: SizeConfig.padding16,
        right: SizeConfig.padding16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              AppState.delegate!.appState.currentAction = PageAction(
                page: ExpertDetailsPageConfig,
                state: PageState.addWidget,
                widget: ExpertsDetailsView(advisorID: booking.advisorId),
              );
            },
            child: Row(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: SizeConfig.padding16,
                      backgroundImage: NetworkImage(
                        booking.image,
                      ),
                    ),
                    SizedBox(width: SizeConfig.padding10),
                    Text(
                      booking.advisorName,
                      style: TextStyles.sourceSansSB.body1,
                    ),
                  ],
                ),
                SizedBox(width: SizeConfig.padding10),
                Icon(
                  Icons.arrow_forward_ios,
                  color: UiConstants.kTextColor,
                  size: SizeConfig.body4,
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.padding16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scheduled on',
                    style: TextStyles.sourceSans.body4.colour(
                      UiConstants.kTextColor5,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding4),
                  Text(
                    _formatDate(booking.scheduledOn),
                    style: TextStyles.sourceSansSB.body2.colour(
                      UiConstants.kTextColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Duration',
                    style: TextStyles.sourceSans.body4.colour(
                      UiConstants.kTextColor5,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding4),
                  Text(
                    booking.duration, // Display the duration
                    style: TextStyles.sourceSansSB.body2.colour(
                      UiConstants.kTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: SizeConfig.padding16),
          const Divider(
            color: UiConstants.grey6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (booking.eventId != null && booking.eventId != '')
                TextButton(
                  onPressed: () async {
                    final preloadBloc = BlocProvider.of<PreloadBloc>(context);
                    final videoData = await locator<SaveRepo>()
                        .getRecordingByVideoId(videoId: booking.eventId!);
                    if (videoData.isSuccess()) {
                      if (videoData.model!.url != "") {
                        final switchCompleter = Completer<void>();
                        preloadBloc.add(
                          PreloadEvent.initializeLiveStream(
                            videoData.model!,
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
                                videoData.model!.title,
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
                      } else {
                        BaseUtil.showNegativeAlert(
                          'We are still processing recording!',
                          'Try Again later',
                        );
                      }
                    } else {
                      BaseUtil.showNegativeAlert(
                        'Unable to fetch recording',
                        'Try Again later',
                      );
                    }
                    locator<AnalyticsService>().track(
                      eventName: AnalyticsEvents.pastCalls,
                      properties: {
                        "bookingId": booking.eventId,
                      },
                    );
                  },
                  child: Text(
                    'View Recording',
                    style: TextStyles.sourceSansSB.body4,
                  ),
                ),
              SizedBox(width: SizeConfig.padding10),
              GestureDetector(
                onTap: () {
                  AppState.delegate!.appState.currentAction = PageAction(
                    page: ExpertDetailsPageConfig,
                    state: PageState.addWidget,
                    widget: ExpertsDetailsView(advisorID: booking.advisorId),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding8,
                    vertical: SizeConfig.padding6,
                  ),
                  decoration: BoxDecoration(
                    color: UiConstants.kTextColor,
                    borderRadius: BorderRadius.circular(
                      SizeConfig.roundness5,
                    ),
                  ),
                  child: Text(
                    'Book Again',
                    style: TextStyles.sourceSansSB.body4
                        .colour(UiConstants.kTextColor4),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.padding16),
        ],
      ),
    );
  }

  // Helper function to format the scheduledOn DateTime
  String _formatDate(DateTime dateTime) {
    return "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}, ${_formatTime(dateTime)}";
  }

  // Helper function to format time in the desired format
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  // Helper function to get the month name
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
