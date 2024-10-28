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

class UpcomingLiveCardWidget extends StatelessWidget {
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

  UpcomingLiveCardWidget({
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
                    image: NetworkImage(bgImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (status == 'live')
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
              if (status == 'upcoming')
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
                      '',
                      // 'STARTS IN ${_calculateStartTimeDifference()}',
                      style: TextStyles.sourceSansSB.body4.colour(
                        UiConstants.titleTextColor,
                      ),
                    ),
                  ),
                ),
              if (broadcasterCode != null)
                Positioned(
                  bottom: SizeConfig.padding10,
                  right: SizeConfig.padding10,
                  child: GestureDetector(
                    onTap: () {
                      final userService = locator<UserService>();
                      final userId = userService.baseUser!.uid;
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
                          roomCode: broadcasterCode,
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
                    category.toUpperCase(),
                    style: TextStyles.sourceSansSB.body4.colour(
                      UiConstants.kblue1,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.padding4),
                // Title
                Text(
                  title,
                  style: TextStyles.sourceSansSB.body2.colour(
                    UiConstants.kTextColor,
                  ),
                ),
                SizedBox(height: SizeConfig.padding4),

                Text(
                  subTitle,
                  style: TextStyles.sourceSans.body4.colour(
                    UiConstants.kTextColor5,
                  ),
                ),
                SizedBox(height: SizeConfig.padding20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      author,
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

  String _calculateStartTimeDifference() {
    if ('startTime' == null) return '';
    final now = DateTime.now();
    final start = DateTime.parse('3:15');
    final difference = start.difference(now);
    return formatDuration(difference);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'stocks':
        return Colors.green;
      case 'crypto':
        return Colors.blue;
      case 'investments':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  void navigateToEdit() {
    Haptic.vibrate();
    _analyticsService.track(eventName: AnalyticsEvents.allblogsview);
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: ScheduleCallViewConfig,
      widget: ScheduleCallWrapper(
        id: id,
        status: status, // "live"
        title: title, // "Investment Webinar"
        subTitle:
            subTitle, // "A comprehensive webinar on investment strategies."
        author: author, // "Not coming from backend"
        category: category, // "Finance"
        bgImage: bgImage, // "https://example.com/image.jpg"
        liveCount: liveCount, // 3
        duration: duration,
        timeSlot: timeSlot,
      ),
    );
  }
}
