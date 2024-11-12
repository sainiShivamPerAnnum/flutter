import 'dart:async';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/advisor/advisor_components/schedule.dart';
import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class UpcomingLiveCardWidget extends StatefulWidget {
  final String? id;
  final String status;
  final String title;
  final String subTitle;
  final String author;
  final String category;
  final String bgImage;
  final int? liveCount;
  final int? duration;
  final String? timeSlot;
  final String? broadcasterCode;

  const UpcomingLiveCardWidget({
    required this.status,
    required this.title,
    required this.subTitle,
    required this.author,
    required this.category,
    required this.bgImage,
    this.id,
    this.liveCount,
    this.duration,
    this.timeSlot,
    this.broadcasterCode,
    super.key,
  });

  @override
  State<UpcomingLiveCardWidget> createState() => _UpcomingLiveCardWidgetState();
}

class _UpcomingLiveCardWidgetState extends State<UpcomingLiveCardWidget> {
  Timer? _timer;
  String _remainingTime = '';
  @override
  void initState() {
    super.initState();
    if (widget.status == 'upcoming' && widget.timeSlot != null) {
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _updateRemainingTime(); // Initial update
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemainingTime();
    });
  }

  DateTime getAdjustedUtcTime() {
    // Get the current UTC time
    final DateTime nowUtc = DateTime.now().toUtc();

    // Get the current local time
    final DateTime nowLocal = DateTime.now();

    // Calculate the difference between local and UTC
    final Duration offset = nowLocal.timeZoneOffset;

    // Adjust the UTC time by adding or subtracting the offset
    final DateTime adjustedUtcTime = nowUtc.add(offset);

    return adjustedUtcTime;
  }

  void _updateRemainingTime() {
    final now = getAdjustedUtcTime();
    final start = DateTime.parse(widget.timeSlot!);
    final difference = start.difference(now);

    if (difference.isNegative) {
      // Stop the timer if the start time has passed
      _timer?.cancel();
      setState(() {
        _remainingTime = 'START NOW';
      });
    } else {
      setState(() {
        _remainingTime = "STARTS IN ${_formatDuration(difference)}";
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.padding300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
        color: UiConstants.greyVarient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: double.infinity,
                height: SizeConfig.padding152,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.roundness8),
                    topRight: Radius.circular(SizeConfig.roundness8),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(widget.bgImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (widget.status == 'live')
                Positioned(
                  bottom: SizeConfig.padding10,
                  left: SizeConfig.padding10,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding8,
                      vertical: SizeConfig.padding4,
                    ),
                    decoration: BoxDecoration(
                      color: UiConstants.kred1,
                      borderRadius: BorderRadius.circular(
                        SizeConfig.roundness5,
                      ),
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyles.sourceSansSB.body4.colour(
                        UiConstants.titleTextColor,
                      ),
                    ),
                  ),
                ),
              if (widget.status == 'upcoming')
                Positioned(
                  bottom: SizeConfig.padding10,
                  left: SizeConfig.padding10,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding8,
                      vertical: SizeConfig.padding4,
                    ),
                    decoration: BoxDecoration(
                      color: UiConstants.kTextColor4,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness5),
                    ),
                    child: Text(
                      _remainingTime,
                      style: TextStyles.sourceSansSB.body4.colour(
                        UiConstants.titleTextColor,
                      ),
                    ),
                  ),
                ),
              if (widget.broadcasterCode != null)
                Positioned(
                  bottom: SizeConfig.padding10,
                  right: SizeConfig.padding10,
                  child: GestureDetector(
                    onTap: () {
                      final userService = locator<UserService>();
                      final userId = userService.baseUser!.uid;
                      final advisoriD = userService.baseUser!.advisorId!;
                      final String userName =
                          (userService.baseUser!.kycName != null &&
                                      userService.baseUser!.kycName!.isNotEmpty
                                  ? userService.baseUser!.kycName
                                  : userService.baseUser!.name) ??
                              "N/A";
                      AppState.delegate!.appState.currentAction = PageAction(
                        page: LivePreviewPageConfig,
                        state: PageState.addWidget,
                        widget: HMSPrebuilt(
                          eventId: widget.id ?? '',
                          isLiked: false,
                          advisorId: advisoriD,
                          title: widget.title,
                          description: widget.subTitle,
                          roomCode: widget.broadcasterCode,
                          onLeave: () async {
                            await AppState.backButtonDispatcher!.didPopRoute();
                          },
                          options: HMSPrebuiltOptions(
                            userName: userName,
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding8,
                        vertical: SizeConfig.padding4,
                      ),
                      decoration: BoxDecoration(
                        color: UiConstants.kTextColor,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness5),
                      ),
                      child: Text(
                        'Join Live',
                        style: TextStyles.sourceSansSB.body4
                            .colour(UiConstants.kTextColor4),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(SizeConfig.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(SizeConfig.padding4),
                  decoration: BoxDecoration(
                    color: UiConstants.kblue2.withOpacity(.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.category.toUpperCase(),
                    style: TextStyles.sourceSansSB.body4.colour(
                      UiConstants.kblue1,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.padding4),
                // Title
                Text(
                  widget.title,
                  style: TextStyles.sourceSansSB.body2.colour(
                    UiConstants.kTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: SizeConfig.padding4),
                Text(
                  widget.subTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.sourceSans.body4.colour(
                    UiConstants.kTextColor5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.author,
                      style: TextStyles.sourceSans.body4.colour(
                        UiConstants.kTextColor,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: navigateToEdit,
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.white,
                        backgroundColor: UiConstants.kBackgroundColor,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding8,
                          vertical: SizeConfig.padding6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness5),
                        ),
                      ),
                      child: Text(
                        'Edit',
                        style: TextStyles.sourceSansSB.body4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  void navigateToEdit() {
    Haptic.vibrate();
    _analyticsService.track(eventName: AnalyticsEvents.allblogsview);
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: ScheduleCallViewConfig,
      widget: ScheduleCallWrapper(
        id: widget.id,
        status: widget.status, 
        title: widget.title,
        subTitle: widget
            .subTitle,
        author: widget.author,
        category: widget.category, 
        bgImage: widget.bgImage, 
        liveCount: widget.liveCount,
        duration: widget.duration,
        timeSlot: widget.timeSlot,
      ),
    );
  }
}
